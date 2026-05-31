import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../spots/application/spots_providers.dart';
import '../application/alerts_providers.dart';

/// Невидимая обёртка, которая держит запланированные алёрты о клёве в актуальном
/// состоянии: пере-планирует при первом кадре (заход в приложение) и при смене
/// тумблера / набора спотов / вида рыбы. Свежий прогноз вытесняет устаревшие
/// уведомления — это и есть замена капризному фоновому fetch.
class BiteAlertsScheduler extends ConsumerStatefulWidget {
  const BiteAlertsScheduler({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<BiteAlertsScheduler> createState() =>
      _BiteAlertsSchedulerState();
}

class _BiteAlertsSchedulerState extends ConsumerState<BiteAlertsScheduler> {
  bool _kicked = false;

  void _reschedule() {
    final l10n = AppLocalizations.of(context);
    // Fire-and-forget: сеть не должна блокировать UI; сам планировщик молча
    // обрабатывает «выключено» и «нет спотов».
    ref.read(biteAlertSchedulerProvider).reschedule(l10n: l10n);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(biteAlertsProvider, (_, _) => _reschedule());
    ref.listen(savedSpotsProvider, (_, _) => _reschedule());

    if (!_kicked) {
      _kicked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _reschedule();
      });
    }

    return widget.child;
  }
}
