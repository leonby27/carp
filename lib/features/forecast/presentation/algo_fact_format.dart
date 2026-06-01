import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/algo_fact.dart';

/// Иконка-топик под факт (Material-иконки, без отдельных ассетов).
IconData algoFactIcon(AlgoFact fact) => switch (fact) {
  AlgoFact.waterModel => Icons.thermostat,
  AlgoFact.thermalInertia => Icons.hourglass_bottom,
  AlgoFact.pressureTrend => Icons.trending_down,
  AlgoFact.frontMemory => Icons.history,
  AlgoFact.weakestLink => Icons.link_off,
  AlgoFact.heatCalm => Icons.wb_sunny_outlined,
  AlgoFact.realSun => Icons.wb_twilight,
  AlgoFact.spawnPhysics => Icons.egg_outlined,
  AlgoFact.speciesModels => Icons.compare_arrows,
  AlgoFact.biteWindows => Icons.schedule,
};

String algoFactTitle(AppLocalizations l10n, AlgoFact fact) => switch (fact) {
  AlgoFact.waterModel => l10n.algoFactWaterModelTitle,
  AlgoFact.thermalInertia => l10n.algoFactThermalInertiaTitle,
  AlgoFact.pressureTrend => l10n.algoFactPressureTrendTitle,
  AlgoFact.frontMemory => l10n.algoFactFrontMemoryTitle,
  AlgoFact.weakestLink => l10n.algoFactWeakestLinkTitle,
  AlgoFact.heatCalm => l10n.algoFactHeatCalmTitle,
  AlgoFact.realSun => l10n.algoFactRealSunTitle,
  AlgoFact.spawnPhysics => l10n.algoFactSpawnPhysicsTitle,
  AlgoFact.speciesModels => l10n.algoFactSpeciesModelsTitle,
  AlgoFact.biteWindows => l10n.algoFactBiteWindowsTitle,
};

String algoFactBody(AppLocalizations l10n, AlgoFact fact) => switch (fact) {
  AlgoFact.waterModel => l10n.algoFactWaterModelBody,
  AlgoFact.thermalInertia => l10n.algoFactThermalInertiaBody,
  AlgoFact.pressureTrend => l10n.algoFactPressureTrendBody,
  AlgoFact.frontMemory => l10n.algoFactFrontMemoryBody,
  AlgoFact.weakestLink => l10n.algoFactWeakestLinkBody,
  AlgoFact.heatCalm => l10n.algoFactHeatCalmBody,
  AlgoFact.realSun => l10n.algoFactRealSunBody,
  AlgoFact.spawnPhysics => l10n.algoFactSpawnPhysicsBody,
  AlgoFact.speciesModels => l10n.algoFactSpeciesModelsBody,
  AlgoFact.biteWindows => l10n.algoFactBiteWindowsBody,
};

/// Заголовок + тело одним абзацем: заголовок становится первым предложением.
String algoFactText(AppLocalizations l10n, AlgoFact fact) =>
    '${algoFactTitle(l10n, fact)}. ${algoFactBody(l10n, fact)}';

/// Ключ ассета-иллюстрации под факт (для `assets/images/algo/[dark/]<key>.webp`).
String _algoFactKey(AlgoFact fact) => switch (fact) {
  AlgoFact.waterModel => 'algo_water_model',
  AlgoFact.thermalInertia => 'algo_thermal_inertia',
  AlgoFact.pressureTrend => 'algo_pressure_trend',
  AlgoFact.frontMemory => 'algo_front_memory',
  AlgoFact.weakestLink => 'algo_weakest_link',
  AlgoFact.heatCalm => 'algo_heat_calm',
  AlgoFact.realSun => 'algo_real_sun',
  AlgoFact.spawnPhysics => 'algo_spawn_physics',
  AlgoFact.speciesModels => 'algo_species_models',
  AlgoFact.biteWindows => 'algo_bite_windows',
};

/// Путь к иллюстрации факта — задел под художественные ассеты.
///
/// Пока картинок нет, возвращаем null и в UI показываем брендовый фоллбэк.
/// Чтобы включить иллюстрации: положите webp в `assets/images/algo/` и
/// `assets/images/algo/dark/` по ключам [_algoFactKey], объявите обе папки в
/// pubspec и поднимите [_algoIllustrationsReady].
const bool _algoIllustrationsReady = false;

String? algoFactIllustration(AlgoFact fact, {required bool dark}) {
  if (!_algoIllustrationsReady) return null;
  final dir = dark ? 'assets/images/algo/dark' : 'assets/images/algo';
  return '$dir/${_algoFactKey(fact)}.webp';
}
