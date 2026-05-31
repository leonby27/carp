import 'package:flutter/material.dart';

/// Базовый layout для пустых / ошибочных состояний.
/// Стандартизирует визуал: иконка наверху, тайтл, подзаголовок, кнопка снизу.
class _StatePlaceholder extends StatelessWidget {
  const _StatePlaceholder({
    this.icon,
    this.illustration,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconColor,
  }) : assert(icon != null || illustration != null);

  final IconData? icon;

  /// Иллюстрация-заглушка вместо иконки (края уже зафичерены под фон).
  final String? illustration;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (illustration != null)
              Image.asset(illustration!, width: 200, height: 200, fit: BoxFit.contain)
            else
              Icon(icon!, size: 64, color: iconColor ?? theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Пустое состояние: нет данных, но без ошибки.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.illustration,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;

  /// Иллюстрация-заглушка вместо иконки.
  final String? illustration;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _StatePlaceholder(
      icon: illustration == null ? icon : null,
      illustration: illustration,
      title: title,
      subtitle: subtitle,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

/// Ошибка с возможностью retry.
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.title,
    this.subtitle,
    this.retryLabel,
    this.onRetry,
  });

  final String title;
  final String? subtitle;
  final String? retryLabel;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _StatePlaceholder(
      icon: Icons.error_outline,
      iconColor: theme.colorScheme.error,
      title: title,
      subtitle: subtitle,
      actionLabel: retryLabel,
      onAction: onRetry,
    );
  }
}

/// Лоадер для full-screen состояний.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            strokeWidth: 2.4,
            color: theme.colorScheme.primary,
          ),
          if (label != null) ...[
            const SizedBox(height: 16),
            Text(
              label!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Skeleton-плейсхолдер — серый бокс с shimmer-анимацией.
/// Используется для placeholder content при загрузке списков/карточек.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 8,
  });

  /// `null` ширина = max-available.
  final double? width;
  final double height;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.colorScheme.surfaceContainerHigh;
    final highlight = theme.colorScheme.surfaceContainerHighest;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: Color.lerp(base, highlight, _controller.value),
        ),
      ),
    );
  }
}
