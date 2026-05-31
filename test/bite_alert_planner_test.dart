import 'package:app/features/alerts/domain/bite_alert_planner.dart';
import 'package:app/features/alerts/domain/planned_alert.dart';
import 'package:app/features/forecast/domain/bite_score.dart';
import 'package:app/features/forecast/domain/fish.dart';
import 'package:app/features/forecast/domain/forecast.dart';
import 'package:app/features/forecast/domain/weather_point.dart';
import 'package:flutter_test/flutter_test.dart';

WeatherPoint _wp(DateTime t) => WeatherPoint(
      time: t,
      pressureHpa: 1015,
      pressureTrend6h: 0,
      airTempC: 20,
      waterTempC: 18,
      windSpeedMs: 3,
      windDirDeg: 200,
      cloudCoverPct: 40,
      precipMm: 0,
      moonIllumination: 0.5,
      sunrise: DateTime(t.year, t.month, t.day, 5),
      sunset: DateTime(t.year, t.month, t.day, 21),
    );

/// День с суточным индексом [dailyIndex]; ночные часы получают высокий почасовой
/// балл, чтобы у дня было окно клёва (bestWindow != null).
DayForecast _day(DateTime date, int dailyIndex) {
  final d = DateTime(date.year, date.month, date.day);
  final hours = <HourForecast>[
    for (var h = 0; h < 24; h++)
      HourForecast(
        weather: _wp(DateTime(d.year, d.month, d.day, h)),
        bite: BiteScore(value: h >= 21 || h <= 3 ? 82 : 30, factors: const []),
      ),
  ];
  return DayForecast(
    date: d,
    representative: _wp(DateTime(d.year, d.month, d.day, 13)),
    bite: BiteScore(value: dailyIndex, factors: const []),
    hours: hours,
    minTempC: 15,
    maxTempC: 24,
  );
}

Forecast _forecast(List<DayForecast> days) =>
    Forecast(locationName: 'Озеро', days: days, fetchedAt: days.first.date);

/// Один спот для удобства — большинство тестов про логику типов, не про споты.
List<({String spotName, Forecast forecast})> _one(String name, Forecast f) =>
    [(spotName: name, forecast: f)];

void main() {
  const planner = BiteAlertPlanner();
  final today = DateTime(2026, 7, 1);
  final morning = DateTime(2026, 7, 1, 9);

  DateTime plus(int d) => today.add(Duration(days: d));

  test('excellentDays: отличный день завтра → один алёрт вечером накануне', () {
    final f = _forecast([_day(today, 40), _day(plus(1), 90)]); // excellent
    final alerts = planner.plan(
      fish: Fish.carp,
      bySpot: _one('Озеро', f),
      kinds: {BiteAlertKind.excellentDays},
      now: morning,
    );

    expect(alerts, hasLength(1));
    final a = alerts.single;
    expect(a.kind, BiteAlertKind.excellentDays);
    expect(a.fish, Fish.carp);
    expect(a.forDay, DateTime(2026, 7, 2));
    expect(a.fireAt, DateTime(2026, 7, 1, 19)); // вечер накануне
    expect(a.spotName, 'Озеро');
    expect(a.windowKind, isNotNull);
  });

  test('excellentDays: «хороший» (не отличный) день → без алёрта', () {
    final f = _forecast([_day(today, 40), _day(plus(1), 75)]); // good, не excellent
    final alerts = planner.plan(
      fish: Fish.carp,
      bySpot: _one('Озеро', f),
      kinds: {BiteAlertKind.excellentDays},
      now: morning,
    );
    expect(alerts, isEmpty);
  });

  test('primeWeek: выбирает единственный лучший день недели', () {
    final f = _forecast([
      _day(today, 40),
      _day(plus(1), 70), // good
      _day(plus(2), 95), // пик
      _day(plus(3), 72), // good
    ]);
    final alerts = planner.plan(
      fish: Fish.carp,
      bySpot: _one('Озеро', f),
      kinds: {BiteAlertKind.primeWeek},
      now: morning,
    );

    expect(alerts, hasLength(1));
    final a = alerts.single;
    expect(a.kind, BiteAlertKind.primeWeek);
    expect(a.forDay, DateTime(2026, 7, 3));
    expect(a.index, 95);
  });

  test('primeWeek: посредственная неделя (ниже good) → без алёрта', () {
    final f = _forecast([
      _day(today, 40),
      _day(plus(1), 50), // medium
      _day(plus(2), 60), // medium
    ]);
    final alerts = planner.plan(
      fish: Fish.carp,
      bySpot: _one('Озеро', f),
      kinds: {BiteAlertKind.primeWeek},
      now: morning,
    );
    expect(alerts, isEmpty);
  });

  test('оба типа: прайм перекрывает «отличный» в пик-день, без задвоения', () {
    final f = _forecast([
      _day(today, 40),
      _day(plus(1), 95), // пик и отличный
      _day(plus(2), 88), // отличный, но не пик
    ]);
    final alerts = planner.plan(
      fish: Fish.carp,
      bySpot: _one('Озеро', f),
      kinds: {BiteAlertKind.primeWeek, BiteAlertKind.excellentDays},
      now: morning,
    );

    expect(alerts, hasLength(2));
    final byDay = {for (final a in alerts) a.forDay: a};
    expect(byDay[DateTime(2026, 7, 2)]!.kind, BiteAlertKind.primeWeek);
    expect(byDay[DateTime(2026, 7, 3)]!.kind, BiteAlertKind.excellentDays);
  });

  test('кросс-спот: на день берётся лучший спот, его имя в алёрте', () {
    final fA = _forecast([_day(today, 40), _day(plus(1), 70)]); // good
    final fB = _forecast([_day(today, 40), _day(plus(1), 92)]); // excellent
    final alerts = planner.plan(
      fish: Fish.carp,
      bySpot: [(spotName: 'Спот A', forecast: fA), (spotName: 'Спот B', forecast: fB)],
      kinds: {BiteAlertKind.excellentDays},
      now: morning,
    );

    expect(alerts, hasLength(1));
    expect(alerts.single.spotName, 'Спот B');
    expect(alerts.single.index, 92);
  });

  test('вечер накануне уже прошёл → не планируем', () {
    final f = _forecast([_day(today, 40), _day(plus(1), 95)]);
    // now = 20:00, fireAt = 19:00 того же дня → в прошлом
    final alerts = planner.plan(
      fish: Fish.carp,
      bySpot: _one('Озеро', f),
      kinds: {BiteAlertKind.excellentDays},
      now: DateTime(2026, 7, 1, 20),
    );
    expect(alerts, isEmpty);
  });

  test('день за горизонтом недели (8-й) не рассматривается', () {
    final days = <DayForecast>[_day(today, 40)];
    for (var i = 1; i <= 8; i++) {
      days.add(_day(plus(i), i == 8 ? 95 : 30));
    }
    final alerts = planner.plan(
      fish: Fish.carp,
      bySpot: _one('Озеро', _forecast(days)),
      kinds: {BiteAlertKind.primeWeek},
      now: morning,
    );
    expect(alerts, isEmpty); // пик только на 8-й день, горизонт = 7
  });

  test('пустые kinds или пустые споты → без алёртов', () {
    final f = _forecast([_day(today, 40), _day(plus(1), 95)]);
    expect(
      planner.plan(
          fish: Fish.carp, bySpot: _one('Озеро', f), kinds: {}, now: morning),
      isEmpty,
    );
    expect(
      planner.plan(
          fish: Fish.carp,
          bySpot: const [],
          kinds: {BiteAlertKind.excellentDays},
          now: morning),
      isEmpty,
    );
  });

  test('id стабилен, положителен и различается по виду рыбы', () {
    final f = _forecast([_day(today, 40), _day(plus(1), 95)]);
    PlannedAlert planFor(Fish fish) => planner
        .plan(
          fish: fish,
          bySpot: _one('Озеро', f),
          kinds: {BiteAlertKind.excellentDays},
          now: morning,
        )
        .single;

    final carp1 = planFor(Fish.carp);
    final carp2 = planFor(Fish.carp);
    final crucian = planFor(Fish.crucian);
    expect(carp1.notificationId, carp2.notificationId);
    expect(carp1.notificationId, greaterThanOrEqualTo(0));
    expect(carp1.notificationId, isNot(crucian.notificationId));
  });
}
