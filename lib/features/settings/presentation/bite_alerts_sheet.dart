import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../alerts/application/alerts_providers.dart';
import '../../alerts/domain/planned_alert.dart';
import '../../forecast/domain/fish.dart';

/// Bottom-sheet с тумблерами уведомлений по одному виду рыбы: «Лучший день
/// недели» и «Все отличные дни». Открывается из секции «Уведомления» в настройках.
Future<void> showBiteAlertsSheet({
  required BuildContext context,
  required Fish fish,
  required String title,
}) {
  return showModalBottomSheet<void>(
    context: context,
    // Покрывает bottom-nav: модал в root-навигаторе.
    useRootNavigator: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _BiteAlertsSheet(fish: fish, title: title),
  );
}

class _BiteAlertsSheet extends StatelessWidget {
  const _BiteAlertsSheet({required this.fish, required this.title});

  final Fish fish;
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: cs.outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
            _AlertToggleTile(
              fish: fish,
              kind: BiteAlertKind.primeWeek,
              title: l10n.settingsAlertsPrimeTitle,
              subtitle: l10n.settingsAlertsPrimeSubtitle,
            ),
            _AlertToggleTile(
              fish: fish,
              kind: BiteAlertKind.excellentDays,
              title: l10n.settingsAlertsExcellentTitle,
              subtitle: l10n.settingsAlertsExcellentSubtitle,
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertToggleTile extends ConsumerWidget {
  const _AlertToggleTile({
    required this.fish,
    required this.kind,
    required this.title,
    required this.subtitle,
  });

  final Fish fish;
  final BiteAlertKind kind;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final on = ref.watch(biteAlertsProvider).contains((kind, fish));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(value: on, onChanged: (v) => _toggle(ref, v)),
        ],
      ),
    );
  }

  Future<void> _toggle(WidgetRef ref, bool value) async {
    final notifier = ref.read(biteAlertsProvider.notifier);
    if (!value) {
      await notifier.set(kind, fish, false);
      return;
    }
    // Включение требует системного разрешения; без него тумблер не зажигаем,
    // чтобы не обещать алёрты, которые не придут.
    final granted =
        await ref.read(notificationServiceProvider).requestPermission();
    if (granted) await notifier.set(kind, fish, true);
  }
}
