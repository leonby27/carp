import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/units/units.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/states.dart';
import '../../forecast/application/forecast_providers.dart';
import '../domain/advice.dart';
import '../domain/advice_engine.dart';
import 'advice_format.dart';

const _weekdayShort = {
  'ru': ['', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
  'en': ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
};
const _months = {
  'ru': ['', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля',
        'августа', 'сентября', 'октября', 'ноября', 'декабря'],
  'en': ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July',
        'August', 'September', 'October', 'November', 'December'],
};

String _code(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'ru' ? 'ru' : 'en';

/// Подпись дня для заголовка: сегодня/завтра словом, дальше — день недели и дата.
String _dayTitle(
    BuildContext context, AppLocalizations l10n, int index, DateTime date) {
  if (index == 0) return l10n.fcToday;
  if (index == 1) return l10n.fcTomorrow;
  final code = _code(context);
  final wd = _weekdayShort[code]![date.weekday];
  final m = _months[code]![date.month];
  final d = code == 'ru' ? '${date.day} $m' : '$m ${date.day}';
  return '$wd, $d';
}

/// Тактика для выбранного дня — модалкой поверх прогноза (как лист локаций).
/// День берём из общего [selectedDayIndexProvider], поэтому селектор дней и
/// шапка с индексом здесь не нужны — лист открывают уже для нужного дня.
Future<void> showAdviceSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    // Потолок высоты + внутренний скролл — как в листе локаций, чтобы при
    // длинном списке советов шапка не уезжала и лист закрывался.
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.85,
    ),
    // Фон листа — back-поверхность (темнее карточек), чтобы плашки советов,
    // которые сами на cs.surface, выделялись, а не сливались с фоном.
    backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _AdviceSheet(),
  );
}

class _AdviceSheet extends ConsumerWidget {
  const _AdviceSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final forecastAsync = ref.watch(forecastProvider);

    // Заголовок: «Тактика · <день>» — день берём из выбранного в прогнозе.
    final fc = forecastAsync.value;
    var title = l10n.tabAdvice;
    if (fc != null && fc.days.isNotEmpty) {
      final idx =
          ref.watch(selectedDayIndexProvider).clamp(0, fc.days.length - 1);
      title = '${l10n.tabAdvice} · ${_dayTitle(context, l10n, idx, fc.days[idx].date)}';
    }

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: cs.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Flexible(
            child: forecastAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: ErrorState(
                  title: l10n.fcError,
                  subtitle: l10n.fcErrorSubtitle,
                  retryLabel: l10n.fcRetry,
                  onRetry: () => ref.invalidate(weatherSeriesProvider),
                ),
              ),
              data: (forecast) {
                final selectedIndex = ref
                    .watch(selectedDayIndexProvider)
                    .clamp(0, forecast.days.length - 1);
                final day = forecast.days[selectedIndex];
                final prev =
                    selectedIndex > 0 ? forecast.days[selectedIndex - 1] : null;
                final fish = ref.watch(selectedFishProvider);
                final advice = AdviceEngine.forDay(day, fish, prev: prev);
                final units = ref.watch(unitsProvider);
                return ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    _Disclaimer(text: l10n.adviceDisclaimer),
                    const SizedBox(height: 16),
                    for (var i = 0; i < advice.length; i++) ...[
                      _TipCard(tip: advice[i], units: units),
                      if (i != advice.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip, required this.units});
  final AdviceTip tip;
  final Units units;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final kind = tip.kind;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        // Тёмная тема — без обводки (карточка выделяется поверхностью на фоне).
        border: isDark
            ? null
            : Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1B364A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            height: 96,
            child: Image.asset(
              adviceIconAsset(
                tip.code,
                dark: theme.brightness == Brightness.dark,
              ),
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  adviceKindTitle(l10n, kind).toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  adviceTitle(l10n, tip),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  adviceBody(l10n, tip),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.bolt,
                        size: 13, color: theme.colorScheme.primary),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(
                        adviceReason(l10n, units, tip),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline,
            size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
