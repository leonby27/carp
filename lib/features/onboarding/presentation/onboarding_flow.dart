import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../forecast/application/forecast_providers.dart';
import '../../forecast/domain/fish.dart';
import '../data/answers_store.dart';
import '../data/quiz_config.dart';
import 'analyzing_view.dart';
import 'quiz_step_view.dart';

const _kHeaderHeight = 64.0;
const _kHeaderRadius = 24.0;
const _kPillSize = Size(46, 36);
const _kPillRadius = 122.0;
const _kForwardDuration = Duration(milliseconds: 300);
const _kReverseDuration = Duration(milliseconds: 250);

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

enum _Phase { quiz, processing }

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  int _index = 0;
  bool _isForward = true;
  _Phase _phase = _Phase.quiz;

  void _next() {
    if (_index < kQuizSteps.length - 1) {
      setState(() {
        _isForward = true;
        _index++;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    _applySpecies();
    setState(() => _phase = _Phase.processing);
  }

  /// Прокидываем ответ про вид рыбы в дефолт прогноза. «Обе» → карп (основной).
  void _applySpecies() {
    final answer = ref.read(answersProvider)[kSpeciesAnswerKey];
    final fish = answer == kSpeciesCrucian ? Fish.crucian : Fish.carp;
    ref.read(selectedFishProvider.notifier).select(fish);
  }

  void _back() {
    if (_index == 0) {
      context.go('/welcome');
      return;
    }
    setState(() {
      _isForward = false;
      _index--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkBack3 : AppColors.lightBack3;

    switch (_phase) {
      case _Phase.processing:
        return Scaffold(
          backgroundColor: bg,
          body: AnalyzingView(
            onDone: () => context.go('/paywall'),
          ),
        );
      case _Phase.quiz:
        return _buildQuiz(context, isDark, bg);
    }
  }

  Widget _buildQuiz(BuildContext context, bool isDark, Color bg) {
    final progress = (_index + 1) / kQuizSteps.length;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          _ProgressHeader(
            progress: progress,
            showBack: true,
            onBack: _back,
            isDark: isDark,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: _isForward ? _kForwardDuration : _kReverseDuration,
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[...previousChildren, ?currentChild],
              ),
              transitionBuilder: (child, animation) {
                final isIncoming =
                    (child.key as ValueKey<int>?)?.value == _index;
                final slideBegin = _isForward
                    ? (isIncoming ? 0.25 : -0.15)
                    : (isIncoming ? -0.25 : 0.15);
                final fadeAnim = isIncoming
                    ? CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                      )
                    : animation;
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(slideBegin, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: fadeAnim, child: child),
                );
              },
              child: QuizStepView(
                key: ValueKey(_index),
                step: kQuizSteps[_index],
                onContinue: _next,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.progress,
    required this.showBack,
    required this.onBack,
    required this.isDark,
  });

  final double progress;
  final bool showBack;
  final VoidCallback onBack;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final bgColor = isDark ? AppColors.darkSurface : AppColors.lightOnBack;

    return Container(
      padding: EdgeInsets.only(top: topInset),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(_kHeaderRadius),
          bottomRight: Radius.circular(_kHeaderRadius),
        ),
        boxShadow: isDark ? null : AppColors.baseDrop,
        border: Border.all(
          color: isDark ? AppColors.lineDT100 : AppColors.lineLight100,
        ),
      ),
      child: SizedBox(
        height: _kHeaderHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _BackPill(visible: showBack, onTap: onBack, isDark: isDark),
              const SizedBox(width: 12),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: _kForwardDuration,
                  curve: Curves.easeInOut,
                  builder: (_, v, _) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: v,
                      minHeight: 12,
                      backgroundColor: isDark
                          ? AppColors.darkDividerLight
                          : AppColors.lightDividerLight,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(width: _kPillSize.width, height: _kPillSize.height),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackPill extends StatelessWidget {
  const _BackPill({required this.visible, required this.onTap, required this.isDark});

  final bool visible;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return SizedBox(width: _kPillSize.width, height: _kPillSize.height);
    }
    final pillBg = isDark
        ? AppColors.darkSurface2
        : AppColors.onboardingClickableBg;
    return Material(
      color: pillBg,
      borderRadius: BorderRadius.circular(_kPillRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_kPillRadius),
        child: SizedBox(
          width: _kPillSize.width,
          height: _kPillSize.height,
          child: Icon(
            Icons.arrow_back,
            size: 20,
            color: isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface,
          ),
        ),
      ),
    );
  }
}
