import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/l10n/locale_provider.dart';
import '../../../l10n/app_localizations.dart';

Future<String?> showLanguageSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    useRootNavigator: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _LanguageSheet(),
  );
}

class _LanguageSheet extends ConsumerWidget {
  const _LanguageSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final currentCode = Localizations.localeOf(context).languageCode;

    final entries = <(String, String, String)>[
      ('en', l10n.languageEn, 'gb'),
      ('ru', l10n.languageRu, 'ru'),
      ('de', l10n.languageDe, 'de'),
      ('es', l10n.languageEs, 'es'),
      ('fr', l10n.languageFr, 'fr'),
      ('pl', l10n.languagePl, 'pl'),
    ];

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
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 4),
              child: Text(
                l10n.languageSheetTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: Text(
                l10n.languageSheetSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            for (final entry in entries)
              _LanguageRow(
                code: entry.$1,
                label: entry.$2,
                flagCode: entry.$3,
                isSelected: entry.$1 == currentCode,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(Locale(entry.$1));
                  Navigator.of(context).pop(entry.$1);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.code,
    required this.label,
    required this.flagCode,
    required this.isSelected,
    required this.onTap,
  });

  final String code;
  final String label;
  final String flagCode;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = isSelected ? cs.primary : cs.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            SvgPicture.asset('assets/flags/$flagCode.svg', width: 28, height: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: fg,
                ),
              ),
            ),
            Icon(
              Icons.check,
              size: 20,
              color: isSelected ? cs.primary : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
