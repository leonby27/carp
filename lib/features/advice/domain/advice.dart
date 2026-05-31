import '../../forecast/domain/weather_point.dart' show WindCardinal;

/// Категория совета по тактике ловли.
enum AdviceKind { bait, feeding, depth, location, timing }

/// Конкретные рекомендации. Движок выбирает по одному коду на категорию,
/// presentation-слой превращает код в локализованный текст и иконку.
enum AdviceCode {
  // bait — насадка
  baitColdBright,
  baitMidBoilies,
  baitWarmFishmeal,
  baitHotSurface,
  baitWarming,
  baitCooling,
  // feeding — прикормка
  feedMinimal,
  feedModerate,
  feedHeavy,
  // depth — горизонт/оснастка
  rigBottom,
  rigZig,
  rigSurface,
  // location — где ловить
  swimWindward,
  swimCalmFeatures,
  swimSheltered,
  // timing — когда
  timePressureDrop,
  timeBestWindow,
  timeDawnDusk,
  timeAllDay,
  timeSlowPatient,

  // ── Карась ──────────────────────────────────────────────────────────────
  // Отдельный набор: карась капризнее карпа, любит мелкие мягкие насадки,
  // тёплые заросшие мелководья, утро; падение давления делает его пассивным
  // (инверсия карповой логики «окна перед фронтом»).
  // bait — насадка
  crucianBaitColdAnimal, // холод: мелкий мотыль/опарыш, животная
  crucianBaitWarming, // потепление: животная активизирует
  crucianBaitCooling, // похолодание: капризничает — мельче, бутерброд
  crucianBaitSandwich, // переходная вода: бутерброд опарыш+перловка
  crucianBaitWarmPlant, // тепло: растительные — перловка, манка, кукуруза
  crucianBaitHotDough, // жара: мягкое тесто/болтушка
  // feeding — прикормка
  crucianFeedTiny, // совсем скупо, мелкая сладкая
  crucianFeedSweet, // умеренно, мелкая сладкая (чеснок/ваниль)
  crucianFeedActive, // активно, но малыми порциями
  // depth — горизонт/оснастка
  crucianRigFloatBottom, // поплавок, насадка у дна / лежит — классика
  crucianRigDropper, // подпасок, медленное опускание над дном
  crucianRigShallow, // прогретое мелководье у поверхности
  // location — где ловить
  crucianSwimReeds, // кромка камыша/травы, окна в растительности
  crucianSwimWarmShallows, // самые прогретые мелководья
  crucianSwimDeepEdge, // приямки/тень в зной
  // timing — когда
  crucianTimePressureDrop, // падение давления — пассивен, лови терпеливо
  crucianTimeBestWindow, // окно клёва
  crucianTimeMorning, // утренняя зорька — классика по карасю
  crucianTimeStableWarm, // стабильное тепло — активен и днём
  crucianTimePatient, // слабый клёв — точечно и терпеливо
}

/// Что именно стало главным основанием для совета — показывается короткой
/// строкой «почему», чтобы рекомендация не выглядела случайной.
enum AdviceReason {
  waterTemp, // reasonValue = °C
  waterRising,
  waterFalling,
  airHot, // reasonValue = °C
  windStrong, // reasonValue = м/с
  windLight,
  pressureFalling,
  rainDay,
  bottomHabit,
  biteHigh,
  biteMid,
  biteLow,
  bestHours,
}

/// Совет с данными для текста: причина выбора (+ при необходимости числовое
/// значение в метрике), направление ветра дня и реальное окно клёва — всё это
/// заполняет плейсхолдеры в локализованных строках.
class AdviceTip {
  const AdviceTip(
    this.code, {
    required this.reason,
    this.reasonValue,
    this.windDir,
    this.window,
  });

  final AdviceCode code;
  final AdviceReason reason;

  /// Сырое значение в метрике (°C или м/с) для строки «почему»; форматируется
  /// в выбранные единицы на presentation-слое.
  final double? reasonValue;
  final WindCardinal? windDir;
  final (DateTime, DateTime)? window;

  AdviceKind get kind => adviceKindOf(code);
}

AdviceKind adviceKindOf(AdviceCode code) => switch (code) {
      AdviceCode.baitColdBright ||
      AdviceCode.baitMidBoilies ||
      AdviceCode.baitWarmFishmeal ||
      AdviceCode.baitHotSurface ||
      AdviceCode.baitWarming ||
      AdviceCode.baitCooling =>
        AdviceKind.bait,
      AdviceCode.feedMinimal ||
      AdviceCode.feedModerate ||
      AdviceCode.feedHeavy =>
        AdviceKind.feeding,
      AdviceCode.rigBottom ||
      AdviceCode.rigZig ||
      AdviceCode.rigSurface =>
        AdviceKind.depth,
      AdviceCode.swimWindward ||
      AdviceCode.swimCalmFeatures ||
      AdviceCode.swimSheltered =>
        AdviceKind.location,
      AdviceCode.timePressureDrop ||
      AdviceCode.timeBestWindow ||
      AdviceCode.timeDawnDusk ||
      AdviceCode.timeAllDay ||
      AdviceCode.timeSlowPatient =>
        AdviceKind.timing,
      // ── Карась ──
      AdviceCode.crucianBaitColdAnimal ||
      AdviceCode.crucianBaitWarming ||
      AdviceCode.crucianBaitCooling ||
      AdviceCode.crucianBaitSandwich ||
      AdviceCode.crucianBaitWarmPlant ||
      AdviceCode.crucianBaitHotDough =>
        AdviceKind.bait,
      AdviceCode.crucianFeedTiny ||
      AdviceCode.crucianFeedSweet ||
      AdviceCode.crucianFeedActive =>
        AdviceKind.feeding,
      AdviceCode.crucianRigFloatBottom ||
      AdviceCode.crucianRigDropper ||
      AdviceCode.crucianRigShallow =>
        AdviceKind.depth,
      AdviceCode.crucianSwimReeds ||
      AdviceCode.crucianSwimWarmShallows ||
      AdviceCode.crucianSwimDeepEdge =>
        AdviceKind.location,
      AdviceCode.crucianTimePressureDrop ||
      AdviceCode.crucianTimeBestWindow ||
      AdviceCode.crucianTimeMorning ||
      AdviceCode.crucianTimeStableWarm ||
      AdviceCode.crucianTimePatient =>
        AdviceKind.timing,
    };
