import 'dart:math' as math;

import '../../forecast/domain/weather_point.dart';
import 'spot_advice.dart';
import 'water_body.dart';

/// Детерминированный движок пространственных подсказок по споту (рядом с
/// [BiteEngine]/[AdviceEngine]). На вход — водоём из карты OSM + погода; на
/// выход — где сегодня вероятнее активная рыба. Только устоявшиеся карповые
/// эвристики на основе ветра и температуры, без данных о дне/глубине/рыбе.
///
/// Биология, зашитая в правила:
/// - карп идёт за ветром: тёплый ветер гонит планктон/корм и тёплую
///   поверхностную воду к подветренному (дальнему по ходу ветра) берегу;
/// - но если ветер ХОЛОДНЕЕ воды — он остужает наветренный берег, и рыба,
///   наоборот, отходит в затишье (РАЗВОРОТ — без него совет был бы вредным);
/// - в штиль сноса корма нет — берег не выделен;
/// - в холодной воде рыба у дна и пассивна — ветер двигает её слабо.
class SpotAdvisor {
  const SpotAdvisor._();

  /// Ниже этой скорости (м/с) ветер не создаёт заметного сноса коря/воды.
  static const _windEffectMs = 3.0;

  /// Разница «воздух − вода» (°C), при которой ветер считаем тёплым/холодным.
  static const _windTempDelta = 1.0;

  /// Ниже этой температуры воды (°C) рыба у дна — ветер почти не двигает её.
  static const _coldWaterC = 8.0;

  /// Спот ближе этого расстояния к центру (м) — берег пользователя не считаем
  /// (мелкий пруд: «берега» относительно центра нет смысла различать).
  static const _userShoreMinM = 40.0;

  static SpotAdvice analyze(
    WaterBody body,
    WeatherPoint weather, {
    required double spotLat,
    required double spotLon,
  }) {
    if (!body.hasShores) {
      return SpotAdvice(body: body, tip: SpotTip.none);
    }
    if (weather.waterTempC < _coldWaterC) {
      return SpotAdvice(body: body, tip: SpotTip.coldWater);
    }
    if (weather.windSpeedMs < _windEffectMs) {
      return SpotAdvice(body: body, tip: SpotTip.noWind);
    }

    final delta = weather.airTempC - weather.waterTempC;
    final WindCardinal active;
    final SpotTip tip;
    if (delta <= -_windTempDelta) {
      // Холодный ветер — рыба в затишье у наветренного (откуда дует) берега.
      tip = SpotTip.shelteredBank;
      active = cardinalFromDeg(weather.windDirDeg);
    } else {
      // Тёплый/нейтральный ветер — корм у подветренного (куда дует) берега.
      tip = SpotTip.windwardBank;
      active = cardinalFromDeg((weather.windDirDeg + 180) % 360);
    }

    final userShore = _userShore(body, spotLat, spotLon);
    return SpotAdvice(
      body: body,
      tip: tip,
      activeShore: active,
      userShore: userShore,
    );
  }

  /// Берег спота = азимут из центра водоёма на спот. null, если спот по сути в
  /// центре (нет смысла говорить о береге).
  static WindCardinal? _userShore(WaterBody body, double lat, double lon) {
    final d = _haversineM(body.centroidLat, body.centroidLon, lat, lon);
    if (d < _userShoreMinM) return null;
    return cardinalFromDeg(_bearingDeg(body.centroidLat, body.centroidLon, lat, lon));
  }
}

/// Азимут из точки 1 в точку 2, градусы (0 = север, по часовой).
double _bearingDeg(double lat1, double lon1, double lat2, double lon2) {
  final phi1 = degToRad(lat1);
  final phi2 = degToRad(lat2);
  final dLon = degToRad(lon2 - lon1);
  final y = math.sin(dLon) * math.cos(phi2);
  final x = math.cos(phi1) * math.sin(phi2) -
      math.sin(phi1) * math.cos(phi2) * math.cos(dLon);
  return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
}

/// Расстояние между точками, метры (haversine).
double _haversineM(double lat1, double lon1, double lat2, double lon2) {
  const r = 6371000.0;
  final dPhi = degToRad(lat2 - lat1);
  final dLambda = degToRad(lon2 - lon1);
  final a = math.sin(dPhi / 2) * math.sin(dPhi / 2) +
      math.cos(degToRad(lat1)) *
          math.cos(degToRad(lat2)) *
          math.sin(dLambda / 2) *
          math.sin(dLambda / 2);
  return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
}
