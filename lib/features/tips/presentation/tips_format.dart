import '../../../l10n/app_localizations.dart';
import '../domain/fishing_tip.dart';

/// Иллюстрация совета. Имя файла = snake_case от имени enum
/// (например `crucianWarmShallows` → `crucian_warm_shallows.webp`).
/// Тёмный вариант лежит в `tips/dark/`.
String tipAsset(FishingTip tip, {required bool dark}) {
  final snake = tip.name.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (m) => '_${m[0]!.toLowerCase()}',
  );
  final dir = dark ? 'assets/images/tips/dark' : 'assets/images/tips';
  return '$dir/$snake.webp';
}

String tipTitle(AppLocalizations l10n, FishingTip tip) => switch (tip) {
      FishingTip.locationFirst => l10n.tipLocationFirstTitle,
      FishingTip.margins => l10n.tipMarginsTitle,
      FishingTip.sharpHooks => l10n.tipSharpHooksTitle,
      FishingTip.dontOverfeed => l10n.tipDontOverfeedTitle,
      FishingTip.baitRegularly => l10n.tipBaitRegularlyTitle,
      FishingTip.hairRig => l10n.tipHairRigTitle,
      FishingTip.sweetcorn => l10n.tipSweetcornTitle,
      FishingTip.mixedSizes => l10n.tipMixedSizesTitle,
      FishingTip.fallingPressure => l10n.tipFallingPressureTitle,
      FishingTip.waterTemp => l10n.tipWaterTempTitle,
      FishingTip.pvaBag => l10n.tipPvaBagTitle,
      FishingTip.featureFinding => l10n.tipFeatureFindingTitle,
      FishingTip.stayQuiet => l10n.tipStayQuietTitle,
      FishingTip.particles => l10n.tipParticlesTitle,
      FishingTip.fishCare => l10n.tipFishCareTitle,
      FishingTip.crucianShyBites => l10n.tipCrucianShyBitesTitle,
      FishingTip.crucianFineTackle => l10n.tipCrucianFineTackleTitle,
      FishingTip.crucianSlowFall => l10n.tipCrucianSlowFallTitle,
      FishingTip.crucianWarmShallows => l10n.tipCrucianWarmShallowsTitle,
    };

String tipBody(AppLocalizations l10n, FishingTip tip) => switch (tip) {
      FishingTip.locationFirst => l10n.tipLocationFirstBody,
      FishingTip.margins => l10n.tipMarginsBody,
      FishingTip.sharpHooks => l10n.tipSharpHooksBody,
      FishingTip.dontOverfeed => l10n.tipDontOverfeedBody,
      FishingTip.baitRegularly => l10n.tipBaitRegularlyBody,
      FishingTip.hairRig => l10n.tipHairRigBody,
      FishingTip.sweetcorn => l10n.tipSweetcornBody,
      FishingTip.mixedSizes => l10n.tipMixedSizesBody,
      FishingTip.fallingPressure => l10n.tipFallingPressureBody,
      FishingTip.waterTemp => l10n.tipWaterTempBody,
      FishingTip.pvaBag => l10n.tipPvaBagBody,
      FishingTip.featureFinding => l10n.tipFeatureFindingBody,
      FishingTip.stayQuiet => l10n.tipStayQuietBody,
      FishingTip.particles => l10n.tipParticlesBody,
      FishingTip.fishCare => l10n.tipFishCareBody,
      FishingTip.crucianShyBites => l10n.tipCrucianShyBitesBody,
      FishingTip.crucianFineTackle => l10n.tipCrucianFineTackleBody,
      FishingTip.crucianSlowFall => l10n.tipCrucianSlowFallBody,
      FishingTip.crucianWarmShallows => l10n.tipCrucianWarmShallowsBody,
    };

String tipProof(AppLocalizations l10n, FishingTip tip) => switch (tip) {
      FishingTip.locationFirst => l10n.tipLocationFirstProof,
      FishingTip.margins => l10n.tipMarginsProof,
      FishingTip.sharpHooks => l10n.tipSharpHooksProof,
      FishingTip.dontOverfeed => l10n.tipDontOverfeedProof,
      FishingTip.baitRegularly => l10n.tipBaitRegularlyProof,
      FishingTip.hairRig => l10n.tipHairRigProof,
      FishingTip.sweetcorn => l10n.tipSweetcornProof,
      FishingTip.mixedSizes => l10n.tipMixedSizesProof,
      FishingTip.fallingPressure => l10n.tipFallingPressureProof,
      FishingTip.waterTemp => l10n.tipWaterTempProof,
      FishingTip.pvaBag => l10n.tipPvaBagProof,
      FishingTip.featureFinding => l10n.tipFeatureFindingProof,
      FishingTip.stayQuiet => l10n.tipStayQuietProof,
      FishingTip.particles => l10n.tipParticlesProof,
      FishingTip.fishCare => l10n.tipFishCareProof,
      FishingTip.crucianShyBites => l10n.tipCrucianShyBitesProof,
      FishingTip.crucianFineTackle => l10n.tipCrucianFineTackleProof,
      FishingTip.crucianSlowFall => l10n.tipCrucianSlowFallProof,
      FishingTip.crucianWarmShallows => l10n.tipCrucianWarmShallowsProof,
    };
