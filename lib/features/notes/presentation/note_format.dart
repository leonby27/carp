import '../../../core/units/units.dart';
import '../../../l10n/app_localizations.dart';
import '../../forecast/presentation/forecast_format.dart';
import '../domain/note.dart';

/// Краткая строка условий заметки в выбранных единицах: давление · ветер · вода.
String noteConditionsText(AppLocalizations l10n, Units units, NoteConditions c) {
  final wind =
      c.windMs < 0.5 ? l10n.fcWindCalm : formatWind(l10n, units, c.windMs);
  // Подписываем воду, чтобы «13°» не путали с воздухом.
  return '${formatPressure(l10n, units, c.pressureHpa)} · $wind · ${l10n.fcChipWater} ${formatTemp(units, c.waterTempC)}';
}
