import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

/// Обратный геокодинг: по координатам находит ближайший населённый пункт,
/// чтобы «Моё место» и кастомные споты без названия показывали человекочитаемый
/// ориентир — ближайший город/посёлок/деревню, а не голые координаты.
///
/// Два источника (оба бесплатные, без ключа):
///  1) Overpass (OpenStreetMap) — даёт НАСТОЯЩИЙ ближайший населённый пункт по
///     расстоянию; точнее всего для спота на воде вдали от города.
///  2) BigDataCloud reverse-geocode — запасной путь, когда зеркала Overpass не
///     ответили (rate-limit): стабилен, но возвращает админ-единицу (город/район).
///
/// Возвращает имя или null — если оба источника молчат (тогда UI честно остаётся
/// на запасной подписи вроде «Моё место»).
class ReverseGeocodingClient {
  ReverseGeocodingClient({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  // Короткий таймаут: запрос идёт в фоне, но не должен «висеть» десятки секунд
  // на залипшем зеркале — лучше быстро откатиться на запасной источник.
  static const _timeout = Duration(seconds: 8);

  /// Радиусы поиска по Overpass, метры: сперва близко (рядом с городом не
  /// хватаем дальний пункт), затем расширяем — чтобы в глуши всё равно найти.
  static const _radiiM = [12000, 40000, 90000];

  /// Зеркала Overpass: те же полнопланетные инстансы, что и для поиска воды.
  static final _overpassEndpoints = [
    Uri.parse('https://overpass-api.de/api/interpreter'),
    Uri.parse('https://overpass.kumi.systems/api/interpreter'),
  ];

  /// Имя ближайшего населённого пункта; [language] — предпочитаемый язык
  /// названия (`name:<lang>`), с откатом на местное `name`.
  Future<String?> nearestSettlement(
    double lat,
    double lon, {
    String language = 'en',
  }) async {
    // 1) Overpass — настоящий ближайший пункт.
    for (final radius in _radiiM) {
      final (responded, name) = await _overpassQuery(lat, lon, radius, language);
      if (name != null) return name;
      // Зеркала не ответили — расширять радиус бессмысленно, идём в фолбэк.
      if (!responded) break;
      // responded && name == null ⇒ в этом радиусе пусто, расширяем.
    }
    // 2) Запасной стабильный источник.
    return _bigDataCloud(lat, lon, language);
  }

  /// (responded, name): responded=false ⇒ ни одно зеркало не дало 200.
  Future<(bool, String?)> _overpassQuery(
    double lat,
    double lon,
    int radius,
    String language,
  ) async {
    final query = '[out:json][timeout:20];'
        '('
        'node["place"~"^(city|town|village|hamlet)\$"](around:$radius,$lat,$lon);'
        ');'
        'out;';

    var anyResponse = false;
    for (final endpoint in _overpassEndpoints) {
      final body = await _post(endpoint, {'data': query});
      if (body == null) continue;
      anyResponse = true;
      try {
        final json = jsonDecode(body) as Map<String, dynamic>;
        final elements = json['elements'] as List?;
        if (elements == null) continue;

        String? bestName;
        var bestDist = double.infinity;
        var bestRank = 99;
        for (final e in elements) {
          final el = e as Map<String, dynamic>;
          final eLat = (el['lat'] as num?)?.toDouble();
          final eLon = (el['lon'] as num?)?.toDouble();
          if (eLat == null || eLon == null) continue;
          final tags =
              (el['tags'] as Map?)?.cast<String, dynamic>() ?? const {};
          final name = _nameOf(tags, language);
          if (name == null) continue;

          final dist = _haversineM(lat, lon, eLat, eLon);
          final rank = _placeRank(tags['place'] as String?);
          // Город «весомее» деревни: при близких расстояниях предпочитаем более
          // крупный, узнаваемый ориентир.
          final adjusted = dist * (1 + 0.15 * rank);
          final bestAdjusted = bestDist * (1 + 0.15 * bestRank);
          if (bestName == null || adjusted < bestAdjusted) {
            bestName = name;
            bestDist = dist;
            bestRank = rank;
          }
        }
        return (true, bestName);
      } catch (_) {
        continue;
      }
    }
    return (anyResponse, null);
  }

  /// Запасной реверс-геокодинг: стабилен, локализует имя, но для глуши отдаёт
  /// административную единицу (город/район), а не отдельный посёлок.
  Future<String?> _bigDataCloud(double lat, double lon, String language) async {
    final uri = Uri.https('api.bigdatacloud.net', '/data/reverse-geocode-client', {
      'latitude': '$lat',
      'longitude': '$lon',
      'localityLanguage': language,
    });
    try {
      final resp = await _client.get(uri).timeout(_timeout);
      if (resp.statusCode != 200) return null;
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final city = (json['city'] as String?)?.trim();
      if (city != null && city.isNotEmpty) return city;
      final locality = (json['locality'] as String?)?.trim();
      if (locality != null && locality.isNotEmpty) return locality;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<String?> _post(Uri endpoint, Map<String, String> body) async {
    try {
      final resp = await _client.post(endpoint, body: body).timeout(_timeout);
      return resp.statusCode == 200 ? resp.body : null;
    } catch (_) {
      return null;
    }
  }

  /// Имя с учётом языка: `name:<lang>` → местное `name`.
  String? _nameOf(Map<String, dynamic> tags, String language) {
    final localized = (tags['name:$language'] as String?)?.trim();
    if (localized != null && localized.isNotEmpty) return localized;
    final name = (tags['name'] as String?)?.trim();
    if (name != null && name.isNotEmpty) return name;
    return null;
  }

  /// Чем меньше ранг, тем крупнее пункт (city=0 … hamlet=3).
  int _placeRank(String? place) {
    switch (place) {
      case 'city':
        return 0;
      case 'town':
        return 1;
      case 'village':
        return 2;
      default:
        return 3;
    }
  }

  void dispose() => _client.close();
}

double _degToRad(double deg) => deg * math.pi / 180;

double _haversineM(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371000.0;
  final dPhi = _degToRad(lat2 - lat1);
  final dLambda = _degToRad(lon2 - lon1);
  final a = math.sin(dPhi / 2) * math.sin(dPhi / 2) +
      math.cos(_degToRad(lat1)) *
          math.cos(_degToRad(lat2)) *
          math.sin(dLambda / 2) *
          math.sin(dLambda / 2);
  return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}
