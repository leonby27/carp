import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

/// Открыть лонгрид «Анатомия клёва» — история о том, как рождается балл клёва.
void showForecastStory(BuildContext context) {
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(builder: (_) => const ForecastStoryScreen()),
  );
}

/// Вертикальный лонгрид: главы (заголовок + текст + опциональная иллюстрация).
/// Картинка рисуется, только если у главы задан ассет — поэтому новые hero-арты
/// можно подставлять по мере готовности, не ломая экран (как со спотами).
class ForecastStoryScreen extends StatelessWidget {
  const ForecastStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;

    String spot(String dir) => dark
        ? 'assets/images/spots/dark/spot_lake_$dir.webp'
        : 'assets/images/spots/spot_lake_$dir.webp';
    String advice(String name) => dark
        ? 'assets/images/advice/dark/$name.webp'
        : 'assets/images/advice/$name.webp';
    String story(String name) => dark
        ? 'assets/images/story/dark/story_$name.webp'
        : 'assets/images/story/story_$name.webp';

    // (заголовок, текст, ассет или null). null — hero ещё не нарисован.
    final chapters = <(String, String, String?)>[
      (l10n.storyHookTitle, l10n.storyHookBody, story('hook')),
      // «Давление + температура воды» и «ветер + время суток» объединены —
      // главы стали плотнее.
      (l10n.storyPressureTitle, l10n.storyPressureBody, story('pressure')),
      (l10n.storyWindTitle, l10n.storyWindBody, story('wind')),
      // Переиспользуем уже нарисованное:
      (l10n.storyTypeTitle, l10n.storyTypeBody, spot('none')),
      (l10n.storyFishTitle, l10n.storyFishBody, 'assets/images/carp_fish.webp'),
      (l10n.storyTacticsTitle, l10n.storyTacticsBody, advice('bait_warm_fishmeal')),
      (l10n.storyHonestTitle, l10n.storyHonestBody, story('honest')),
    ];

    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w800,
    );
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      color: cs.onSurface.withValues(alpha: 0.9),
      height: 1.4,
    );

    Widget textColumn(String title, String body) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: titleStyle),
            const SizedBox(height: 6),
            Text(body, style: bodyStyle),
          ],
        );

    final blocks = <Widget>[
      const SizedBox(height: 8),
    ];

    for (var i = 0; i < chapters.length; i++) {
      final c = chapters[i];
      final image = c.$3;
      if (image == null) {
        blocks.add(textColumn(c.$1, c.$2));
      } else {
        final pic = ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(image, width: 118, height: 118, fit: BoxFit.contain),
        );
        // Картинка всегда слева, текст справа.
        blocks.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pic,
            const SizedBox(width: 14),
            Expanded(child: textColumn(c.$1, c.$2)),
          ],
        ));
      }
      blocks.add(const SizedBox(height: 26));
    }

    final bg = dark ? AppColors.darkSurface : Colors.white;
    return Scaffold(
      // Светлая — белый; тёмная — цвет плашек (191E24), не глубокий base/back.
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        // Отделяем шапку от контента тонкой линией снизу.
        shape: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        title: Text(l10n.storyTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: blocks,
      ),
    );
  }
}
