import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../domain/water_body.dart';

/// Сервер Overpass недоступен (все зеркала не ответили). Отличаем от «воды
/// нет»: при недоступности блок честно говорит «не смог проверить карту»,
/// а не выдумывает отсутствие водоёма.
class OverpassUnavailable implements Exception {
  const OverpassUnavailable();
}

/// Определяет водоём рядом с координатами через бесплатный Overpass API
/// (данные OpenStreetMap, без ключа). Рыбак ставит спот С БЕРЕГА, поэтому ищем
/// ближайшую воду в радиусе, а не строго под точкой.
///
/// Контракт честности:
///  • WaterBody — нашли воду;
///  • null — зеркало ответило 200, но воды рядом нет (точно «нет»);
///  • throw [OverpassUnavailable] — ни одно зеркало не ответило (НЕ «нет воды»).
class OverpassClient {
  OverpassClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Радиус поиска воды от точки спота, метры.
  static const _radiusM = 300;
  static const _timeout = Duration(seconds: 10);

  /// Зеркала Overpass рвут соединение/отдают 403/406 на запросы без
  /// User-Agent (так требует политика OSM). Dart по умолчанию шлёт
  /// `Dart/… (dart:io)`, который WAF-ы режут — поэтому ставим свой.
  static const _userAgent =
      'CarpBiteForecast/1.0 (+https://github.com/; carp app)';

  /// Зеркала Overpass: перебираем по очереди, берём первый ответ 200. Берём
  /// только полнопланетные инстансы — региональные (напр. osm.ch) дают ложное
  /// «воды нет» за пределами своего покрытия, что хуже честной ошибки.
  static final _endpoints = [
    Uri.parse('https://overpass-api.de/api/interpreter'),
    Uri.parse('https://overpass.kumi.systems/api/interpreter'),
    Uri.parse('https://overpass.private.coffee/api/interpreter'),
  ];

  Future<WaterBody?> nearestWater(double lat, double lon) async {
    final query = '[out:json][timeout:20];'
        '('
        'way["natural"="water"](around:$_radiusM,$lat,$lon);'
        'way["landuse"="reservoir"](around:$_radiusM,$lat,$lon);'
        'way["waterway"~"^(river|canal)\$"](around:$_radiusM,$lat,$lon);'
        'relation["natural"="water"](around:$_radiusM,$lat,$lon);'
        ');'
        'out tags geom;';

    // Зеркала опрашиваем ПАРАЛЛЕЛЬНО и берём первый валидный ответ — иначе
    // одно медленное зеркало (до таймаута) держало бы лоадер, складываясь по
    // всем трём. Так общее время ≈ самое быстрое зеркало.
    final completer = Completer<WaterBody?>();
    var pending = _endpoints.length;
    void onFailure() {
      if (completer.isCompleted) return;
      // Все зеркала отпали без пригодного ответа — это сбой связи, не «нет воды».
      if (--pending == 0) completer.completeError(const OverpassUnavailable());
    }

    for (final endpoint in _endpoints) {
      _fetchAndParse(endpoint, query, lat, lon).then((outcome) {
        if (completer.isCompleted) return;
        if (outcome.isValid) {
          // Валидный ответ: body == null ⇒ воды рядом действительно нет.
          completer.complete(outcome.body);
        } else {
          onFailure();
        }
      }).catchError((Object _) {
        onFailure();
      });
    }
    return completer.future;
  }

  /// Запрос к одному зеркалу + разбор. [_Outcome.invalid] — зеркало не дало
  /// пригодного ответа (не 200 / не распарсилось): пробуем другие.
  Future<_Outcome> _fetchAndParse(
    Uri endpoint,
    String query,
    double lat,
    double lon,
  ) async {
    final body = await _fetch(endpoint, query);
    if (body == null) return const _Outcome.invalid();
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final elements = json['elements'] as List?;
      if (elements == null) return const _Outcome.invalid();

      _Candidate? best;
      for (final e in elements) {
        final c = _parse(e as Map<String, dynamic>, lat, lon);
        if (c == null) continue;
        if (best == null || c.distanceM < best.distanceM) best = c;
      }
      return _Outcome.valid(best?.body);
    } catch (_) {
      return const _Outcome.invalid();
    }
  }

  /// Тело ответа при 200, иначе null (чтобы перейти к следующему зеркалу).
  Future<String?> _fetch(Uri endpoint, String query) async {
    try {
      final resp = await _client.post(
        endpoint,
        headers: const {'User-Agent': _userAgent},
        body: {'data': query},
      ).timeout(_timeout);
      return resp.statusCode == 200 ? resp.body : null;
    } catch (_) {
      return null;
    }
  }

  void dispose() => _client.close();

  _Candidate? _parse(Map<String, dynamic> e, double qLat, double qLon) {
    final tags = (e['tags'] as Map?)?.cast<String, dynamic>() ?? const {};
    final type = _classify(tags);
    final name = (tags['name'] as String?)?.trim().isEmpty ?? true
        ? null
        : (tags['name'] as String).trim();
    final points = _geometry(e);

    final double centroidLat;
    final double centroidLon;
    final double minDist;
    final double? areaHa;

    if (points.isNotEmpty) {
      var dist = double.infinity;
      var sumLat = 0.0;
      var sumLon = 0.0;
      for (final p in points) {
        final d = _haversineM(qLat, qLon, p.$1, p.$2);
        if (d < dist) dist = d;
        sumLat += p.$1;
        sumLon += p.$2;
      }
      centroidLat = sumLat / points.length;
      centroidLon = sumLon / points.length;
      minDist = dist;
      // Площадь считаем только для замкнутого кольца way; реки/каналы оставляем
      // без площади (честнее, чем угадывать).
      areaHa = type == WaterBodyType.river || type == WaterBodyType.canal
          ? null
          : _areaHa(points);
    } else {
      // relation-мультиполигон: геометрии членов нет, есть только bbox.
      // Берём центр бокса как центроид; площадь не оцениваем (бокс сильно
      // завышает для неправильной формы — это была бы ложь).
      final bounds = (e['bounds'] as Map?)?.cast<String, dynamic>();
      if (bounds == null) return null;
      final minLat = (bounds['minlat'] as num?)?.toDouble();
      final minLon = (bounds['minlon'] as num?)?.toDouble();
      final maxLat = (bounds['maxlat'] as num?)?.toDouble();
      final maxLon = (bounds['maxlon'] as num?)?.toDouble();
      if (minLat == null || minLon == null || maxLat == null || maxLon == null) {
        return null;
      }
      centroidLat = (minLat + maxLat) / 2;
      centroidLon = (minLon + maxLon) / 2;
      areaHa = null;
      // Расстояние до бокса: точка внутри → 0, иначе до ближайшей грани.
      final clampedLat = qLat.clamp(minLat, maxLat).toDouble();
      final clampedLon = qLon.clamp(minLon, maxLon).toDouble();
      minDist = _haversineM(qLat, qLon, clampedLat, clampedLon);
    }

    final body = WaterBody(
      type: type,
      centroidLat: centroidLat,
      centroidLon: centroidLon,
      name: name,
      areaHa: areaHa,
    );
    return _Candidate(body: body, distanceM: minDist);
  }

  /// Точки геометрии: для way — её узлы; для relation — узлы всех членов.
  List<(double, double)> _geometry(Map<String, dynamic> e) {
    final out = <(double, double)>[];
    void addGeom(dynamic geom) {
      if (geom is! List) return;
      for (final g in geom) {
        if (g is Map && g['lat'] != null && g['lon'] != null) {
          out.add(((g['lat'] as num).toDouble(), (g['lon'] as num).toDouble()));
        }
      }
    }

    addGeom(e['geometry']);
    final members = e['members'];
    if (members is List) {
      for (final m in members) {
        if (m is Map) addGeom(m['geometry']);
      }
    }
    return out;
  }

  WaterBodyType _classify(Map<String, dynamic> tags) {
    final waterway = tags['waterway'] as String?;
    if (waterway == 'river') return WaterBodyType.river;
    if (waterway == 'canal') return WaterBodyType.canal;
    final water = tags['water'] as String?;
    if (tags['landuse'] == 'reservoir' || water == 'reservoir') {
      return WaterBodyType.reservoir;
    }
    if (water == 'pond') return WaterBodyType.pond;
    // Широкие реки/протоки рисуют полигоном natural=water + water=river —
    // линии waterway у них нет, поэтому тип берём из значения water.
    if (water == 'river' || water == 'stream' || water == 'tidal_channel') {
      return WaterBodyType.river;
    }
    if (water == 'canal' || water == 'ditch' || water == 'moat') {
      return WaterBodyType.canal;
    }
    if (water == 'lake' ||
        water == 'lagoon' ||
        water == 'oxbow' ||
        tags['natural'] == 'water') {
      return WaterBodyType.lake;
    }
    return WaterBodyType.other;
  }

  /// Площадь кольца, га. Равнопромежуточная проекция вокруг первой точки —
  /// для размеров водоёма точности более чем достаточно.
  double? _areaHa(List<(double, double)> ring) {
    if (ring.length < 3) return null;
    final lat0 = degToRad(ring.first.$1);
    final mPerDegLat = 110540.0;
    final mPerDegLon = 111320.0 * math.cos(lat0);
    var area = 0.0;
    for (var i = 0; i < ring.length; i++) {
      final a = ring[i];
      final b = ring[(i + 1) % ring.length];
      final ax = a.$2 * mPerDegLon;
      final ay = a.$1 * mPerDegLat;
      final bx = b.$2 * mPerDegLon;
      final by = b.$1 * mPerDegLat;
      area += ax * by - bx * ay;
    }
    final ha = area.abs() / 2 / 10000;
    return ha < 0.01 ? null : ha;
  }
}

/// Итог опроса одного зеркала: валидный ответ (с водоёмом или без) либо
/// непригодный (зеркало отпало).
class _Outcome {
  const _Outcome.valid(this.body) : isValid = true;
  const _Outcome.invalid()
      : isValid = false,
        body = null;
  final bool isValid;
  final WaterBody? body;
}

/// Разобранный водоём-кандидат с расстоянием до точки спота.
class _Candidate {
  const _Candidate({required this.body, required this.distanceM});
  final WaterBody body;
  final double distanceM;
}

double degToRad(double deg) => deg * math.pi / 180;

double _haversineM(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371000.0;
  final dPhi = degToRad(lat2 - lat1);
  final dLambda = degToRad(lon2 - lon1);
  final a = math.sin(dPhi / 2) * math.sin(dPhi / 2) +
      math.cos(degToRad(lat1)) *
          math.cos(degToRad(lat2)) *
          math.sin(dLambda / 2) *
          math.sin(dLambda / 2);
  return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}
