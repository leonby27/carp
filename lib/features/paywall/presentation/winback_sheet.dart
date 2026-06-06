import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../data/premium_status.dart';

// Дизайн Figma «Large card» (node 9707:9440): корона+рыба, заголовок 24/Bold,
// тело 16/Regular, две кнопки h60 r20 (primary + outline).
const _brandGreen = AppColors.onboardingCtaGreen; // #3C6B33 ≈ Figma #3c6b32
const _ink = Color(0xFF0A1B39); // Text or Icons/Primary
const _outlineBorder = Color(0xFFD6E4FF); // Buttons/Outline/Border
const _crownImg = 'assets/images/paywall/pro/crown.png';

/// Win-back модалка после тапа «закрыть пейволл». Дарит 1 день полного Pro,
/// чтобы пользователь увидел ценность до решения об оплате.
///
/// Возвращает `true`, если подарок забрали (Pro уже активирован), `false`/`null`
/// если пользователь решил продолжить без Pro.
Future<bool?> showWinbackSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.lightOnBack,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _WinbackSheet(),
  );
}

class _WinbackSheet extends ConsumerWidget {
  const _WinbackSheet();

  void _claim(BuildContext context, WidgetRef ref) {
    ref.read(premiumStatusProvider.notifier).activateFor(const Duration(days: 1));
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Корона+рыба (свечение запечено в png) — 96×96, по центру.
            Center(
              child: Image.asset(_crownImg, width: 96, height: 96),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.winbackTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: _ink,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.winbackBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 20 / 16,
                color: _ink,
              ),
            ),
            const SizedBox(height: 24),
            _SheetButton(
              label: l10n.winbackCtaClaim,
              onTap: () => _claim(context, ref),
              filled: true,
            ),
            const SizedBox(height: 8),
            _SheetButton(
              label: l10n.winbackCtaSkip,
              onTap: () => Navigator.of(context).pop(false),
              filled: false,
            ),
          ],
        ),
      ),
    );
  }
}

/// Кнопка модалки: filled — primary (зелёный фон, белый текст), иначе outline
/// (белый фон, бордер, зелёный текст). Высота 56, скругление 20 — как у кнопок
/// онбординга (welcome / quiz CTA).
class _SheetButton extends StatelessWidget {
  const _SheetButton({
    required this.label,
    required this.onTap,
    required this.filled,
  });

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: filled ? _brandGreen : AppColors.lightOnBack,
          borderRadius: BorderRadius.circular(20),
          border: filled ? null : Border.all(color: _outlineBorder),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 22 / 16,
            color: filled ? Colors.white : _brandGreen,
          ),
        ),
      ),
    );
  }
}
