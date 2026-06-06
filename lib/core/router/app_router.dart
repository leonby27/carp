import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/app_shell/presentation/app_shell.dart';
import '../../features/forecast/presentation/forecast_tab.dart';
import '../../features/notes/presentation/notes_tab.dart';
import '../../features/onboarding/data/onboarding_completed.dart';
import '../../features/onboarding/presentation/onboarding_flow.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/paywall/presentation/paywall_screen.dart';
import '../../features/settings/presentation/settings_tab.dart';
import '../../features/tips/presentation/tips_tab.dart';
import '../theme/app_theme.dart';

final _rootNavKey = GlobalKey<NavigatorState>();

CustomTransitionPage<T> _fadePage<T>(GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    child: child,
    transitionsBuilder: (context, animation, secondary, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

/// Marketing-screens (welcome, onboarding, paywall) — всегда в light theme,
/// независимо от системной/пользовательской настройки. Это conversion-паттерн
/// топовых subscription-приложений (Calm, Headspace, Duolingo Super и т.д.):
/// paywall оптимизирован под одну цветовую схему, dark-вариант — отдельный
/// A/B-тест, который имеет смысл вводить только когда есть данные.
Widget _lockLight(Widget child) {
  return Theme(data: AppTheme.light, child: child);
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: '/welcome',
    redirect: (context, state) {
      final completed = ref.read(onboardingCompletedProvider);
      // Если онбординг уже пройден — не пускаем на welcome.
      if (completed && state.matchedLocation == '/welcome') return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) =>
            _fadePage(state, _lockLight(const WelcomeScreen())),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) =>
            _fadePage(state, _lockLight(const OnboardingFlow())),
      ),
      GoRoute(
        path: '/paywall',
        pageBuilder: (context, state) {
          // `?from=app` — пейволл открыт из работающего приложения (free-версия:
          // Тактика, заглушка Pro, апгрейд в настройках). В этом режиме крестик
          // просто закрывает экран и возвращает на тот же экран, без win-back
          // модалки и без перехода в онбординг. Без флага — финальный шаг
          // онбординга (win-back + возврат на welcome).
          final embedded = state.uri.queryParameters['from'] == 'app';
          return _fadePage(state, _lockLight(PaywallScreen(embedded: embedded)));
        },
      ),
      StatefulShellRoute(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        // Переключение табов — fade-through (Material 3): уходящий экран гаснет,
        // входящий проявляется с лёгким масштабированием. indexedStack делает
        // это мгновенно, поэтому анимируем сами на уровне контейнера веток.
        // Состояние каждой ветки go_router сохраняет за нас.
        navigatorContainerBuilder: (context, navigationShell, children) =>
            _FadeThroughBranchContainer(
              currentIndex: navigationShell.currentIndex,
              children: children,
            ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ForecastTab()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tips',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TipsTab()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/notes',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: NotesTab()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: SettingsTab()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Контейнер веток нижнего меню с переходом fade-through (Material 3).
///
/// Все навигаторы веток живут в [Stack] одновременно (go_router сохраняет их
/// состояние), но видна только активная. При смене таба запускается
/// staggered-анимация: уходящая ветка резко гаснет в первой трети, входящая
/// проявляется следом с лёгким подъёмом масштаба 0.99→1. В коротком зазоре
/// просвечивает фон Scaffold — это и есть «through» в fade-through.
class _FadeThroughBranchContainer extends StatefulWidget {
  const _FadeThroughBranchContainer({
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<_FadeThroughBranchContainer> createState() =>
      _FadeThroughBranchContainerState();
}

class _FadeThroughBranchContainerState
    extends State<_FadeThroughBranchContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _current;
  int? _previous;

  @override
  void initState() {
    super.initState();
    _current = widget.currentIndex;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      value: 1,
    );
  }

  @override
  void didUpdateWidget(_FadeThroughBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != _current) {
      _previous = _current;
      _current = widget.currentIndex;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final animating = _controller.isAnimating;
        // Уходящий: резко гаснет в первые 22% перехода.
        final outOpacity =
            1 - Curves.easeOutCubic.transform((t / 0.22).clamp(0, 1));
        // Входящий: проявляется в последние 82% с минимальным зазором.
        final inT = ((t - 0.18) / 0.82).clamp(0.0, 1.0);
        final inOpacity = Curves.easeOutCubic.transform(inT);
        final inScale = 0.99 + 0.01 * Curves.easeOutCubic.transform(inT);

        return Stack(
          children: [
            for (var i = 0; i < widget.children.length; i++)
              _branch(i, animating, outOpacity, inOpacity, inScale),
          ],
        );
      },
    );
  }

  Widget _branch(
    int i,
    bool animating,
    double outOpacity,
    double inOpacity,
    double inScale,
  ) {
    final isCurrent = i == _current;
    final isPrevious = i == _previous && animating;

    double opacity;
    double scale = 1;
    if (isCurrent) {
      opacity = animating ? inOpacity : 1;
      scale = animating ? inScale : 1;
    } else if (isPrevious) {
      opacity = outOpacity;
    } else {
      opacity = 0;
    }

    // Неактивные ветки держим в дереве (сохранение состояния), но отключаем
    // ввод и тикеры, чтобы анимации/жесты шли только в активной.
    return IgnorePointer(
      ignoring: !isCurrent,
      child: TickerMode(
        enabled: isCurrent,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.scale(scale: scale, child: widget.children[i]),
        ),
      ),
    );
  }
}
