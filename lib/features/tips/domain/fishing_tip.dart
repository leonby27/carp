/// Практические советы по ловле карпа и карася.
///
/// Вечнозелёный контент, не зависит от погоды/прогноза (этим отличается от
/// data-driven «Тактики»/AdviceEngine). Каждый совет = заголовок + тело +
/// короткая строка-«пруф» (чтобы пользователь видел, что это не выдумка).
/// Порядок enum = порядок ротации; тексты берутся в presentation.
enum FishingTip {
  locationFirst,
  margins,
  sharpHooks,
  dontOverfeed,
  baitRegularly,
  hairRig,
  sweetcorn,
  mixedSizes,
  fallingPressure,
  waterTemp,
  pvaBag,
  featureFinding,
  stayQuiet,
  particles,
  fishCare,
  crucianShyBites,
  crucianFineTackle,
  crucianSlowFall,
  crucianWarmShallows,
}

/// Все советы в порядке показа.
const List<FishingTip> kFishingTips = FishingTip.values;

/// Индекс «совета дня» — детерминирован по календарному дню, чтобы при каждом
/// заходе в один день показывался один и тот же совет, а назавтра — следующий.
int tipOfDayIndex(DateTime now) {
  final daysSinceEpoch = now.toUtc().difference(DateTime.utc(2020)).inDays;
  return daysSinceEpoch % kFishingTips.length;
}
