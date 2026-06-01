import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/persistence/prefs_service.dart';
import '../../location/application/location_providers.dart';
import '../../location/domain/geo_point.dart';
import '../../spots/application/spots_providers.dart';
import '../../spots/domain/water_body.dart';
import '../data/forecast_builder.dart';
import '../data/open_meteo_client.dart';
import '../domain/bite_engine.dart';
import '../domain/fish.dart';
import '../domain/forecast.dart';
import '../domain/weather_point.dart';

final openMeteoClientProvider = Provider<OpenMeteoClient>((ref) {
  final client = OpenMeteoClient();
  ref.onDispose(client.dispose);
  return client;
});

/// Постоянная времени прогрева воды (τ, сут) под тип/размер водоёма из OSM.
/// Проточная и мелкая вода идёт за воздухом быстро, крупные озёра — медленно.
/// Когда водоём неизвестен — дефолт клиента.
double waterTauForBody(WaterBody? body) {
  if (body == null) return OpenMeteoClient.defaultWaterTauDays;
  switch (body.type) {
    case WaterBodyType.river:
    case WaterBodyType.canal:
      return 3; // проточная — быстро отслеживает воздух
    case WaterBodyType.pond:
      return 4; // мелкий, быстро прогревается
    case WaterBodyType.lake:
    case WaterBodyType.reservoir:
    case WaterBodyType.other:
      final ha = body.areaHa;
      if (ha == null) return OpenMeteoClient.defaultWaterTauDays;
      if (ha < 10) return 6;
      if (ha < 100) return 12;
      if (ha < 1000) return 20;
      return 30; // большое водохранилище — сильная тепловая инерция
  }
}

/// Сырой почасовой ряд погоды + момент загрузки и флаг «из офлайн-кэша».
typedef WeatherSeries = ({
  List<WeatherPoint> points,
  int pastDays,
  DateTime fetchedAt,
  bool fromCache,
});

/// ~5 км допуска по координатам: для часовой сетки погоды этого достаточно,
/// чтобы считать кэш «той же локацией» (текущая GPS-точка слегка дрожит между
/// фиксами, и не хочется ронять офлайн-фолбэк из-за метров).
const _cacheCoordTolerance = 0.05;

void _cacheWeather(Map<String, dynamic> json, GeoPoint location, DateTime at) {
  sharedPrefs.setString(PrefsKeys.cachedWeatherJson, jsonEncode(json));
  sharedPrefs.setDouble(PrefsKeys.cachedWeatherLat, location.latitude);
  sharedPrefs.setDouble(PrefsKeys.cachedWeatherLon, location.longitude);
  sharedPrefs.setInt(PrefsKeys.cachedWeatherAtMs, at.millisecondsSinceEpoch);
}

({Map<String, dynamic> json, DateTime at})? _readCachedWeather(
    GeoPoint location) {
  final raw = sharedPrefs.getString(PrefsKeys.cachedWeatherJson);
  final lat = sharedPrefs.getDouble(PrefsKeys.cachedWeatherLat);
  final lon = sharedPrefs.getDouble(PrefsKeys.cachedWeatherLon);
  final atMs = sharedPrefs.getInt(PrefsKeys.cachedWeatherAtMs);
  if (raw == null || lat == null || lon == null || atMs == null) return null;
  // Кэш для заметно другой локации не подсовываем — лучше честная ошибка.
  if ((lat - location.latitude).abs() > _cacheCoordTolerance ||
      (lon - location.longitude).abs() > _cacheCoordTolerance) {
    return null;
  }
  try {
    return (
      json: jsonDecode(raw) as Map<String, dynamic>,
      at: DateTime.fromMillisecondsSinceEpoch(atMs),
    );
  } catch (_) {
    return null;
  }
}

/// Сырой почасовой ряд погоды из Open-Meteo — зависит ТОЛЬКО от координат.
/// Вынесен отдельно, чтобы пересчёт температуры воды под тип водоёма не дёргал
/// повторный сетевой запрос: меняется только τ, ряд воздуха берётся из кэша.
///
/// Офлайн: успешный ответ кэшируем в prefs; при сетевой ошибке отдаём последний
/// сохранённый ряд (если он для этой же локации) с пометкой [fromCache] — иначе
/// пробрасываем ошибку на экран.
final weatherSeriesProvider = FutureProvider<WeatherSeries>((ref) async {
  ref.watch(
      activeLocationProvider.select((l) => (l.latitude, l.longitude)));
  final client = ref.watch(openMeteoClientProvider);
  final location = ref.read(activeLocationProvider);
  try {
    final json = await client.fetchJson(location);
    final now = DateTime.now();
    _cacheWeather(json, location, now);
    final s = OpenMeteoClient.seriesFromJson(json);
    return (
      points: s.points,
      pastDays: s.pastDays,
      fetchedAt: now,
      fromCache: false,
    );
  } catch (_) {
    final cached = _readCachedWeather(location);
    if (cached == null) rethrow;
    final s = OpenMeteoClient.seriesFromJson(cached.json);
    return (
      points: s.points,
      pastDays: s.pastDays,
      fetchedAt: cached.at,
      fromCache: true,
    );
  }
});

/// Выбранный вид рыбы. От него зависит профиль индекса клёва и иллюстрации.
/// Смена вида перезапрашивает прогноз (как смена локации).
class SelectedFishNotifier extends Notifier<Fish> {
  @override
  Fish build() => Fish.carp;

  void select(Fish fish) => state = fish;
}

final selectedFishProvider =
    NotifierProvider<SelectedFishNotifier, Fish>(SelectedFishNotifier.new);

/// Сконфигурированный движок индекса под выбранный вид рыбы и полушарие.
/// Нужен UI (модалка «почему такая оценка») для разбора базовых факторов и
/// поправки времени суток по конкретному часу — те же расчёты, что и в прогнозе.
final biteEngineProvider = Provider<BiteEngine>((ref) {
  final fish = ref.watch(selectedFishProvider);
  final location = ref.read(activeLocationProvider);
  return BiteEngine.forFish(fish, southern: location.latitude < 0);
});

/// Прогноз по активной локации из Open-Meteo, прогнанный через движок индекса
/// для выбранного вида рыбы. Перезапрашивается автоматически при смене локации
/// или вида рыбы.
final forecastProvider = FutureProvider<Forecast>((ref) async {
  // Погоду и водоём запускаем ПАРАЛЛЕЛЬНО: оба провайдера начинают грузиться в
  // момент watch (до await), поэтому общее ожидание ≈ медленнейший из двух, а не
  // их сумма. Раньше водоём трогали только после await погоды — запросы шли
  // последовательно и складывались (до ~20 с на медленной сети/Overpass).
  final seriesFuture = ref.watch(weatherSeriesProvider.future);
  // Тип водоёма (из OSM) задаёт τ прогрева воды. Обработчик ошибки вешаем сразу:
  // если зеркала Overpass недоступны — τ по умолчанию (а не «unhandled» ошибка),
  // и прогноз считается один раз, без «мигания» индекса с дефолтного τ.
  final bodyFuture = ref
      .watch(waterBodyProvider.future)
      .then<WaterBody?>((b) => b, onError: (_) => null);

  // Сырой ряд (только координаты) + вид рыбы. Переименование локации прогноз
  // не дёргает — weatherSeriesProvider зависит лишь от координат.
  final series = await seriesFuture;
  final fish = ref.watch(selectedFishProvider);
  final location = ref.read(activeLocationProvider);

  final body = await bodyFuture;
  final tau = waterTauForBody(body);

  // Пересчёт воды под τ по ПОЛНОЙ истории, затем отсекаем предысторию.
  final air = [for (final p in series.points) p.airTempC];
  final water = OpenMeteoClient.estimateWaterTemp(air, tau);
  final full = [
    for (var i = 0; i < series.points.length; i++)
      series.points[i].copyWith(
        waterTempC: water[i],
        // Тренд воды за ~48 ч — триггер активизации при прогреве.
        waterTrendC: water[i] - water[i < 48 ? 0 : i - 48],
      ),
  ];
  final skip = (series.pastDays * 24).clamp(0, full.length);
  final windowed = full.sublist(skip);

  return buildForecast(location.name, windowed,
      fish: fish,
      latitude: location.latitude,
      fetchedAt: series.fetchedAt,
      fromCache: series.fromCache,
      waterTauDays: tau);
});

/// Индекс выбранного дня в ленте 7 дней (0 = сегодня). Сбрасывается на «сегодня»
/// при смене локации.
class SelectedDayNotifier extends Notifier<int> {
  @override
  int build() {
    // Только по смене координат: переименование локации не должно сбрасывать
    // выбранный день на «сегодня».
    ref.listen(activeLocationProvider.select((l) => (l.latitude, l.longitude)),
        (_, _) => state = 0);
    ref.listen(selectedFishProvider, (_, _) => state = 0);
    return 0;
  }

  void select(int index) {
    final days = ref.read(forecastProvider).value?.days.length ?? 0;
    if (index >= 0 && index < days) state = index;
  }
}

final selectedDayIndexProvider =
    NotifierProvider<SelectedDayNotifier, int>(SelectedDayNotifier.new);

/// Идёт ли ручное обновление прогноза. На время true главный экран показывает
/// полноэкранную загрузку вместо контента; по завершении контент монтируется
/// заново — числа проигрывают count-up с нуля (подтверждение пересчёта).
class ForecastRefreshing extends Notifier<bool> {
  @override
  bool build() => false;

  void start() => state = true;
  void stop() => state = false;
}

final forecastRefreshingProvider =
    NotifierProvider<ForecastRefreshing, bool>(ForecastRefreshing.new);
