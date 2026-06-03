import '../../forecast/domain/bite_score.dart';
import '../../forecast/domain/fish.dart';
import '../../forecast/domain/forecast.dart';
import '../../forecast/domain/weather_point.dart';
import '../../spots/domain/water_body.dart';
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
    WaterBody? body,
  }) {
    final w = day.representative;
    final features = _spotFeatures(body);
    final waterTrend = prev == null
        ? 0.0
        : w.waterTempC - prev.representative.waterTempC;
    final rainToday = day.hours.any((h) => h.weather.precipMm >= 0.3) ||
        w.condition == WeatherCondition.rain ||
        w.condition == WeatherCondition.storm;
    final level = day.bite.level;

    // Вчерашний аромат — для гистерезиса у температурных порогов (см. _aroma).
    final prevAroma =
        prev == null ? null : _aroma(prev.representative).code;

    return switch (fish) {
      Fish.carp => [
          _bait(w, waterTrend),
          _aroma(w, prevAroma: prevAroma),
          _feeding(w, waterTrend, level),
          _depth(w, waterTrend, rainToday),
          _location(w, features),
          _timing(w, level, day.bestWindow),
        ],
      Fish.crucian => [
          _crucianBait(w, waterTrend),
          _crucianFeeding(w, waterTrend, level),
          _crucianDepth(w, waterTrend),
          _crucianLocation(w, features),
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

  /// Вкус/аромат по температуре воды. Это химия растворимости ароматики плюс
  /// метаболизм, а не данные о водоёме. Три семейства: сладко-фруктовое —
  /// водорастворимое привлекающее (холод-прозрач, прогрев, жара на поверхности);
  /// рыбно-мясное — тёплый жор 16–24 °C (масла раздаются и кормят); пряное —
  /// холодная вода + муть от дождя/ветра (сильный сигнал для вялой рыбы).
  /// Полуширина дед-бэнда гистерезиса у порогов тёплой полосы, °C. Температура
  /// воды — модель (EMA воздуха, погрешность ±2–3 °C), поэтому у самой границы
  /// 16/24 °C микро-колебания иначе перекидывали бы совет день-к-дню. Сменяем
  /// профиль только при заметном (≥ [_aromaBand]) выходе за полосу.
  static const _aromaBand = 1.0;

  /// [prevAroma] — вчерашний аромат-код (для гистерезиса у порогов); null, если
  /// предыдущего дня нет.
  static AdviceTip _aroma(WeatherPoint w, {AdviceCode? prevAroma}) {
    final t = w.waterTempC;
    // Холодная + реально мутящий фактор — пряное. Муть воды поднимают дождевой
    // сток и ветровое перемешивание (измеряемые величины), а НЕ облачность неба:
    // пасмурно ≠ мутно, поэтому прокси по cloudCover убран как недостоверный.
    final stirred = w.precipMm >= 1.0 || w.windSpeedMs >= 6;
    if (t < 10 && stirred) {
      return AdviceTip(AdviceCode.aromaSpicy,
          reason: AdviceReason.waterTemp, reasonValue: t);
    }
    // Тёплый жор — рыбно-мясное (полоса 16–24 °C) с гистерезисом: если вчера уже
    // был этот профиль — отпускаем его только при выходе за полосу на _aromaBand;
    // войти в него с краёв (холод-прозрач/жара) — только зайдя на _aromaBand
    // внутрь. Так шум модели у границ не дёргает совет. Спайси (выше) завязан на
    // реальные дождь/ветер, не на шумную воду, — его не сглаживаем.
    const lo = 16.0, hi = 24.0;
    final bool fishmeal;
    if (prevAroma == AdviceCode.aromaFishmeal) {
      fishmeal = t >= lo - _aromaBand && t < hi + _aromaBand; // липкий выход
    } else if (prevAroma == AdviceCode.aromaSweetFruity) {
      fishmeal = t >= lo + _aromaBand && t < hi - _aromaBand; // липкий вход
    } else {
      fishmeal = t >= lo && t < hi; // нет истории — номинальные пороги
    }
    return AdviceTip(
        fishmeal ? AdviceCode.aromaFishmeal : AdviceCode.aromaSweetFruity,
        reason: AdviceReason.waterTemp,
        reasonValue: t);
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

  /// Структурные признаки спота из OSM → буллеты к совету «Место». Аддитивно:
  /// признаков может быть несколько сразу, порядок фиксирован. Пусто, если
  /// водоём неизвестен или структуры рядом нет.
  static List<SpotFeature> _spotFeatures(WaterBody? b) {
    if (b == null) return const [];
    return [
      if (b.reedsNearSpot) SpotFeature.reeds,
      if (b.inflowNearSpot) SpotFeature.inflow,
      if (b.damNearSpot) SpotFeature.dam,
      if (b.islandCount > 0) SpotFeature.island,
    ];
  }

  static AdviceTip _location(WeatherPoint w, List<SpotFeature> features) {
    if (w.airTempC >= 28) {
      return AdviceTip(AdviceCode.swimSheltered,
          reason: AdviceReason.airHot,
          reasonValue: w.airTempC,
          bullets: features);
    }
    if (w.windSpeedMs >= 4) {
      return AdviceTip(AdviceCode.swimWindward,
          reason: AdviceReason.windStrong,
          reasonValue: w.windSpeedMs,
          windDir: w.windCardinal,
          bullets: features);
    }
    return AdviceTip(AdviceCode.swimCalmFeatures,
        reason: AdviceReason.windLight, bullets: features);
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

  static AdviceTip _crucianLocation(WeatherPoint w, List<SpotFeature> features) {
    if (w.airTempC >= 30) {
      return AdviceTip(AdviceCode.crucianSwimDeepEdge,
          reason: AdviceReason.airHot,
          reasonValue: w.airTempC,
          bullets: features);
    }
    if (w.waterTempC < 14) {
      return AdviceTip(AdviceCode.crucianSwimWarmShallows,
          reason: AdviceReason.waterTemp,
          reasonValue: w.waterTempC,
          bullets: features);
    }
    return AdviceTip(AdviceCode.crucianSwimReeds,
        reason: AdviceReason.bottomHabit, bullets: features);
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
