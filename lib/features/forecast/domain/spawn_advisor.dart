import 'bite_config.dart';
import 'fish.dart';
import 'weather_point.dart';

/// Фаза относительно нереста. НЕ точная дата (оценка воды как EMA воздуха её не
/// позволяет), а честный контекстный сигнал: где мы в нерестовом окне.
enum SpawnPhase {
  none, // вне нерестового окна — сигнал не показываем
  preSpawn, // вода подходит к полосе и растёт — часто преднерестовый жор
  spawning, // вода в нерестовой полосе — клёв обычно проваливается
  postSpawn, // вода прошла полосу вверх — посленерестовый жор
}

/// Насколько можно доверять сигналу. Вода у нас НЕ измеряется, а оценивается по
/// воздуху с постоянной времени τ ([waterTauForBody]): чем крупнее/инертнее
/// водоём, тем больше лаг и ошибка оценки — тем осторожнее формулировка.
enum SpawnConfidence { high, medium, low }

/// Оценка нерестовой фазы вместе с числами, которые её приняли (вода + тренд) —
/// чтобы текст в UI расшифровывался реальными значениями, а не безликим ярлыком.
class SpawnAssessment {
  const SpawnAssessment({
    required this.phase,
    required this.confidence,
    required this.waterC,
    required this.trendC,
  });

  final SpawnPhase phase;
  final SpawnConfidence confidence;

  /// Оценка температуры воды на момент, °C.
  final double waterC;

  /// Тренд воды за ~48 ч, °C (знак решает «подходит/проходит» полосу).
  final double trendC;

  bool get isActive => phase != SpawnPhase.none;

  static const none = SpawnAssessment(
    phase: SpawnPhase.none,
    confidence: SpawnConfidence.low,
    waterC: 0,
    trendC: 0,
  );
}

/// Определяет фазу нереста по оценке воды, её тренду, длине светового дня и
/// широкому warming-half окну сезона. Чистый Dart, без знания об источнике
/// данных. Сигнал намеренно консервативен: вне весенне-летнего прогрева, при
/// коротком дне и на остывании воды молчит, даже если температура случайно
/// попала в полосу (защита от «осеннего/ранневесеннего лжанереста»).
class SpawnAdvisor {
  const SpawnAdvisor(this.config, {this.southern = false});

  factory SpawnAdvisor.forFish(Fish fish, {bool southern = false}) =>
      SpawnAdvisor(BiteConfig.of(fish), southern: southern);

  final BiteConfig config;

  /// Южное полушарие: нерестовое окно сдвинуто на полгода (как и сезон).
  final bool southern;

  /// Минимальный прогрев за 48 ч, чтобы считать воду «растущей» к полосе, °C.
  static const _warmingTrend = 0.5;

  /// Насколько ниже полосы ещё считаем «преднерестом» (подход), °C.
  static const _preSpawnReach = 3;

  /// Насколько выше полосы ещё считаем «посленерестом», °C. Дальше — нерест
  /// давно позади, сигнал гасим (иначе разгар лета весь стал бы «посленерестом»).
  static const _postSpawnReach = 4;

  /// Границы warming-half сезона (северное полушарие, 1..12): от выхода воды из
  /// зимнего минимума до её летнего пика. Это НЕ видовое окно нереста, а грубый
  /// сезонный предохранитель — конкретную фазу внутри решает температура полосы,
  /// которая сама географична (вода = EMA локального воздуха), поэтому юг входит
  /// в полосу раньше, север позже, и окно подстраивается без подбора месяцев.
  static const _seasonFirstMonth = 3;
  static const _seasonLastMonth = 8;

  SpawnAssessment assess(WeatherPoint p, {required double tauDays}) {
    // Месяц приводим к северному полушарию тем же приёмом, что и сезонная кривая.
    final m = southern ? (p.month + 5) % 12 + 1 : p.month;
    final water = p.waterTempC;
    final trend = p.waterTrendC;
    final conf = _confidence(tauDays);

    SpawnAssessment of(SpawnPhase phase) => SpawnAssessment(
          phase: phase,
          confidence: conf,
          waterC: water,
          trendC: trend,
        );

    // Грубый сезонный гейт: вне весенне-летнего прогрева молчим, чтобы аномальное
    // межсезонное тепло не дало ложного «нереста».
    if (m < _seasonFirstMonth || m > _seasonLastMonth) {
      return SpawnAssessment.none;
    }

    // Фотопериод: у карповых нерест завязан не только на тепло, но и на длинный
    // день. Длину берём из реальных sunrise/sunset точки (уже с поправкой на
    // широту и дату), поэтому короткий день ранней весной гасит ложный
    // преднерест, когда вода уже в полосе.
    final daylightHours = p.sunset.difference(p.sunrise).inMinutes / 60.0;
    if (daylightHours < config.minSpawnDaylightHours) {
      return SpawnAssessment.none;
    }

    final lo = config.spawnTempLow;
    final hi = config.spawnTempHigh;

    if (water < lo) {
      // Подход к нересту: вода ещё ниже полосы, но близко и уверенно растёт.
      if (trend >= _warmingTrend && water >= lo - _preSpawnReach) {
        return of(SpawnPhase.preSpawn);
      }
      return SpawnAssessment.none;
    }
    // В полосе и выше сигналим только на ПОДЪЁМЕ воды — это и есть «первый прогрев
    // года сквозь полосу». Заметное остывание сквозь ту же полосу (позднее лето
    // или тёплое межсезонье) нерестом не считаем.
    if (trend <= -_warmingTrend) return SpawnAssessment.none;
    if (water <= hi) return of(SpawnPhase.spawning);
    if (water <= hi + _postSpawnReach) return of(SpawnPhase.postSpawn);
    return SpawnAssessment.none;
  }

  /// Доверие к сигналу выводим из τ водоёма: проточная/мелкая вода (малая τ)
  /// близко идёт за воздухом — оценка надёжнее; крупное инертное водохранилище
  /// (большая τ) сильнее запаздывает — формулируем осторожнее.
  SpawnConfidence _confidence(double tauDays) {
    if (tauDays <= 6) return SpawnConfidence.high;
    if (tauDays <= 20) return SpawnConfidence.medium;
    return SpawnConfidence.low;
  }
}
