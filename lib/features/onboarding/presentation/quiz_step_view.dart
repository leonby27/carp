import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../data/answers_store.dart';
import '../data/quiz_config.dart';

const _kCardRadius = 20.0;
const _kCardHeight = 64.0;
const _kCardGap = 10.0;
const _kImageRadius = 24.0;
const _kCtaRadius = 20.0;
const _kScaleDuration = Duration(milliseconds: 200);
const _kContainerDuration = Duration(milliseconds: 180);
const _kCurve = Curves.easeOutCubic;

class QuizStepView extends ConsumerWidget {
  const QuizStepView({super.key, required this.step, required this.onContinue});

  final QuizStep step;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(answersProvider)[step.storeAs];
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: step.image != null ? 20 : 28),
                  if (step.image != null) ...[
                    FractionallySizedBox(
                      widthFactor: 0.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_kImageRadius),
                        child: Image.asset(
                          step.image!,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                  Text(
                    step.question(l10n),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.subtitle(l10n),
                    style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  for (final opt in step.options) ...[
                    _OptionCard(
                      option: opt,
                      selected: selected == opt.value,
                      onTap: () => ref
                          .read(answersProvider.notifier)
                          .set(step.storeAs, opt.value),
                    ),
                    const SizedBox(height: _kCardGap),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: _DarkCtaButton(
              label: l10n.commonContinue,
              onPressed: selected == null ? null : onContinue,
              isDark: isDark,
            ),
          ),
          SizedBox(height: 16 + MediaQuery.paddingOf(context).bottom),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.option, required this.selected, required this.onTap});

  final QuizOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkOnBack4 : AppColors.onboardingClickableBg;
    final selectedBg = isDark ? AppColors.darkSurface : Colors.white;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.0 : 0.97,
        duration: _kScaleDuration,
        curve: _kCurve,
        child: AnimatedContainer(
          duration: _kContainerDuration,
          curve: _kCurve,
          height: _kCardHeight,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          decoration: BoxDecoration(
            color: selected ? selectedBg : cardBg,
            borderRadius: BorderRadius.circular(_kCardRadius),
            border: Border.all(
              color: selected ? AppColors.onboardingCtaBg : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            option.label(AppLocalizations.of(context)),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _DarkCtaButton extends StatelessWidget {
  const _DarkCtaButton({required this.label, required this.onPressed, required this.isDark});

  final String label;
  final VoidCallback? onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    final bg = disabled
        ? (isDark ? AppColors.darkDisabledBg : AppColors.lightDisabledBg)
        : AppColors.onboardingCtaBg;
    final fg = disabled
        ? (isDark ? AppColors.darkDisabledContent : AppColors.lightDisabledContent)
        : Colors.white;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor: bg,
        disabledForegroundColor: fg,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_kCtaRadius)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    );
  }
}
