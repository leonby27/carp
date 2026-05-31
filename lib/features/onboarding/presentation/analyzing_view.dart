import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// «Обработка» перед результатом онбординга (labor-illusion): короткая пауза
/// с прогресс-баром, чтобы персональный прогноз ощущался как посчитанный под
/// пользователя. По завершении дёргает [onDone].
class AnalyzingView extends StatefulWidget {
  const AnalyzingView({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<AnalyzingView> createState() => _AnalyzingViewState();
}

class _AnalyzingViewState extends State<AnalyzingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) widget.onDone();
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    const ringSize = 96.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Center(
              child: SizedBox(
                width: ringSize,
                height: ringSize,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) => Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: Curves.easeInOut.transform(_controller.value),
                          strokeWidth: 6,
                          backgroundColor: cs.primary.withAlpha(38),
                          valueColor: AlwaysStoppedAnimation(cs.primary),
                        ),
                      ),
                      Text(
                        '${(Curves.easeInOut.transform(_controller.value) * 100).round()}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: constraints.maxHeight / 2 + ringSize / 2 + 28,
                left: 32,
                right: 32,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.onbAnalyzingTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.onbAnalyzingSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
