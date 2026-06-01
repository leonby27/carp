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

  /// Радиус, в котором тянем структурные объекты (притоки, тростник, дамбы)
  /// вокруг спота. Берём с запасом — порог близости считаем уже по геометрии.
  static const _structRadiusM = 220;

  /// Пороги «рядом со спотом» для структурных подсказок, метры.
  static const _inflowNearM = 160;
  static const _reedNearM = 130;
  static const _damNearM = 160;

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
    // Две ситуации, которые нужно покрыть:
    //  1. Спот НА ВОДЕ (лодка/середина большого водохранилища). `around` меряет
    //     расстояние до береговой линии, а не «внутри ли воды», поэтому в
    //     центре крупного водоёма он ничего не находит (берег за радиусом).
    //     Ловим это через `is_in`+`pivot` — какой водный полигон содержит точку.
    //  2. Спот С БЕРЕГА — ищем ближайшую воду в радиусе через `around`.
    // Крупные водоёмы и длинные реки/каналы в OSM почти всегда —
    // relation-мультиполигоны, поэтому перебираем и way, и relation. `out geom;`
    // (без модификатора `tags`!) отдаёт геометрию членов relation вместе с
    // тегами; `out tags geom;` молча обрезает геометрию членов до bbox — из-за
    // этого крупные водоёмы распознавались по грубому прямоугольнику.
    final query = '[out:json][timeout:25];'
        'is_in($lat,$lon)->.a;'
        '('
        'way(pivot.a)["natural"="water"];'
        'relation(pivot.a)["natural"="water"];'
        'way(pivot.a)["landuse"="reservoir"];'
        'relation(pivot.a)["landuse"="reservoir"];'
        'way["natural"="water"](around:$_radiusM,$lat,$lon);'
        'way["landuse"="reservoir"](around:$_radiusM,$lat,$lon);'
        'way["waterway"~"^(river|canal)\$"](around:$_radiusM,$lat,$lon);'
        'relation["natural"="water"](around:$_radiusM,$lat,$lon);'
        'relation["landuse"="reservoir"](around:$_radiusM,$lat,$lon);'
        'relation["waterway"~"^(river|canal)\$"](around:$_radiusM,$lat,$lon);'
        // Структурные объекты у спота: притоки (ручьи/канавы — river/canal уже
        // выше), прибрежный тростник/болото, плотины/дамбы. Это НЕ кандидаты в
        // водоём (см. _isWaterTags), а признаки для тактических подсказок.
        'way["waterway"~"^(stream|ditch)\$"](around:$_structRadiusM,$lat,$lon);'
        'way["natural"~"^(wetland|reed)\$"](around:$_structRadiusM,$lat,$lon);'
        'node["natural"="wetland"](around:$_structRadiusM,$lat,$lon);'
        'way["waterway"="dam"](around:$_structRadiusM,$lat,$lon);'
        'way["man_made"~"^(dyke|dam|embankment)\$"](around:$_structRadiusM,$lat,$lon);'
        ');'
        'out geom;';

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
      // Структурные признаки у спота считаем за один проход по элементам. Один
      // элемент может быть и водой, и притоком (линия waterway=river) — это ок.
      var inflow = false;
      var reeds = false;
      var dam = false;
      for (final raw in elements) {
        final e = raw as Map<String, dynamic>;
        final tags = (e['tags'] as Map?)?.cast<String, dynamic>() ?? const {};
        if (_isWaterTags(tags)) {
          final c = _parse(e, tags, lat, lon);
          if (c != null && (best == null || c.distanceM < best.distanceM)) {
            best = c;
          }
        }
        if (!inflow &&
            _isInflowLine(tags) &&
            _structDistM(e, lat, lon) <= _inflowNearM) {
          inflow = true;
        }
        if (!reeds &&
            _isReedTags(tags) &&
            _structDistM(e, lat, lon) <= _reedNearM) {
          reeds = true;
        }
        if (!dam && _isDamTags(tags) && _structDistM(e, lat, lon) <= _damNearM) {
          dam = true;
        }
      }
      if (best == null) return const _Outcome.valid(null);
      final b = best.body;
      // На реке/канале «приток рядом» — это сама река: подсказка бессмысленна,
      // гасим её, чтобы не дублировать тип водоёма.
      final inflowHint = inflow && b.hasShores;
      final enriched = WaterBody(
        type: b.type,
        centroidLat: b.centroidLat,
        centroidLon: b.centroidLon,
        name: b.name,
        areaHa: b.areaHa,
        islandCount: best.islandCount,
        inflowNearSpot: inflowHint,
        reedsNearSpot: reeds,
        damNearSpot: dam,
      );
      return _Outcome.valid(enriched);
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

  _Candidate? _parse(
    Map<String, dynamic> e,
    Map<String, dynamic> tags,
    double qLat,
    double qLon,
  ) {
    final type = _classify(tags);
    final name = (tags['name'] as String?)?.trim().isEmpty ?? true
        ? null
        : (tags['name'] as String).trim();
    final rings = _rings(e);

    final double centroidLat;
    final double centroidLon;
    final double minDist;
    final double? areaHa;

    if (rings.isNotEmpty) {
      var sumLat = 0.0;
      var sumLon = 0.0;
      var n = 0;
      for (final r in rings) {
        for (final p in r.pts) {
          sumLat += p.$1;
          sumLon += p.$2;
          n++;
        }
      }
      centroidLat = sumLat / n;
      centroidLon = sumLon / n;
      // До РЁБЕР геометрии, а не до вершин: у редко размеченного полигона
      // берег между вершинами куда ближе любой вершины, а если точка внутри
      // водоёма — расстояние 0. Иначе близкая вершина соседней линии (реки)
      // ложно перебивала водоём, внутри которого стоит спот.
      minDist = _minDistM(qLat, qLon, rings);
      // Реки/каналы оставляем без площади (честнее, чем угадывать); для
      // полигонов считаем outer − inner (вычитаем острова).
      areaHa = type == WaterBodyType.river || type == WaterBodyType.canal
          ? null
          : _areaHa(rings);
    } else {
      // Запасной путь: relation без разрешённой геометрии членов — есть только
      // bbox. Берём центр бокса как центроид; площадь не оцениваем (бокс сильно
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
    return _Candidate(
      body: body,
      distanceM: minDist,
      islandCount: _islandCount(rings),
    );
  }

  /// Полилинии границы водоёма: для way — одна (её узлы); для relation — по
  /// одной на каждый member-way с его ролью (outer/inner). ВАЖНО: возвращаем
  /// РАЗДЕЛЬНО, не склеивая в один список. Граница мультиполигона нарезана на
  /// десятки member-ways, которые стыкуются концами; если их склеить, на стыке
  /// возникает ложное ребро — и тест «точка внутри», и расстояние до берега
  /// считаются неверно (середина большого водохранилища переставала давать 0).
  List<_Ring> _rings(Map<String, dynamic> e) {
    final out = <_Ring>[];
    List<(double, double)>? toPts(dynamic geom) {
      if (geom is! List) return null;
      final pts = <(double, double)>[];
      for (final g in geom) {
        if (g is Map && g['lat'] != null && g['lon'] != null) {
          pts.add(((g['lat'] as num).toDouble(), (g['lon'] as num).toDouble()));
        }
      }
      return pts.isEmpty ? null : pts;
    }

    final own = toPts(e['geometry']);
    if (own != null) out.add((role: 'outer', pts: own));
    final members = e['members'];
    if (members is List) {
      for (final m in members) {
        if (m is! Map) continue;
        final pts = toPts(m['geometry']);
        if (pts == null) continue;
        out.add((role: m['role'] == 'inner' ? 'inner' : 'outer', pts: pts));
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

  /// Является ли элемент собственно водоёмом (кандидатом). Тростник, дамбы и
  /// линии-ручьи сюда НЕ попадают — иначе они конкурировали бы за «ближайшую
  /// воду» и подменяли реальный водоём.
  bool _isWaterTags(Map<String, dynamic> tags) {
    if (tags['natural'] == 'water') return true;
    if (tags['landuse'] == 'reservoir') return true;
    final w = tags['waterway'];
    if (w == 'river' || w == 'canal') return true;
    return tags['water'] != null;
  }

  /// Линейный водоток (приток/вытек) рядом — река/ручей/канал/канава.
  bool _isInflowLine(Map<String, dynamic> tags) {
    final w = tags['waterway'];
    return w == 'river' || w == 'stream' || w == 'canal' || w == 'ditch';
  }

  /// Прибрежная растительность: тростник/камыш или болото (его частный случай).
  bool _isReedTags(Map<String, dynamic> tags) {
    if (tags['natural'] == 'reed') return true;
    if (tags['natural'] == 'wetland') {
      final wl = tags['wetland'];
      return wl == null || wl == 'reed' || wl == 'marsh' || wl == 'swamp';
    }
    return false;
  }

  /// Плотина/дамба/насыпь.
  bool _isDamTags(Map<String, dynamic> tags) {
    if (tags['waterway'] == 'dam') return true;
    final m = tags['man_made'];
    return m == 'dyke' || m == 'dam' || m == 'embankment';
  }

  /// Расстояние от спота до структурного объекта (линии/полигона/узла), метры.
  double _structDistM(Map<String, dynamic> e, double qLat, double qLon) {
    final rings = _rings(e);
    if (rings.isNotEmpty) return _minDistM(qLat, qLon, rings);
    // Узел (point): тростник/дамба иногда размечены точкой.
    final elat = (e['lat'] as num?)?.toDouble();
    final elon = (e['lon'] as num?)?.toDouble();
    if (elat == null || elon == null) return double.infinity;
    return _haversineM(qLat, qLon, elat, elon);
  }

  /// Число островов — замкнутых inner-колец (после сшивки дуг), у которых
  /// достаточно вершин для реального контура.
  int _islandCount(List<_Ring> rings) {
    final inner = [for (final r in rings) if (r.role == 'inner') r.pts];
    if (inner.isEmpty) return 0;
    var count = 0;
    for (final ring in _stitch(inner)) {
      if (ring.length >= 3) count++;
    }
    return count;
  }

  /// Площадь водоёма, га: суммарная площадь outer-контуров минус inner
  /// (острова). Граница мультиполигона нарезана на десятки несомкнутых дуг
  /// (member-ways), поэтому сначала СШИВАЕМ их в замкнутые кольца — иначе
  /// shoelace по отдельной дуге даёт бессмысленный кусок и площадь занижается.
  double? _areaHa(List<_Ring> rings) {
    if (rings.isEmpty) return null;
    final lat0 = rings.first.pts.first.$1;
    double sumRings(String role) {
      final arcs = [for (final r in rings) if (r.role == role) r.pts];
      var sum = 0.0;
      for (final ring in _stitch(arcs)) {
        sum += _ringAreaHa(ring, lat0);
      }
      return sum;
    }

    final total = sumRings('outer') - sumRings('inner');
    return total < 0.01 ? null : total;
  }

  /// Площадь замкнутого кольца, га (shoelace в локальной проекции вокруг lat0).
  double _ringAreaHa(List<(double, double)> ring, double lat0) {
    if (ring.length < 3) return 0;
    final mPerDegLat = 110540.0;
    final mPerDegLon = 111320.0 * math.cos(degToRad(lat0));
    var area = 0.0;
    for (var i = 0; i < ring.length; i++) {
      final a = ring[i];
      final b = ring[(i + 1) % ring.length];
      area += (a.$2 * mPerDegLon) * (b.$1 * mPerDegLat) -
          (b.$2 * mPerDegLon) * (a.$1 * mPerDegLat);
    }
    return area.abs() / 2 / 10000;
  }

  /// Сшивает открытые дуги в замкнутые кольца по совпадающим концам. OSM не
  /// гарантирует ни порядок членов, ни их ориентацию — ищем продолжение с
  /// любого конца дуги и при необходимости разворачиваем её.
  List<List<(double, double)>> _stitch(List<List<(double, double)>> arcs) {
    final pool = [for (final a in arcs) List.of(a)];
    final rings = <List<(double, double)>>[];
    while (pool.isNotEmpty) {
      final ring = pool.removeLast();
      var extended = true;
      while (extended && ring.first != ring.last) {
        extended = false;
        for (var i = 0; i < pool.length; i++) {
          final arc = pool[i];
          if (arc.first == ring.last) {
            ring.addAll(arc.skip(1));
          } else if (arc.last == ring.last) {
            ring.addAll(arc.reversed.skip(1));
          } else if (arc.last == ring.first) {
            ring.insertAll(0, arc.take(arc.length - 1));
          } else if (arc.first == ring.first) {
            ring.insertAll(0, arc.reversed.take(arc.length - 1));
          } else {
            continue;
          }
          pool.removeAt(i);
          extended = true;
          break;
        }
      }
      rings.add(ring);
    }
    return rings;
  }
}

/// Полилиния границы водоёма с её ролью в мультиполигоне (outer/inner).
typedef _Ring = ({String role, List<(double, double)> pts});

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

/// Разобранный водоём-кандидат с расстоянием до точки спота и числом островов.
class _Candidate {
  const _Candidate({
    required this.body,
    required this.distanceM,
    required this.islandCount,
  });
  final WaterBody body;
  final double distanceM;
  final int islandCount;
}

double degToRad(double deg) => deg * math.pi / 180;

/// Минимальное расстояние от точки до геометрии водоёма, метры. Линию (реку)
/// меряем до ближайшего сегмента; если точка внутри полигона (в т.ч. между
/// островами мультиполигона) — 0. Локальная равнопромежуточная проекция вокруг
/// точки запроса — на масштабе водоёма искажение пренебрежимо.
double _minDistM(double qLat, double qLon, List<_Ring> rings) {
  final mPerDegLat = 110540.0;
  final mPerDegLon = 111320.0 * math.cos(degToRad(qLat));
  final qx = qLon * mPerDegLon;
  final qy = qLat * mPerDegLat;
  // Кольца проецируем РАЗДЕЛЬНО — без рёбер между разными member-ways.
  final projected = [
    for (final r in rings)
      [for (final p in r.pts) (p.$2 * mPerDegLon, p.$1 * mPerDegLat)],
  ];
  // Чёт-нечётный тест по рёбрам всех колец: объединение member-ways замыкается
  // в кольца, поэтому считать пересечения можно по всем рёбрам сразу — острова
  // (inner) дают чётное число пересечений и корректно исключаются.
  if (_pointInRings(qx, qy, projected)) return 0;
  var best = double.infinity;
  for (final xy in projected) {
    if (xy.length == 1) {
      best = math.min(best, math.sqrt(_sq(qx - xy.first.$1) + _sq(qy - xy.first.$2)));
      continue;
    }
    for (var i = 0; i < xy.length - 1; i++) {
      final d = _segDistM(qx, qy, xy[i].$1, xy[i].$2, xy[i + 1].$1, xy[i + 1].$2);
      if (d < best) best = d;
    }
  }
  return best;
}

/// Расстояние от точки до отрезка AB в проективных метрах.
double _segDistM(
  double px,
  double py,
  double ax,
  double ay,
  double bx,
  double by,
) {
  final dx = bx - ax;
  final dy = by - ay;
  final len2 = dx * dx + dy * dy;
  if (len2 == 0) return math.sqrt(_sq(px - ax) + _sq(py - ay));
  final t = (((px - ax) * dx + (py - ay) * dy) / len2).clamp(0.0, 1.0);
  return math.sqrt(_sq(px - (ax + t * dx)) + _sq(py - (ay + t * dy)));
}

/// Чёт-нечётный лучевой тест «точка внутри полигона» по рёбрам всех колец.
/// Рёбра берём только между соседними точками внутри каждой полилинии (без
/// замыкающего last→first): member-ways мультиполигона — это открытые дуги,
/// которые стыкуются концами, поэтому добавлять замыкание нельзя — иначе на
/// стыке возникнет ложное ребро. Замкнутый одиночный way (first==last) и так
/// содержит замыкающий сегмент в своих соседних парах.
bool _pointInRings(double px, double py, List<List<(double, double)>> rings) {
  var inside = false;
  for (final ring in rings) {
    for (var i = 0; i + 1 < ring.length; i++) {
      final xi = ring[i].$1;
      final yi = ring[i].$2;
      final xj = ring[i + 1].$1;
      final yj = ring[i + 1].$2;
      if ((yi > py) != (yj > py) &&
          px < (xj - xi) * (py - yi) / (yj - yi) + xi) {
        inside = !inside;
      }
    }
  }
  return inside;
}

double _sq(double v) => v * v;

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
