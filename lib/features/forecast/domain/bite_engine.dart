import 'dart:math' as math;

import 'bite_config.dart';
import 'bite_score.dart';
import 'fish.dart';
import 'weather_point.dart';

/// Режим времени суток: какая поправка применяется к базовому индексу часа и
/// ПОЧЕМУ. Питает и почасовой множитель, и текст объяснения в модалке периода.
enum TimeOfDayRegime {
  dawn, // рассветная зорька — буст
  dusk, // вечерняя зорька — буст
  warmNight, // тёплая вода — ночь активна
  midNight, // умеренная вода — ночь средняя
  coldNight, // холодная вода — ночь проваливается
  middayHot, // жаркий полдень — рыба уходит
  coldDay, // прохлада — дневной прогрев относительно лучше
  dayNeutral, // обычный дневной час между зорьками
}

/// Движок индекса клёва. Эвристическая взвешенная модель: каждый фактор
/// переводится в балл 0..1 через свою кривую отклика, затем берётся взвешенная
/// сумма (см. [BiteConfig]). Чистый Dart, без Flutter и без знания об источнике
/// данных.
///
/// Профиль вида рыбы задаётся через [config]: один и тот же движок считает и
/// карпа, и карася — отличаются только параметры кривых и веса факторов.
class BiteEngine {
  const BiteEngine(this.config, {this.southern = false});

  /// Движок под выбранный вид рыбы. [southern] — южное полушарие: сезонная
  /// кривая зашита под северное, поэтому для юга месяцы сдвигаются на полгода.
  factory BiteEngine.forFish(Fish fish, {bool southern = false}) =>
      BiteEngine(BiteConfig.of(fish), southern: southern);

  final BiteConfig config;

  /// Южное полушарие: сезон инвертирован относительно северного.
  final bool southern;

  /// Базовый индекс «дня» без поправки на время суток.
  BiteScore daily(WeatherPoint p) => _score(p, timeMultiplier: 1.0);

  /// Почасовой индекс: базовый × множитель времени суток (рассвет/закат/ночь).
  BiteScore hourly(WeatherPoint p) =>
      _score(p, timeMultiplier: timeOfDayMultiplier(p));

  BiteScore _score(WeatherPoint p, {required double timeMultiplier}) {
    final pressure = pressureScore(p.pressureHpa, p.pressureTrend6h);
    final temperature = temperatureScore(p.waterTempC);
    final wind = windScore(p.windSpeedMs, p.windDirDeg);
    final cloud = cloudScore(p.cloudCoverPct, p.airTempC);
    final precip = precipScore(p.precipMm, p.airTempC);
    final season = seasonScore(p.month);
    final moon = moonScore(p.moonIllumination);

    final factors = <BiteFactor>[
      BiteFactor(
          kind: BiteFactorKind.pressure,
          score: pressure,
          weight: config.wPressure),
      BiteFactor(
          kind: BiteFactorKind.temperature,
          score: temperature,
          weight: config.wTemperature),
      BiteFactor(kind: BiteFactorKind.wind, score: wind, weight: config.wWind),
      BiteFactor(
          kind: BiteFactorKind.cloud, score: cloud, weight: config.wCloud),
      BiteFactor(
          kind: BiteFactorKind.precipitation,
          score: precip,
          weight: config.wPrecip),
      BiteFactor(
          kind: BiteFactorKind.season, score: season, weight: config.wSeason),
      BiteFactor(kind: BiteFactorKind.moon, score: moon, weight: config.wMoon),
    ];

    var base = 0.0;
    for (final f in factors) {
      base += f.score * f.weight;
    }
    // Лимитирующий гейт: один убийственный фактор не должен теряться в сумме.
    base *= _limitingGate(
      temperature: temperature,
      season: season,
      pressure: pressure,
      waterC: p.waterTempC,
      windMs: p.windSpeedMs,
    );
    // Последействие фронта: резкий рост давления за сутки держит клёв низким,
    // даже если 6-часовой тренд уже выровнялся (фронт прошёл «вчера»).
    base *= _postFrontGate(p.pressureTrend24h);
    // Тренд воды: устойчивый прогрев активизирует, остывание — наоборот.
    base *= _waterTrendGate(p.waterTrendC);
    final value = (base * 100 * timeMultiplier).round().clamp(0, 100);
    return BiteScore(value: value, factors: factors);
  }

  /// Мультипликативный штраф за лимитирующие условия (закон минимума Либиха):
  /// холодная вода, мёртвый сезон, шок давления, а также жара со штилем
  /// (кислородный стресс). Возвращает множитель 0..1 к итоговой сумме.
  double _limitingGate({
    required double temperature,
    required double season,
    required double pressure,
    required double waterC,
    required double windMs,
  }) {
    final tempGate =
        _gate(temperature, config.tempGateKnee, config.tempGateFloor);
    final seasonGate =
        _gate(season, config.seasonGateKnee, config.seasonGateFloor);
    final pressGate =
        _gate(pressure, config.pressureGateKnee, config.pressureGateFloor);
    // Жара + штиль: штраф включается, только когда одновременно жарко И тихо.
    final hot = ((waterC - config.tempOptimumHigh) /
            (config.tempHeatStress - config.tempOptimumHigh))
        .clamp(0.0, 1.0);
    final calm = ((config.windBestLow - windMs) / config.windBestLow)
        .clamp(0.0, 1.0);
    final heatCalmGate = 1 - config.heatCalmPenalty * hot * calm;
    return tempGate * seasonGate * pressGate * heatCalmGate;
  }

  /// Сглаженный штраф: 1.0 при [score] ≥ [knee], плавно спадает до [floor]
  /// при [score] → 0.
  static double _gate(double score, double knee, double floor) {
    if (score >= knee) return 1.0;
    return floor + (1.0 - floor) * (score / knee);
  }

  /// Последействие холодного фронта: чем резче давление выросло за сутки, тем
  /// сильнее подавлен клёв (рыбе нужно 1–2 дня прийти в себя). Штраф включается
  /// после +4 гПа/сутки и доходит до −[config.postFrontPenalty] при +12 гПа/сутки.
  double _postFrontGate(double trend24h) {
    final t = ((trend24h - 4) / 8).clamp(0.0, 1.0);
    return 1 - config.postFrontPenalty * t;
  }

  /// Тренд температуры воды за ~48 ч: прогрев — бонус, остывание — штраф
  /// (±[config.waterTrendBonus] при ±3 °C/48 ч). Уровень воды уже учтён кривой
  /// температуры — это добавка именно за ДИНАМИКУ (триггер жора на потеплении).
  double _waterTrendGate(double trendC) {
    final t = (trendC / 3).clamp(-1.0, 1.0);
    return 1 + config.waterTrendBonus * t;
  }

  // ── Факторы (каждый возвращает 0..1) ─────────────────────────

  double pressureScore(double hpa, double trend6h) {
    final level = _bell(
      hpa,
      config.pressureOptimumHpa,
      config.pressureHalfWidth,
    );
    final trend = _trendScore(trend6h);
    final s = config.pressureLevelShare;
    return (level * s + trend * (1 - s)).clamp(0.0, 1.0);
  }

  double _trendScore(double d) {
    // Лучше всего — медленное падение (−1..−4 гПа): преднастье фронта, жор.
    if (d <= -8) return 0.35; // резкий обвал — гроза, потом глухо
    if (d <= -4) return _lerp(d, -8, -4, 0.35, 0.95);
    if (d <= -1) return _lerp(d, -4, -1, 0.95, 1.0);
    if (d < 1) return 0.80; // стабильно
    if (d < 4) return _lerp(d, 1, 4, 0.70, 0.40); // медленный рост
    if (d < 8) return _lerp(d, 4, 8, 0.40, 0.18);
    return 0.15; // резкий скачок вверх — после фронта, хуже всего
  }

  /// Кривая по температуре воды задаётся 4 точками профиля: ниже [tempColdDormant]
  /// рыба почти не кормится; от него до [tempOptimumLow] активность нарастает;
  /// плато оптимума — до [tempOptimumHigh]; дальше спад из-за кислородного
  /// стресса, начиная с [tempHeatStress].
  double temperatureScore(double waterC) {
    final c = config;
    if (waterC <= c.tempColdDormant) return 0.10;
    if (waterC <= c.tempOptimumLow) {
      return _lerp(waterC, c.tempColdDormant, c.tempOptimumLow, 0.10, 0.85);
    }
    if (waterC <= c.tempOptimumHigh) {
      return _lerp(waterC, c.tempOptimumLow, c.tempOptimumHigh, 0.85, 1.0);
    }
    if (waterC <= c.tempHeatStress) {
      return _lerp(waterC, c.tempOptimumHigh, c.tempHeatStress, 1.0, 0.55);
    }
    return _lerp(waterC, c.tempHeatStress, c.tempHeatStress + 6, 0.55, 0.20)
        .clamp(0.20, 1.0);
  }

  double windScore(double speedMs, double dirDeg) {
    final speed = _windSpeedScore(speedMs);
    final dir = _windDirFactor(dirDeg);
    return (speed * dir).clamp(0.0, 1.0);
  }

  double _windSpeedScore(double s) {
    if (s <= 0.5) return 0.50; // штиль
    if (s <= config.windBestLow) {
      return _lerp(s, 0.5, config.windBestLow, 0.50, 0.90);
    }
    if (s <= config.windBestHigh) {
      return _lerp(s, config.windBestLow, config.windBestHigh, 0.90, 1.0);
    }
    if (s <= 8) return _lerp(s, config.windBestHigh, 8, 1.0, 0.60);
    if (s <= 12) return _lerp(s, 8, 12, 0.60, 0.35);
    return 0.18; // шторм
  }

  /// Тёплые южные румбы (≈180°) лучше холодных северных (≈0°).
  double _windDirFactor(double dirDeg) {
    final warmth = (math.cos(degToRad(dirDeg - 180)) + 1) / 2; // 1 юг, 0 север
    return config.windDirColdFactor +
        (config.windDirWarmFactor - config.windDirColdFactor) * warmth;
  }

  double cloudScore(double cloudPct, double airTempC) {
    final c = (cloudPct / 100).clamp(0.0, 1.0);
    if (airTempC >= 18) {
      // Тепло: переменная облачность лучше яркого солнца (рыба осторожна).
      return c <= 0.5 ? _lerp(c, 0, 0.5, 0.55, 1.0) : _lerp(c, 0.5, 1, 1.0, 0.85);
    }
    if (airTempC <= 12) {
      // Холодно: солнце прогревает мелководье.
      return _lerp(c, 0, 1, 0.85, 0.60);
    }
    return 0.80;
  }

  double precipScore(double mm, double airTempC) {
    if (mm <= 0) return 0.80;
    final warm = airTempC >= 14;
    if (mm < 0.5) return warm ? 1.0 : 0.70; // тёплая морось — триггер жора
    if (mm < 2) return warm ? 0.90 : 0.60;
    if (mm < 6) return 0.55;
    return 0.30; // ливень/гроза
  }

  double seasonScore(int month) {
    // На юге сдвигаем месяц на полгода: тамошний май (осень) ≈ северному ноябрю.
    final m = southern ? (month + 5) % 12 + 1 : month;
    return config.seasonByMonth[m] ?? 0.6;
  }

  double moonScore(double illumination) {
    // Солунар: пик активности у новолуния (0) и полнолуния (1), минимум в четвертях.
    final strength = ((illumination - 0.5).abs() * 2).clamp(0.0, 1.0);
    return 0.55 + 0.45 * strength;
  }

  // ── Множитель времени суток ──────────────────────────────────

  double timeOfDayMultiplier(WeatherPoint p) => timeOfDayBreakdown(p).multiplier;

  /// Поправка времени суток вместе с её ПРИЧИНОЙ ([TimeOfDayRegime]): одна и та
  /// же логика питает и почасовой множитель, и человекочитаемое объяснение
  /// «почему ночью оценка ниже, чем утром». Держим их вместе, чтобы текст и
  /// число никогда не разъезжались.
  ({TimeOfDayRegime regime, double multiplier}) timeOfDayBreakdown(
      WeatherPoint p) {
    final t = p.time;
    final hoursToSunrise = t.difference(p.sunrise).inMinutes / 60.0;
    final hoursToSunset = t.difference(p.sunset).inMinutes / 60.0;
    final water = p.waterTempC;

    // Рассвет: −1ч..+2ч вокруг восхода.
    if (hoursToSunrise >= -1 && hoursToSunrise <= 2) {
      return (regime: TimeOfDayRegime.dawn, multiplier: config.dawnBoost);
    }
    // Закат: −2ч..+1ч вокруг заката.
    if (hoursToSunset >= -2 && hoursToSunset <= 1) {
      return (regime: TimeOfDayRegime.dusk, multiplier: config.duskBoost);
    }

    final isNight = t.isBefore(p.sunrise) || t.isAfter(p.sunset);
    if (isNight) {
      // Ночь решает температура воды, а не календарь: в тёплой воде ночь —
      // активный клёв, в холодной рыба пассивна.
      if (water >= config.warmNightWaterC) {
        return (
          regime: TimeOfDayRegime.warmNight,
          multiplier: config.warmNightBoost
        );
      }
      if (water <= config.coldWaterC) {
        return (
          regime: TimeOfDayRegime.coldNight,
          multiplier: config.coldNightPenalty
        );
      }
      return (
        regime: TimeOfDayRegime.midNight,
        multiplier: _lerp(water, config.coldWaterC, config.warmNightWaterC,
            config.coldNightPenalty, config.warmNightBoost),
      );
    }

    // Жаркий полдень — рыба уходит с кормёжки (в тень/на глубину).
    if (t.hour >= 11 &&
        t.hour <= 16 &&
        (p.airTempC >= config.middayHeatC || water >= config.middayHeatC)) {
      return (
        regime: TimeOfDayRegime.middayHot,
        multiplier: config.middayHotPenalty
      );
    }
    // В холодной воде дневной прогрев — относительно лучшее время.
    if (water <= config.coldWaterC) {
      return (regime: TimeOfDayRegime.coldDay, multiplier: config.coldDayBoost);
    }
    return (regime: TimeOfDayRegime.dayNeutral, multiplier: config.dayNeutral);
  }

  // ── Математические помощники ─────────────────────────────────

  /// Гауссов колокол: 1.0 в [optimum], ≈0.37 на [optimum ± halfWidth].
  static double _bell(double x, double optimum, double halfWidth) {
    final z = (x - optimum) / halfWidth;
    return math.max(0.1, math.exp(-z * z));
  }

  /// Линейная интерполяция [outA..outB] по положению [x] в [inA..inB].
  static double _lerp(double x, double inA, double inB, double outA, double outB) {
    if (inB == inA) return outA;
    final t = ((x - inA) / (inB - inA)).clamp(0.0, 1.0);
    return outA + (outB - outA) * t;
  }
}
