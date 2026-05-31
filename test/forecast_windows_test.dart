import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/forecast/domain/bite_score.dart';
import 'package:app/features/forecast/domain/forecast.dart';
import 'package:app/features/forecast/domain/weather_point.dart';

final _sunrise = DateTime(2025, 7, 15, 5);
final _sunset = DateTime(2025, 7, 15, 20);

WeatherPoint _wp(int hour, double water) => WeatherPoint(
      time: DateTime(2025, 7, 15, hour),
      pressureHpa: 1015,
      pressureTrend6h: 0,
      airTempC: 18,
      waterTempC: water,
      windSpeedMs: 3,
      windDirDeg: 180,
      cloudCoverPct: 50,
      precipMm: 0,
      moonIllumination: 0.5,
      sunrise: _sunrise,
      sunset: _sunset,
    );

DayForecast _day({
  required double water,
  required int dayValue,
  required int Function(int hour) valueAt,
}) {
  return DayForecast(
    date: DateTime(2025, 7, 15),
    representative: _wp(13, water),
    bite: BiteScore(value: dayValue, factors: const []),
    hours: [
      for (var h = 0; h < 24; h++)
        HourForecast(
          weather: _wp(h, water),
          bite: BiteScore(value: valueAt(h), factors: const []),
        ),
    ],
    minTempC: 12,
    maxTempC: 22,
  );
}

int _warmShape(int h) {
  if (h >= 4 && h <= 7) return 80; // рассвет
  if (h >= 18 && h <= 21) return 80; // закат
  if (h >= 22 || h <= 3) return 75; // ночь — тёплая, активна
  if (h >= 12 && h <= 15) return 55; // жаркий полдень — спад
  return 65;
}

int _coldShape(int h) {
  if (h >= 11 && h <= 15) return 78; // дневной прогрев — лучшее в холоде
  if (h >= 4 && h <= 7) return 70;
  if (h >= 18 && h <= 21) return 70;
  if (h >= 22 || h <= 3) return 50; // холодная ночь — провал
  return 60;
}

void main() {
  group('biteWindows', () {
    test('тёплая вода → есть ночное окно (карп кормится в темноте)', () {
      final day = _day(water: 20, dayValue: 70, valueAt: _warmShape);
      expect(day.biteWindows, isNotEmpty);
      expect(day.biteWindows.any((w) => w.kind == BiteWindowKind.night), isTrue);
      // Непрерывная активность вечер→ночь→утро склеивается в окно через полночь.
      final night =
          day.biteWindows.firstWhere((w) => w.kind == BiteWindowKind.night);
      expect(night.to.hour, lessThan(night.from.hour));
    });

    test('холодная вода → ночи нет, но есть дневной прогрев', () {
      final day = _day(water: 5, dayValue: 60, valueAt: _coldShape);
      final kinds = day.biteWindows.map((w) => w.kind).toSet();
      expect(kinds.contains(BiteWindowKind.night), isFalse);
      expect(kinds.contains(BiteWindowKind.day), isTrue);
    });

    test('слабый день (низкий индекс) → окон нет', () {
      final day = _day(water: 20, dayValue: 30, valueAt: _warmShape);
      expect(day.biteWindows, isEmpty);
    });

    test('bestWindow — окно с максимальным пиком', () {
      final day = _day(water: 20, dayValue: 70, valueAt: _warmShape);
      expect(day.bestWindow, isNotNull);
      expect(day.bestWindow!.peak, 80); // рассвет/закат пик
    });
  });
}
