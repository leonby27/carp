import 'package:flutter/material.dart';

import '../../../core/units/units.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/astro.dart';
import '../domain/bite_engine.dart';
import '../domain/bite_score.dart';
import '../domain/forecast.dart';
import '../domain/weather_point.dart';

/// Маппинг доменных enum'ов в подписи, цвета и иконки для UI прогноза.

/// Описание под уровнем клёва: лучшее окно и его время одной строкой,
/// например «Лучшее окно 19:00–21:00». Если окна нет — слабая активность.
String verdictText(AppLocalizations l10n, BiteLevel level, BiteWindow? window) {
  String hm(DateTime t) => '${t.hour}:00';
  if (window == null) return l10n.fcBestWindowEmpty;
  return '${l10n.fcBestWindow} ${hm(window.from)}–${hm(window.to)}';
}

/// Температура в выбранных единицах с символом градуса.
String formatTemp(Units units, double celsius) =>
    '${units.tempValue(celsius).round()}°';

/// Диапазон мин–макс температуры дня.
String formatTempRange(Units units, double minC, double maxC) =>
    '${formatTemp(units, minC)}–${formatTemp(units, maxC)}';

/// Скорость ветра с локализованным суффиксом выбранной единицы.
String formatWind(AppLocalizations l10n, Units units, double ms) {
  final suffix =
      units.wind == WindUnit.kmh ? l10n.fcUnitKmhSuffix : l10n.fcUnitMsSuffix;
  return '${units.windValue(ms).round()} $suffix';
}

/// Давление с локализованным суффиксом выбранной единицы.
String formatPressure(AppLocalizations l10n, Units units, double hpa) {
  final suffix = units.pressure == PressureUnit.mmhg
      ? l10n.fcUnitMmHgSuffix
      : l10n.fcUnitHpaSuffix;
  return '${units.pressureValue(hpa).round()} $suffix';
}

String biteLevelLabel(AppLocalizations l10n, BiteLevel level) => switch (level) {
      BiteLevel.veryLow => l10n.fcLevelVeryLow,
      BiteLevel.low => l10n.fcLevelLow,
      BiteLevel.medium => l10n.fcLevelMedium,
      BiteLevel.good => l10n.fcLevelGood,
      BiteLevel.excellent => l10n.fcLevelExcellent,
    };

/// Цветовая шкала индекса: красный (плохо) → зелёный (отлично).
Color biteLevelColor(BiteLevel level) => switch (level) {
      BiteLevel.veryLow => const Color(0xFFE0556E),
      BiteLevel.low => const Color(0xFFF0681B),
      BiteLevel.medium => const Color(0xFFEBA80B),
      BiteLevel.good => const Color(0xFF1D8B53),
      BiteLevel.excellent => const Color(0xFF1D8B53),
    };

Color biteValueColor(int value) {
  if (value < 20) return const Color(0xFFE0556E);
  if (value < 40) return const Color(0xFFF0681B);
  if (value < 60) return const Color(0xFFEBA80B);
  return const Color(0xFF1D8B53);
}

String factorLabel(AppLocalizations l10n, BiteFactorKind kind) => switch (kind) {
      BiteFactorKind.pressure => l10n.fcFactorPressure,
      BiteFactorKind.temperature => l10n.fcFactorTemperature,
      BiteFactorKind.wind => l10n.fcFactorWind,
      BiteFactorKind.cloud => l10n.fcFactorCloud,
      BiteFactorKind.precipitation => l10n.fcFactorPrecipitation,
      BiteFactorKind.season => l10n.fcFactorSeason,
      BiteFactorKind.moon => l10n.fcFactorMoon,
    };

IconData factorIcon(BiteFactorKind kind) => switch (kind) {
      BiteFactorKind.pressure => Icons.speed,
      BiteFactorKind.temperature => Icons.thermostat,
      BiteFactorKind.wind => Icons.air,
      BiteFactorKind.cloud => Icons.cloud_outlined,
      BiteFactorKind.precipitation => Icons.water_drop_outlined,
      BiteFactorKind.season => Icons.calendar_today_outlined,
      BiteFactorKind.moon => Icons.nightlight_round,
    };

/// Описательная фраза по фактору в контексте его влияния, напр. «стабильное
/// давление» / «сильный ветер». Используется для связного объяснения прогноза.
String factorPhrase(AppLocalizations l10n, BiteFactor f) {
  final pos = f.isPositive;
  return switch (f.kind) {
    BiteFactorKind.pressure =>
      pos ? l10n.fcPhrasePressurePos : l10n.fcPhrasePressureNeg,
    BiteFactorKind.temperature =>
      pos ? l10n.fcPhraseTemperaturePos : l10n.fcPhraseTemperatureNeg,
    BiteFactorKind.wind => pos ? l10n.fcPhraseWindPos : l10n.fcPhraseWindNeg,
    BiteFactorKind.cloud => pos ? l10n.fcPhraseCloudPos : l10n.fcPhraseCloudNeg,
    BiteFactorKind.precipitation =>
      pos ? l10n.fcPhrasePrecipPos : l10n.fcPhrasePrecipNeg,
    BiteFactorKind.season =>
      pos ? l10n.fcPhraseSeasonPos : l10n.fcPhraseSeasonNeg,
    BiteFactorKind.moon => pos ? l10n.fcPhraseMoonPos : l10n.fcPhraseMoonNeg,
  };
}

/// Факторы, ранжированные по реальному вкладу (вес × отклонение от нейтрали):
/// плюсы по убыванию пользы, минусы по убыванию вреда. Общая основа для текста
/// объяснения и выбора иллюстрации — чтобы они не разъезжались.
({List<BiteFactor> pros, List<BiteFactor> cons}) rankedFactors(BiteScore score) {
  double proImpact(BiteFactor f) => (f.score - 0.5) * f.weight;
  double conImpact(BiteFactor f) => (0.5 - f.score) * f.weight;
  final pros = [...score.factors.where((f) => f.isPositive)]
    ..sort((a, b) => proImpact(b).compareTo(proImpact(a)));
  final cons = [...score.factors.where((f) => f.isNegative)]
    ..sort((a, b) => conImpact(b).compareTo(conImpact(a)));
  return (pros: pros, cons: cons);
}

/// Связное объяснение прогноза словами. Каждый значимый фактор — отдельное
/// мини-предложение с механизмом («почему это влияет»), а не просто ярлык.
String whyExplanation(AppLocalizations l10n, BiteScore score) {
  final r = rankedFactors(score);

  String cap(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  String sentence(BiteFactor f) {
    final s = factorPhrase(l10n, f).trim();
    return cap(s.endsWith('.') ? s : '$s.');
  }

  // Ведём с главным, что помогает; в конце — самый сильный ограничитель.
  // Если плюсов нет — показываем оба основных минуса.
  final picks = <BiteFactor>[
    ...r.pros.take(2),
    ...r.cons.take(r.pros.isEmpty ? 2 : 1),
  ];
  if (picks.isEmpty) return l10n.fcWhyBalanced;
  return picks.map(sentence).join(' ');
}

/// Иллюстрация для карточки «Почему такой прогноз»: подбирается по ведущему
/// фактору объяснения (тот, с которого начинается [whyExplanation]). Возвращает
/// путь к ассету под текущую тему либо null — если иллюстрации нет (тогда
/// показываем запасной щит).
String? whyIllustrationAsset(BiteScore score, {required bool dark}) {
  final r = rankedFactors(score);
  final BiteFactor? lead =
      r.pros.isNotEmpty ? r.pros.first : (r.cons.isNotEmpty ? r.cons.first : null);
  final key = lead == null ? 'why_balanced' : _factorIllustrationKey(lead);
  if (key == null) return null;
  final dir = dark ? 'assets/images/why/dark' : 'assets/images/why';
  return '$dir/$key.webp';
}

/// Ключ ассета по фактору и знаку его влияния. null — для состояний, под
/// которые иллюстрации пока нет (сухая погода → фоллбэк на щит).
String? _factorIllustrationKey(BiteFactor f) {
  final pos = f.isPositive;
  return switch (f.kind) {
    BiteFactorKind.pressure => pos ? 'why_pressure_steady' : 'why_pressure_swings',
    BiteFactorKind.temperature => pos ? 'why_water_warm' : 'why_water_cold',
    BiteFactorKind.wind => pos ? 'why_wind_ripple' : 'why_wind_strong',
    BiteFactorKind.cloud => pos ? 'why_clouds_soft' : 'why_sun_bright',
    BiteFactorKind.precipitation => pos ? null : 'why_rain_murky',
    BiteFactorKind.season => pos ? 'why_season_peak' : 'why_season_low',
    BiteFactorKind.moon => pos ? 'why_moon_active' : 'why_moon_weak',
  };
}

/// Уровень доверия к прогнозу: насколько факторы согласованы между собой.
enum WhyConfidence { high, medium, low }

WhyConfidence confidenceLevel(BiteScore score) {
  final pros = score.factors.where((f) => f.isPositive).length;
  final cons = score.factors.where((f) => f.isNegative).length;
  final decisive = pros + cons;
  final dominant = pros > cons ? pros : cons;
  final ratio = decisive == 0 ? 0.0 : dominant / decisive;
  if (decisive >= 2 && ratio >= 0.7) return WhyConfidence.high;
  if (decisive >= 1) return WhyConfidence.medium;
  return WhyConfidence.low;
}

String confidenceLabel(AppLocalizations l10n, WhyConfidence c) => switch (c) {
      WhyConfidence.high => l10n.fcConfidenceHigh,
      WhyConfidence.medium => l10n.fcConfidenceMedium,
      WhyConfidence.low => l10n.fcConfidenceLow,
    };

Color confidenceColor(WhyConfidence c) => switch (c) {
      WhyConfidence.high => const Color(0xFF1D8B53),
      WhyConfidence.medium => const Color(0xFFEBA80B),
      WhyConfidence.low => const Color(0xFF8A94A6),
    };

String conditionLabel(AppLocalizations l10n, WeatherCondition c) => switch (c) {
      WeatherCondition.clear => l10n.fcCondClear,
      WeatherCondition.partlyCloudy => l10n.fcCondPartly,
      WeatherCondition.cloudy => l10n.fcCondCloudy,
      WeatherCondition.rain => l10n.fcCondRain,
      WeatherCondition.storm => l10n.fcCondStorm,
    };

/// Цвет иконки погоды — немного живости карточкам (солнце/тучи/дождь).
Color conditionColor(WeatherCondition c) => switch (c) {
      WeatherCondition.clear => const Color(0xFFFFB300),
      WeatherCondition.partlyCloudy => const Color(0xFFFFB300),
      WeatherCondition.cloudy => const Color(0xFF90A4AE),
      WeatherCondition.rain => const Color(0xFF42A5F5),
      WeatherCondition.storm => const Color(0xFF5C6BC0),
    };

IconData conditionIcon(WeatherCondition c) => switch (c) {
      WeatherCondition.clear => Icons.wb_sunny_outlined,
      WeatherCondition.partlyCloudy => Icons.wb_cloudy_outlined,
      WeatherCondition.cloudy => Icons.cloud_outlined,
      WeatherCondition.rain => Icons.grain,
      WeatherCondition.storm => Icons.bolt,
    };

/// Фаза луны словом по доле синодического цикла.
String moonPhaseLabel(AppLocalizations l10n, DateTime date) {
  final f = moonPhaseFraction(date);
  if (f < 0.03 || f > 0.97) return l10n.moonNew;
  if (f > 0.47 && f < 0.53) return l10n.moonFull;
  return f < 0.5 ? l10n.moonWaxing : l10n.moonWaning;
}

String windCardinalLabel(AppLocalizations l10n, WindCardinal c) => switch (c) {
      WindCardinal.n => l10n.fcWindN,
      WindCardinal.ne => l10n.fcWindNE,
      WindCardinal.e => l10n.fcWindE,
      WindCardinal.se => l10n.fcWindSE,
      WindCardinal.s => l10n.fcWindS,
      WindCardinal.sw => l10n.fcWindSW,
      WindCardinal.w => l10n.fcWindW,
      WindCardinal.nw => l10n.fcWindNW,
    };

/// Категория-ярлык по числовому индексу (Слабо/Средне/Хорошо/Отлично) — общая
/// для карточек периода и модалки разбора, чтобы пороги не разъезжались.
String biteRateLabel(AppLocalizations l10n, int value) {
  if (value < 40) return l10n.fcRateWeak;
  if (value < 60) return l10n.fcRateMid;
  if (value < 80) return l10n.fcRateGood;
  return l10n.fcRateGreat;
}

/// Объяснение поправки времени суток: почему оценка ЭТОГО периода выше или ниже
/// дневной базы (зорьки бустятся, холодная ночь проседает и т.д.).
String todRegimePhrase(AppLocalizations l10n, TimeOfDayRegime r) => switch (r) {
      TimeOfDayRegime.dawn => l10n.fcTodDawn,
      TimeOfDayRegime.dusk => l10n.fcTodDusk,
      TimeOfDayRegime.warmNight => l10n.fcTodWarmNight,
      TimeOfDayRegime.midNight => l10n.fcTodMidNight,
      TimeOfDayRegime.coldNight => l10n.fcTodColdNight,
      TimeOfDayRegime.middayHot => l10n.fcTodMiddayHot,
      TimeOfDayRegime.coldDay => l10n.fcTodColdDay,
      TimeOfDayRegime.dayNeutral => l10n.fcTodDayNeutral,
    };

/// Поправка времени суток в процентах как символьный бейдж: «+15 %», «−15 %»
/// или «0 %». Знак считается от множителя (1.0 = без поправки).
String todAdjustmentBadge(double multiplier) {
  final pct = ((multiplier - 1) * 100).round();
  if (pct > 0) return '+$pct %';
  if (pct < 0) return '−${-pct} %';
  return '0 %';
}

/// Цвет бейджа поправки: буст — зелёный, штраф — красный, ноль — серый.
Color todAdjustmentColor(double multiplier) {
  final pct = ((multiplier - 1) * 100).round();
  if (pct > 0) return const Color(0xFF1D8B53);
  if (pct < 0) return const Color(0xFFE0556E);
  return const Color(0xFF8A94A6);
}
