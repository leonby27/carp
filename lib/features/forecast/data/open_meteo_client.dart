import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../../location/domain/geo_point.dart';
import '../domain/astro.dart';
import '../domain/weather_point.dart';

class OpenMeteoException implements Exception {
  OpenMeteoException(this.message);
  final String message;
  @override
  String toString() => 'OpenMeteoException: $message';
}

/// Клиент бесплатного Open-Meteo Forecast API (без ключа). Тянет почасовую
/// погоду на 8 дней вперёд ПЛЮС [_pastDays] суток назад и приводит её к
/// [WeatherPoint] — единому входу движка.
///
/// Температуру воды API не отдаёт, поэтому она оценивается из температуры
/// воздуха. Физически поверхность водоёма подчиняется dW/dt = (air − W)/τ —
/// это в точности экспоненциальное сглаживание (EMA) с постоянной времени τ.
/// Поэтому важны ДВЕ вещи, которых раньше не хватало:
///  1) реальная τ ≈ [_waterTauDays] суток (а не часы) — иначе нет ни тепловой
///     инерции, ни сезонного запаздывания (весной вода холоднее воздуха,
///     осенью теплее);
///  2) достаточная ПРЕДЫСТОРИЯ воздуха (≥ ~3·τ), чтобы EMA успела «накопить»
///     сезонное тепло до начала прогноза — ради этого и тянем [_pastDays] назад.
class OpenMeteoClient {
  OpenMeteoClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _hourlyVars =
      'temperature_2m,pressure_msl,cloud_cover,precipitation,'
      'wind_speed_10m,wind_direction_10m';

  /// Сколько суток истории воздуха тянуть для «разогрева» модели воды.
  /// ~3·τ обеспечивает сходимость EMA к реальному сезонному уровню к началу
  /// прогноза, дальше предыстория уже не влияет.
  static const _pastDays = 45;

  Future<Map<String, dynamic>> fetchJson(GeoPoint location) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': location.latitude.toString(),
      'longitude': location.longitude.toString(),
      'hourly': _hourlyVars,
      'daily': 'sunrise,sunset',
      'wind_speed_unit': 'ms',
      'timezone': 'auto',
      'forecast_days': '8',
      'past_days': '$_pastDays',
    });

    final http.Response resp;
    try {
      resp = await _client.get(uri);
    } catch (e) {
      throw OpenMeteoException('network error: $e');
    }
    if (resp.statusCode != 200) {
      throw OpenMeteoException('HTTP ${resp.statusCode}');
    }
    try {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    } catch (e) {
      throw OpenMeteoException('bad JSON: $e');
    }
  }

  /// Полный почасовой ряд С ПРЕДЫСТОРИЕЙ (не отсекаем) + сколько суток в начале —
  /// история. Вода посчитана при τ по умолчанию, но `airTempC` сохранён, поэтому
  /// вызывающий может пересчитать воду под конкретный водоём через
  /// [estimateWaterTemp], не делая повторный сетевой запрос.
  Future<({List<WeatherPoint> points, int pastDays})> fetchSeries(
      GeoPoint location) async {
    return seriesFromJson(await fetchJson(location));
  }

  /// Разбор УЖЕ полученного JSON в сырой ряд — без сетевого запроса. Нужен для
  /// офлайн-кэша: сохранённый ответ парсим тем же кодом, что и свежий.
  static ({List<WeatherPoint> points, int pastDays}) seriesFromJson(
      Map<String, dynamic> json) {
    return (
      points: _buildPoints(json, defaultWaterTauDays),
      pastDays: _pastDays,
    );
  }

  Future<List<WeatherPoint>> fetchHourly(GeoPoint location) async {
    return parse(await fetchJson(location), pastDays: _pastDays);
  }

  /// Разбор тела ответа в почасовой ряд. Выделено публично для тестов на
  /// фикстурах без сети.
  ///
  /// [pastDays] — сколько ведущих суток ряда относятся к ПРЕДЫСТОРИИ: они
  /// участвуют в оценке температуры воды (разогрев EMA), но в результат не
  /// попадают — наружу отдаём только окно прогноза (сегодня и вперёд).
  static List<WeatherPoint> parse(Map<String, dynamic> json,
      {int pastDays = 0, double waterTauDays = defaultWaterTauDays}) {
    final points = _buildPoints(json, waterTauDays);
    final skip = (pastDays * 24).clamp(0, points.length);
    return points.sublist(skip);
  }

  /// Полный ряд без отсечения предыстории. Вода — EMA воздуха с постоянной [tau].
  static List<WeatherPoint> _buildPoints(
      Map<String, dynamic> json, double tau) {
    final hourly = json['hourly'] as Map<String, dynamic>?;
    if (hourly == null) throw OpenMeteoException('missing hourly');

    final times = (hourly['time'] as List).cast<String>();
    final temp = _doubles(hourly['temperature_2m']);
    final pressure = _doubles(hourly['pressure_msl']);
    final cloud = _doubles(hourly['cloud_cover']);
    final precip = _doubles(hourly['precipitation']);
    final windSpeed = _doubles(hourly['wind_speed_10m']);
    final windDir = _doubles(hourly['wind_direction_10m']);

    final sun = _sunByDate(json['daily'] as Map<String, dynamic>?);
    final water = estimateWaterTemp(temp, tau);

    final points = <WeatherPoint>[];
    for (var i = 0; i < times.length; i++) {
      final time = DateTime.parse(times[i]);
      final dateKey = times[i].split('T').first;
      final daylight = sun[dateKey] ??
          (
            DateTime(time.year, time.month, time.day, 5),
            DateTime(time.year, time.month, time.day, 20, 30),
          );

      points.add(WeatherPoint(
        time: time,
        pressureHpa: pressure[i],
        pressureTrend6h: pressure[i] - pressure[i < 6 ? 0 : i - 6],
        pressureTrend24h: pressure[i] - pressure[i < 24 ? 0 : i - 24],
        airTempC: temp[i],
        waterTempC: water[i],
        windSpeedMs: windSpeed[i],
        windDirDeg: windDir[i],
        cloudCoverPct: cloud[i],
        precipMm: precip[i],
        moonIllumination: moonIllumination(time),
        sunrise: daylight.$1,
        sunset: daylight.$2,
      ));
    }
    return points;
  }

  static Map<String, (DateTime, DateTime)> _sunByDate(
      Map<String, dynamic>? daily) {
    final out = <String, (DateTime, DateTime)>{};
    if (daily == null) return out;
    final dates = (daily['time'] as List?)?.cast<String>() ?? const [];
    final sunrise = (daily['sunrise'] as List?)?.cast<String>() ?? const [];
    final sunset = (daily['sunset'] as List?)?.cast<String>() ?? const [];
    for (var i = 0; i < dates.length; i++) {
      if (i >= sunrise.length || i >= sunset.length) break;
      out[dates[i]] = (DateTime.parse(sunrise[i]), DateTime.parse(sunset[i]));
    }
    return out;
  }

  /// Постоянная времени тепловой инерции водоёма по умолчанию, суток. ~10 суток
  /// — компромисс, когда тип водоёма неизвестен. Зная тип/площадь из OSM, можно
  /// подставить свою τ (пруд — дни, крупное озеро — недели), см.
  /// `waterTauForBody` в forecast_providers.
  static const defaultWaterTauDays = 10.0;

  /// Оценка температуры воды как EMA воздуха с физической постоянной времени
  /// [tauDays]. Для часового шага alpha = 1 − exp(−Δt/τ), Δt = 1 ч.
  ///
  /// Сид — средняя температура первых суток ряда; при достаточной предыстории
  /// (см. [_pastDays]) его вклад к началу прогноза затухает, и вода определяется
  /// реальной накопленной историей воздуха, а не сидом.
  static List<double> estimateWaterTemp(List<double> air,
      [double tauDays = defaultWaterTauDays]) {
    if (air.isEmpty) return const [];
    final alpha = 1 - math.exp(-1 / (tauDays * 24));
    final seedCount = air.length < 24 ? air.length : 24;
    var acc = 0.0;
    for (var i = 0; i < seedCount; i++) {
      acc += air[i];
    }
    var water = acc / seedCount;
    final out = <double>[];
    for (final a in air) {
      water = alpha * a + (1 - alpha) * water;
      out.add(water);
    }
    return out;
  }

  static List<double> _doubles(Object? raw) {
    final list = (raw as List?) ?? const [];
    return [for (final v in list) (v as num?)?.toDouble() ?? 0.0];
  }

  void dispose() => _client.close();
}
