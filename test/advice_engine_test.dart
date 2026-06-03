import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/advice/domain/advice.dart';
import 'package:app/features/advice/domain/advice_engine.dart';
import 'package:app/features/forecast/domain/bite_score.dart';
import 'package:app/features/forecast/domain/fish.dart';
import 'package:app/features/forecast/domain/forecast.dart';
import 'package:app/features/forecast/domain/weather_point.dart';

WeatherPoint _point({
  double pressureTrend6h = 0,
  double airTempC = 18,
  double waterTempC = 19,
  double windSpeedMs = 3,
  double windDirDeg = 180,
  double cloudCoverPct = 50,
  double precipMm = 0,
}) {
  final t = DateTime(2025, 6, 15, 13);
  return WeatherPoint(
    time: t,
    pressureHpa: 1015,
    pressureTrend6h: pressureTrend6h,
    airTempC: airTempC,
    waterTempC: waterTempC,
    windSpeedMs: windSpeedMs,
    windDirDeg: windDirDeg,
    cloudCoverPct: cloudCoverPct,
    precipMm: precipMm,
    moonIllumination: 1,
    sunrise: DateTime(t.year, t.month, t.day, 6),
    sunset: DateTime(t.year, t.month, t.day, 20),
  );
}

/// День без почасовки (bestWindow == null), индекс задаётся напрямую.
DayForecast _day(WeatherPoint rep, {int biteValue = 50}) => DayForecast(
      date: DateTime(rep.time.year, rep.time.month, rep.time.day),
      representative: rep,
      bite: BiteScore(value: biteValue, factors: const []),
      hours: const [],
      minTempC: rep.airTempC,
      maxTempC: rep.airTempC,
    );

/// День с непрерывным «отличным» окном (рассветные часы) — даёт непустой
/// bestWindow с учётом новой устойчивой детекции (минимум 2 часа подряд).
DayForecast _dayWithWindow(WeatherPoint rep, {int biteValue = 50}) {
  return DayForecast(
    date: DateTime(rep.time.year, rep.time.month, rep.time.day),
    representative: rep,
    bite: BiteScore(value: biteValue, factors: const []),
    hours: [
      for (final h in const [5, 6, 7])
        HourForecast(
          weather: rep.copyWith(time: DateTime(2025, 6, 15, h)),
          bite: const BiteScore(value: 80, factors: []),
        ),
    ],
    minTempC: rep.airTempC,
    maxTempC: rep.airTempC,
  );
}

/// Этот набор тестов проверяет ветку карпа — оборачиваем [AdviceEngine.forDay],
/// подставляя [Fish.carp] (второй обязательный аргумент движка).
List<AdviceTip> _advice(DayForecast day, {DayForecast? prev}) =>
    AdviceEngine.forDay(day, Fish.carp, prev: prev);

AdviceCode _of(List<AdviceTip> advice, AdviceKind kind) =>
    advice.firstWhere((t) => t.kind == kind).code;

AdviceTip _tip(List<AdviceTip> advice, AdviceKind kind) =>
    advice.firstWhere((t) => t.kind == kind);

void main() {
  group('bait по температуре воды', () {
    test('холодная → яркая мелкая насадка', () {
      final a = _advice(_day(_point(waterTempC: 7)));
      expect(_of(a, AdviceKind.bait), AdviceCode.baitColdBright);
    });

    test('средняя стабильная → бойлы/пеллетс', () {
      final a = _advice(_day(_point(waterTempC: 13)));
      expect(_of(a, AdviceKind.bait), AdviceCode.baitMidBoilies);
    });

    test('тёплая стабильная → фишмил', () {
      final a = _advice(_day(_point(waterTempC: 20)));
      expect(_of(a, AdviceKind.bait), AdviceCode.baitWarmFishmeal);
    });

    test('жара → плавающие насадки', () {
      final a = _advice(_day(_point(waterTempC: 26)));
      expect(_of(a, AdviceKind.bait), AdviceCode.baitHotSurface);
    });
  });

  group('bait по динамике день-к-дню', () {
    test('потепление → совет «вода прогревается»', () {
      final prev = _day(_point(waterTempC: 16));
      final today = _day(_point(waterTempC: 18));
      final a = _advice(today, prev: prev);
      expect(_of(a, AdviceKind.bait), AdviceCode.baitWarming);
    });

    test('похолодание → совет «похолодание»', () {
      final prev = _day(_point(waterTempC: 19));
      final today = _day(_point(waterTempC: 17));
      final a = _advice(today, prev: prev);
      expect(_of(a, AdviceKind.bait), AdviceCode.baitCooling);
    });

    test('без prev (сегодня) тренда нет — базовый диапазон', () {
      final a = _advice(_day(_point(waterTempC: 18)));
      expect(_of(a, AdviceKind.bait), AdviceCode.baitWarmFishmeal);
    });
  });

  group('feeding', () {
    test('похолодание → скупой закорм', () {
      final prev = _day(_point(waterTempC: 19));
      final today = _day(_point(waterTempC: 17));
      expect(_of(_advice(today, prev: prev), AdviceKind.feeding),
          AdviceCode.feedMinimal);
    });

    test('тёплая + высокий индекс → обильный', () {
      final a = _advice(_day(_point(waterTempC: 20), biteValue: 85));
      expect(_of(a, AdviceKind.feeding), AdviceCode.feedHeavy);
    });

    test('тёплая вода 24–28 — пик жора, не скупой', () {
      // 27 °C — прайм-кормёжка: умеренный закорм (при среднем индексе),
      // а не «скупо», как раньше.
      expect(_of(_advice(_day(_point(waterTempC: 27))),
          AdviceKind.feeding), AdviceCode.feedModerate);
    });

    test('экстремальная жара ≥28 → скупой', () {
      expect(_of(_advice(_day(_point(waterTempC: 29))),
          AdviceKind.feeding), AdviceCode.feedMinimal);
    });
  });

  group('depth/rig', () {
    test('жара + ясно → поверхность', () {
      final a =
          _advice(_day(_point(waterTempC: 26, cloudCoverPct: 20)));
      expect(_of(a, AdviceKind.depth), AdviceCode.rigSurface);
    });

    test('потепление + солнце → зиг', () {
      final prev = _day(_point(waterTempC: 16));
      final today = _day(_point(waterTempC: 18, cloudCoverPct: 20));
      expect(_of(_advice(today, prev: prev), AdviceKind.depth),
          AdviceCode.rigZig);
    });

    test('дождливый день → дно', () {
      final a = _advice(_day(_point(waterTempC: 18, precipMm: 2)));
      expect(_of(a, AdviceKind.depth), AdviceCode.rigBottom);
    });
  });

  group('location', () {
    test('жара → глубина/тень', () {
      final a =
          _advice(_day(_point(airTempC: 30, windSpeedMs: 6)));
      expect(_of(a, AdviceKind.location), AdviceCode.swimSheltered);
    });

    test('заметный ветер → «в ветер» + направление в подсказке', () {
      // 180° = ветер с юга → windCardinal == s.
      final a = _advice(
          _day(_point(airTempC: 20, windSpeedMs: 5, windDirDeg: 180)));
      final tip = _tip(a, AdviceKind.location);
      expect(tip.code, AdviceCode.swimWindward);
      expect(tip.windDir, WindCardinal.s);
    });

    test('слабый ветер → укрытия', () {
      final a =
          _advice(_day(_point(airTempC: 20, windSpeedMs: 1)));
      expect(_of(a, AdviceKind.location), AdviceCode.swimCalmFeatures);
    });
  });

  group('timing', () {
    test('падение давления → окно перед фронтом', () {
      final a = _advice(
          _dayWithWindow(_point(pressureTrend6h: -3), biteValue: 50));
      expect(_of(a, AdviceKind.timing), AdviceCode.timePressureDrop);
    });

    test('есть окно клёва → конкретные часы', () {
      final a = _advice(_dayWithWindow(_point(), biteValue: 60));
      final tip = _tip(a, AdviceKind.timing);
      expect(tip.code, AdviceCode.timeBestWindow);
      expect(tip.window, isNotNull);
    });

    test('нет окна + низкий индекс → терпеливо', () {
      final a = _advice(_day(_point(), biteValue: 15));
      expect(_of(a, AdviceKind.timing), AdviceCode.timeSlowPatient);
    });
  });

  group('причина (reason) отражает реальный триггер', () {
    test('потепление → reason waterRising', () {
      final prev = _day(_point(waterTempC: 16));
      final today = _day(_point(waterTempC: 18));
      final tip = _tip(_advice(today, prev: prev), AdviceKind.bait);
      expect(tip.reason, AdviceReason.waterRising);
    });

    test('тёплая стабильная вода → reason waterTemp с величиной', () {
      final tip = _tip(_advice(_day(_point(waterTempC: 20))),
          AdviceKind.bait);
      expect(tip.reason, AdviceReason.waterTemp);
      expect(tip.reasonValue, 20);
    });

    test('ветер → reason windStrong со скоростью', () {
      final tip = _tip(
          _advice(_day(_point(airTempC: 20, windSpeedMs: 5))),
          AdviceKind.location);
      expect(tip.reason, AdviceReason.windStrong);
      expect(tip.reasonValue, 5);
    });

    test('падение давления → reason pressureFalling', () {
      final tip = _tip(
          _advice(_dayWithWindow(_point(pressureTrend6h: -3))),
          AdviceKind.timing);
      expect(tip.reason, AdviceReason.pressureFalling);
    });

    test('дождливый день → reason rainDay', () {
      final tip = _tip(
          _advice(_day(_point(waterTempC: 18, precipMm: 2))),
          AdviceKind.depth);
      expect(tip.reason, AdviceReason.rainDay);
    });
  });

  group('aroma по температуре воды и мути (дождь/ветер)', () {
    test('холодная прозрачная → сладко-фруктовый', () {
      final a = _advice(_day(_point(waterTempC: 7, cloudCoverPct: 20)));
      expect(_of(a, AdviceKind.aroma), AdviceCode.aromaSweetFruity);
    });

    test('холодная + ветер мутит воду → пряный', () {
      final a = _advice(_day(_point(waterTempC: 7, windSpeedMs: 7)));
      expect(_of(a, AdviceKind.aroma), AdviceCode.aromaSpicy);
    });

    test('холодная + дождь мутит воду → пряный', () {
      final a = _advice(_day(_point(waterTempC: 7, precipMm: 2)));
      expect(_of(a, AdviceKind.aroma), AdviceCode.aromaSpicy);
    });

    test('холодная + облачно, но вода спокойная → сладко-фруктовый', () {
      // Облачность больше НЕ считается мутью: пасмурно при штиле и без дождя —
      // вода прозрачная, аромат сладко-фруктовый.
      final a = _advice(_day(_point(waterTempC: 7, cloudCoverPct: 80)));
      expect(_of(a, AdviceKind.aroma), AdviceCode.aromaSweetFruity);
    });

    test('прогрев 10–16 → сладко-фруктовый', () {
      final a = _advice(_day(_point(waterTempC: 13)));
      expect(_of(a, AdviceKind.aroma), AdviceCode.aromaSweetFruity);
    });

    test('тёплый жор 16–24 → рыбно-мясной', () {
      final a = _advice(_day(_point(waterTempC: 20)));
      expect(_of(a, AdviceKind.aroma), AdviceCode.aromaFishmeal);
    });

    test('жара ≥24 → сладко-фруктовый (лёгкое на верх)', () {
      final a = _advice(_day(_point(waterTempC: 26)));
      expect(_of(a, AdviceKind.aroma), AdviceCode.aromaSweetFruity);
    });

    test('аромат опирается на температуру воды (reason)', () {
      final tip = _tip(_advice(_day(_point(waterTempC: 20))), AdviceKind.aroma);
      expect(tip.reason, AdviceReason.waterTemp);
      expect(tip.reasonValue, 20);
    });
  });

  group('aroma гистерезис у порогов 16/24 (шум модели воды)', () {
    test('был рыбно-мясной, чуть ниже 16 → удерживаем (липкий выход)', () {
      // prev=20°C → рыбно-мясной; сегодня 15.5°C в дед-бэнде [15,16) —
      // без гистерезиса перекинуло бы в сладко-фруктовый.
      final prev = _day(_point(waterTempC: 20));
      final today = _day(_point(waterTempC: 15.5));
      expect(_of(_advice(today, prev: prev), AdviceKind.aroma),
          AdviceCode.aromaFishmeal);
    });

    test('был сладко-фруктовый, чуть выше 16 → не входим (липкий вход)', () {
      // prev=13°C → сладко-фруктовый; сегодня 16.5°C ещё в дед-бэнде [16,17) —
      // без гистерезиса уже стало бы рыбно-мясным.
      final prev = _day(_point(waterTempC: 13));
      final today = _day(_point(waterTempC: 16.5));
      expect(_of(_advice(today, prev: prev), AdviceKind.aroma),
          AdviceCode.aromaSweetFruity);
    });

    test('заметный выход за полосу → профиль всё-таки меняется', () {
      // prev=20°C → рыбно-мясной; сегодня 14°C — глубже дед-бэнда, переключаем.
      final prev = _day(_point(waterTempC: 20));
      final today = _day(_point(waterTempC: 14));
      expect(_of(_advice(today, prev: prev), AdviceKind.aroma),
          AdviceCode.aromaSweetFruity);
    });
  });

  test('forDay возвращает по одному совету на каждую категорию по порядку', () {
    final a = _advice(_day(_point()));
    expect(a.map((t) => t.kind).toList(), [
      AdviceKind.bait,
      AdviceKind.aroma,
      AdviceKind.feeding,
      AdviceKind.depth,
      AdviceKind.location,
      AdviceKind.timing,
    ]);
  });
}
