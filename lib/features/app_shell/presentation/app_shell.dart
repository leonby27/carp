import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../alerts/presentation/bite_alerts_scheduler.dart';
import '../../forecast/application/forecast_providers.dart';

const _navBarHeight = 64.0;

/// Прогноз считаем устаревшим к моменту возврата в приложение, если ему больше
/// ~20 минут или он за прошлый календарный день — тогда тихо перезапрашиваем
/// (свежий вытеснит кэш; офлайн вернёт тот же кэш с пометкой).
bool _forecastStale(DateTime? fetchedAt, DateTime now) {
  if (fetchedAt == null) return true;
  if (now.difference(fetchedAt) >= const Duration(minutes: 20)) return true;
  return now.year != fetchedAt.year ||
      now.month != fetchedAt.month ||
      now.day != fetchedAt.day;
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Возврат с фона: если прогноз протух — перезапрашиваем погоду. Гейт по
    // возрасту бережёт трафик при коротких сворачиваниях.
    if (state != AppLifecycleState.resumed) return;
    final fetchedAt = ref.read(forecastProvider).value?.fetchedAt;
    if (_forecastStale(fetchedAt, DateTime.now())) {
      ref.invalidate(weatherSeriesProvider);
    }
  }

  void _onTap(int index) {
    HapticFeedback.selectionClick();
    widget.navigationShell.goBranch(
      index,
      // Повторный тап по активному табу — возврат к корню ветки.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BiteAlertsScheduler(child: widget.navigationShell),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onTap: _onTap,
      ),
    );
  }
}

/// Описание одного таба: outline-иконка (неактивная), filled (активная), лейбл.
class _NavItemData {
  const _NavItemData(this.icon, this.selectedIcon, this.label);
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Кастомный нижний бар с анимацией иконок. Геометрия как у Material
/// [NavigationBar] (высота 64, лейблы всегда видны, прозрачный фон-индикатор —
/// iOS-минимализм), но при переключении таба иконка проигрывает «pop» (пружину
/// с овершутом) и кросс-фейдит outline↔filled с лерпом цвета.
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.selectedIndex, required this.onTap});

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final navBg = isDark ? AppColors.darkSurface : Colors.white;
    final navBorder = isDark ? AppColors.lineDT100 : AppColors.lineLight200;

    final items = <_NavItemData>[
      _NavItemData(Icons.phishing_outlined, Icons.phishing, l10n.tabForecast),
      _NavItemData(Icons.note_alt_outlined, Icons.note_alt, l10n.tabNotes),
      _NavItemData(Icons.settings_outlined, Icons.settings, l10n.tabSettings),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(height: 1, color: navBorder),
        Material(
          color: navBg,
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: _navBarHeight,
              child: Row(
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: _NavItem(
                        data: items[i],
                        selected: i == selectedIndex,
                        onTap: () => onTap(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _NavItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with TickerProviderStateMixin {
  // Прогресс выбранности: 0 — неактивна, 1 — активна. Плавно ведёт кросс-фейд
  // иконок и цвет; реверсится при уходе с таба.
  late final AnimationController _select = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 240),
    value: widget.selected ? 1 : 0,
  );
  // Одноразовый «pop» — пружинистый bump масштаба при переключении на таб.
  late final AnimationController _pop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (widget.selected && !old.selected) {
      _select.forward();
      _pop.forward(from: 0); // pop только в момент выбора
    } else if (!widget.selected && old.selected) {
      _select.reverse();
    }
  }

  @override
  void dispose() {
    _select.dispose();
    _pop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.data.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_select, _pop]),
          builder: (context, _) {
            final t = _select.value;
            // Один гладкий «горб» 0→1→0: масштаб вырастает и возвращается к 1.
            final pop = math.sin(math.pi * _pop.value);
            final scale = 1 + 0.18 * pop;
            final lift = -2.0 * pop;
            final color = Color.lerp(cs.onSurfaceVariant, cs.primary, t)!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: Offset(0, lift),
                  child: Transform.scale(
                    scale: scale,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outline гаснет по мере выбора…
                        Opacity(
                          opacity: 1 - t,
                          child: Icon(
                            widget.data.icon,
                            color: cs.onSurfaceVariant,
                            size: 26,
                          ),
                        ),
                        // …filled проявляется.
                        Opacity(
                          opacity: t,
                          child: Icon(
                            widget.data.selectedIcon,
                            color: cs.primary,
                            size: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.data.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: t > 0.5 ? FontWeight.w600 : FontWeight.w500,
                    color: color,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
