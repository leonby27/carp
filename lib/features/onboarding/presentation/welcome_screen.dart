import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import 'language_sheet.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final localeCode = Localizations.localeOf(context).languageCode;

    return Scaffold(
      // scaffoldBackgroundColor темы — адаптивен (lightBack3 / darkBack3).
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              'assets/images/onboarding/start.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    l10n.welcomeTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 32 / 28,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.welcomeSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 22 / 16,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _LanguagePill(localeCode: localeCode),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: _CtaButton(
                      label: l10n.welcomeCta,
                      onPressed: () => context.go('/onboarding'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  const _LanguagePill({required this.localeCode});

  final String localeCode;

  String _flagAsset(String code) {
    final flag = code == 'en' ? 'gb' : code;
    return 'assets/flags/$flag.svg';
  }

  String _shortLabel(BuildContext context, String code) {
    final l10n = AppLocalizations.of(context);
    return switch (code) {
      'ru' => l10n.langShortRu,
      'de' => l10n.langShortDe,
      'es' => l10n.langShortEs,
      'fr' => l10n.langShortFr,
      _ => l10n.langShortEn,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(122),
        onTap: () => showLanguageSheet(context),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 6, 14, 6),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(122),
            border: Border.all(
              color: isDark ? AppColors.lineDT100 : AppColors.lineLight100,
            ),
            boxShadow: isDark ? null : AppColors.baseDrop,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(_flagAsset(localeCode), width: 24, height: 24),
              const SizedBox(width: 8),
              Text(
                _shortLabel(context, localeCode),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          // В dark theme тёмная CTA на тёмном фоне теряется — используем primary.
          color: isDark
              ? Theme.of(context).colorScheme.primary
              : AppColors.onboardingCtaBg,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
