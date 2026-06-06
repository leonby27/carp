import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/persistence/prefs_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../onboarding/data/answers_store.dart';
import '../../onboarding/data/onboarding_completed.dart';
import '../data/mock_packages.dart';
import '../data/premium_status.dart';
import 'promo_code_sheet.dart';
import 'winback_sheet.dart';

// ── Цвета (точечные для пейволла, по Figma-переменным) ─────────
const _ink = Color(0xFF0A1B39); // Text/Primary
const _muted = Color(0xFF676E85); // Text/Secondary Dark
const _faint = Color(0xFF83899F); // Text/Secondary
const _cardBg = Color(0xFFF5F6F8); // Base/Surface
const _line = Color(0xFFEDEEF3); // Line/100
const _accent = AppColors.onboardingCtaGreen; // оливковый акцент #3C6B33
const _dayPillBg = Color(0xFFF0F3E6); // фон пилюль таймлайна
const _proColBg = Color(0xFFE8EFE7); // фон колонки Pro

// ── Геометрия ─────────────────────────────────────────────────
const _headerHeight = 56.0;
const _pillSize = Size(44, 44);
const _pillRadius = 22.0;
const _cardRadius = 24.0;
// Высота как у кнопок онбординга (welcome / quiz CTA = 56).
const _ctaHeight = 56.0;
// Скругление как у кнопок онбординга (welcome / quiz CTA = 20).
const _ctaRadius = 20.0;
const _heroHeight = 219.0;

const _imgBase = 'assets/images/paywall/pro/';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key, this.embedded = false});

  /// Открыт из работающего приложения (free-версия), а не из онбординга. В этом
  /// режиме крестик/назад просто закрывают экран (pop) и возвращают на тот же
  /// экран — без win-back модалки и без перехода на welcome.
  final bool embedded;

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
        .animate(
          CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic),
        );
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.mockPurchase(pkg.title(l10n)))));
    if (mounted) _leaveAfterUnlock();
  }

  /// Куда уходим после успешной покупки/промокода. Встроенный пейволл просто
  /// закрываем (возврат на тот же free-экран, который теперь разблокируется
  /// реактивно). Из онбординга — на главную.
  void _leaveAfterUnlock() {
    if (widget.embedded) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  /// Крестик. Встроенный (in-app) пейволл просто закрываем — возвращаемся на тот
  /// же free-экран без win-back модалки (она часть онбординга).
  ///
  /// В онбординге по крестику показываем win-back модалку с подарком 1 дня Pro
  /// (Figma «Large card»). В интерфейс уходим ТОЛЬКО по кнопкам модалки:
  ///   • «Забрать 1 день» → `true`  — Pro на 1 день уже активирован в модалке;
  ///   • «Продолжить без Pro» → `false` — уходим во free.
  /// Закрытие по бэкдропу/свайпу → `null` — просто закрываем модалку и
  /// остаёмся на пейволле (в интерфейс не переходим).
  Future<void> _skipToFree() async {
    if (widget.embedded) {
      context.pop();
      return;
    }
    final result = await showWinbackSheet(context);
    if (!mounted || result == null) return;
    ref.read(onboardingCompletedProvider.notifier).markCompleted();
    context.go('/');
  }

  void _restore() {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.mockRestore)));
  }

  Future<void> _enterPromoCode() async {
    final ok = await showPromoCodeSheet(context);
    if (ok == true && mounted) {
      ref.read(onboardingCompletedProvider.notifier).markCompleted();
      _leaveAfterUnlock();
    }
  }

  /// Стрелка «назад». Встроенный пейволл просто закрываем (возврат на тот же
  /// free-экран). В онбординге — возвращаемся на самый первый экран воронки;
  /// ответы квиза не сбрасываем, пользователь просто идёт назад.
  void _back() {
    if (widget.embedded) {
      context.pop();
      return;
    }
    context.go('/welcome');
  }

  void _restart() {
    ref.read(answersProvider.notifier).reset();
    ref.read(onboardingCompletedProvider.notifier).reset();
    // Сбрасываем одноразовый gate, чтобы win-back модалка снова показалась
    // при следующем прохождении (важно для тестов прогона онбординга).
    sharedPrefs.remove(PrefsKeys.winbackOfferShown);
    context.go('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pkg = _selectedPkg;
    // Онбординг: системный «назад» блокируем — выход только через явный выбор
    // (крестик → win-back). Встроенный пейволл закрывается свайпом/назад как
    // обычный экран.
    return PopScope(
      canPop: widget.embedded,
      child: Scaffold(
        backgroundColor: AppColors.lightBack3,
        body: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: Column(
              children: [
                _PaywallHeader(
                  // Встроенный пейволл: без стрелки «назад» (она ведёт в
                  // онбординг) — закрытие только крестиком.
                  showBack: !widget.embedded,
                  onBack: _back,
                  onClose: _skipToFree,
                  onRestore: _restore,
                  onPromoCode: _enterPromoCode,
                  onRestart: _restart,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                          child: Text(
                            l10n.paywallTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 26 / 20,
                              color: _ink,
                            ),
                          ),
                        ),
                        const _HeroImage(),
                        // Контент наезжает на низ картинки (с растворением hero
                        // в белом) — карточки и плашка цен слегка перекрывают
                        // нижнюю часть иллюстрации.
                        Transform.translate(
                          offset: const Offset(0, -72),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _PlanPicker(
                                  selectedId: _selectedId,
                                  onSelect: _selectPlan,
                                ),
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
                                    padding: const EdgeInsets.only(top: 20),
                                    child: _TrialTimeline(pkg: pkg),
                                  ),
                                  secondChild: const SizedBox(
                                    width: double.infinity,
                                    height: 0,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const _UnlockCard(),
                                const SizedBox(height: 16),
                                const _FaqCard(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _BottomBar(
                  pkg: pkg,
                  isPurchasing: _isPurchasing,
                  onPurchase: _purchase,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Hero image ───────────────────────────────────────────────

/// Full-bleed иллюстрация спота. Верх и низ растворяются в белом фоне через
/// градиентные оверлеи (37px), чтобы картинка бесшовно вписывалась в экран.
class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    const fade = 37.0;
    const bg = AppColors.lightBack3;
    return SizedBox(
      height: _heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('${_imgBase}hero.jpg', fit: BoxFit.cover),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: fade,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [bg, Color(0x00FFFFFF)],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: fade,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [bg, Color(0x00FFFFFF)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────

class _PaywallHeader extends StatelessWidget {
  const _PaywallHeader({
    required this.showBack,
    required this.onBack,
    required this.onClose,
    required this.onRestore,
    required this.onPromoCode,
    required this.onRestart,
  });

  /// Показывать ли стрелку «назад» (онбординг — да, встроенный пейволл — нет).
  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback onClose;
  final VoidCallback onRestore;
  final VoidCallback onPromoCode;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return Container(
      padding: EdgeInsets.only(top: topInset),
      color: AppColors.lightBack3,
      child: SizedBox(
        height: _headerHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (showBack)
                _IconPill(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: onBack,
                ),
              const Spacer(),
              _MenuKebab(
                onRestore: onRestore,
                onPromoCode: onPromoCode,
                onRestart: onRestart,
              ),
              const SizedBox(width: 8),
              _IconPill(icon: Icons.close_rounded, onTap: onClose),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconPill extends StatelessWidget {
  const _IconPill({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _cardBg,
      borderRadius: BorderRadius.circular(_pillRadius),
      child: InkWell(
        borderRadius: BorderRadius.circular(_pillRadius),
        onTap: onTap,
        child: SizedBox(
          width: _pillSize.width,
          height: _pillSize.height,
          child: Icon(icon, size: 18, color: _ink),
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
      color: _cardBg,
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
          child: const Icon(Icons.more_vert, size: 20, color: _ink),
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
    final l10n = AppLocalizations.of(context);
    // Слева — короткий план (неделя), справа — годовой (дефолт, с подарком).
    final left = kMockPackages.firstWhere((p) => p.id != 'yearly');
    final yearly = kMockPackages.firstWhere((p) => p.id == 'yearly');
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
                    pkg: left,
                    selected: left.id == selectedId,
                    onTap: () => onSelect(left.id),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PlanCard(
                    pkg: yearly,
                    selected: yearly.id == selectedId,
                    saveLabel: l10n.paywallSaveBadge,
                    onTap: () => onSelect(yearly.id),
                  ),
                ),
              ],
            ),
          ),
          if (yearly.hasTrial && yearly.trialDays != null)
            Positioned(
              // Плашка «наезжает» на верхнюю границу карточки: половина над ней,
              // половина внутри (≈ половина высоты бейджа = 24/2).
              top: -12,
              left: 0,
              right: 0,
              // Зеркалим раскладку карточек (Expanded · 8 · Expanded), чтобы
              // бейдж центрировался ровно над годовой карточкой в любой локали —
              // вне зависимости от ширины текста.
              child: Row(
                children: [
                  const Expanded(child: SizedBox()),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: _TrialBadge(days: yearly.trialDays!),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.pkg,
    required this.selected,
    required this.onTap,
    this.saveLabel,
  });

  final MockPackage pkg;
  final bool selected;
  final VoidCallback onTap;
  final String? saveLabel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        // 2pt border ест внутрь — компенсируем уменьшая padding.
        padding: EdgeInsets.all(selected ? 18 : 19),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_cardRadius),
          border: Border.all(
            color: selected ? _accent : _line,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
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
                  if (saveLabel != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      saveLabel!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 16 / 12,
                        color: _accent,
                      ),
                    ),
                  ],
                  // Прижимаем ценник к низу, чтобы в обеих карточках он стоял
                  // на одной линии (минимум 8pt над ним сохраняем).
                  const SizedBox(height: 8),
                  const Spacer(),
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
            // Чекбокс держим у верхней кромки независимо от высоты карточки.
            Align(
              alignment: Alignment.topCenter,
              child: _PlanCheckbox(selected: selected),
            ),
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
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? _accent : Colors.transparent,
        border: Border.all(color: selected ? _accent : _faint, width: 2),
      ),
      child: selected
          ? const Icon(Icons.check, color: Colors.white, size: 16)
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _accent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        l10n.trialBadgeFreeDays(days),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 16 / 12,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ─── Trial timeline ───────────────────────────────────────────

/// Таймлайн пробного периода: что и когда случится. Зелёные пилюли «День N»
/// в белой карточке (border + Base Drop shadow), последняя строка — старт
/// оплаты с ценой.
class _TrialTimeline extends StatelessWidget {
  const _TrialTimeline({required this.pkg});

  final MockPackage pkg;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final days = pkg.trialDays ?? 3;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: _line),
        boxShadow: AppColors.baseDrop,
      ),
      child: Column(
        children: [
          _TimelineRow(
            dayLabel: l10n.trialDayLabel(1),
            text: l10n.trialDay1Desc,
          ),
          const SizedBox(height: 12),
          _TimelineRow(
            dayLabel: l10n.trialDayLabel(days),
            text: l10n.trialDayMidDesc,
          ),
          const SizedBox(height: 12),
          _TimelineRow(
            dayLabel: l10n.trialDayLabel(days + 1),
            // Цена — реальная стоимость выбранного плана (как в плашке),
            // не зачёркнутый anchor. Неразрывные пробелы держат «· цену»
            // одной строкой.
            text:
                '${l10n.trialDayEndDesc} · ${pkg.priceShort.replaceAll(' ', ' ')}',
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.dayLabel, required this.text});

  final String dayLabel;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          decoration: BoxDecoration(
            color: _dayPillBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            dayLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 20 / 16,
              color: _accent,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 20 / 15,
              color: _ink,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Unlock card (Free / Pro comparison) ──────────────────────

class _UnlockFeature {
  const _UnlockFeature(this.image, this.label, this.free);
  final String image;
  final String label;
  final String free; // значение в колонке Free
}

class _UnlockCard extends StatelessWidget {
  const _UnlockCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final features = <_UnlockFeature>[
      _UnlockFeature('${_imgBase}f_forecast.jpg', l10n.tblForecast, '—'),
      _UnlockFeature('${_imgBase}f_tactics.jpg', l10n.tblTactics, '—'),
      _UnlockFeature('${_imgBase}f_spot.jpg', l10n.tblSpot, '—'),
      _UnlockFeature(
        '${_imgBase}f_alerts.jpg',
        l10n.tblAlerts,
        l10n.tblLimited,
      ),
      _UnlockFeature(
        '${_imgBase}f_playbook.jpg',
        l10n.tblPlaybook,
        l10n.tblLimited,
      ),
      _UnlockFeature('${_imgBase}f_journal.jpg', l10n.tblJournal, '1'),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: _line),
        boxShadow: AppColors.baseDrop,
      ),
      child: Column(
        children: [
          Image.asset('${_imgBase}lock.jpg', width: 84, height: 84),
          const SizedBox(height: 4),
          Text(
            l10n.unlockTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 24 / 18,
              color: _ink,
            ),
          ),
          const SizedBox(height: 20),
          _ComparisonTable(
            features: features,
            freeLabel: l10n.tblFree,
            proLabel: l10n.tblPro,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.unlockBody,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, height: 18 / 12, color: _ink),
          ),
        ],
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({
    required this.features,
    required this.freeLabel,
    required this.proLabel,
  });

  final List<_UnlockFeature> features;
  final String freeLabel;
  final String proLabel;

  static const _headerH = 40.0;
  static const _rowH = 52.0;
  static const _colW = 58.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Колонка с фичами (иконка + подпись).
        Expanded(
          child: Column(
            children: [
              const SizedBox(height: _headerH),
              for (var i = 0; i < features.length; i++)
                Container(
                  height: _rowH,
                  decoration: BoxDecoration(
                    border: i == features.length - 1
                        ? null
                        : const Border(bottom: BorderSide(color: _line)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          features[i].image,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          features[i].label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 17 / 13,
                            color: _ink,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
            ],
          ),
        ),
        // Колонка Free.
        SizedBox(
          width: _colW,
          child: Column(
            children: [
              SizedBox(
                height: _headerH,
                child: Center(
                  child: Text(
                    freeLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _muted,
                    ),
                  ),
                ),
              ),
              for (var i = 0; i < features.length; i++)
                Container(
                  height: _rowH,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: i == features.length - 1
                        ? null
                        : const Border(bottom: BorderSide(color: _line)),
                  ),
                  child: Text(
                    features[i].free,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _muted,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Колонка Pro — подсвеченный зелёный столбец.
        Container(
          width: _colW,
          decoration: BoxDecoration(
            color: _proColBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _accent),
          ),
          child: Column(
            children: [
              SizedBox(
                height: _headerH,
                child: Center(
                  child: Text(
                    proLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _accent,
                    ),
                  ),
                ),
              ),
              for (var i = 0; i < features.length; i++)
                SizedBox(
                  height: _rowH,
                  child: Center(
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accent,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: _line),
        boxShadow: AppColors.baseDrop,
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
              onTap: () =>
                  setState(() => _expanded = _expanded == i ? null : i),
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
  });

  final MockPackage pkg;
  final bool isPurchasing;
  final VoidCallback onPurchase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ctaLabel = pkg.hasTrial
        ? l10n.paywallCtaStartFree
        : l10n.paywallCtaSubscribe;
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
                      const Icon(Icons.check_rounded, size: 22, color: _accent),
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
                const SizedBox(height: 12),
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
              ? AppColors.onboardingCtaGreen
              : AppColors.onboardingCtaGreen.withAlpha(120),
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
