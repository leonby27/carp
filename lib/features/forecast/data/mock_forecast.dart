import 'dart:math' as math;

import '../domain/astro.dart';
import '../domain/forecast.dart';
import '../domain/weather_point.dart';
import 'forecast_builder.dart';

/// Заглушка прогноза на 7 дней с правдоподобной погодой. Прогоняется через
/// общий [buildForecast] (и движок индекса), чтобы экран жил на реальной
/// логике до подключения Open-Meteo. Дни подобраны так, чтобы показать разброс
/// клёва.
Forecast buildMockForecast({
  required String locationName,
  DateTime? now,
}) {
  final today = _dateOnly(now ?? DateTime.now());
  final hourly = <WeatherPoint>[];

  for (var i = 0; i < _dayChars.length; i++) {
    final c = _dayChars[i];
    final date = today.add(Duration(days: i));
    final sunrise = date.add(const Duration(hours: 5));
    final sunset = date.add(const Duration(hours: 20, minutes: 30));
    final moon = moonIllumination(date);

    for (var h = 0; h < 24; h++) {
      final airT = c.airMid + c.airAmp * math.cos(2 * math.pi * (h - 15) / 24);
      hourly.add(WeatherPoint(
        time: date.add(Duration(hours: h)),
        pressureHpa: c.pressure + 1.2 * math.sin(2 * math.pi * h / 24),
        pressureTrend6h: c.trend,
        airTempC: airT,
        waterTempC: c.waterTemp,
        windSpeedMs: (c.wind + 0.8 * math.sin(2 * math.pi * (h - 9) / 24))
            .clamp(0.0, 30.0),
        windDirDeg: c.windDir,
        cloudCoverPct: c.cloud,
        precipMm: c.precip,
        moonIllumination: moon,
        sunrise: sunrise,
        sunset: sunset,
      ));
    }
  }

  return buildForecast(locationName, hourly);
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// «Характер» дня — погодный профиль, из которого раскручивается почасовка.
class _DayChar {
  const _DayChar({
    required this.pressure,
    required this.trend,
    required this.airMid,
    required this.airAmp,
    required this.waterTemp,
    required this.wind,
    required this.windDir,
    required this.cloud,
    required this.precip,
  });

  final double pressure; // гПа
  final double trend; // гПа / 6ч
  final double airMid; // средняя температура воздуха
  final double airAmp; // суточная амплитуда
  final double waterTemp;
  final double wind; // м/с
  final double windDir; // градусы
  final double cloud; // %
  final double precip; // мм/ч
}

const _dayChars = <_DayChar>[
  // Сегодня — отличный клёв: давление падает, тепло, ЮЗ ветерок.
  _DayChar(pressure: 1014, trend: -2, airMid: 19, airAmp: 5, waterTemp: 19, wind: 3, windDir: 225, cloud: 40, precip: 0),
  // Хороший: стабильно-низкое, пасмурно.
  _DayChar(pressure: 1016, trend: -1, airMid: 18, airAmp: 4, waterTemp: 18, wind: 4, windDir: 180, cloud: 60, precip: 0),
  // Средний: давление подрастает, ясно.
  _DayChar(pressure: 1020, trend: 3, airMid: 16, airAmp: 6, waterTemp: 17, wind: 6, windDir: 270, cloud: 15, precip: 0),
  // Слабый: резкий рост давления, северо-западный ветер.
  _DayChar(pressure: 1026, trend: 5, airMid: 14, airAmp: 6, waterTemp: 16, wind: 9, windDir: 315, cloud: 10, precip: 0),
  // Средний: лёгкий дождь, тепло.
  _DayChar(pressure: 1018, trend: -1, airMid: 18, airAmp: 4, waterTemp: 18, wind: 3, windDir: 180, cloud: 55, precip: 0.3),
  // Хороший: тёплая морось, давление падает.
  _DayChar(pressure: 1013, trend: -3, airMid: 22, airAmp: 4, waterTemp: 20, wind: 4, windDir: 225, cloud: 80, precip: 0.4),
  // Очень слабый: антициклон, холодный северный ветер.
  _DayChar(pressure: 1030, trend: 6, airMid: 11, airAmp: 5, waterTemp: 13, wind: 11, windDir: 0, cloud: 10, precip: 0),
];
