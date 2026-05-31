import 'dart:math' as math;

final _knownNewMoon = DateTime.utc(2000, 1, 6, 18, 14);
const _synodic = 29.530588853;

/// Доля синодического цикла 0..1: 0 = новолуние, 0.5 = полнолуние, →1 снова
/// новолуние. 0..0.5 — растущая, 0.5..1 — убывающая.
double moonPhaseFraction(DateTime date) {
  final days = date.toUtc().difference(_knownNewMoon).inHours / 24.0;
  return (days % _synodic) / _synodic;
}

/// Освещённость луны 0..1 (0 = новолуние, 1 = полнолуние) по синодическому
/// циклу. Достаточно точно для солунарной поправки индекса клёва.
double moonIllumination(DateTime date) {
  final phase = moonPhaseFraction(date);
  return (1 - math.cos(2 * math.pi * phase)) / 2;
}
