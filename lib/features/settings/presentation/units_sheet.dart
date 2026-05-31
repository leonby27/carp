import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Универсальный bottom-sheet выбора одного значения из списка.
/// Используется для единиц измерения (температура / ветер / давление).
Future<void> showOptionSheet({
  required BuildContext context,
  required String title,
  String? subtitle,
  required List<String> labels,
  required int selectedIndex,
  required ValueChanged<int> onSelect,
}) {
  return showModalBottomSheet<void>(
    context: context,
    // Покрывает bottom-nav: модал в root-навигаторе.
    useRootNavigator: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _OptionSheet(
      title: title,
      subtitle: subtitle,
      labels: labels,
      selectedIndex: selectedIndex,
      onSelect: onSelect,
    ),
  );
}

class _OptionSheet extends StatelessWidget {
  const _OptionSheet({
    required this.title,
    required this.subtitle,
    required this.labels,
    required this.selectedIndex,
    required this.onSelect,
  });

  final String title;
  final String? subtitle;
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
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
                  color: cs.outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, subtitle == null ? 16 : 4),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                child: Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                ),
              ),
            for (var i = 0; i < labels.length; i++)
              _OptionRow(
                label: labels[i],
                isSelected: i == selectedIndex,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSelect(i);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fg = isSelected ? cs.primary : cs.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: fg,
                ),
              ),
            ),
            Icon(
              Icons.check,
              size: 20,
              color: isSelected ? cs.primary : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
