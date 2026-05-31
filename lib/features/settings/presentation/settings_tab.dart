import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/brand.dart';
import '../../../core/config/env.dart';
import '../../../core/icons/solar_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_mode_provider.dart';
import '../../../core/units/units.dart';
import '../../../l10n/app_localizations.dart';
import '../../alerts/application/alerts_providers.dart';
import '../../alerts/domain/planned_alert.dart';
import '../../forecast/domain/fish.dart';
import '../../forecast/presentation/forecast_story_screen.dart';
import '../../onboarding/data/answers_store.dart';
import '../../onboarding/data/onboarding_completed.dart';
import '../../onboarding/presentation/language_sheet.dart';
import '../../paywall/data/premium_status.dart';
import 'bite_alerts_sheet.dart';
import 'theme_sheet.dart';
import 'units_sheet.dart';

// ─── Confirm dialog ──────────────────────────────────────────

Future<void> _confirmRestart(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final theme = Theme.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.restartConfirmTitle),
      content: Text(l10n.restartConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.commonConfirm),
        ),
      ],
    ),
  );
  if (confirmed == true && context.mounted) {
    ref.read(answersProvider.notifier).reset();
    ref.read(onboardingCompletedProvider.notifier).reset();
    ref.read(premiumStatusProvider.notifier).deactivate();
    context.go('/welcome');
  }
}

// ─── Screen ──────────────────────────────────────────────────

class SettingsTab extends ConsumerWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final premium = ref.watch(premiumStatusProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabSettings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _SectionTitle(text: l10n.settingsSubscriptionTitle),
          const SizedBox(height: 8),
          _SubscriptionCard(premium: premium),

          const SizedBox(height: 24),
          _SectionTitle(text: l10n.settingsAppearanceTitle),
          const SizedBox(height: 8),
          Container(
            decoration: _cardDecoration(context),
            child: Column(
              children: [
                const _ThemeRow(),
                _Divider(),
                const _LanguageRow(),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _SectionTitle(text: l10n.settingsUnitsTitle),
          const SizedBox(height: 8),
          const _UnitsCard(),

          const SizedBox(height: 24),
          _SectionTitle(text: l10n.settingsNotificationsTitle),
          const SizedBox(height: 8),
          const _NotificationsCard(),

          const SizedBox(height: 24),
          _SectionTitle(text: l10n.settingsAboutTitle),
          const SizedBox(height: 8),
          const _AboutCard(),

          const SizedBox(height: 24),
          _SectionTitle(text: l10n.settingsMoreTitle),
          const SizedBox(height: 8),
          const _MoreCard(),

          const SizedBox(height: 32),
          const _VersionFooter(),
        ],
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  return BoxDecoration(
    color: isDark ? AppColors.darkSurface : Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: isDark ? null : AppColors.baseDrop,
    // В тёмной теме карточки-группы выделяются цветом поверхности на глубоком
    // фоне — обводка не нужна. В светлой оставляем (иначе сольётся с белым).
    border: isDark
        ? null
        : Border.all(color: AppColors.lineLight100),
  );
}

/// iOS Settings-style icon square: solid colour + лёгкий вертикальный градиент,
/// иконка Solar bold (solid) белая по центру.
class _AppleIconSquare extends StatelessWidget {
  const _AppleIconSquare({required this.iconName, required this.color});

  final String iconName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    final darker =
        hsl.withLightness((hsl.lightness - 0.08).clamp(0.0, 1.0));
    final top = darker
        .withLightness((darker.lightness + 0.06).clamp(0.0, 1.0))
        .toColor();
    final bottom = darker.toColor();
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      alignment: Alignment.center,
      child: SolarIcon(iconName, size: 16, color: Colors.white, bold: true),
    );
  }
}

/// Тот же icon-square, но на Material-иконке — для случаев, где нет
/// подходящего Solar-ассета (температура / ветер / давление).
class _MaterialIconSquare extends StatelessWidget {
  const _MaterialIconSquare({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(color);
    final darker = hsl.withLightness((hsl.lightness - 0.08).clamp(0.0, 1.0));
    final top = darker
        .withLightness((darker.lightness + 0.06).clamp(0.0, 1.0))
        .toColor();
    final bottom = darker.toColor();
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }
}

/// Apple iOS system colors — палитра для icon squares.
class _IconColors {
  _IconColors._();
  static const purple = Color(0xFFAF52DE);
  static const orange = Color(0xFFFF9500);
  static const yellow = Color(0xFFFFCC00);
  static const green = Color(0xFF34C759);
  static const blue = Color(0xFF007AFF);
  static const gray = Color(0xFF8E8E93);
  static const red = Color(0xFFFF3B30);
  static const teal = Color(0xFF30B0C7);
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

// ─── Subscription ────────────────────────────────────────────

class _SubscriptionCard extends ConsumerWidget {
  const _SubscriptionCard({required this.premium});
  final PremiumStatus premium;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final active = premium.isActive;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                active ? Icons.workspace_premium : Icons.auto_awesome,
                size: 36,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      active ? l10n.settingsSubActive : l10n.settingsSubInactive,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      active && premium.expiresAt != null
                          ? l10n.settingsSubExpiresLeft(
                              _formatRemaining(l10n, premium.expiresAt!),
                            )
                          : l10n.settingsSubInactiveSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!active)
            FilledButton(
              onPressed: () => context.go('/paywall'),
              child: Text(l10n.settingsSubBtnGoPaywall),
            )
          else
            OutlinedButton(
              onPressed: _openManageSubscriptions,
              child: Text(l10n.settingsSubBtnManage),
            ),
        ],
      ),
    );
  }

  Future<void> _openManageSubscriptions() async {
    final uri = Platform.isIOS
        ? Uri.parse('https://apps.apple.com/account/subscriptions')
        : Uri.parse(
            'https://play.google.com/store/account/subscriptions?package=com.baseapp.app',
          );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _formatRemaining(AppLocalizations l10n, DateTime expiresAt) {
    final d = expiresAt.difference(DateTime.now());
    if (d.inDays >= 1) return l10n.remainingDays(d.inDays);
    if (d.inHours >= 1) return l10n.remainingHours(d.inHours);
    return l10n.remainingMinutes(d.inMinutes);
  }
}

// ─── Appearance rows ─────────────────────────────────────────

class _ThemeRow extends ConsumerWidget {
  const _ThemeRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = ref.watch(themeModeProvider);
    final label = switch (current) {
      ThemeMode.system => l10n.themeSystem,
      ThemeMode.light => l10n.themeLight,
      ThemeMode.dark => l10n.themeDark,
    };
    return _ActionTile(
      leading: const _AppleIconSquare(iconName: 'palette', color: _IconColors.purple),
      label: l10n.settingsThemeTitle,
      trailing: _TrailingLabel(text: label),
      onTap: () => showThemeSheet(context),
    );
  }
}

// ─── Language ────────────────────────────────────────────────

class _LanguageRow extends ConsumerWidget {
  const _LanguageRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final code = Localizations.localeOf(context).languageCode;
    final label = switch (code) {
      'ru' => l10n.languageRu,
      'de' => l10n.languageDe,
      'es' => l10n.languageEs,
      'fr' => l10n.languageFr,
      _ => l10n.languageEn,
    };
    return _ActionTile(
      leading: const _AppleIconSquare(iconName: 'global', color: _IconColors.orange),
      label: l10n.settingsLanguage,
      trailing: _TrailingLabel(text: label),
      onTap: () => showLanguageSheet(context),
    );
  }
}

// ─── Units (temperature / wind / pressure) ───────────────────

class _UnitsCard extends ConsumerWidget {
  const _UnitsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final units = ref.watch(unitsProvider);
    final notifier = ref.read(unitsProvider.notifier);
    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          _ActionTile(
            leading: const _MaterialIconSquare(
              icon: Icons.thermostat,
              color: _IconColors.red,
            ),
            label: l10n.unitTemperature,
            trailing: _TrailingLabel(text: tempUnitLabel(units.temp)),
            onTap: () => showOptionSheet(
              context: context,
              title: l10n.unitTemperature,
              labels: [
                for (final u in TempUnit.values) tempUnitLabel(u),
              ],
              selectedIndex: units.temp.index,
              onSelect: (i) => notifier.setTemp(TempUnit.values[i]),
            ),
          ),
          _Divider(),
          _ActionTile(
            leading: const _MaterialIconSquare(
              icon: Icons.air,
              color: _IconColors.teal,
            ),
            label: l10n.unitWind,
            trailing: _TrailingLabel(text: windUnitLabel(l10n, units.wind)),
            onTap: () => showOptionSheet(
              context: context,
              title: l10n.unitWind,
              labels: [
                for (final u in WindUnit.values) windUnitLabel(l10n, u),
              ],
              selectedIndex: units.wind.index,
              onSelect: (i) => notifier.setWind(WindUnit.values[i]),
            ),
          ),
          _Divider(),
          _ActionTile(
            leading: const _MaterialIconSquare(
              icon: Icons.speed,
              color: _IconColors.blue,
            ),
            label: l10n.unitPressure,
            trailing:
                _TrailingLabel(text: pressureUnitLabel(l10n, units.pressure)),
            onTap: () => showOptionSheet(
              context: context,
              title: l10n.unitPressure,
              labels: [
                for (final u in PressureUnit.values)
                  pressureUnitLabel(l10n, u),
              ],
              selectedIndex: units.pressure.index,
              onSelect: (i) => notifier.setPressure(PressureUnit.values[i]),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Notifications (bite alerts) ─────────────────────────────

/// Секция уведомлений: два пункта-дрилл-ина (по карпу / по карасю). Внутри
/// каждого — тумблеры «Лучший день недели» и «Все отличные дни». Мастера нет.
class _NotificationsCard extends StatelessWidget {
  const _NotificationsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          _FishNotifRow(
            fish: Fish.carp,
            color: _IconColors.orange,
            label: l10n.settingsAlertsForCarp,
          ),
          _Divider(),
          _FishNotifRow(
            fish: Fish.crucian,
            color: _IconColors.teal,
            label: l10n.settingsAlertsForCrucian,
          ),
        ],
      ),
    );
  }
}

/// Строка-дрилл-ин по одному виду рыбы: открывает шит с двумя тумблерами,
/// показывает точку-индикатор, если хоть один из них включён.
class _FishNotifRow extends ConsumerWidget {
  const _FishNotifRow({
    required this.fish,
    required this.color,
    required this.label,
  });

  final Fish fish;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(biteAlertsProvider);
    final anyOn = enabled.contains((BiteAlertKind.primeWeek, fish)) ||
        enabled.contains((BiteAlertKind.excellentDays, fish));
    return _ActionTile(
      leading: _MaterialIconSquare(icon: Icons.phishing, color: color),
      label: label,
      trailing: _NotifStatusTrailing(active: anyOn),
      onTap: () =>
          showBiteAlertsSheet(context: context, fish: fish, title: label),
    );
  }
}

class _NotifStatusTrailing extends StatelessWidget {
  const _NotifStatusTrailing({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (active) ...[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
        ],
        Icon(Icons.chevron_right, size: 18, color: cs.onSurfaceVariant),
      ],
    );
  }
}

// ─── About (rate + share) ────────────────────────────────────

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          _ActionTile(
            leading: const _AppleIconSquare(
              iconName: 'document-text',
              color: _IconColors.teal,
            ),
            label: l10n.storyTitle,
            trailing: const _TrailingIcon(icon: Icons.chevron_right),
            onTap: () => showForecastStory(context),
          ),
          _Divider(),
          _ActionTile(
            leading: const _AppleIconSquare(
              iconName: 'star',
              color: _IconColors.yellow,
            ),
            label: l10n.settingsRateApp,
            trailing: _TrailingIcon(icon: _externalIcon()),
            onTap: _rate,
          ),
          _Divider(),
          _ActionTile(
            leading: const _AppleIconSquare(
              iconName: 'upload',
              color: _IconColors.green,
            ),
            label: l10n.settingsShareApp,
            trailing: _TrailingIcon(icon: _shareIcon()),
            onTap: () => _share(context),
          ),
        ],
      ),
    );
  }

  IconData _externalIcon() =>
      Platform.isIOS ? Icons.arrow_outward : Icons.open_in_new;

  IconData _shareIcon() =>
      Platform.isIOS ? Icons.ios_share : Icons.share_outlined;

  Future<void> _rate() async {
    final inApp = InAppReview.instance;
    if (await inApp.isAvailable()) {
      await inApp.requestReview();
    } else {
      await inApp.openStoreListing();
    }
  }

  Future<void> _share(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final box = context.findRenderObject() as RenderBox?;
    final params = ShareParams(
      text: l10n.shareMessage(Env.appName, Env.appShareLink),
      sharePositionOrigin:
          box != null ? box.localToGlobal(Offset.zero) & box.size : null,
    );
    await SharePlus.instance.share(params);
  }
}

// ─── More (legal + reset) ────────────────────────────────────

class _MoreCard extends ConsumerWidget {
  const _MoreCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: _cardDecoration(context),
      child: Column(
        children: [
          _ActionTile(
            leading: const _AppleIconSquare(
              iconName: 'document-text',
              color: _IconColors.blue,
            ),
            label: l10n.menuTerms,
            trailing: _TrailingIcon(icon: _externalIcon()),
            onTap: () => _open(Brand.termsUrl),
          ),
          _Divider(),
          _ActionTile(
            leading: const _AppleIconSquare(
              iconName: 'shield',
              color: _IconColors.gray,
            ),
            label: l10n.menuPrivacy,
            trailing: _TrailingIcon(icon: _externalIcon()),
            onTap: () => _open(Brand.privacyUrl),
          ),
          _Divider(),
          _ActionTile(
            leading: const _AppleIconSquare(
              iconName: 'restart',
              color: _IconColors.gray,
            ),
            label: l10n.settingsRestartOnboarding,
            trailing: const SizedBox.shrink(),
            onTap: () => _confirmRestart(context, ref),
          ),
        ],
      ),
    );
  }

  IconData _externalIcon() =>
      Platform.isIOS ? Icons.arrow_outward : Icons.open_in_new;

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ─── Action Tile + trailing helpers ──────────────────────────

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.leading,
    required this.label,
    required this.trailing,
    required this.onTap,
  });

  final Widget leading;
  final String label;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 15),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _TrailingIcon extends StatelessWidget {
  const _TrailingIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 16,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }
}

class _TrailingLabel extends StatelessWidget {
  const _TrailingLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontSize: 13,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 4),
        Icon(
          Icons.chevron_right,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }
}

// ─── Version footer ──────────────────────────────────────────

class _VersionFooter extends StatelessWidget {
  const _VersionFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final info = snapshot.data!;
        // Прячем build-number в production-форматировании ("BaseApp · 1.0.0").
        return Center(
          child: Text(
            '${Env.appName} · ${info.version}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        );
      },
    );
  }
}
