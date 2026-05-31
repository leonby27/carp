import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../data/premium_status.dart';

const _brandBlue = Color(0xFF094ABE);
const _ink = Color(0xFF0A1B39);
const _muted = Color(0xFF676E85);
const _cardBg = Color(0xFFF5F6F8);

/// Открывает sheet ввода промо-кода. Возвращает `true` если код был валидным.
Future<bool?> showPromoCodeSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.lightOnBack,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _PromoCodeSheet(),
  );
}

class _PromoCodeSheet extends ConsumerStatefulWidget {
  const _PromoCodeSheet();

  @override
  ConsumerState<_PromoCodeSheet> createState() => _PromoCodeSheetState();
}

class _PromoCodeSheetState extends ConsumerState<_PromoCodeSheet> {
  final _controller = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context);
    final raw = _controller.text.trim();
    if (raw.isEmpty) return;
    setState(() {
      _busy = true;
      _error = null;
    });

    Duration? grant;
    switch (raw) {
      case '2170':
        grant = const Duration(days: 7);
        break;
      case '2171':
        grant = const Duration(days: 1);
        break;
    }

    if (grant == null) {
      setState(() {
        _busy = false;
        _error = l10n.promoErrorInvalid;
      });
      return;
    }

    ref.read(premiumStatusProvider.notifier).activateFor(grant);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.promoSuccess(grant.inDays))),
    );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
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
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                l10n.promoTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 24 / 18,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.promoSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  color: _muted,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _controller,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 4,
                  color: _ink,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _cardBg,
                  hintText: '— — — —',
                  hintStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                    color: _muted,
                  ),
                  errorText: _error,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: _brandBlue, width: 1.5),
                  ),
                ),
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _busy ? null : _submit,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 56,
                  decoration: BoxDecoration(
                    color: _busy
                        ? AppColors.onboardingCtaBg.withAlpha(120)
                        : AppColors.onboardingCtaBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: _busy
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          l10n.promoCtaActivate,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
