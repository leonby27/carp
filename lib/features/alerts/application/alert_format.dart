import '../../../l10n/app_localizations.dart';
import '../../forecast/domain/fish.dart';
import '../../forecast/domain/forecast.dart';
import '../data/notification_service.dart';
import '../domain/planned_alert.dart';

/// Собирает локализованный текст уведомления из структурного [PlannedAlert].
/// Выделено из планировщика, чтобы ядро оставалось чистым и тестируемым, а вся
/// привязка к локали жила в одном месте. Заголовок несёт вид рыбы и тип события,
/// тело — спот, окно дня и индекс (каждая строка опирается на реальный фактор).
ScheduledNotification buildScheduledNotification(
  PlannedAlert a,
  AppLocalizations l10n,
) {
  final fish = switch (a.fish) {
    Fish.carp => l10n.fishCarp,
    Fish.crucian => l10n.fishCrucian,
  };

  final title = switch (a.kind) {
    BiteAlertKind.primeWeek => l10n.alertTitlePrime(fish),
    BiteAlertKind.excellentDays => l10n.alertTitleExcellent(fish),
  };

  final when = switch (a.windowKind) {
    BiteWindowKind.dawn => l10n.alertWindowDawn,
    BiteWindowKind.dusk => l10n.alertWindowDusk,
    BiteWindowKind.day => l10n.alertWindowDay,
    BiteWindowKind.night => l10n.alertWindowNight,
    null => l10n.alertWindowAny,
  };

  final spot = a.spotName.trim().isEmpty ? l10n.alertSpotFallback : a.spotName;
  final body = l10n.alertBody(spot, when, a.index);

  return (id: a.notificationId, when: a.fireAt, title: title, body: body);
}
