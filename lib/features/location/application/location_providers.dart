import 'dart:convert';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/locale_provider.dart';
import '../../../core/persistence/prefs_service.dart';
import '../data/geocoding_client.dart';
import '../data/geolocation_service.dart';
import '../data/reverse_geocoding_client.dart';
import '../domain/geo_point.dart';

final geolocationServiceProvider =
    Provider<GeolocationService>((ref) => const GeolocationService());

final geocodingClientProvider = Provider<GeocodingClient>((ref) {
  final client = GeocodingClient();
  ref.onDispose(client.dispose);
  return client;
});

final reverseGeocodingClientProvider = Provider<ReverseGeocodingClient>((ref) {
  final client = ReverseGeocodingClient();
  ref.onDispose(client.dispose);
  return client;
});

/// Последний известный статус определения геолокации — чтобы UI мог показать
/// баннер «включите геолокацию», а не молча оставлять фолбэк.
class LocationStatusNotifier extends Notifier<LocationStatus> {
  @override
  LocationStatus build() => LocationStatus.unknown;

  void set(LocationStatus status) => state = status;
}

final locationStatusProvider =
    NotifierProvider<LocationStatusNotifier, LocationStatus>(
        LocationStatusNotifier.new);

/// Активная локация прогноза. Источник истины — prefs. При первом запуске
/// (нет сохранённой локации) пробуем уточнить координаты по геолокации;
/// если пользователь выбрал спот — он сохраняется и переживает перезапуск.
class ActiveLocationNotifier extends Notifier<GeoPoint> {
  @override
  GeoPoint build() {
    final raw = sharedPrefs.getString(PrefsKeys.activeLocation);
    if (raw == null) {
      // Первый запуск: остаёмся на фолбэке, но в фоне уточняем по устройству.
      Future.microtask(useDeviceLocation);
      return kDefaultLocation;
    }
    GeoPoint point;
    try {
      point = GeoPoint.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return kDefaultLocation;
    }
    // Сохранённая точка без названия (определена по GPS до этой фичи) —
    // в фоне подставим ближайший населённый пункт. Фолбэк-Москву не трогаем,
    // чтобы честно показывать «местоположение не уточнено».
    if (point.isUnnamed && point != kDefaultLocation) {
      Future.microtask(_resolveActiveName);
    }
    return point;
  }

  /// Активная точка не выбрана пользователем и не уточнена по GPS —
  /// сидим на хардкод-фолбэке (Москва). UI показывает это честно.
  bool get isOnFallback => state == kDefaultLocation;

  void setLocation(GeoPoint point) {
    state = point;
    sharedPrefs.setString(PrefsKeys.activeLocation, jsonEncode(point.toJson()));
  }

  /// Переименовать активную точку, если она всё ещё [from] (пользователь не
  /// успел переключиться). Для фонового обратного геокодинга добавленного спота.
  void renameIfCurrent(GeoPoint from, GeoPoint to) {
    if (state == from) setLocation(to);
  }

  Future<void> useDeviceLocation() async {
    final result = await ref.read(geolocationServiceProvider).currentLocation();
    ref.read(locationStatusProvider.notifier).set(result.status);
    if (result.point != null) {
      setLocation(result.point!);
      await _resolveActiveName();
    }
  }

  /// Если активная точка без названия — подставить ближайший населённый пункт
  /// (обратный геокодинг). Тихо ничего не делаем при сбое связи или если
  /// пользователь успел сменить точку, пока шёл запрос.
  Future<void> _resolveActiveName() async {
    final current = state;
    if (!current.isUnnamed) return;
    // Язык названия — выбранный в приложении, иначе системный.
    final lang = ref.read(localeProvider)?.languageCode ??
        PlatformDispatcher.instance.locale.languageCode;
    final name = await ref
        .read(reverseGeocodingClientProvider)
        .nearestSettlement(current.latitude, current.longitude, language: lang);
    if (name == null || name.isEmpty) return;
    if (state == current) setLocation(current.copyWith(name: name));
  }
}

final activeLocationProvider =
    NotifierProvider<ActiveLocationNotifier, GeoPoint>(
        ActiveLocationNotifier.new);
