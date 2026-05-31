import '../../forecast/domain/bite_score.dart';
import '../../forecast/domain/fish.dart';
import '../../forecast/domain/forecast.dart';
import 'planned_alert.dart';

/// Параметры планировщика алёртов о клёве.
class BiteAlertConfig {
  const BiteAlertConfig({
    this.horizonDays = 7,
    this.showHour = 19,
    this.primeMinLevel = BiteLevel.good,
  });

  /// Сколько дней вперёд рассматривать. «Прайм день недели» — отсюда «недели»:
  /// смотрим на всю доступную неделю прогноза.
  final int horizonDays;

  /// Час вечера накануне, когда показать алёрт (рыбаку нужно время собраться).
  final int showHour;

  /// Минимальный уровень для «прайм-дня недели». Лучший день недели не зовём на
  /// выезд, если даже он не дотянул до этого уровня (была бы посредственная неделя).
  final BiteLevel primeMinLevel;
}

/// Лучший спот на конкретный день: имя + его дневной прогноз.
class _DayCandidate {
  const _DayCandidate(this.spotName, this.day);
  final String spotName;
  final DayForecast day;
}

/// Чистый Dart-планировщик: из готовых [Forecast] по всем спотам (для одного вида
/// рыбы) решает, какие дни недели достойны пуша и когда его показать. Логики
/// UI/локали тут нет — на выходе структурные [PlannedAlert].
///
/// Модель (согласована): на каждый день берём лучший спот среди всех. Затем:
///  • [BiteAlertKind.excellentDays] — каждый день, чей лучший спот = `excellent`;
///  • [BiteAlertKind.primeWeek] — единственный день недели с максимальным индексом
///    (уровень не ниже [BiteAlertConfig.primeMinLevel]).
/// Прайм перекрывает «отличный»: на один день+рыбу приходится максимум один алёрт.
/// Показ — [BiteAlertConfig.showHour]:00 НАКАНУНЕ; прошлое не планируем.
class BiteAlertPlanner {
  const BiteAlertPlanner({this.config = const BiteAlertConfig()});

  final BiteAlertConfig config;

  List<PlannedAlert> plan({
    required Fish fish,
    required List<({String spotName, Forecast forecast})> bySpot,
    required Set<BiteAlertKind> kinds,
    required DateTime now,
  }) {
    if (kinds.isEmpty || bySpot.isEmpty) return const [];

    // Лучший спот на каждый календарный день (кроме сегодня), в пределах горизонта.
    final bestPerDay = <DateTime, _DayCandidate>{};
    for (final entry in bySpot) {
      final days = entry.forecast.days;
      for (var i = 1; i < days.length && i <= config.horizonDays; i++) {
        final day = days[i];
        final key = DateTime(day.date.year, day.date.month, day.date.day);
        final cur = bestPerDay[key];
        if (cur == null || day.bite.value > cur.day.bite.value) {
          bestPerDay[key] = _DayCandidate(entry.spotName, day);
        }
      }
    }
    if (bestPerDay.isEmpty) return const [];

    final dayKeys = bestPerDay.keys.toList()..sort();

    // Дни уровня «отлично».
    final excellentDates = <DateTime>{};
    if (kinds.contains(BiteAlertKind.excellentDays)) {
      for (final key in dayKeys) {
        if (bestPerDay[key]!.day.bite.level == BiteLevel.excellent) {
          excellentDates.add(key);
        }
      }
    }

    // Прайм-день недели: глобальный максимум индекса при уровне ≥ порога.
    DateTime? primeDate;
    if (kinds.contains(BiteAlertKind.primeWeek)) {
      for (final key in dayKeys) {
        final cand = bestPerDay[key]!;
        if (cand.day.bite.level.index < config.primeMinLevel.index) continue;
        if (primeDate == null ||
            cand.day.bite.value > bestPerDay[primeDate]!.day.bite.value) {
          primeDate = key;
        }
      }
    }

    final out = <PlannedAlert>[];
    for (final key in dayKeys) {
      final isPrime = key == primeDate;
      final isExcellent = excellentDates.contains(key);
      if (!isPrime && !isExcellent) continue;

      // Прайм перекрывает «отличный»: на день+рыбу — один алёрт.
      final kind =
          isPrime ? BiteAlertKind.primeWeek : BiteAlertKind.excellentDays;

      final fireAt = DateTime(key.year, key.month, key.day, config.showHour)
          .subtract(const Duration(days: 1));
      if (!fireAt.isAfter(now)) continue; // вечер накануне уже прошёл

      final cand = bestPerDay[key]!;
      out.add(PlannedAlert(
        fish: fish,
        kind: kind,
        spotName: cand.spotName,
        fireAt: fireAt,
        forDay: key,
        windowKind: cand.day.bestWindow?.kind,
        index: cand.day.bite.value,
        level: cand.day.bite.level,
      ));
    }
    return out;
  }
}
