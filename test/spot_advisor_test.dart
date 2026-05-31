import 'package:flutter_test/flutter_test.dart';

import 'package:app/features/forecast/domain/weather_point.dart';
import 'package:app/features/spots/domain/spot_advice.dart';
import 'package:app/features/spots/domain/spot_advisor.dart';
import 'package:app/features/spots/domain/water_body.dart';

const _cLat = 55.0;
const _cLon = 37.0;

WaterBody _body({
  WaterBodyType type = WaterBodyType.lake,
  double centroidLat = _cLat,
  double centroidLon = _cLon,
}) =>
    WaterBody(
      type: type,
      centroidLat: centroidLat,
      centroidLon: centroidLon,
      areaHa: 12,
    );

WeatherPoint _point({
  double airTempC = 22,
  double waterTempC = 18,
  double windSpeedMs = 5,
  double windDirDeg = 180, // дует с юга, на север
}) {
  final t = DateTime(2025, 6, 15, 13);
  return WeatherPoint(
    time: t,
    pressureHpa: 1015,
    pressureTrend6h: 0,
    airTempC: airTempC,
    waterTempC: waterTempC,
    windSpeedMs: windSpeedMs,
    windDirDeg: windDirDeg,
    cloudCoverPct: 50,
    precipMm: 0,
    moonIllumination: 1,
    sunrise: DateTime(t.year, t.month, t.day, 6),
    sunset: DateTime(t.year, t.month, t.day, 20),
  );
}

SpotAdvice _analyze(
  WaterBody body,
  WeatherPoint w, {
  double spotLat = _cLat,
  double spotLon = _cLon,
}) =>
    SpotAdvisor.analyze(body, w, spotLat: spotLat, spotLon: spotLon);

void main() {
  test('река/канал — без береговой подсказки', () {
    final a = _analyze(_body(type: WaterBodyType.river), _point());
    expect(a.tip, SpotTip.none);
    expect(a.hasShoreHint, isFalse);
  });

  test('холодная вода — рыба у дна, ветер не двигает', () {
    final a = _analyze(_body(), _point(waterTempC: 6, airTempC: 10));
    expect(a.tip, SpotTip.coldWater);
    expect(a.activeShore, isNull);
  });

  test('штиль — берег не выделен', () {
    final a = _analyze(_body(), _point(windSpeedMs: 1));
    expect(a.tip, SpotTip.noWind);
    expect(a.activeShore, isNull);
  });

  test('тёплый ветер — корм к подветренному берегу (южный ветер → север)', () {
    final a = _analyze(_body(), _point(airTempC: 23, waterTempC: 18));
    expect(a.tip, SpotTip.windwardBank);
    expect(a.activeShore, WindCardinal.n);
  });

  test('РАЗВОРОТ: холодный ветер — затишье у наветренного берега (юг)', () {
    final a = _analyze(_body(), _point(airTempC: 15, waterTempC: 18));
    expect(a.tip, SpotTip.shelteredBank);
    expect(a.activeShore, WindCardinal.s);
  });

  test('нейтральная разница температур уходит в подветренный берег', () {
    final a = _analyze(_body(), _point(airTempC: 18.4, waterTempC: 18));
    expect(a.tip, SpotTip.windwardBank);
    expect(a.activeShore, WindCardinal.n);
  });

  test('спот у центра — берег пользователя не определяем', () {
    final a = _analyze(_body(), _point());
    expect(a.userShore, isNull);
  });

  test('спот к северу от центра и активный берег север → ты в правильном месте',
      () {
    // Южный тёплый ветер → активный берег N. Спот тоже на северном берегу.
    final a = _analyze(_body(), _point(), spotLat: 55.01, spotLon: 37.0);
    expect(a.activeShore, WindCardinal.n);
    expect(a.userShore, WindCardinal.n);
    expect(a.userOnActiveShore, isTrue);
  });

  test('спот на южном берегу, а рыба у северного — не на активном берегу', () {
    final a = _analyze(_body(), _point(), spotLat: 54.99, spotLon: 37.0);
    expect(a.userShore, WindCardinal.s);
    expect(a.userOnActiveShore, isFalse);
    expect(a.userOnOppositeShore, isTrue);
  });

  test('спот на соседнем берегу (СВ при активном С) — всё ещё «тот самый» берег',
      () {
    // Активный берег N; спот к северо-востоку (45° в сторону) — не «напротив».
    final a = _analyze(_body(), _point(), spotLat: 55.01, spotLon: 37.02);
    expect(a.userShore, WindCardinal.ne);
    expect(a.userOnActiveShore, isTrue);
    expect(a.userOnOppositeShore, isFalse);
  });

  test('спот на перпендикулярном берегу (В при активном С) — молчим', () {
    // Активный берег N; спот строго к востоку (~90°) — ни «там же», ни «напротив».
    final a = _analyze(_body(), _point(), spotLat: 55.0, spotLon: 37.02);
    expect(a.userShore, WindCardinal.e);
    expect(a.userOnActiveShore, isFalse);
    expect(a.userOnOppositeShore, isFalse);
  });
}
