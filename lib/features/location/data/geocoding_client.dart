import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/geo_point.dart';

/// Поиск места по названию через бесплатный Open-Meteo Geocoding API
/// (без ключа). Превращает «озеро Сенеж» / «Москва» в координаты + читаемое имя,
/// чтобы спот не приходилось искать, вручную возя карту.
class GeocodingClient {
  GeocodingClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<GeoPoint>> search(String query, {String language = 'en'}) async {
    final q = query.trim();
    if (q.isEmpty) return const [];

    final uri = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': q,
      'count': '6',
      'language': language,
      'format': 'json',
    });

    final http.Response resp;
    try {
      resp = await _client.get(uri);
    } catch (_) {
      return const [];
    }
    if (resp.statusCode != 200) return const [];

    try {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      final results = json['results'] as List?;
      if (results == null) return const [];
      return [
        for (final r in results) _toPoint(r as Map<String, dynamic>),
      ];
    } catch (_) {
      return const [];
    }
  }

  GeoPoint _toPoint(Map<String, dynamic> r) {
    final name = (r['name'] as String?)?.trim() ?? '';
    final admin1 = (r['admin1'] as String?)?.trim();
    // Имя + регион, чтобы различать одноимённые места.
    final label = (admin1 != null && admin1.isNotEmpty && admin1 != name)
        ? '$name, $admin1'
        : name;
    return GeoPoint(
      name: label,
      latitude: (r['latitude'] as num).toDouble(),
      longitude: (r['longitude'] as num).toDouble(),
    );
  }

  void dispose() => _client.close();
}
