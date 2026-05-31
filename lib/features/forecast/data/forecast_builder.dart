import '../domain/bite_engine.dart';
import '../domain/bite_score.dart';
import '../domain/fish.dart';
import '../domain/forecast.dart';
import '../domain/spawn_advisor.dart';
import '../domain/weather_point.dart';
import 'open_meteo_client.dart';

/// Собирает [Forecast] из плоского почасового ряда: группирует точки по дате,
/// прогоняет через [BiteEngine] (профиль выбранного вида рыбы) и выбирает
/// околополуденную погоду как репрезентативную для суточного индекса. Единая
/// точка сборки для мок-данных и Open-Meteo — UI не знает, откуда пришли точки.
Forecast buildForecast(
  String locationName,
  List<WeatherPoint> hourly, {
  Fish fish = Fish.carp,
  DateTime? fetchedAt,
  double latitude = 0,
  bool fromCache = false,
  double waterTauDays = OpenMeteoClient.defaultWaterTauDays,
}) {
  // Южное полушарие — сезон инвертирован (lat < 0).
  final southern = latitude < 0;
  final engine = BiteEngine.forFish(fish, southern: southern);
  final spawnAdvisor = SpawnAdvisor.forFish(fish, southern: southern);
  final byDate = <DateTime, List<WeatherPoint>>{};
  for (final p in hourly) {
    final key = DateTime(p.time.year, p.time.month, p.time.day);
    (byDate[key] ??= []).add(p);
  }

  final dates = byDate.keys.toList()..sort();
  final days = <DayForecast>[];
  for (final date in dates) {
    final points = byDate[date]!..sort((a, b) => a.time.compareTo(b.time));

    final hours = [
      for (final p in points)
        HourForecast(weather: p, bite: engine.hourly(p)),
    ];

    var minT = double.infinity;
    var maxT = double.negativeInfinity;
    for (final p in points) {
      if (p.airTempC < minT) minT = p.airTempC;
      if (p.airTempC > maxT) maxT = p.airTempC;
    }

    final representative = _representative(points);
    // Дневной индекс — среднее базового балла по всем часам (без множителя
    // времени суток): убирает перекос «витрины» строго на 13:00 (летом самый
    // жаркий/тихий/яркий час). Факторы для «почему» берём из репрезентативной
    // точки — единый понятный разбор.
    var sum = 0;
    for (final p in points) {
      sum += engine.daily(p).value;
    }
    final dailyValue = points.isEmpty ? 0 : (sum / points.length).round();
    final repScore = engine.daily(representative);
    days.add(DayForecast(
      date: date,
      representative: representative,
      bite: BiteScore(value: dailyValue, factors: repScore.factors),
      hours: hours,
      minTempC: minT,
      maxTempC: maxT,
      spawn: spawnAdvisor.assess(representative, tauDays: waterTauDays),
    ));
  }

  return Forecast(
    locationName: locationName,
    days: days,
    fetchedAt: fetchedAt ?? DateTime.now(),
    fromCache: fromCache,
  );
}

/// Околополуденная точка (ближайший к 13:00 час) — стабильная «витрина» дня.
WeatherPoint _representative(List<WeatherPoint> points) {
  var best = points.first;
  var bestDist = (best.time.hour - 13).abs();
  for (final p in points) {
    final dist = (p.time.hour - 13).abs();
    if (dist < bestDist) {
      best = p;
      bestDist = dist;
    }
  }
  return best;
}
