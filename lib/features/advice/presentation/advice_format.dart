import 'package:flutter/material.dart';

import '../../../core/units/units.dart';
import '../../../l10n/app_localizations.dart';
import '../../forecast/domain/weather_point.dart' show WindCardinal;
import '../../forecast/presentation/forecast_format.dart'
    show formatTemp, formatWind;
import '../domain/advice.dart';

/// Маппинг категорий и кодов советов в иконки и локализованные подписи.

IconData adviceKindIcon(AdviceKind kind) => switch (kind) {
      AdviceKind.bait => Icons.set_meal_outlined,
      AdviceKind.feeding => Icons.grain,
      AdviceKind.depth => Icons.swap_vert,
      AdviceKind.location => Icons.explore_outlined,
      AdviceKind.timing => Icons.schedule,
    };

/// Путь к иллюстрации-иконке под конкретный код совета. Имя файла = код в
/// snake_case (см. assets/images/advice/). В тёмной теме берём вариант на
/// тёмном фоне из подпапки dark/.
String adviceIconAsset(AdviceCode code, {bool dark = false}) {
  final name = _iconName(code);
  return dark
      ? 'assets/images/advice/dark/$name.webp'
      : 'assets/images/advice/$name.webp';
}

String _iconName(AdviceCode code) => switch (code) {
      AdviceCode.baitColdBright => 'bait_cold_bright',
      AdviceCode.baitMidBoilies => 'bait_mid_boilies',
      AdviceCode.baitWarmFishmeal => 'bait_warm_fishmeal',
      AdviceCode.baitHotSurface => 'bait_hot_surface',
      AdviceCode.baitWarming => 'bait_warming',
      AdviceCode.baitCooling => 'bait_cooling',
      AdviceCode.feedMinimal => 'feed_minimal',
      AdviceCode.feedModerate => 'feed_moderate',
      AdviceCode.feedHeavy => 'feed_heavy',
      AdviceCode.rigBottom => 'rig_bottom',
      AdviceCode.rigZig => 'rig_zig',
      AdviceCode.rigSurface => 'rig_surface',
      AdviceCode.swimWindward => 'swim_windward',
      AdviceCode.swimCalmFeatures => 'swim_calm_features',
      AdviceCode.swimSheltered => 'swim_sheltered',
      AdviceCode.timePressureDrop => 'time_pressure_drop',
      AdviceCode.timeBestWindow => 'time_best_window',
      AdviceCode.timeDawnDusk => 'time_dawn_dusk',
      AdviceCode.timeAllDay => 'time_all_day',
      AdviceCode.timeSlowPatient => 'time_slow_patient',
      // Карась — собственные иллюстрации.
      AdviceCode.crucianBaitColdAnimal => 'crucian_bait_cold_animal',
      AdviceCode.crucianBaitWarming => 'crucian_bait_warming',
      AdviceCode.crucianBaitCooling => 'crucian_bait_cooling',
      AdviceCode.crucianBaitSandwich => 'crucian_bait_sandwich',
      AdviceCode.crucianBaitWarmPlant => 'crucian_bait_warm_plant',
      AdviceCode.crucianBaitHotDough => 'crucian_bait_hot_dough',
      AdviceCode.crucianFeedTiny => 'crucian_feed_tiny',
      AdviceCode.crucianFeedSweet => 'crucian_feed_sweet',
      AdviceCode.crucianFeedActive => 'crucian_feed_active',
      AdviceCode.crucianRigFloatBottom => 'crucian_rig_float_bottom',
      AdviceCode.crucianRigDropper => 'crucian_rig_dropper',
      AdviceCode.crucianRigShallow => 'crucian_rig_shallow',
      AdviceCode.crucianSwimReeds => 'crucian_swim_reeds',
      AdviceCode.crucianSwimWarmShallows => 'crucian_swim_warm_shallows',
      AdviceCode.crucianSwimDeepEdge => 'crucian_swim_deep_edge',
      AdviceCode.crucianTimePressureDrop => 'crucian_time_pressure_drop',
      AdviceCode.crucianTimeBestWindow => 'crucian_time_best_window',
      AdviceCode.crucianTimeMorning => 'crucian_time_morning',
      AdviceCode.crucianTimeStableWarm => 'crucian_time_stable_warm',
      AdviceCode.crucianTimePatient => 'crucian_time_patient',
    };

String adviceKindTitle(AppLocalizations l10n, AdviceKind kind) =>
    switch (kind) {
      AdviceKind.bait => l10n.adviceKindBait,
      AdviceKind.feeding => l10n.adviceKindFeeding,
      AdviceKind.depth => l10n.adviceKindDepth,
      AdviceKind.location => l10n.adviceKindLocation,
      AdviceKind.timing => l10n.adviceKindTiming,
    };

String adviceTitle(AppLocalizations l10n, AdviceTip tip) => switch (tip.code) {
      AdviceCode.baitColdBright => l10n.adviceBaitColdBrightTitle,
      AdviceCode.baitMidBoilies => l10n.adviceBaitMidBoiliesTitle,
      AdviceCode.baitWarmFishmeal => l10n.adviceBaitWarmFishmealTitle,
      AdviceCode.baitHotSurface => l10n.adviceBaitHotSurfaceTitle,
      AdviceCode.baitWarming => l10n.adviceBaitWarmingTitle,
      AdviceCode.baitCooling => l10n.adviceBaitCoolingTitle,
      AdviceCode.feedMinimal => l10n.adviceFeedMinimalTitle,
      AdviceCode.feedModerate => l10n.adviceFeedModerateTitle,
      AdviceCode.feedHeavy => l10n.adviceFeedHeavyTitle,
      AdviceCode.rigBottom => l10n.adviceRigBottomTitle,
      AdviceCode.rigZig => l10n.adviceRigZigTitle,
      AdviceCode.rigSurface => l10n.adviceRigSurfaceTitle,
      AdviceCode.swimWindward => l10n.adviceSwimWindwardTitle,
      AdviceCode.swimCalmFeatures => l10n.adviceSwimCalmFeaturesTitle,
      AdviceCode.swimSheltered => l10n.adviceSwimShelteredTitle,
      AdviceCode.timePressureDrop => l10n.adviceTimePressureDropTitle,
      AdviceCode.timeBestWindow => l10n.adviceTimeBestWindowTitle,
      AdviceCode.timeDawnDusk => l10n.adviceTimeDawnDuskTitle,
      AdviceCode.timeAllDay => l10n.adviceTimeAllDayTitle,
      AdviceCode.timeSlowPatient => l10n.adviceTimeSlowPatientTitle,
      // Карась
      AdviceCode.crucianBaitColdAnimal => l10n.crucianBaitColdAnimalTitle,
      AdviceCode.crucianBaitWarming => l10n.crucianBaitWarmingTitle,
      AdviceCode.crucianBaitCooling => l10n.crucianBaitCoolingTitle,
      AdviceCode.crucianBaitSandwich => l10n.crucianBaitSandwichTitle,
      AdviceCode.crucianBaitWarmPlant => l10n.crucianBaitWarmPlantTitle,
      AdviceCode.crucianBaitHotDough => l10n.crucianBaitHotDoughTitle,
      AdviceCode.crucianFeedTiny => l10n.crucianFeedTinyTitle,
      AdviceCode.crucianFeedSweet => l10n.crucianFeedSweetTitle,
      AdviceCode.crucianFeedActive => l10n.crucianFeedActiveTitle,
      AdviceCode.crucianRigFloatBottom => l10n.crucianRigFloatBottomTitle,
      AdviceCode.crucianRigDropper => l10n.crucianRigDropperTitle,
      AdviceCode.crucianRigShallow => l10n.crucianRigShallowTitle,
      AdviceCode.crucianSwimReeds => l10n.crucianSwimReedsTitle,
      AdviceCode.crucianSwimWarmShallows => l10n.crucianSwimWarmShallowsTitle,
      AdviceCode.crucianSwimDeepEdge => l10n.crucianSwimDeepEdgeTitle,
      AdviceCode.crucianTimePressureDrop => l10n.crucianTimePressureDropTitle,
      AdviceCode.crucianTimeBestWindow => l10n.crucianTimeBestWindowTitle,
      AdviceCode.crucianTimeMorning => l10n.crucianTimeMorningTitle,
      AdviceCode.crucianTimeStableWarm => l10n.crucianTimeStableWarmTitle,
      AdviceCode.crucianTimePatient => l10n.crucianTimePatientTitle,
    };

String adviceBody(AppLocalizations l10n, AdviceTip tip) {
  switch (tip.code) {
    case AdviceCode.swimWindward:
      final dir = tip.windDir != null ? windFullLabel(l10n, tip.windDir!) : '';
      return l10n.adviceSwimWindwardBody(dir);
    case AdviceCode.timeBestWindow:
      final w = tip.window;
      final from = w != null ? _hm(w.$1) : '';
      final to = w != null ? _hm(w.$2) : '';
      return l10n.adviceTimeBestWindowBody(from, to);
    case AdviceCode.crucianTimeBestWindow:
      final w = tip.window;
      final from = w != null ? _hm(w.$1) : '';
      final to = w != null ? _hm(w.$2) : '';
      return l10n.crucianTimeBestWindowBody(from, to);
    default:
      return _staticBody(l10n, tip.code);
  }
}

/// Короткая строка «почему» с реальным фактом, отформатированным в выбранных
/// единицах. Делает совет прозрачным, а не случайным.
String adviceReason(AppLocalizations l10n, Units units, AdviceTip tip) =>
    switch (tip.reason) {
      AdviceReason.waterTemp =>
        l10n.adviceWhyWater(formatTemp(units, tip.reasonValue ?? 0)),
      AdviceReason.waterRising => l10n.adviceWhyWaterRising,
      AdviceReason.waterFalling => l10n.adviceWhyWaterFalling,
      AdviceReason.airHot =>
        l10n.adviceWhyAirHot(formatTemp(units, tip.reasonValue ?? 0)),
      AdviceReason.windStrong =>
        l10n.adviceWhyWind(formatWind(l10n, units, tip.reasonValue ?? 0)),
      AdviceReason.windLight => l10n.adviceWhyWindLight,
      AdviceReason.pressureFalling => l10n.adviceWhyPressureFalling,
      AdviceReason.rainDay => l10n.adviceWhyRain,
      AdviceReason.bottomHabit => l10n.adviceWhyBottomHabit,
      AdviceReason.biteHigh => l10n.adviceWhyBiteHigh,
      AdviceReason.biteMid => l10n.adviceWhyBiteMid,
      AdviceReason.biteLow => l10n.adviceWhyBiteLow,
      AdviceReason.bestHours => l10n.adviceWhyBestHours,
    };

String _hm(DateTime t) => '${t.hour}:00';

/// Полное название направления ветра — в предложении короткие «С/В/З» путаются
/// с цифрами/латиницей (особенно «З» ↔ «3»), поэтому в тексте совета пишем
/// словом.
String windFullLabel(AppLocalizations l10n, WindCardinal c) => switch (c) {
      WindCardinal.n => l10n.windFullN,
      WindCardinal.ne => l10n.windFullNE,
      WindCardinal.e => l10n.windFullE,
      WindCardinal.se => l10n.windFullSE,
      WindCardinal.s => l10n.windFullS,
      WindCardinal.sw => l10n.windFullSW,
      WindCardinal.w => l10n.windFullW,
      WindCardinal.nw => l10n.windFullNW,
    };

String _staticBody(AppLocalizations l10n, AdviceCode code) => switch (code) {
      AdviceCode.baitColdBright => l10n.adviceBaitColdBrightBody,
      AdviceCode.baitMidBoilies => l10n.adviceBaitMidBoiliesBody,
      AdviceCode.baitWarmFishmeal => l10n.adviceBaitWarmFishmealBody,
      AdviceCode.baitHotSurface => l10n.adviceBaitHotSurfaceBody,
      AdviceCode.baitWarming => l10n.adviceBaitWarmingBody,
      AdviceCode.baitCooling => l10n.adviceBaitCoolingBody,
      AdviceCode.feedMinimal => l10n.adviceFeedMinimalBody,
      AdviceCode.feedModerate => l10n.adviceFeedModerateBody,
      AdviceCode.feedHeavy => l10n.adviceFeedHeavyBody,
      AdviceCode.rigBottom => l10n.adviceRigBottomBody,
      AdviceCode.rigZig => l10n.adviceRigZigBody,
      AdviceCode.rigSurface => l10n.adviceRigSurfaceBody,
      AdviceCode.swimCalmFeatures => l10n.adviceSwimCalmFeaturesBody,
      AdviceCode.swimSheltered => l10n.adviceSwimShelteredBody,
      AdviceCode.timePressureDrop => l10n.adviceTimePressureDropBody,
      AdviceCode.timeDawnDusk => l10n.adviceTimeDawnDuskBody,
      AdviceCode.timeAllDay => l10n.adviceTimeAllDayBody,
      AdviceCode.timeSlowPatient => l10n.adviceTimeSlowPatientBody,
      // Карась
      AdviceCode.crucianBaitColdAnimal => l10n.crucianBaitColdAnimalBody,
      AdviceCode.crucianBaitWarming => l10n.crucianBaitWarmingBody,
      AdviceCode.crucianBaitCooling => l10n.crucianBaitCoolingBody,
      AdviceCode.crucianBaitSandwich => l10n.crucianBaitSandwichBody,
      AdviceCode.crucianBaitWarmPlant => l10n.crucianBaitWarmPlantBody,
      AdviceCode.crucianBaitHotDough => l10n.crucianBaitHotDoughBody,
      AdviceCode.crucianFeedTiny => l10n.crucianFeedTinyBody,
      AdviceCode.crucianFeedSweet => l10n.crucianFeedSweetBody,
      AdviceCode.crucianFeedActive => l10n.crucianFeedActiveBody,
      AdviceCode.crucianRigFloatBottom => l10n.crucianRigFloatBottomBody,
      AdviceCode.crucianRigDropper => l10n.crucianRigDropperBody,
      AdviceCode.crucianRigShallow => l10n.crucianRigShallowBody,
      AdviceCode.crucianSwimReeds => l10n.crucianSwimReedsBody,
      AdviceCode.crucianSwimWarmShallows => l10n.crucianSwimWarmShallowsBody,
      AdviceCode.crucianSwimDeepEdge => l10n.crucianSwimDeepEdgeBody,
      AdviceCode.crucianTimePressureDrop => l10n.crucianTimePressureDropBody,
      AdviceCode.crucianTimeMorning => l10n.crucianTimeMorningBody,
      AdviceCode.crucianTimeStableWarm => l10n.crucianTimeStableWarmBody,
      AdviceCode.crucianTimePatient => l10n.crucianTimePatientBody,
      // обрабатываются с плейсхолдерами в adviceBody
      AdviceCode.swimWindward ||
      AdviceCode.timeBestWindow ||
      AdviceCode.crucianTimeBestWindow =>
        '',
    };
