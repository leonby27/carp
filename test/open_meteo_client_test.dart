import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/forecast/data/open_meteo_client.dart';

/// Минимальная фикстура: один день, 8 часов. Open-Meteo при timezone=auto
/// отдаёт время без таймзонного суффикса.
Map<String, dynamic> _fixture() => {
      'latitude': 55.75,
      'longitude': 37.62,
      'hourly': {
        'time': [
          '2026-05-29T00:00',
          '2026-05-29T01:00',
          '2026-05-29T02:00',
          '2026-05-29T03:00',
          '2026-05-29T04:00',
          '2026-05-29T05:00',
          '2026-05-29T06:00',
          '2026-05-29T07:00',
        ],
        'temperature_2m': [12, 11, 11, 10, 10, 12, 15, 18],
        'pressure_msl': [1015, 1015, 1014, 1014, 1013, 1013, 1012, 1011],
        'cloud_cover': [40, 45, 50, 55, 60, 50, 30, 20],
        'precipitation': [0, 0, 0, 0.2, 0.1, 0, 0, 0],
        'wind_speed_10m': [3, 3, 4, 4, 3, 3, 2, 2],
        'wind_direction_10m': [180, 190, 200, 210, 220, 200, 180, 170],
      },
      'daily': {
        'time': ['2026-05-29'],
        'sunrise': ['2026-05-29T04:48'],
        'sunset': ['2026-05-29T21:06'],
      },
    };

void main() {
  group('OpenMeteoClient.parse', () {
    test('маппит все часы в WeatherPoint', () {
      final points = OpenMeteoClient.parse(_fixture());
      expect(points.length, 8);
      expect(points.first.airTempC, 12);
      expect(points.first.pressureHpa, 1015);
      expect(points.last.windDirDeg, 170);
    });

    test('тренд давления первого часа = 0, далее отрицательный при падении', () {
      final points = OpenMeteoClient.parse(_fixture());
      expect(points.first.pressureTrend6h, 0);
      // 7-й час (индекс 6): 1012 - pressure[0]=1015 → -3.
      expect(points[6].pressureTrend6h, closeTo(-3, 1e-9));
    });

    test('sunrise/sunset берутся из daily по дате', () {
      final points = OpenMeteoClient.parse(_fixture());
      expect(points.first.sunrise, DateTime(2026, 5, 29, 4, 48));
      expect(points.first.sunset, DateTime(2026, 5, 29, 21, 6));
    });

    test('температура воды оценена и попадает в разумный диапазон воздуха', () {
      final points = OpenMeteoClient.parse(_fixture());
      for (final p in points) {
        expect(p.waterTempC, inInclusiveRange(8, 20));
      }
    });

    test('освещённость луны нормирована 0..1', () {
      final points = OpenMeteoClient.parse(_fixture());
      expect(points.first.moonIllumination, inInclusiveRange(0.0, 1.0));
    });

    test('бросает при отсутствии hourly', () {
      expect(
        () => OpenMeteoClient.parse({'latitude': 1, 'longitude': 2}),
        throwsA(isA<OpenMeteoException>()),
      );
    });
  });
}
