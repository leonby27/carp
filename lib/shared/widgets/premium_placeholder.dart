import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// Заглушка вместо премиум-контента для free-версии (Figma «Pro», node
/// 9777:8711). Белая карточка с заголовком «Доступно в Pro версии» и
/// outline-кнопкой, ведущей на пейволл. Реальные данные под ней НЕ считаются —
/// гейт стоит на уровне данных, это лишь визуальный слот.
class PremiumPlaceholder extends StatelessWidget {
  const PremiumPlaceholder({
    super.key,
    required this.onContinue,
    this.title,
  });

  /// Колбэк кнопки «Продолжить» — обычно открыть пейволл.
  final VoidCallback onContinue;

  /// Заголовок; по умолчанию — локализованное «Доступно в Pro версии».
  final String? title;

  static const _ink = Color(0xFF0A1B39); // Text or Icons/Primary
  static const _outlineBorder = Color(0xFFD6E4FF); // Buttons/Outline/Border
  static const _green = AppColors.onboardingCtaGreen; // #3C6B33

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.lineLight100),
        boxShadow: AppColors.baseDrop,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? l10n.gateProTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 24 / 18,
              color: _ink,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onContinue,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _outlineBorder),
              ),
              alignment: Alignment.center,
              child: Text(
                l10n.commonContinue,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 22 / 16,
                  color: _green,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
