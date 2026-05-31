import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

/// Экран-результат онбординга (teaser перед пейволлом). Честно показывает:
/// клёв на СЕГОДНЯ доступен бесплатно, а прогноз на 7 дней вперёд — заблокирован
/// (превью, не реальные данные). CTA ведёт на пейволл.
class ResultView extends StatelessWidget {
  const ResultView({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        child: Column(
          children: [
            const Spacer(),
            Icon(Icons.insights_rounded, size: 56, color: cs.primary),
            const SizedBox(height: 20),
            Text(
              l10n.onbResultTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.onbResultSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.4,
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            _ForecastTeaser(
              todayBadge: l10n.onbResultTodayBadge,
              lockedLabel: l10n.onbResultLockedLabel,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: _CtaButton(label: l10n.onbResultCta, onPressed: onContinue),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastTeaser extends StatelessWidget {
  const _ForecastTeaser({required this.todayBadge, required this.lockedLabel});

  final String todayBadge;
  final String lockedLabel;

  // Декоративные высоты столбцов (иллюстрация, не реальные данные).
  static const _lockedHeights = [0.55, 0.8, 0.45, 0.95, 0.6, 0.75];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lineLight100),
        boxShadow: AppColors.baseDrop,
      ),
      child: SizedBox(
        height: 156,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Сегодня — открыто.
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _Badge(text: todayBadge, color: cs.primary),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _Bar(heightFactor: 0.85, color: cs.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 7 дней вперёд — заблокировано (превью).
            Expanded(
              flex: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final h in _lockedHeights) ...[
                        Expanded(
                          child: _Bar(
                            heightFactor: h,
                            color: cs.onSurfaceVariant.withAlpha(46),
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ],
                  ),
                  _LockChip(label: lockedLabel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.heightFactor, required this.color});

  final double heightFactor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: heightFactor.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _LockChip extends StatelessWidget {
  const _LockChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(122),
        border: Border.all(color: AppColors.lineLight100),
        boxShadow: AppColors.baseDrop,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline_rounded, size: 16, color: cs.onSurface),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ],
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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.onboardingCtaBg,
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
