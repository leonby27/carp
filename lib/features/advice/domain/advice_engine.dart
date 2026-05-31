import '../../forecast/domain/bite_score.dart';
import '../../forecast/domain/fish.dart';
import '../../forecast/domain/forecast.dart';
import '../../forecast/domain/weather_point.dart';
import 'advice.dart';

/// Эвристический «движок тактики»: по реальной погоде Open-Meteo выдаёт по
/// одному совету на каждую категорию [AdviceKind].
///
/// Ключевой принцип — советы должны отличаться по дням, поэтому движок смотрит
/// не на один полуденный час, а на: динамику воды день-к-дню (потепление/
/// похолодание), факт дождя в течение дня, фактическое направление ветра и
/// реальное окно клёва дня. Это устоявшиеся карповые эвристики на основе
/// погоды, а не данные конкретного водоёма.
class AdviceEngine {
  const AdviceEngine._();

  /// Порог «заметного» суточного изменения температуры воды, °C.
  static const _trendThreshold = 1.0;

  /// Советы для дня [day] под выбранный вид рыбы [fish]. [prev] — предыдущий
  /// день для расчёта тренда (null для сегодняшнего дня). Порядок результата
  /// фиксирован по [AdviceKind]: bait, feeding, depth, location, timing.
  static List<AdviceTip> forDay(
    DayForecast day,
    Fish fish, {
    DayForecast? prev,
  }) {
    final w = day.representative;
    final waterTrend = prev == null
        ? 0.0
        : w.waterTempC - prev.representative.waterTempC;
    final rainToday = day.hours.any((h) => h.weather.precipMm >= 0.3) ||
        w.condition == WeatherCondition.rain ||
        w.condition == WeatherCondition.storm;
    final level = day.bite.level;

    return switch (fish) {
      Fish.carp => [
          _bait(w, waterTrend),
          _feeding(w, waterTrend, level),
          _depth(w, waterTrend, rainToday),
          _location(w),
          _timing(w, level, day.bestWindow),
        ],
      Fish.crucian => [
          _crucianBait(w, waterTrend),
          _crucianFeeding(w, waterTrend, level),
          _crucianDepth(w, waterTrend),
          _crucianLocation(w),
          _crucianTiming(w, level, day.bestWindow),
        ],
    };
  }

  static AdviceTip _bait(WeatherPoint w, double trend) {
    final t = w.waterTempC;
    if (t < 10) {
      return AdviceTip(AdviceCode.baitColdBright,
          reason: AdviceReason.waterTemp, reasonValue: t);
    }
    if (trend <= -_trendThreshold && t < 20) {
      return const AdviceTip(AdviceCode.baitCooling,
          reason: AdviceReason.waterFalling);
    }
    if (trend >= _trendThreshold && t < 24) {
      return const AdviceTip(AdviceCode.baitWarming,
          reason: AdviceReason.waterRising);
    }
    if (t < 16) {
      return AdviceTip(AdviceCode.baitMidBoilies,
          reason: AdviceReason.waterTemp, reasonValue: t);
    }
    if (t < 24) {
      return AdviceTip(AdviceCode.baitWarmFishmeal,
          reason: AdviceReason.waterTemp, reasonValue: t);
    }
    return AdviceTip(AdviceCode.baitHotSurface,
        reason: AdviceReason.waterTemp, reasonValue: t);
  }

  static AdviceTip _feeding(WeatherPoint w, double trend, BiteLevel level) {
    final t = w.waterTempC;
    // Скупо кормим на похолодании, в холоде и в ЭКСТРЕМАЛЬНУЮ жару (кислородный
    // стресс, ≥28 °C). Тёплая вода 24–28 — это пик жора, недокармливать незачем.
    if (trend <= -_trendThreshold) {
      return const AdviceTip(AdviceCode.feedMinimal,
          reason: AdviceReason.waterFalling);
    }
    if (t < 10 || t >= 28) {
      return AdviceTip(AdviceCode.feedMinimal,
          reason: AdviceReason.waterTemp, reasonValue: t);
    }
    if (t < 16) {
      return AdviceTip(AdviceCode.feedModerate,
          reason: AdviceReason.waterTemp, reasonValue: t);
    }
    if (trend >= _trendThreshold) {
      return const AdviceTip(AdviceCode.feedHeavy,
          reason: AdviceReason.waterRising);
    }
    if (level == BiteLevel.good || level == BiteLevel.excellent) {
      return const AdviceTip(AdviceCode.feedHeavy,
          reason: AdviceReason.biteHigh);
    }
    return AdviceTip(AdviceCode.feedModerate,
        reason: AdviceReason.waterTemp, reasonValue: t);
  }

  static AdviceTip _depth(WeatherPoint w, double trend, bool rainToday) {
    final t = w.waterTempC;
    if (t >= 24) {
      // Жара — рыба поднимается. Ясно → у поверхности, облачно → в толще.
      return w.cloudCoverPct < 50
          ? AdviceTip(AdviceCode.rigSurface,
              reason: AdviceReason.waterTemp, reasonValue: t)
          : AdviceTip(AdviceCode.rigZig,
              reason: AdviceReason.waterTemp, reasonValue: t);
    }
    // Потепление + солнце поднимают рыбу в толщу — пробуем зиг.
    if (trend >= _trendThreshold && t >= 16 && w.cloudCoverPct < 50) {
      return const AdviceTip(AdviceCode.rigZig,
          reason: AdviceReason.waterRising);
    }
    if (rainToday) {
      return const AdviceTip(AdviceCode.rigBottom,
          reason: AdviceReason.rainDay);
    }
    return const AdviceTip(AdviceCode.rigBottom,
        reason: AdviceReason.bottomHabit);
  }

  static AdviceTip _location(WeatherPoint w) {
    if (w.airTempC >= 28) {
      return AdviceTip(AdviceCode.swimSheltered,
          reason: AdviceReason.airHot, reasonValue: w.airTempC);
    }
    if (w.windSpeedMs >= 4) {
      return AdviceTip(AdviceCode.swimWindward,
          reason: AdviceReason.windStrong,
          reasonValue: w.windSpeedMs,
          windDir: w.windCardinal);
    }
    return const AdviceTip(AdviceCode.swimCalmFeatures,
        reason: AdviceReason.windLight);
  }

  static AdviceTip _timing(WeatherPoint w, BiteLevel level, BiteWindow? window) {
    if (w.pressureTrend6h <= -2) {
      return const AdviceTip(AdviceCode.timePressureDrop,
          reason: AdviceReason.pressureFalling);
    }
    if (window != null && level != BiteLevel.veryLow) {
      return AdviceTip(AdviceCode.timeBestWindow,
          reason: AdviceReason.bestHours, window: (window.from, window.to));
    }
    return switch (level) {
      BiteLevel.good || BiteLevel.excellent =>
        const AdviceTip(AdviceCode.timeAllDay, reason: AdviceReason.biteHigh),
      BiteLevel.veryLow || BiteLevel.low =>
        const AdviceTip(AdviceCode.timeSlowPatient,
            reason: AdviceReason.biteLow),
      BiteLevel.medium =>
        const AdviceTip(AdviceCode.timeDawnDusk, reason: AdviceReason.biteMid),
    };
  }

  // ── Карась ──────────────────────────────────────────────────────────────
  // Карась теплолюбивее и капризнее карпа: температурные пороги выше, упор на
  // мелкие мягкие насадки и переключение животная↔растительная, а падение
  // давления — не «окно перед фронтом», а сигнал пассивности.

  static AdviceTip _crucianBait(WeatherPoint w, double trend) {
    final t = w.waterTempC;
    if (t < 12) {
      return AdviceTip(AdviceCode.crucianBaitColdAnimal,
          reason: AdviceReason.waterTemp, reasonValue: t);
    }
    if (trend <= -_trendThreshold && t < 22) {
      return const AdviceTip(AdviceCode.crucianBaitCooling,
          reason: AdviceReason.waterFalling);
    }
    if (trend >= _trendThreshold && t < 26) {
      return const AdviceTip(AdviceCode.crucianBaitWarming,
          reason: AdviceReason.waterRising);
    }
    if (t < 18) {
      return AdviceTip(AdviceCode.crucianBaitSandwich,
          reason: AdviceReason.waterTemp, reasonValue: t);
    }
    if (t < 25) {
      return AdviceTip(AdviceCode.crucianBaitWarmPlant,
          reason: AdviceReason.waterTemp, reasonValue: t);
    }
    return AdviceTip(AdviceCode.crucianBaitHotDough,
        reason: AdviceReason.waterTemp, reasonValue: t);
  }

  static AdviceTip _crucianFeeding(
      WeatherPoint w, double trend, BiteLevel level) {
    final t = w.waterTempC;
    // Карася легко перекормить — в холод, жару и на похолодании кормим скупо.
    if (trend <= -_trendThreshold) {
      return const AdviceTip(AdviceCode.crucianFeedTiny,
          reason: AdviceReason.waterFalling);
    }
    if (t < 12 || t >= 26) {
      return AdviceTip(AdviceCode.crucianFeedTiny,
          reason: AdviceReason.waterTemp, reasonValue: t);
    }
    if (trend >= _trendThreshold) {
      return const AdviceTip(AdviceCode.crucianFeedActive,
          reason: AdviceReason.waterRising);
    }
    if (level == BiteLevel.good || level == BiteLevel.excellent) {
      return const AdviceTip(AdviceCode.crucianFeedActive,
          reason: AdviceReason.biteHigh);
    }
    return AdviceTip(AdviceCode.crucianFeedSweet,
        reason: AdviceReason.waterTemp, reasonValue: t);
  }

  static AdviceTip _crucianDepth(WeatherPoint w, double trend) {
    final t = w.waterTempC;
    if (t >= 25) {
      // Жара: по ясной погоде карась греется на мелководье у поверхности,
      // в облачность держится глубже над дном.
      return w.cloudCoverPct < 50
          ? AdviceTip(AdviceCode.crucianRigShallow,
              reason: AdviceReason.waterTemp, reasonValue: t)
          : AdviceTip(AdviceCode.crucianRigFloatBottom,
              reason: AdviceReason.waterTemp, reasonValue: t);
    }
    // Потепление поднимает карася в полводы — медленно тонущая насадка.
    if (trend >= _trendThreshold && t >= 18) {
      return const AdviceTip(AdviceCode.crucianRigDropper,
          reason: AdviceReason.waterRising);
    }
    return const AdviceTip(AdviceCode.crucianRigFloatBottom,
        reason: AdviceReason.bottomHabit);
  }

  static AdviceTip _crucianLocation(WeatherPoint w) {
    if (w.airTempC >= 30) {
      return AdviceTip(AdviceCode.crucianSwimDeepEdge,
          reason: AdviceReason.airHot, reasonValue: w.airTempC);
    }
    if (w.waterTempC < 14) {
      return AdviceTip(AdviceCode.crucianSwimWarmShallows,
          reason: AdviceReason.waterTemp, reasonValue: w.waterTempC);
    }
    return const AdviceTip(AdviceCode.crucianSwimReeds,
        reason: AdviceReason.bottomHabit);
  }

  static AdviceTip _crucianTiming(
      WeatherPoint w, BiteLevel level, BiteWindow? window) {
    // Инверсия карпа: падение давления для карася — не выход, а пассивность.
    if (w.pressureTrend6h <= -2) {
      return const AdviceTip(AdviceCode.crucianTimePressureDrop,
          reason: AdviceReason.pressureFalling);
    }
    if (window != null && level != BiteLevel.veryLow) {
      return AdviceTip(AdviceCode.crucianTimeBestWindow,
          reason: AdviceReason.bestHours, window: (window.from, window.to));
    }
    return switch (level) {
      BiteLevel.good || BiteLevel.excellent => const AdviceTip(
          AdviceCode.crucianTimeStableWarm,
          reason: AdviceReason.biteHigh),
      BiteLevel.veryLow || BiteLevel.low => const AdviceTip(
          AdviceCode.crucianTimePatient,
          reason: AdviceReason.biteLow),
      BiteLevel.medium => const AdviceTip(AdviceCode.crucianTimeMorning,
          reason: AdviceReason.biteMid),
    };
  }
}
