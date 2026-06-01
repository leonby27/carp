import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/fishing_tip.dart';
import 'tips_format.dart';

/// Таб «Советы»: один практический совет за раз.
///
/// Стартуем с детерминированного «совета дня» ([tipOfDayIndex]), кнопка «Ещё
/// совет» прокручивает пул по кругу. Состояние — локальный сдвиг от совета дня.
class TipsTab extends StatefulWidget {
  const TipsTab({super.key});

  @override
  State<TipsTab> createState() => _TipsTabState();
}

class _TipsTabState extends State<TipsTab> {
  int _offset = 0;

  void _next() {
    HapticFeedback.selectionClick();
    setState(() => _offset++);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final base = tipOfDayIndex(DateTime.now());
    final tip = kFishingTips[(base + _offset) % kFishingTips.length];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabTips), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, anim) => FadeTransition(
                    opacity: anim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.03),
                        end: Offset.zero,
                      ).animate(anim),
                      child: child,
                    ),
                  ),
                  child: SingleChildScrollView(
                    key: ValueKey(tip),
                    physics: const BouncingScrollPhysics(),
                    child: _TipCard(tip: tip),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: _next,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.tipsNext),
                  style: FilledButton.styleFrom(
                    foregroundColor: cs.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
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

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final FishingTip tip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: isDark ? null : Border.all(color: cs.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F1B364A),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FractionallySizedBox(
            widthFactor: 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  tipAsset(tip, dark: isDark),
                  fit: BoxFit.cover,
                  errorBuilder: (context, _, _) => ColoredBox(
                    color: cs.primary.withValues(alpha: 0.06),
                    child: Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: cs.primary.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            tipTitle(l10n, tip),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tipBody(l10n, tip),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: cs.onSurface.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tipProof(l10n, tip),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: cs.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
