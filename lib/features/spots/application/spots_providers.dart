import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/persistence/prefs_service.dart';
import '../../location/application/location_providers.dart';
import '../../location/domain/geo_point.dart';
import '../data/overpass_client.dart';
import '../domain/water_body.dart';

/// Сохранённые пользователем споты (именованные точки на карте). Источник
/// истины — prefs; список переживает перезапуск.
class SavedSpotsNotifier extends Notifier<List<GeoPoint>> {
  @override
  List<GeoPoint> build() {
    final raw = sharedPrefs.getString(PrefsKeys.savedSpots);
    if (raw == null) return const [];
    try {
      final list = jsonDecode(raw) as List;
      return [
        for (final e in list) GeoPoint.fromJson(e as Map<String, dynamic>),
      ];
    } catch (_) {
      return const [];
    }
  }

  void add(GeoPoint spot) {
    state = [...state, spot];
    _persist();
  }

  /// Заменить спот [from] на [to] (тот же индекс). Используется фоновым
  /// обратным геокодингом: спот появляется мгновенно с запасным именем, а
  /// затем подпись меняется на ближайший населённый пункт.
  void replace(GeoPoint from, GeoPoint to) {
    final i = state.indexOf(from);
    if (i < 0) return;
    state = [...state]..[i] = to;
    _persist();
  }

  void removeAt(int index) {
    if (index < 0 || index >= state.length) return;
    state = [...state]..removeAt(index);
    _persist();
  }

  /// Вернуть спот на прежнее место — для undo после удаления.
  void insertAt(int index, GeoPoint spot) {
    final i = index.clamp(0, state.length);
    state = [...state]..insert(i, spot);
    _persist();
  }

  void _persist() {
    sharedPrefs.setString(
      PrefsKeys.savedSpots,
      jsonEncode([for (final s in state) s.toJson()]),
    );
  }
}

final savedSpotsProvider =
    NotifierProvider<SavedSpotsNotifier, List<GeoPoint>>(SavedSpotsNotifier.new);

final overpassClientProvider = Provider<OverpassClient>((ref) {
  final client = OverpassClient();
  ref.onDispose(client.dispose);
  return client;
});

/// Срок годности кэша водоёма. Геометрия водоёмов почти статична, но карта OSM
/// дополняется — раз в ~45 дней перепроверяем, чтобы подхватить разметку.
const _waterCacheTtl = Duration(days: 45);

/// Сколько водоёмов держим в кэше. При переполнении вытесняем самые старые —
/// чтобы prefs не разрастался от множества разовых тыков по карте.
const _waterCacheMaxEntries = 200;

/// Версия формата записи кэша. Поднимаем, когда в WaterBody добавляются поля,
/// которых нет в старых записях, — чтобы они перечитались с карты, а не висели
/// без новых признаков (острова, притоки и т.п.) до истечения TTL.
const _waterCacheVersion = 2;

/// Ключ кэша по координатам, округлённым до ~10 м (4 знака). Точка спота между
/// фиксами слегка дрожит, но на масштабе водоёма 10 м — та же вода.
String _waterCacheKey(double lat, double lon) =>
    '${lat.toStringAsFixed(4)},${lon.toStringAsFixed(4)}';

Map<String, dynamic> _readWaterCache() {
  final raw = sharedPrefs.getString(PrefsKeys.cachedWaterBodies);
  if (raw == null) return {};
  try {
    return (jsonDecode(raw) as Map).cast<String, dynamic>();
  } catch (_) {
    return {};
  }
}

/// Достать из кэша свежий результат для координат. Возвращает обёртку
/// `(body: ...)`, где `body` может быть null («воды нет» — тоже валидный кэш).
/// `null` сам по себе означает промах кэша (записи нет или протухла).
({WaterBody? body})? _cachedWater(double lat, double lon) {
  final entry = _readWaterCache()[_waterCacheKey(lat, lon)];
  if (entry is! Map) return null;
  // Запись старого формата (без версии или с младшей) игнорируем — перечитаем.
  if ((entry['v'] as int?) != _waterCacheVersion) return null;
  final atMs = entry['at'] as int?;
  if (atMs == null) return null;
  final age = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(atMs));
  if (age > _waterCacheTtl) return null;
  final bodyJson = entry['body'];
  if (bodyJson == null) return (body: null);
  try {
    return (body: WaterBody.fromJson((bodyJson as Map).cast<String, dynamic>()));
  } catch (_) {
    return null;
  }
}

void _putWaterCache(double lat, double lon, WaterBody? body) {
  final cache = _readWaterCache();
  cache[_waterCacheKey(lat, lon)] = {
    'v': _waterCacheVersion,
    'at': DateTime.now().millisecondsSinceEpoch,
    'body': body?.toJson(),
  };
  // Вытеснение самых старых при переполнении.
  if (cache.length > _waterCacheMaxEntries) {
    final keys = cache.keys.toList()
      ..sort((a, b) {
        final at = (cache[a] as Map)['at'] as int? ?? 0;
        final bt = (cache[b] as Map)['at'] as int? ?? 0;
        return at.compareTo(bt);
      });
    for (final k in keys.take(cache.length - _waterCacheMaxEntries)) {
      cache.remove(k);
    }
  }
  sharedPrefs.setString(PrefsKeys.cachedWaterBodies, jsonEncode(cache));
}

/// Сбросить кэш для координат — кнопка «повторить» должна сходить в сеть заново,
/// а не вернуть тот же протухший/ошибочный результат.
void clearWaterCache(double lat, double lon) {
  final cache = _readWaterCache();
  if (cache.remove(_waterCacheKey(lat, lon)) != null) {
    sharedPrefs.setString(PrefsKeys.cachedWaterBodies, jsonEncode(cache));
  }
}

/// Водоём рядом с активной локацией по данным OpenStreetMap. Перезапрашивается
/// при смене локации; Riverpod кэширует результат на время сессии, а prefs —
/// между сессиями (геометрия водоёма почти не меняется, см. [_waterCacheTtl]).
/// null — воды рядом нет; ошибка ([OverpassUnavailable]) — карту не удалось
/// проверить (UI разводит эти случаи: «нет воды» vs «сбой»). В кэш кладём только
/// определённые ответы (вода или подтверждённое «нет воды»); сбой сети не кэшируем,
/// иначе временный сбой залип бы как «воды нет».
final waterBodyProvider = FutureProvider<WaterBody?>((ref) async {
  // Зависим только от координат: переименование локации не должно
  // перезапрашивать карту водоёмов.
  final (lat, lon) =
      ref.watch(activeLocationProvider.select((l) => (l.latitude, l.longitude)));

  final cached = _cachedWater(lat, lon);
  if (cached != null) return cached.body;

  final client = ref.watch(overpassClientProvider);
  final body = await client.nearestWater(lat, lon);
  _putWaterCache(lat, lon, body);
  return body;
});
