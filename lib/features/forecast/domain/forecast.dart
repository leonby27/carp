import 'dart:math' as math;

import 'bite_score.dart';
import 'weather_point.dart';

/// Прогноз на один час: погода + индекс клёва с учётом времени суток.
class HourForecast {
  const HourForecast({required this.weather, required this.bite});

  final WeatherPoint weather;
  final BiteScore bite;

  DateTime get time => weather.time;
}

/// Прогноз на один день: суточный индекс + почасовая разбивка.
class DayForecast {
  const DayForecast({
    required this.date,
    required this.representative,
    required this.bite,
    required this.hours,
    required this.minTempC,
    required this.maxTempC,
  });

  final DateTime date;

  /// Репрезентативная (околополуденная) погода — для чипов и суточного индекса.
  final WeatherPoint representative;
  final BiteScore bite;
  final List<HourForecast> hours;
  final double minTempC;
  final double maxTempC;

  WeatherCondition get condition => representative.condition;

  /// Окна клёва дня — структурно по времени суток (зорьки/ночь/день), а не
  /// склейкой шумных почасовых баров. См. [_computeBiteWindows].
  List<BiteWindow> get biteWindows => _computeBiteWindows(this);

  /// Лучшее окно — с максимальным пиком индекса (для вердикта и подсказок).
  BiteWindow? get bestWindow {
    final w = biteWindows;
    if (w.isEmpty) return null;
    return w.reduce((a, b) => b.peak > a.peak ? b : a);
  }
}

/// Тип окна клёва — задаёт иконку, подпись и пояснение в UI.
enum BiteWindowKind { dawn, day, dusk, night }

/// Окно клёва внутри дня. Для ночи [from]..[to] могут переходить через полночь
/// (напр. 22:00→4:00) — это нормально и читается как «ночью».
class BiteWindow {
  const BiteWindow({
    required this.kind,
    required this.from,
    required this.to,
    required this.peak,
  });

  final BiteWindowKind kind;
  final DateTime from;
  final DateTime to;
  final int peak;
}

/// Расчёт окон от ФАКТИЧЕСКОГО почасового индекса (он меняется день ото дня:
/// давление, облачность, фронты, тёплая ночь и т.д.). Устойчивость к шуму:
/// порог относительно пика дня, мост через одночасовые провалы, минимум 2 часа,
/// склейка через полночь. Тип окна (зорька/ночь/день) — по времени суток
/// относительно восхода/заката. Слабые дни окон не дают — ехать незачем.
List<BiteWindow> _computeBiteWindows(DayForecast day) {
  if (day.hours.isEmpty) return const [];
  if (day.bite.level == BiteLevel.veryLow || day.bite.level == BiteLevel.low) {
    return const [];
  }

  final byHour = <int, int>{
    for (final h in day.hours) h.time.hour: h.bite.value,
  };
  if (byHour.isEmpty) return const [];
  final maxV = byHour.values.reduce(math.max);
  if (maxV < 45) return const [];
  final threshold = math.max(50, maxV - 12);

  final good = List<bool>.generate(24, (h) => (byHour[h] ?? 0) >= threshold);
  // Мост через одночасовой провал: ...true,false,true... → не рвём окно.
  final bridged = List<bool>.of(good);
  for (var h = 0; h < 24; h++) {
    if (!good[h] && good[(h - 1 + 24) % 24] && good[(h + 1) % 24]) {
      bridged[h] = true;
    }
  }

  // Циклический поиск отрезков — окно может переходить через полночь.
  final runs = <(int, int)>[];
  if (bridged.every((g) => g)) {
    runs.add((0, 23));
  } else {
    final startFalse = bridged.indexWhere((g) => !g);
    int? runStart;
    var prev = -1;
    for (var i = 0; i < 24; i++) {
      final h = (startFalse + i) % 24;
      if (bridged[h]) {
        runStart ??= h;
        prev = h;
      } else if (runStart != null) {
        runs.add((runStart, prev));
        runStart = null;
      }
    }
    if (runStart != null) runs.add((runStart, prev));
  }

  final date = day.date;
  int roundH(DateTime t) => t.hour + (t.minute >= 30 ? 1 : 0);
  final sr = roundH(day.representative.sunrise).toDouble();
  final ss = roundH(day.representative.sunset).toDouble();

  final out = <BiteWindow>[];
  for (final (start, end) in runs) {
    final len = (end - start + 24) % 24 + 1;
    if (len < 2) continue; // одиночные часы — шум, не окно
    var peak = 0;
    for (var i = 0; i < len; i++) {
      final v = byHour[(start + i) % 24] ?? 0;
      if (v > peak) peak = v;
    }
    final mid = (start + (len - 1) / 2.0) % 24;
    out.add(BiteWindow(
      kind: _classifyWindowKind(mid, sr, ss),
      from: DateTime(date.year, date.month, date.day, start),
      to: DateTime(date.year, date.month, date.day, end),
      peak: peak,
    ));
  }
  out.sort((a, b) => a.from.hour.compareTo(b.from.hour));
  return out;
}

BiteWindowKind _classifyWindowKind(double midHour, double sr, double ss) {
  if ((midHour - sr).abs() <= 2) return BiteWindowKind.dawn;
  if ((midHour - ss).abs() <= 2) return BiteWindowKind.dusk;
  if (midHour < sr || midHour > ss) return BiteWindowKind.night;
  return BiteWindowKind.day;
}

/// Полный прогноз по локации на несколько дней.
class Forecast {
  const Forecast({
    required this.locationName,
    required this.days,
    required this.fetchedAt,
    this.fromCache = false,
  });

  final String locationName;
  final List<DayForecast> days;

  /// Момент получения прогноза — для подписи о возрасте данных.
  final DateTime fetchedAt;

  /// Прогноз отдан из офлайн-кэша (сеть была недоступна) — данные могут быть
  /// устаревшими; UI помечает это явно.
  final bool fromCache;

  DayForecast get today => days.first;
}
