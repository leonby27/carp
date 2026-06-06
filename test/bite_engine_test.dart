import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/forecast/domain/bite_config.dart';
import 'package:app/features/forecast/domain/bite_engine.dart';
import 'package:app/features/forecast/domain/bite_score.dart';
import 'package:app/features/forecast/domain/weather_point.dart';

/// Движок под карпа — базовый для большинства проверок.
final carp = BiteEngine(BiteConfig.carp);

/// Погодная точка с «нейтральными» значениями — тесты переопределяют через
/// именованные параметры только тот фактор, который проверяют.
WeatherPoint _point({
  DateTime? time,
  double pressureHpa = 1015,
  double pressureTrend6h = 0,
  double pressureTrend24h = 0,
  double airTempC = 18,
  double waterTempC = 19,
  double waterTrendC = 0,
  double windSpeedMs = 3,
  double windDirDeg = 180,
  double cloudCoverPct = 50,
  double precipMm = 0,
  double moonIllumination = 1,
  DateTime? sunrise,
  DateTime? sunset,
}) {
  final t = time ?? DateTime(2025, 6, 15, 13);
  return WeatherPoint(
    time: t,
    pressureHpa: pressureHpa,
    pressureTrend6h: pressureTrend6h,
    pressureTrend24h: pressureTrend24h,
    airTempC: airTempC,
    waterTempC: waterTempC,
    waterTrendC: waterTrendC,
    windSpeedMs: windSpeedMs,
    windDirDeg: windDirDeg,
    cloudCoverPct: cloudCoverPct,
    precipMm: precipMm,
    moonIllumination: moonIllumination,
    sunrise: sunrise ?? DateTime(t.year, t.month, t.day, 6),
    sunset: sunset ?? DateTime(t.year, t.month, t.day, 20),
  );
}

void main() {
  group('pressureScore', () {
    test('оптимум с медленным падением выше резкого скачка вверх', () {
      final falling = carp.pressureScore(1015, -2);
      final spiking = carp.pressureScore(1015, 10);
      expect(falling, greaterThan(spiking));
    });

    test('давление у оптимума выше, чем сильно отклонённое', () {
      final atOptimum = carp.pressureScore(1015, 0);
      final far = carp.pressureScore(975, 0);
      expect(atOptimum, greaterThan(far));
    });

    test('всегда в диапазоне 0..1', () {
      for (final hpa in [960.0, 1000.0, 1015.0, 1040.0]) {
        for (final trend in [-15.0, -2.0, 0.0, 12.0]) {
          final s = carp.pressureScore(hpa, trend);
          expect(s, inInclusiveRange(0.0, 1.0));
        }
      }
    });
  });

  group('temperatureScore', () {
    test('холодная вода почти усыпляет клёв', () {
      expect(carp.temperatureScore(2), lessThan(0.2));
    });

    test('пик активности в оптимуме 16..22°C', () {
      final optimum = carp.temperatureScore(20);
      final cold = carp.temperatureScore(8);
      final hot = carp.temperatureScore(32);
      expect(optimum, greaterThan(cold));
      expect(optimum, greaterThan(hot));
      expect(optimum, greaterThan(0.8));
    });

    test('монотонный рост от холода к оптимуму', () {
      expect(carp.temperatureScore(8), lessThan(carp.temperatureScore(14)));
      expect(carp.temperatureScore(14), lessThan(carp.temperatureScore(20)));
    });
  });

  group('windScore', () {
    test('тёплый южный ветер лучше холодного северного при той же скорости', () {
      expect(carp.windScore(4, 180), greaterThan(carp.windScore(4, 0)));
    });

    test('лёгкий бриз 2..5 м/с лучше шторма', () {
      expect(carp.windScore(4, 180), greaterThan(carp.windScore(15, 180)));
    });
  });

  group('moonScore', () {
    test('полнолуние и новолуние выше четвертей', () {
      final full = carp.moonScore(1.0);
      final newMoon = carp.moonScore(0.0);
      final quarter = carp.moonScore(0.5);
      expect(full, greaterThan(quarter));
      expect(newMoon, greaterThan(quarter));
      expect(full, closeTo(newMoon, 1e-9));
    });
  });

  group('seasonScore', () {
    test('май/сентябрь — пик, январь — провал', () {
      expect(carp.seasonScore(5), greaterThan(carp.seasonScore(1)));
      expect(carp.seasonScore(9), equals(1.0));
      expect(carp.seasonScore(1), equals(0.25));
    });

    test('южное полушарие сдвигает сезон на полгода', () {
      final south = BiteEngine(BiteConfig.carp, southern: true);
      // Ноябрь на юге ≈ май на севере (пик), май на юге ≈ ноябрь (спад).
      expect(south.seasonScore(11), equals(1.0));
      expect(south.seasonScore(5), equals(0.50));
      // Северное (по умолчанию) не меняется.
      expect(carp.seasonScore(5), equals(1.0));
    });
  });

  group('последействие фронта и тренд воды', () {
    test('резкий рост давления за сутки снижает индекс', () {
      final calmDay = _point(waterTempC: 20, time: DateTime(2025, 6, 15, 13));
      final afterFront = _point(
        waterTempC: 20,
        pressureTrend24h: 10,
        time: DateTime(2025, 6, 15, 13),
      );
      expect(carp.daily(afterFront).value, lessThan(carp.daily(calmDay).value));
    });

    test('прогрев воды даёт выше индекс, чем остывание', () {
      final warming = _point(
        waterTempC: 18,
        waterTrendC: 3,
        time: DateTime(2025, 5, 15, 13),
      );
      final cooling = _point(
        waterTempC: 18,
        waterTrendC: -3,
        time: DateTime(2025, 5, 15, 13),
      );
      expect(carp.daily(warming).value, greaterThan(carp.daily(cooling).value));
    });
  });

  group('профиль карася против карпа', () {
    test('кислородный штраф мягче, перепады давления жёстче', () {
      expect(BiteConfig.crucian.heatCalmPenalty,
          lessThan(BiteConfig.carp.heatCalmPenalty));
      expect(BiteConfig.crucian.postFrontPenalty,
          greaterThan(BiteConfig.carp.postFrontPenalty));
    });

    test('последействие фронта у карася роняет индекс сильнее (в долях)', () {
      final crucian = BiteEngine(BiteConfig.crucian);
      double drop(BiteEngine e) {
        final base =
            e.daily(_point(waterTempC: 22, time: DateTime(2025, 7, 15, 13)))
                .value;
        final front = e
            .daily(_point(
                waterTempC: 22,
                pressureTrend24h: 10,
                time: DateTime(2025, 7, 15, 13)))
            .value;
        return (base - front) / base;
      }

      expect(drop(crucian), greaterThan(drop(carp)));
    });

    test('жара со штилем карасю почти не вредит (он O2-толерантен)', () {
      final crucian = BiteEngine(BiteConfig.crucian);
      double drop(BiteEngine e, BiteConfig c) {
        final breeze = e
            .daily(_point(
                waterTempC: c.tempHeatStress - 1,
                airTempC: 33,
                windSpeedMs: 4,
                time: DateTime(2025, 7, 15, 13)))
            .value;
        final calm = e
            .daily(_point(
                waterTempC: c.tempHeatStress - 1,
                airTempC: 33,
                windSpeedMs: 0.5,
                time: DateTime(2025, 7, 15, 13)))
            .value;
        return (breeze - calm) / breeze;
      }

      // У карася просадка от штиля в жару заметно меньше карповой.
      expect(drop(crucian, BiteConfig.crucian),
          lessThan(drop(carp, BiteConfig.carp)));
    });
  });

  group('daily', () {
    test('идеальный день даёт высокий индекс, плохой — низкий', () {
      final great = carp.daily(_point(
        pressureHpa: 1015,
        pressureTrend6h: -2,
        waterTempC: 20,
        windSpeedMs: 4,
        windDirDeg: 180,
        cloudCoverPct: 45,
        precipMm: 0.2,
        moonIllumination: 1,
        time: DateTime(2025, 5, 15, 13),
      ));
      final poor = carp.daily(_point(
        pressureHpa: 980,
        pressureTrend6h: 11,
        waterTempC: 3,
        windSpeedMs: 16,
        windDirDeg: 0,
        cloudCoverPct: 100,
        precipMm: 9,
        moonIllumination: 0.5,
        time: DateTime(2025, 1, 15, 13),
      ));
      expect(great.value, greaterThan(poor.value));
      expect(great.level, equals(BiteLevel.excellent));
      // Плохой день остаётся в нижней части шкалы.
      expect(poor.value, lessThan(40));
    });

    test('индекс всегда в диапазоне 0..100', () {
      final s = carp.daily(_point());
      expect(s.value, inInclusiveRange(0, 100));
    });

    test('возвращает по одному фактору на каждый вид', () {
      final s = carp.daily(_point());
      expect(s.factors.length, equals(BiteFactorKind.values.length));
      expect(
        s.factors.map((f) => f.kind).toSet(),
        equals(BiteFactorKind.values.toSet()),
      );
    });
  });

  group('лимитирующий гейт', () {
    test('ледяная вода роняет индекс, даже если всё прочее идеально', () {
      // Идеальные давление/ветер/облачность/луна, но вода 3°C (рыба в покое) —
      // аддитивная сумма раньше давала «Хороший»; гейт должен опустить ниже.
      final dormant = carp.daily(_point(
        pressureHpa: 1015,
        pressureTrend6h: -2,
        waterTempC: 3,
        windSpeedMs: 4,
        windDirDeg: 180,
        cloudCoverPct: 40,
        precipMm: 0,
        moonIllumination: 1,
        time: DateTime(2025, 1, 15, 13),
      ));
      expect(dormant.level, isNot(BiteLevel.good));
      expect(dormant.level, isNot(BiteLevel.excellent));
      expect(dormant.value, lessThan(45));
    });

    test('резкий скачок давления вверх ощутимо снижает индекс', () {
      final base = _point(
        waterTempC: 20,
        windSpeedMs: 4,
        windDirDeg: 180,
        cloudCoverPct: 45,
        time: DateTime(2025, 6, 15, 13),
      );
      final stable = carp.daily(base);
      final shock = carp.daily(_point(
        pressureHpa: 1028,
        pressureTrend6h: 7,
        waterTempC: 20,
        windSpeedMs: 4,
        windDirDeg: 180,
        cloudCoverPct: 45,
        time: DateTime(2025, 6, 15, 13),
      ));
      // Скачок давления должен заметно (>8 пунктов) опускать индекс.
      expect(shock.value, lessThan(stable.value - 8));
    });

    test('жара со штилем хуже той же жары с лёгким ветром', () {
      final hotCalm = carp.daily(_point(
        waterTempC: 27,
        airTempC: 32,
        windSpeedMs: 0.5,
        cloudCoverPct: 10,
        time: DateTime(2025, 7, 15, 13),
      ));
      final hotBreeze = carp.daily(_point(
        waterTempC: 27,
        airTempC: 32,
        windSpeedMs: 4,
        cloudCoverPct: 10,
        time: DateTime(2025, 7, 15, 13),
      ));
      expect(hotCalm.value, lessThan(hotBreeze.value));
    });
  });

  group('timeOfDayMultiplier', () {
    test('рассвет даёт буст', () {
      final dawn = _point(
        time: DateTime(2025, 6, 15, 6, 30),
        sunrise: DateTime(2025, 6, 15, 6),
        sunset: DateTime(2025, 6, 15, 20),
      );
      expect(carp.timeOfDayMultiplier(dawn), equals(BiteConfig.carp.dawnBoost));
    });

    test('жаркий полдень штрафуется сильнее рассвета', () {
      final dawn = _point(
        time: DateTime(2025, 6, 15, 6, 30),
        sunrise: DateTime(2025, 6, 15, 6),
        sunset: DateTime(2025, 6, 15, 20),
      );
      final midday = _point(
        time: DateTime(2025, 6, 15, 14),
        airTempC: 30,
        sunrise: DateTime(2025, 6, 15, 6),
        sunset: DateTime(2025, 6, 15, 20),
      );
      expect(
        carp.timeOfDayMultiplier(midday),
        lessThan(carp.timeOfDayMultiplier(dawn)),
      );
      expect(
        carp.timeOfDayMultiplier(midday),
        equals(BiteConfig.carp.middayHotPenalty),
      );
    });

    test('холодная ночь штрафуется, тёплая — даёт буст (карп — ночной)', () {
      final coldNight = _point(
        time: DateTime(2025, 1, 15, 2),
        waterTempC: 4,
        sunrise: DateTime(2025, 1, 15, 8),
        sunset: DateTime(2025, 1, 15, 17),
      );
      final warmNight = _point(
        time: DateTime(2025, 7, 15, 2),
        waterTempC: 20,
        sunrise: DateTime(2025, 7, 15, 5),
        sunset: DateTime(2025, 7, 15, 21),
      );
      expect(
        carp.timeOfDayMultiplier(coldNight),
        equals(BiteConfig.carp.coldNightPenalty),
      );
      expect(
        carp.timeOfDayMultiplier(warmNight),
        equals(BiteConfig.carp.warmNightBoost),
      );
      expect(carp.timeOfDayMultiplier(warmNight), greaterThan(1.0));
    });

    test('тёплая ночь активнее жаркого полудня', () {
      final warmNight = _point(
        time: DateTime(2025, 7, 15, 2),
        waterTempC: 20,
        sunrise: DateTime(2025, 7, 15, 5),
        sunset: DateTime(2025, 7, 15, 21),
      );
      final hotMidday = _point(
        time: DateTime(2025, 7, 15, 14),
        airTempC: 30,
        waterTempC: 25,
        sunrise: DateTime(2025, 7, 15, 5),
        sunset: DateTime(2025, 7, 15, 21),
      );
      expect(
        carp.timeOfDayMultiplier(warmNight),
        greaterThan(carp.timeOfDayMultiplier(hotMidday)),
      );
    });
  });

  group('BiteScore level/stars', () {
    BiteScore scoreOf(int v) => BiteScore(value: v, factors: const []);

    test('границы уровней (строгие пороги 22/45/68/86)', () {
      expect(scoreOf(0).level, BiteLevel.veryLow);
      expect(scoreOf(21).level, BiteLevel.veryLow);
      expect(scoreOf(22).level, BiteLevel.low);
      expect(scoreOf(44).level, BiteLevel.low);
      expect(scoreOf(45).level, BiteLevel.medium);
      expect(scoreOf(67).level, BiteLevel.medium);
      expect(scoreOf(68).level, BiteLevel.good);
      expect(scoreOf(85).level, BiteLevel.good);
      expect(scoreOf(86).level, BiteLevel.excellent);
      expect(scoreOf(100).level, BiteLevel.excellent);
    });

    test('звёзды 1..5 соответствуют уровню', () {
      expect(scoreOf(10).stars, 1);
      expect(scoreOf(30).stars, 2);
      expect(scoreOf(55).stars, 3);
      expect(scoreOf(75).stars, 4);
      expect(scoreOf(90).stars, 5);
    });
  });

  group('config invariant', () {
    test('сумма весов равна 1.0 для обоих профилей', () {
      for (final c in [BiteConfig.carp, BiteConfig.crucian]) {
        final sum = c.wPressure +
            c.wTemperature +
            c.wWind +
            c.wCloud +
            c.wPrecip +
            c.wSeason +
            c.wMoon;
        expect(sum, closeTo(1.0, 1e-9));
      }
    });
  });
}
