import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../onboarding/data/answers_store.dart';
import '../../onboarding/data/onboarding_completed.dart';
import '../data/mock_packages.dart';
import '../data/premium_status.dart';
import 'promo_code_sheet.dart';

// ── Цвета (точечные для пейволла) ──────────────────────────────
const _brandBlue = Color(0xFF094ABE);
const _cardBg = Color(0xFFF5F6F8);
const _pillBg = Color(0xFFF5F6F8);
const _ink = Color(0xFF0A1B39);
const _muted = Color(0xFF676E85);
const _faint = Color(0xFF83899F);

// ── Геометрия ─────────────────────────────────────────────────
const _headerHeight = 56.0;
const _headerRadius = 24.0;
const _pillSize = Size(46, 36);
const _pillRadius = 122.0;
const _cardRadius = 24.0;
const _ctaHeight = 60.0;
const _ctaRadius = 20.0;

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enterController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  String _selectedId = kDefaultPackageId;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _enterController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutCubic,
    ));
    _enterController.forward();
  }

  @override
  void dispose() {
    _enterController.dispose();
    super.dispose();
  }

  MockPackage get _selectedPkg =>
      kMockPackages.firstWhere((p) => p.id == _selectedId);

  void _selectPlan(String id) {
    if (id == _selectedId) return;
    setState(() => _selectedId = id);
  }

  Future<void> _purchase() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isPurchasing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isPurchasing = false);
    final pkg = _selectedPkg;
    final mockPeriod = pkg.id == 'yearly'
        ? const Duration(days: 365)
        : const Duration(days: 7);
    ref.read(premiumStatusProvider.notifier).activateFor(mockPeriod);
    ref.read(onboardingCompletedProvider.notifier).markCompleted();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.mockPurchase(pkg.title(l10n)))),
    );
    if (mounted) context.go('/');
  }

  /// Гибрид-модель: впускаем в free без оплаты. Контекстный пейволл встретит
  /// пользователя позже — при попытке спланировать (будущий день / Тактика).
  void _skipToFree() {
    ref.read(onboardingCompletedProvider.notifier).markCompleted();
    context.go('/');
  }

  void _restore() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.mockRestore)),
    );
  }

  Future<void> _enterPromoCode() async {
    final ok = await showPromoCodeSheet(context);
    if (ok == true && mounted) {
      ref.read(onboardingCompletedProvider.notifier).markCompleted();
      context.go('/');
    }
  }

  void _restart() {
    ref.read(answersProvider.notifier).reset();
    ref.read(onboardingCompletedProvider.notifier).reset();
    context.go('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    final pkg = _selectedPkg;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.lightBack3,
        body: Stack(
          children: [
            FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  children: [
                    _PaywallHeader(
                      onRestore: _restore,
                      onPromoCode: _enterPromoCode,
                      onRestart: _restart,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              AppLocalizations.of(context).paywallTitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: _ink,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 24),
                            _PlanPicker(
                              selectedId: _selectedId,
                              onSelect: _selectPlan,
                            ),
                            const SizedBox(height: 16),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 260),
                              sizeCurve: Curves.easeOutCubic,
                              firstCurve: Curves.easeOutCubic,
                              secondCurve: Curves.easeOutCubic,
                              alignment: Alignment.topCenter,
                              crossFadeState: pkg.hasTrial
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _TrialCountdown(pkg: pkg),
                              ),
                              secondChild: const SizedBox(
                                width: double.infinity,
                                height: 0,
                              ),
                            ),
                            const _FeaturesCard(),
                            const SizedBox(height: 16),
                            const _FaqCard(),
                          ],
                        ),
                      ),
                    ),
                    _BottomBar(
                      pkg: pkg,
                      isPurchasing: _isPurchasing,
                      onPurchase: _purchase,
                      onSkip: _skipToFree,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────

class _PaywallHeader extends StatelessWidget {
  const _PaywallHeader({
    required this.onRestore,
    required this.onPromoCode,
    required this.onRestart,
  });

  final VoidCallback onRestore;
  final VoidCallback onPromoCode;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return Container(
      padding: EdgeInsets.only(top: topInset),
      decoration: BoxDecoration(
        color: AppColors.lightOnBack,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(_headerRadius),
          bottomRight: Radius.circular(_headerRadius),
        ),
        boxShadow: AppColors.baseDrop,
        border: Border.all(color: AppColors.lineLight100),
      ),
      child: SizedBox(
        height: _headerHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(width: _pillSize.width, height: _pillSize.height),
              const Spacer(),
              _MenuKebab(
                onRestore: onRestore,
                onPromoCode: onPromoCode,
                onRestart: onRestart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuKebab extends StatelessWidget {
  const _MenuKebab({
    required this.onRestore,
    required this.onPromoCode,
    required this.onRestart,
  });

  final VoidCallback onRestore;
  final VoidCallback onPromoCode;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _pillBg,
      borderRadius: BorderRadius.circular(_pillRadius),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'restore':
              onRestore();
              break;
            case 'terms':
              debugPrint('open terms');
              break;
            case 'privacy':
              debugPrint('open privacy');
              break;
            case 'promo':
              onPromoCode();
              break;
            case 'restart':
              onRestart();
              break;
          }
        },
        position: PopupMenuPosition.under,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        itemBuilder: (context) {
          final l10n = AppLocalizations.of(context);
          return [
            PopupMenuItem(value: 'restore', child: Text(l10n.menuRestore)),
            PopupMenuItem(value: 'terms', child: Text(l10n.menuTerms)),
            PopupMenuItem(value: 'privacy', child: Text(l10n.menuPrivacy)),
            const PopupMenuDivider(),
            PopupMenuItem(value: 'promo', child: Text(l10n.menuPromo)),
            PopupMenuItem(value: 'restart', child: Text(l10n.menuRestart)),
          ];
        },
        child: SizedBox(
          width: _pillSize.width,
          height: _pillSize.height,
          child: const Icon(Icons.more_horiz, size: 20, color: _ink),
        ),
      ),
    );
  }
}

// ─── Plan picker ──────────────────────────────────────────────

class _PlanPicker extends StatelessWidget {
  const _PlanPicker({required this.selectedId, required this.onSelect});

  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    // Top inset 13 — резервирует место для floating badge -13 над yearly.
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _PlanCard(
                    pkg: kMockPackages[0],
                    selected: kMockPackages[0].id == selectedId,
                    onTap: () => onSelect(kMockPackages[0].id),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PlanCard(
                    pkg: kMockPackages[1],
                    selected: kMockPackages[1].id == selectedId,
                    onTap: () => onSelect(kMockPackages[1].id),
                  ),
                ),
              ],
            ),
          ),
          // Badge — над тем планом, у которого есть trial.
          for (var i = 0; i < kMockPackages.length; i++)
            if (kMockPackages[i].hasTrial && kMockPackages[i].trialDays != null)
              Positioned(
                top: -13,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment(i == 0 ? -0.5 : 0.5, 0),
                  child: _TrialBadge(days: kMockPackages[i].trialDays!),
                ),
              ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.pkg, required this.selected, required this.onTap});

  final MockPackage pkg;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        // 2pt border ест внутрь — компенсируем уменьшая padding.
        padding: EdgeInsets.all(selected ? 14 : 16),
        decoration: BoxDecoration(
          color: selected ? Colors.white : _cardBg,
          borderRadius: BorderRadius.circular(_cardRadius),
          border: selected ? Border.all(color: _brandBlue, width: 2) : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pkg.title(AppLocalizations.of(context)),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 20 / 16,
                      color: _ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pkg.priceShort,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 20 / 16,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _PlanCheckbox(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _PlanCheckbox extends StatelessWidget {
  const _PlanCheckbox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? _brandBlue : Colors.transparent,
        border: Border.all(
          color: selected ? _brandBlue : _faint,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, color: Colors.white, size: 14)
          : null,
    );
  }
}

class _TrialBadge extends StatelessWidget {
  const _TrialBadge({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _brandBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        l10n.trialBadgeFreeDays(days),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          height: 14 / 11,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ─── Trial countdown ──────────────────────────────────────────

class _TrialCountdown extends StatelessWidget {
  const _TrialCountdown({required this.pkg});

  final MockPackage pkg;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final days = pkg.trialDays ?? 3;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      child: Column(
        children: [
          _TrialRow(
            dayLabel: l10n.trialDayLabel(1),
            description: l10n.trialDay1Desc,
          ),
          const SizedBox(height: 12),
          _TrialRow(
            dayLabel: l10n.trialDayLabel(days - 1),
            description: l10n.trialDayMidDesc,
          ),
          const SizedBox(height: 12),
          _TrialRow(
            dayLabel: l10n.trialDayLabel(days + 1),
            description: l10n.trialDayEndDesc,
          ),
        ],
      ),
    );
  }
}

class _TrialRow extends StatelessWidget {
  const _TrialRow({
    required this.dayLabel,
    required this.description,
  });

  final String dayLabel;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            dayLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 18 / 14,
              color: _ink,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 18 / 14,
              color: _ink,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Features card ────────────────────────────────────────────

class _FeaturesCard extends StatelessWidget {
  const _FeaturesCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <(IconData, String)>[
      (Icons.all_inclusive, l10n.featureUnlimited),
      (Icons.update, l10n.featureUpdates),
      (Icons.lock_outline, l10n.featurePrivacy),
      (Icons.support_agent, l10n.featureSupport),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            Row(
              children: [
                Icon(items[i].$1, size: 22, color: _brandBlue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    items[i].$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 22 / 15,
                      color: _ink,
                    ),
                  ),
                ),
              ],
            ),
            if (i != items.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

// ─── FAQ ──────────────────────────────────────────────────────

class _FaqCard extends StatefulWidget {
  const _FaqCard();

  @override
  State<_FaqCard> createState() => _FaqCardState();
}

class _FaqCardState extends State<_FaqCard> {
  int? _expanded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <(String, String)>[
      (l10n.faqCancelQ, l10n.faqCancelA),
      (l10n.faqChargeQ, l10n.faqChargeA),
      (l10n.faqIncludesQ, l10n.faqIncludesA),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(_cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.faqTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 24 / 18,
              color: _ink,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < items.length; i++) ...[
            _FaqRow(
              question: items[i].$1,
              answer: items[i].$2,
              expanded: _expanded == i,
              onTap: () => setState(
                () => _expanded = _expanded == i ? null : i,
              ),
            ),
            if (i != items.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _FaqRow extends StatelessWidget {
  const _FaqRow({
    required this.question,
    required this.answer,
    required this.expanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 20 / 15,
                    color: _ink,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedRotation(
                turns: expanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                child: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: _ink,
                ),
              ),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 6, right: 28),
                    child: Text(
                      answer,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        color: _ink,
                      ),
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom bar ───────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.pkg,
    required this.isPurchasing,
    required this.onPurchase,
    required this.onSkip,
  });

  final MockPackage pkg;
  final bool isPurchasing;
  final VoidCallback onPurchase;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ctaLabel = pkg.hasTrial ? l10n.paywallCtaStartFree : l10n.paywallCtaSubscribe;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.lightOnBack,
        border: Border(top: BorderSide(color: AppColors.lineLight100)),
      ),
      child: SafeArea(
        top: false,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (pkg.hasTrial) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded, size: 22, color: _ink),
                      const SizedBox(width: 6),
                      Text(
                        l10n.paywallNoPaymentNow,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 22 / 16,
                          color: _ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                _PrimaryButton(
                  label: ctaLabel,
                  isLoading: isPurchasing,
                  onPressed: onPurchase,
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: isPurchasing ? null : onSkip,
                  child: Text(
                    l10n.paywallSkipToday,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 20 / 15,
                      color: _muted,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.paywallDisclaimer,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 18 / 14,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: _ctaHeight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isEnabled
              ? AppColors.onboardingCtaBg
              : AppColors.onboardingCtaBg.withAlpha(120),
          borderRadius: BorderRadius.circular(_ctaRadius),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 22 / 16,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
