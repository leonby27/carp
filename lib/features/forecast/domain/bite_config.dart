import 'fish.dart';

/// Профиль параметров и весов индекса клёва для конкретного вида рыбы.
///
/// Меняй значения в готовых профилях ([carp], [crucian]) — логика движка
/// [BiteEngine] их просто читает, ничего переписывать не нужно. Сумма весов
/// внутри профиля должна оставаться равной 1.0.
class BiteConfig {
  const BiteConfig({
    required this.wPressure,
    required this.wTemperature,
    required this.wWind,
    required this.wCloud,
    required this.wPrecip,
    required this.wSeason,
    required this.wMoon,
    required this.pressureOptimumHpa,
    required this.pressureHalfWidth,
    required this.pressureLevelShare,
    required this.tempColdDormant,
    required this.tempOptimumLow,
    required this.tempOptimumHigh,
    required this.tempHeatStress,
    required this.windBestLow,
    required this.windBestHigh,
    required this.windDirColdFactor,
    required this.windDirWarmFactor,
    required this.dawnBoost,
    required this.duskBoost,
    required this.warmNightBoost,
    required this.middayHotPenalty,
    required this.coldDayBoost,
    required this.dayNeutral,
    required this.coldNightPenalty,
    required this.warmNightWaterC,
    required this.coldWaterC,
    required this.seasonByMonth,
    required this.spawnTempLow,
    required this.spawnTempHigh,
    this.minSpawnDaylightHours = 12.5,
    this.tempGateKnee = 0.45,
    this.tempGateFloor = 0.45,
    this.seasonGateKnee = 0.40,
    this.seasonGateFloor = 0.55,
    this.pressureGateKnee = 0.50,
    this.pressureGateFloor = 0.40,
    this.heatCalmPenalty = 0.40,
    this.postFrontPenalty = 0.18,
    this.waterTrendBonus = 0.08,
    this.middayHeatC = 24,
  });

  // ── Веса факторов (в сумме = 1.00) ───────────────────────────
  final double wPressure;
  final double wTemperature;
  final double wWind;
  final double wCloud;
  final double wPrecip;
  final double wSeason;
  final double wMoon;

  // ── Давление ─────────────────────────────────────────────────
  /// Оптимум абсолютного давления, гПа.
  final double pressureOptimumHpa;

  /// Полуширина колокола: на ±этой дельте от оптимума балл уровня ≈ 0.37.
  final double pressureHalfWidth;

  /// Доля «уровня» против «тренда» в общем балле давления.
  final double pressureLevelShare;

  // ── Температура воды, °C (точки кривой) ──────────────────────
  final double tempColdDormant; // ниже — почти не кормится
  final double tempOptimumLow;
  final double tempOptimumHigh; // пик активности
  final double tempHeatStress; // выше — кислородный стресс

  // ── Ветер ────────────────────────────────────────────────────
  final double windBestLow; // м/с
  final double windBestHigh;
  final double windDirColdFactor; // множитель для холодных румбов
  final double windDirWarmFactor; // для тёплых (южных)

  // ── Множители времени суток (почасовой индекс) ──────────────
  final double dawnBoost;
  final double duskBoost;
  final double warmNightBoost; // тёплая ночь
  final double middayHotPenalty; // жара: рыба уходит с кормёжки
  final double coldDayBoost; // холод: день (прогрев) лучше ночи
  final double dayNeutral; // обычный дневной час
  final double coldNightPenalty; // холодная ночь — рыба вялая

  /// Температура воды, при которой рыба уверенно кормится ночью, °C.
  final double warmNightWaterC;

  /// Холодная вода: ночь проваливается, день относительно лучше, °C.
  final double coldWaterC;

  /// Порог «жаркого полдня», °C: при такой температуре воздуха или воды в
  /// околополуденные часы рыба уходит с кормёжки в тень/на глубину.
  final double middayHeatC;

  // ── Сезонность по месяцам (1..12) ───────────────────────────
  final Map<int, double> seasonByMonth;

  // ── Нерест ───────────────────────────────────────────────────
  // Нерест триггерится УСТОЙЧИВЫМ прогревом воды в видовую полосу температур на
  // весенне-летнем подъёме — это и есть единственный честный сигнал, который мы
  // можем дать (точную дату оценка воды как EMA воздуха не позволяет). Окно по
  // месяцам не задаём: его роль играют температурная полоса (она географична),
  // знак тренда воды и длина светового дня (фотопериод). См. [SpawnAdvisor].
  /// Нижняя граница нерестовой полосы температур воды, °C.
  final double spawnTempLow;

  /// Верхняя граница нерестовой полосы температур воды, °C.
  final double spawnTempHigh;

  /// Минимальная длина светового дня для нереста, ч (вторичный триггер). У
  /// карповых готовность к нересту завязана не только на тепло, но и на
  /// удлиняющийся день — порог отсекает ложный преднерест в аномально тёплый
  /// ранневесенний период, когда вода уже в полосе, а дни ещё коротки. Берётся
  /// из реальных sunrise/sunset точки, поэтому уже учитывает широту и дату.
  final double minSpawnDaylightHours;

  // ── Лимитирующие факторы (мультипликативный «гейт») ──────────
  // Аддитивная сумма позволяет хорошим второстепенным факторам маскировать
  // один убийственный (холодная вода, мёртвый сезон, шок давления). Гейт это
  // чинит: когда критичный фактор ниже своего «колена» (knee), итог умножается
  // на коэффициент, плавно спадающий до floor при балле фактора → 0.
  //
  // knee — порог, ниже которого включается штраф; floor — самый сильный штраф
  // (множитель при балле фактора 0). knee/floor ∈ 0..1.
  final double tempGateKnee; // холодная вода = рыба в покое
  final double tempGateFloor;
  final double seasonGateKnee; // мёртвый сезон
  final double seasonGateFloor;
  final double pressureGateKnee; // скачок/обвал давления
  final double pressureGateFloor;

  /// Жара + штиль = кислородный стресс. Максимальная доля штрафа (при полной
  /// жаре и полном штиле итог умножается на 1 − [heatCalmPenalty]).
  final double heatCalmPenalty;

  /// Последействие фронта: максимальная доля штрафа при резком росте давления
  /// за сутки (итог × 1 − [postFrontPenalty]). Карась к перепадам капризнее.
  final double postFrontPenalty;

  /// Тренд воды: доля бонуса/штрафа за прогрев/остывание за ~48 ч
  /// (итог × 1 ± [waterTrendBonus]).
  final double waterTrendBonus;

  /// Профиль под выбранный вид рыбы.
  static BiteConfig of(Fish fish) => switch (fish) {
    Fish.carp => carp,
    Fish.crucian => crucian,
  };

  // ── КАРП ──────────────────────────────────────────────────────
  // Осторожный сумеречно-ночной кормёжник. В тёплой воде зорьки и НОЧЬ — пик;
  // в холодной активнее дневной прогрев, а ночь проваливается.
  static const BiteConfig carp = BiteConfig(
    wPressure: 0.27,
    wTemperature: 0.20,
    wWind: 0.15,
    wCloud: 0.10,
    wPrecip: 0.10,
    wSeason: 0.13,
    wMoon: 0.05,
    pressureOptimumHpa: 1015,
    pressureHalfWidth: 18,
    pressureLevelShare: 0.4,
    tempColdDormant: 4,
    // Источники: уверенный жор уже с 12–14 °C, пик пищеварения ~24 °C.
    // Поэтому продуктивный диапазон 14–24 (а не 16–22), спад от жары — с 28.
    tempOptimumLow: 14,
    tempOptimumHigh: 24,
    tempHeatStress: 28,
    windBestLow: 2,
    windBestHigh: 5,
    windDirColdFactor: 0.6,
    windDirWarmFactor: 1.0,
    dawnBoost: 1.15,
    duskBoost: 1.15,
    warmNightBoost: 1.10, // тёплая ночь — почти как зорька
    middayHotPenalty: 0.78,
    coldDayBoost: 1.05,
    dayNeutral: 0.92,
    coldNightPenalty: 0.6,
    warmNightWaterC: 16,
    coldWaterC: 10,
    seasonByMonth: {
      1: 0.25,
      2: 0.25,
      3: 0.50,
      4: 0.85,
      5: 1.00,
      6: 0.85,
      7: 0.80,
      8: 0.85,
      9: 1.00,
      10: 0.85,
      11: 0.50,
      12: 0.25,
    },
    // Нерест карпа: устойчивый прогрев до ~17–20 °C при дне от ~12.5 ч.
    spawnTempLow: 17,
    spawnTempHigh: 20,
    minSpawnDaylightHours: 12.5,
  );

  // ── КАРАСЬ ────────────────────────────────────────────────────
  // Теплолюбив и вынослив, но капризен. По сравнению с карпом:
  //  • сильнее завязан на ТЕМПЕРАТУРУ воды — оптимум сдвинут выше (18–25 °C),
  //    в холодной воде почти не кормится (порог покоя выше);
  //  • острее реагирует на ПЕРЕПАДЫ давления — колокол уже, вклад «уровня»
  //    больше (любит устойчивую погоду);
  //  • любит ТЁПЛЫЙ ЛЁГКИЙ ветер и тихие плёсы — оптимум скорости ниже,
  //    сильный ветер переносит хуже карпа;
  //  • это ДНЕВНОЙ/сумеречный кормёжник: ночь пассивнее (бустит ночь только
  //    очень тёплая вода), зато утро и прогретый день — его время;
  //  • СЕЗОН смещён в лето: позже просыпается весной, раньше затихает осенью,
  //    пик — июнь–август.
  static const BiteConfig crucian = BiteConfig(
    wPressure: 0.24,
    wTemperature: 0.25,
    wWind: 0.13,
    wCloud: 0.10,
    wPrecip: 0.08,
    wSeason: 0.15,
    wMoon: 0.05,
    pressureOptimumHpa: 1014,
    pressureHalfWidth: 14, // уже — чувствительнее к перепадам
    pressureLevelShare: 0.45,
    tempColdDormant: 8, // ниже ~8 °C почти не кормится
    tempOptimumLow: 16, // берёт уже с 16 °C
    tempOptimumHigh: 25, // пик в прогретой воде
    tempHeatStress: 30, // выносливее карпа к жаре
    windBestLow: 1,
    windBestHigh: 4,
    windDirColdFactor: 0.55,
    windDirWarmFactor: 1.0,
    dawnBoost: 1.18, // утренний клёв — классика по карасю
    duskBoost: 1.12,
    warmNightBoost: 0.95, // ночью пассивнее карпа
    middayHotPenalty: 0.82,
    coldDayBoost: 1.08, // прогретый день — лучшее время в прохладе
    dayNeutral: 0.95,
    coldNightPenalty: 0.5,
    warmNightWaterC: 20, // ночью кормится только в по-настоящему тёплой воде
    coldWaterC: 12,
    // Карась — чемпион по аноксии: тёплая тихая заросшая вода ему в радость,
    // а не кислородный стресс. Поэтому штраф «жара+штиль» почти снимаем.
    heatCalmPenalty: 0.12,
    // Зато к перепадам давления он капризнее карпа — последействие фронта бьёт
    // сильнее, а на прогрев воды реагирует ярче (температурно-триггерная рыба).
    postFrontPenalty: 0.30,
    waterTrendBonus: 0.10,
    seasonByMonth: {
      1: 0.12,
      2: 0.12,
      3: 0.30,
      4: 0.65,
      5: 0.90,
      6: 1.00,
      7: 1.00,
      8: 0.95,
      9: 0.72,
      10: 0.45,
      11: 0.22,
      12: 0.12,
    },
    // Нерест карася: ~14–18 °C, волнами. Полоса ниже карповой, поэтому держим
    // более высокий порог дня (~13 ч) — это и отодвигает старт нереста ближе к
    // лету (карась нерестится позже карпа), не подбирая календарных месяцев.
    spawnTempLow: 14,
    spawnTempHigh: 18,
    minSpawnDaylightHours: 13,
  );
}
