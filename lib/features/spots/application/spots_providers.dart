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

/// Водоём рядом с активной локацией по данным OpenStreetMap. Перезапрашивается
/// при смене локации; Riverpod кэширует результат на время сессии (геометрия
/// водоёма не меняется). null — воды рядом нет; ошибка ([OverpassUnavailable])
/// — карту не удалось проверить (UI разводит эти случаи: «нет воды» vs «сбой»).
final waterBodyProvider = FutureProvider<WaterBody?>((ref) async {
  // Зависим только от координат: переименование локации не должно
  // перезапрашивать карту водоёмов.
  final (lat, lon) =
      ref.watch(activeLocationProvider.select((l) => (l.latitude, l.longitude)));
  final client = ref.watch(overpassClientProvider);
  return client.nearestWater(lat, lon);
});
