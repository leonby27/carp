import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../data/premium_status.dart';

const _brandGreen = AppColors.onboardingCtaGreen;
const _ink = Color(0xFF0A1B39);
const _muted = Color(0xFF676E85);
const _cardBg = Color(0xFFF5F6F8);

/// Win-back модалка после тапа «пропустить пейволл». Дарит 1 день полного Pro,
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
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _brandGreen.withAlpha(28),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  size: 32,
                  color: _brandGreen,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.winbackTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 28 / 22,
                color: _ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.winbackBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 21 / 15,
                color: _muted,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _claim(context, ref),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: _brandGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.winbackCtaClaim,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                l10n.winbackCtaSkip,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 20 / 15,
                  color: _muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
