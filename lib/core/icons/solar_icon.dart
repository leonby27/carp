import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Solar Icons (Bold Duotone) — приоритетный icon-pack проекта.
/// Источник: https://solar-icons.com — пакеты под CC BY-SA 4.0.
/// SVG-ассеты лежат в `assets/icons/solar/<name>.svg`.
///
/// Тинт работает через `ColorFilter.mode(color, BlendMode.srcIn)` —
/// duotone-структура (path с opacity 0.5) при этом сохраняется,
/// потому что прозрачность остаётся, а цвет заменяется на заданный.
class SolarIcon extends StatelessWidget {
  const SolarIcon(
    this.name, {
    super.key,
    this.size = 24,
    this.color,
    this.bold = false,
  });

  /// Имя файла без префикса и расширения. Пример: `infinity`, `palette`.
  final String name;
  final double size;
  final Color? color;

  /// `true` → bold (solid) вариант из `assets/icons/solar/bold/`.
  /// По умолчанию — duotone (полупрозрачный второй path) из `assets/icons/solar/`.
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final tint = color ??
        IconTheme.of(context).color ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFF0A1B39);
    final folder = bold ? 'bold/' : '';
    return SvgPicture.asset(
      'assets/icons/solar/$folder$name.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
    );
  }
}
