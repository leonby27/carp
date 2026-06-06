import 'package:flutter/material.dart';

import '../../core/icons/solar_icon.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';

/// Заглушка вместо премиум-контента для free-версии (Figma «Pro», node
/// 9777:8711). Карточка цвета поверхности (адаптируется под тему): в одну строку
/// заголовок «Доступно в Pro версии» слева и outline-кнопка «Продолжить» справа,
/// ведущая на пейволл. Реальные данные под ней НЕ считаются — гейт стоит на
/// уровне данных, это лишь визуальный слот.
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

  static const _outlineBorder = Color(0xFFD6E4FF); // Buttons/Outline/Border
  static const _gold = Color(0xFFF5B400); // золотисто-жёлтый акцент короны

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // В тёмной теме карточка выделяется цветом поверхности — обводку и тень
    // убираем (как у соседних карточек прогноза). В светлой — белая карточка
    // на светлом фоне без обводки/тени слилась бы, поэтому их оставляем.
    final buttonBorder = isDark ? theme.colorScheme.outlineVariant : _outlineBorder;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? null : Border.all(color: AppColors.lineLight100),
        boxShadow: isDark ? null : AppColors.baseDrop,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _gold.withAlpha(38), // ≈15% прозрачности
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const SolarIcon('crown', size: 20, color: _gold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title ?? l10n.gateProTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 22 / 16,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onContinue,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: buttonBorder),
              ),
              alignment: Alignment.center,
              child: Text(
                l10n.commonContinue,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 22 / 16,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
