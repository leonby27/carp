import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/forecast/domain/fish.dart';
import 'package:app/features/forecast/domain/spawn_advisor.dart';
import 'package:app/features/forecast/domain/weather_point.dart';

final carp = SpawnAdvisor.forFish(Fish.carp); // полоса 17–20 °C, месяцы 4–6

WeatherPoint _point({
  required DateTime time,
  required double waterTempC,
  double waterTrendC = 0,
}) {
  return WeatherPoint(
    time: time,
    pressureHpa: 1015,
    pressureTrend6h: 0,
    pressureTrend24h: 0,
    airTempC: waterTempC,
    waterTempC: waterTempC,
    waterTrendC: waterTrendC,
    windSpeedMs: 3,
    windDirDeg: 180,
    cloudCoverPct: 50,
    precipMm: 0,
    moonIllumination: 1,
    sunrise: DateTime(time.year, time.month, time.day, 6),
    sunset: DateTime(time.year, time.month, time.day, 20),
  );
}

void main() {
  group('SpawnAdvisor.assess — фаза карпа', () {
    test('вода в полосе и в сезоне → нерест', () {
      final s = carp.assess(_point(time: DateTime(2025, 5, 20), waterTempC: 18),
          tauDays: 4);
      expect(s.phase, SpawnPhase.spawning);
      expect(s.waterC, 18);
    });

    test('вода ниже полосы, растёт, близко → преднерест', () {
      final s = carp.assess(
          _point(time: DateTime(2025, 5, 1), waterTempC: 15, waterTrendC: 1.2),
          tauDays: 4);
      expect(s.phase, SpawnPhase.preSpawn);
    });

    test('вода ниже полосы, но не растёт → молчим', () {
      final s = carp.assess(
          _point(time: DateTime(2025, 5, 1), waterTempC: 15, waterTrendC: 0),
          tauDays: 4);
      expect(s.phase, SpawnPhase.none);
    });

    test('вода чуть выше полосы → посленерест', () {
      final s = carp.assess(_point(time: DateTime(2025, 6, 10), waterTempC: 22),
          tauDays: 4);
      expect(s.phase, SpawnPhase.postSpawn);
    });

    test('разгар лета (вода далеко выше полосы) → молчим', () {
      final s = carp.assess(_point(time: DateTime(2025, 6, 10), waterTempC: 27),
          tauDays: 4);
      expect(s.phase, SpawnPhase.none);
    });

    test('вне сезонного окна совпадение температуры не считаем нерестом', () {
      // Сентябрь, вода 18 °C — в полосе, но не в нерестовых месяцах.
      final s = carp.assess(_point(time: DateTime(2025, 9, 15), waterTempC: 18),
          tauDays: 4);
      expect(s.phase, SpawnPhase.none);
    });
  });

  group('SpawnAdvisor — южное полушарие', () {
    final southern = SpawnAdvisor.forFish(Fish.carp, southern: true);

    test('ноябрь на юге ≈ северному маю → нерест возможен', () {
      final s = southern.assess(
          _point(time: DateTime(2025, 11, 20), waterTempC: 18),
          tauDays: 4);
      expect(s.phase, SpawnPhase.spawning);
    });

    test('май на юге (осень) → молчим', () {
      final s = southern.assess(
          _point(time: DateTime(2025, 5, 20), waterTempC: 18),
          tauDays: 4);
      expect(s.phase, SpawnPhase.none);
    });
  });

  group('SpawnAdvisor — уверенность по τ водоёма', () {
    WeatherPoint inBand() =>
        _point(time: DateTime(2025, 5, 20), waterTempC: 18);

    test('малая τ (река/пруд) → высокая уверенность', () {
      expect(carp.assess(inBand(), tauDays: 3).confidence,
          SpawnConfidence.high);
    });

    test('средняя τ (неизвестный водоём) → средняя уверенность', () {
      expect(carp.assess(inBand(), tauDays: 10).confidence,
          SpawnConfidence.medium);
    });

    test('большая τ (крупное водохранилище) → низкая уверенность', () {
      expect(carp.assess(inBand(), tauDays: 30).confidence,
          SpawnConfidence.low);
    });
  });
}
