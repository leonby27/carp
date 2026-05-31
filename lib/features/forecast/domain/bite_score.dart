/// Качественная оценка клёва — пять ступеней.
enum BiteLevel { veryLow, low, medium, good, excellent }

/// Какой фактор и как он повлиял на итоговый балл.
enum BiteFactorKind { pressure, temperature, wind, cloud, precipitation, season, moon }

/// Вклад одного фактора в индекс. [score] — нормированное качество 0..1,
/// [weight] — его вес в сумме.
class BiteFactor {
  const BiteFactor({
    required this.kind,
    required this.score,
    required this.weight,
  });

  final BiteFactorKind kind;
  final double score;
  final double weight;

  /// Положительный фактор (тянет индекс вверх) при score >= 0.6.
  bool get isPositive => score >= 0.6;

  /// Заметно тянет вниз.
  bool get isNegative => score < 0.4;
}

/// Результат расчёта индекса клёва.
class BiteScore {
  const BiteScore({required this.value, required this.factors});

  /// Индекс 0..100.
  final int value;

  /// Разбор по факторам (для блока «почему такой прогноз»).
  final List<BiteFactor> factors;

  BiteLevel get level {
    // Пороги намеренно строгие: индекс ~60 — это «Средний», а не «Хороший».
    // «Хороший» начинается с 68, «Отличный» — только с 86, чтобы верхние оценки
    // означали реально близкие к идеалу условия, а не просто неплохой день.
    if (value < 22) return BiteLevel.veryLow;
    if (value < 45) return BiteLevel.low;
    if (value < 68) return BiteLevel.medium;
    if (value < 86) return BiteLevel.good;
    return BiteLevel.excellent;
  }

  /// Звёзды 1..5 для компактного отображения.
  int get stars => switch (level) {
        BiteLevel.veryLow => 1,
        BiteLevel.low => 2,
        BiteLevel.medium => 3,
        BiteLevel.good => 4,
        BiteLevel.excellent => 5,
      };
}
