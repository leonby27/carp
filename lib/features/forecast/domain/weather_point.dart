import 'dart:math' as math;

/// Погодные данные на конкретный момент времени — единый вход для движка
/// клёва. Источник может быть любым (мок, Open-Meteo) — движок про источник
/// ничего не знает.
class WeatherPoint {
  const WeatherPoint({
    required this.time,
    required this.pressureHpa,
    required this.pressureTrend6h,
    required this.airTempC,
    required this.waterTempC,
    required this.windSpeedMs,
    required this.windDirDeg,
    required this.cloudCoverPct,
    required this.precipMm,
    required this.moonIllumination,
    required this.sunrise,
    required this.sunset,
    this.pressureTrend24h = 0,
    this.waterTrendC = 0,
  });

  final DateTime time;

  /// Давление, приведённое к уровню моря, гПа.
  final double pressureHpa;

  /// Изменение давления за ~6 часов, гПа (отрицательное = падает).
  final double pressureTrend6h;

  /// Изменение давления за ~24 часа, гПа. Большой положительный = недавно
  /// прошёл фронт (резко выросло давление) — клёв ещё подавлен сутки-двое.
  final double pressureTrend24h;

  /// Изменение температуры воды за ~48 часов, °C. Устойчивый прогрев — триггер
  /// активизации, остывание — наоборот.
  final double waterTrendC;

  final double airTempC;

  /// Температура воды — приходит из API либо оценивается по сглаженной
  /// температуре воздуха.
  final double waterTempC;

  final double windSpeedMs;

  /// Направление ветра, откуда дует, в градусах (0 = север, 180 = юг).
  final double windDirDeg;

  /// Облачность, 0..100 %.
  final double cloudCoverPct;

  /// Осадки, мм/ч.
  final double precipMm;

  /// Освещённость луны: 0 = новолуние, 1 = полнолуние.
  final double moonIllumination;

  final DateTime sunrise;
  final DateTime sunset;

  int get month => time.month;

  WeatherCondition get condition {
    if (precipMm >= 4) return WeatherCondition.storm;
    if (precipMm >= 0.3) return WeatherCondition.rain;
    if (cloudCoverPct >= 75) return WeatherCondition.cloudy;
    if (cloudCoverPct >= 30) return WeatherCondition.partlyCloudy;
    return WeatherCondition.clear;
  }

  /// Стороны света для отображения направления ветра.
  WindCardinal get windCardinal => cardinalFromDeg(windDirDeg);

  WeatherPoint copyWith({
    DateTime? time,
    double? pressureHpa,
    double? pressureTrend6h,
    double? airTempC,
    double? waterTempC,
    double? windSpeedMs,
    double? windDirDeg,
    double? cloudCoverPct,
    double? precipMm,
    double? moonIllumination,
    DateTime? sunrise,
    DateTime? sunset,
    double? pressureTrend24h,
    double? waterTrendC,
  }) {
    return WeatherPoint(
      time: time ?? this.time,
      pressureHpa: pressureHpa ?? this.pressureHpa,
      pressureTrend6h: pressureTrend6h ?? this.pressureTrend6h,
      airTempC: airTempC ?? this.airTempC,
      waterTempC: waterTempC ?? this.waterTempC,
      windSpeedMs: windSpeedMs ?? this.windSpeedMs,
      windDirDeg: windDirDeg ?? this.windDirDeg,
      cloudCoverPct: cloudCoverPct ?? this.cloudCoverPct,
      precipMm: precipMm ?? this.precipMm,
      moonIllumination: moonIllumination ?? this.moonIllumination,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      pressureTrend24h: pressureTrend24h ?? this.pressureTrend24h,
      waterTrendC: waterTrendC ?? this.waterTrendC,
    );
  }
}

enum WeatherCondition { clear, partlyCloudy, cloudy, rain, storm }

enum WindCardinal { n, ne, e, se, s, sw, w, nw }

/// Сторона света по азимуту в градусах (0 = север, по часовой стрелке).
WindCardinal cardinalFromDeg(double deg) {
  final idx = (((deg % 360) + 22.5) ~/ 45) % 8;
  return WindCardinal.values[idx];
}

/// Конвертирует мм рт. ст. ↔ гПа на случай, если в настройках выберут мм.
double hpaToMmHg(double hpa) => hpa * 0.750062;

/// Среднее значение по списку (для агрегатов дня), безопасно для пустого.
double avg(Iterable<double> xs) {
  var sum = 0.0;
  var n = 0;
  for (final x in xs) {
    sum += x;
    n++;
  }
  return n == 0 ? 0 : sum / n;
}

/// Кратчайшая угловая разница направлений ветра в градусах [0..180].
double angularDelta(double a, double b) {
  final d = (a - b).abs() % 360;
  return d > 180 ? 360 - d : d;
}

double degToRad(double deg) => deg * math.pi / 180;
