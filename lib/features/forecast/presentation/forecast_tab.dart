import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/units/units.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/states.dart';
import '../../advice/domain/advice.dart';
import '../../advice/domain/advice_engine.dart';
import '../../advice/presentation/advice_format.dart';
import '../../advice/presentation/advice_tab.dart';
import '../../location/application/location_providers.dart';
import '../../location/data/geolocation_service.dart';
import '../../location/domain/geo_point.dart';
import '../../location/presentation/location_picker_sheet.dart';
import '../../spots/application/spots_providers.dart';
import '../../spots/domain/spot_advice.dart';
import '../../spots/domain/spot_advisor.dart';
import '../../spots/presentation/map_picker_screen.dart';
import '../../spots/presentation/spot_format.dart';
import 'forecast_story_screen.dart';
import '../application/forecast_providers.dart';
import '../domain/bite_score.dart';
import '../domain/fish.dart';
import '../domain/forecast.dart';
import '../domain/spawn_advisor.dart';
import '../domain/weather_point.dart';
import 'forecast_format.dart';

/// Локализованное название вида рыбы для шапки и шита выбора.
String fishLabel(AppLocalizations l10n, Fish fish) => switch (fish) {
  Fish.carp => l10n.fishCarp,
  Fish.crucian => l10n.fishCrucian,
};

/// Прозрачная картинка рыбы для иллюстрации на главной (одинаковый масштаб для всех).
String fishAsset(Fish fish) => switch (fish) {
  Fish.carp => 'assets/images/carp_fish.webp',
  Fish.crucian => 'assets/images/crucian_fish.webp',
};

const _weekdayShort = {
  'ru': ['', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'],
  'en': ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
};
const _months = {
  'ru': [
    '',
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ],
  'en': [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ],
};

String _localeCode(BuildContext context) {
  final code = Localizations.localeOf(context).languageCode;
  return (code == 'ru') ? 'ru' : 'en';
}

String _dateLabel(BuildContext context, DateTime date) {
  final code = _localeCode(context);
  final m = _months[code]![date.month];
  return code == 'ru' ? '${date.day} $m' : '$m ${date.day}';
}

String _weekdayLabel(BuildContext context, DateTime date) =>
    _weekdayShort[_localeCode(context)]![date.weekday];

class ForecastTab extends ConsumerWidget {
  const ForecastTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final location = ref.watch(activeLocationProvider);
    final fish = ref.watch(selectedFishProvider);
    final forecastAsync = ref.watch(forecastProvider);
    final onFallback = location == kDefaultLocation;
    final title = onFallback
        ? l10n.locDefault
        : (location.isUnnamed ? l10n.locCurrent : location.name);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 16,
        title: Row(
          children: [
            // Локация — слева, тянется и сжимается с многоточием.
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _HeaderPill(
                  icon: Icons.location_on,
                  iconColor: theme.colorScheme.primary,
                  label: title,
                  onTap: () => showLocationSheet(context),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Рыба — справа. Без иконки: только подпись и ▾.
            _HeaderPill(
              label: fishLabel(l10n, fish),
              onTap: () => showFishSheet(context),
            ),
          ],
        ),
      ),
      body: forecastAsync.when(
        // Первая загрузка прогноза показывает тот же полноэкранный лоадер, что
        // и ручное обновление (спиннер + бегущие по шагам подписи) — единый
        // язык «считаем прогноз» вместо простого спиннера.
        loading: () => _RefreshLoading(steps: _forecastLoadingSteps(l10n)),
        error: (_, _) => ErrorState(
          title: l10n.fcError,
          subtitle: l10n.fcErrorSubtitle,
          retryLabel: l10n.fcRetry,
          onRetry: () => ref.invalidate(weatherSeriesProvider),
        ),
        data: (forecast) {
          final units = ref.watch(unitsProvider);
          final status = ref.watch(locationStatusProvider);
          final showFallback =
              onFallback &&
              (status == LocationStatus.denied ||
                  status == LocationStatus.serviceDisabled);
          final selectedIndex = ref
              .watch(selectedDayIndexProvider)
              .clamp(0, forecast.days.length - 1);
          // На время ручного обновления показываем полноэкранную загрузку
          // вместо контента; по завершении контент монтируется заново и числа
          // проигрывают count-up с нуля.
          if (ref.watch(forecastRefreshingProvider)) {
            return _RefreshLoading(steps: _forecastLoadingSteps(l10n));
          }
          final day = forecast.days[selectedIndex];
          final prev = selectedIndex > 0
              ? forecast.days[selectedIndex - 1]
              : null;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              if (showFallback) ...[
                const _FallbackBanner(),
                const SizedBox(height: 12),
              ],
              // 1. Ближайшие дни — выбор дня вверху; всё ниже про выбранный.
              // Блоки с count-up держим живыми (_KeepAlive), чтобы при скролле
              // вверх-вниз их состояние не пересоздавалось и цифры не
              // проигрывали анимацию заново. На обновление это не влияет:
              // там пересоздаётся весь ListView.
              _KeepAlive(
                child: _UpcomingDays(
                  forecast: forecast,
                  selectedIndex: selectedIndex,
                ),
              ),
              const SizedBox(height: 12),
              // 2. Вердикт: стоит ли ехать и когда — простыми словами.
              _KeepAlive(
                child: _HeroCard(
                  day: day,
                  dayIndex: selectedIndex,
                  units: units,
                  fish: fish,
                ),
              ),
              const SizedBox(height: 12),
              // 2b. Нерест — контекстный сигнал, если вода в нерестовом окне.
              if (day.spawn.isActive) ...[
                _SpawnBanner(spawn: day.spawn, units: units),
                const SizedBox(height: 12),
              ],
              // 3. Погода днём — ключевые условия сразу под оценкой (без заголовка).
              _KeepAlive(
                child: _Card(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: _ConditionsRow(
                    weather: day.representative,
                    units: units,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 4. Как ловить сегодня — саммари тактики (ядро ценности).
              _TacticsSummary(
                day: day,
                dayIndex: selectedIndex,
                prev: prev,
                fish: fish,
              ),
              const SizedBox(height: 20),
              // 4b. Твой спот — пространственный разбор по карте OSM + ветру.
              _SpotAdviceCard(day: day),
              const SizedBox(height: 20),
              // 5. Когда — таймлайн дня с окнами клёва и зорьками.
              _SectionTitle(l10n.fcWhenTitle),
              const SizedBox(height: 10),
              _DayPeriods(day: day),
              const SizedBox(height: 20),
              // 6. Почему — связное объяснение прогноза + уверенность.
              _WhySummary(score: day.bite),
              const SizedBox(height: 20),
              // 7. Обновление прогноза вручную.
              _RefreshButton(
                label: l10n.fcRefresh,
                onPressed: () => _refreshForecast(ref),
              ),
              const SizedBox(height: 12),
              _UpdatedAt(forecast: forecast),
            ],
          );
        },
      ),
    );
  }
}

/// Пилюля-дропдаун в шапке: [иконка] [подпись] [▾]. Используется для выбора
/// локации и выбора рыбы.
class _HeaderPill extends StatelessWidget {
  const _HeaderPill({
    this.icon,
    this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData? icon;
  final Color? iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: ShapeDecoration(
          color: cs.surface,
          shape: StadiumBorder(side: BorderSide(color: cs.outline)),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: iconColor),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Выбор вида рыбы: список со всеми видами, активный помечен галочкой. Тап
/// переключает профиль индекса и иллюстрации (через [selectedFishProvider]).
Future<void> showFishSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _FishSheet(),
  );
}

class _FishSheet extends ConsumerWidget {
  const _FishSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final selected = ref.watch(selectedFishProvider);
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: cs.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.fishSheetTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),
          for (final fish in Fish.values)
            ListTile(
              leading: SizedBox(
                width: 44,
                height: 44,
                child: Image.asset(fishAsset(fish), fit: BoxFit.contain),
              ),
              title: Text(
                fishLabel(l10n, fish),
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: fish == selected
                  ? Icon(Icons.check, color: cs.primary)
                  : null,
              onTap: () {
                ref.read(selectedFishProvider.notifier).select(fish);
                Navigator.of(context).pop();
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _FallbackBanner extends ConsumerWidget {
  const _FallbackBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final color = theme.colorScheme.error;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.location_off_outlined, size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.locFallbackBanner,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.3,
              ),
            ),
          ),
          TextButton(
            onPressed: () => showLocationSheet(context),
            child: Text(l10n.locFallbackAction),
          ),
        ],
      ),
    );
  }
}

/// Контекстный баннер нереста: фаза словами (расшифрована температурой воды) +
/// оговорка об уверенности. Индекс клёва не меняет — только объясняет, что вода
/// вошла в нерестовое окно вида. Показывается лишь при [SpawnAssessment.isActive].
class _SpawnBanner extends StatelessWidget {
  const _SpawnBanner({required this.spawn, required this.units});
  final SpawnAssessment spawn;
  final Units units;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final color = spawnPhaseColor(spawn.phase);
    final caveat = spawnCaveatText(l10n, spawn.confidence);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(spawnPhaseIcon(spawn.phase), size: 20, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.spawnTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  spawnPhraseText(l10n, spawn, units),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  spawnImpactText(l10n, spawn.phase),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface,
                    height: 1.35,
                  ),
                ),
                if (caveat != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    caveat,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Человекочитаемый возраст прогноза: «только что» / «N мин назад» / «N ч назад»
/// в пределах суток, дальше — дата.
String _ageLabel(
    BuildContext context, AppLocalizations l10n, DateTime at, Duration age) {
  if (age.inMinutes < 1) return l10n.fcUpdatedJustNow;
  if (age.inMinutes < 60) return l10n.fcUpdatedMinAgo(age.inMinutes);
  if (age.inHours < 24 && _sameDay(DateTime.now(), at)) {
    return l10n.fcUpdatedHoursAgo(age.inHours);
  }
  return l10n.fcUpdatedDate(_dateLabel(context, at));
}

/// Подпись о свежести прогноза. Тикает раз в минуту, чтобы относительный возраст
/// оставался честным без перерисовки всего экрана. Помечает устаревание: офлайн
/// (показан кэш) — явно с иконкой; «старый, но онлайн» (≥3 ч / другой день) —
/// приглушённым предупреждающим цветом.
class _UpdatedAt extends StatefulWidget {
  const _UpdatedAt({required this.forecast});
  final Forecast forecast;

  @override
  State<_UpdatedAt> createState() => _UpdatedAtState();
}

class _UpdatedAtState extends State<_UpdatedAt> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(
      const Duration(minutes: 1),
      (_) => mounted ? setState(() {}) : null,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final fetchedAt = widget.forecast.fetchedAt;
    final fromCache = widget.forecast.fromCache;
    final now = DateTime.now();
    final age = now.difference(fetchedAt);
    final staleOnline =
        !fromCache && (age >= const Duration(hours: 3) || !_sameDay(now, fetchedAt));

    final Color color;
    if (fromCache) {
      color = cs.error;
    } else if (staleOnline) {
      color = cs.error.withValues(alpha: 0.75);
    } else {
      color = cs.onSurfaceVariant;
    }

    final ageLabel = _ageLabel(context, l10n, fetchedAt, age);
    final text = fromCache ? l10n.fcOfflineUpdated(ageLabel) : ageLabel;
    final style = theme.textTheme.labelSmall?.copyWith(color: color);

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (fromCache) ...[
            Icon(Icons.cloud_off, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(text, textAlign: TextAlign.center, style: style),
          ),
        ],
      ),
    );
  }
}

/// Псевдо-обновление прогноза: включаем полноэкранную загрузку, ждём короткую
/// искусственную задержку (имитация запроса), пересчитываем прогноз и гасим
/// загрузку — контент монтируется заново, числа проигрывают count-up с нуля.
Future<void> _refreshForecast(WidgetRef ref) async {
  final refreshing = ref.read(forecastRefreshingProvider.notifier);
  refreshing.start();
  try {
    await Future<void>.delayed(const Duration(milliseconds: 4200));
    // Инвалидируем СЫРОЙ ряд — это перезапросит погоду; forecastProvider, который
    // его читает, пересоберётся следом.
    ref.invalidate(weatherSeriesProvider);
    await ref.read(forecastProvider.future);
  } finally {
    refreshing.stop();
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.label, required this.onPressed});
  final String label;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.primary;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.refresh, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.45), width: 1.4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Шаги статуса для полноэкранного лоадера прогноза. Один и тот же набор
/// используется и при первой загрузке, и при ручном обновлении.
List<String> _forecastLoadingSteps(AppLocalizations l10n) => [
  l10n.fcRefreshStep1,
  l10n.fcRefreshStep2,
  l10n.fcRefreshStep3,
  l10n.fcRefreshStep4,
  l10n.fcRefreshStep5,
];

/// Полноэкранная загрузка обновления: спиннер + строка статуса, которая
/// сменяется по шагам («Запрашиваем погоду…» → «Считаем давление…» → …),
/// создавая ощущение реальной работы. Шаги идут по кругу плавным кросс-фейдом.
class _RefreshLoading extends StatefulWidget {
  const _RefreshLoading({required this.steps});
  final List<String> steps;

  @override
  State<_RefreshLoading> createState() => _RefreshLoadingState();
}

class _RefreshLoadingState extends State<_RefreshLoading> {
  static const _interval = Duration(milliseconds: 1200);
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_interval, (_) {
      if (!mounted) return;
      setState(() => _index = (_index + 1) % widget.steps.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Text(
              widget.steps[_index],
              key: ValueKey(_index),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {this.action});
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final title = Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
    if (action == null) return title;
    return Row(
      children: [
        Expanded(child: title),
        action!,
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    this.backgroundImage,
    this.backgroundScale = 1.0,
    this.padding = const EdgeInsets.all(16),
  });
  final Widget child;

  /// Опциональная фоновая картинка карточки.
  final ImageProvider? backgroundImage;

  /// Масштаб фоновой картинки (1.0 = cover, 1.3 = zoom-in на 30%).
  final double backgroundScale;

  /// Внутренние отступы карточки.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = backgroundImage != null;
    final isDark = theme.brightness == Brightness.dark;
    final decoration = BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(20),
      // Карточка с фото — без обводки. В тёмной теме обводку тоже убираем: на
      // глубоком фоне карточки и так выделяются цветом поверхности (бордеры
      // оставляем только инпутам/селектам и кликабельным блокам). В светлой
      // теме обводка нужна — иначе белая карточка сливается со светлым фоном.
      border: hasImage || isDark
          ? null
          : Border.all(color: theme.colorScheme.outlineVariant),
      boxShadow: hasImage
          ? null
          : const [
              BoxShadow(
                color: Color(0x0A1B364A),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
    );

    if (backgroundImage == null) {
      return Container(padding: padding, decoration: decoration, child: child);
    }

    // Фон рендерим отдельным Image, чтобы можно было зумить через Transform —
    // у DecorationImage с BoxFit.cover параметр scale игнорируется.
    return Container(
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.scale(
                scale: backgroundScale,
                child: Image(image: backgroundImage!, fit: BoxFit.cover),
              ),
            ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    super.key,
    required this.day,
    required this.dayIndex,
    required this.units,
    required this.fish,
  });
  final DayForecast day;
  final int dayIndex;
  final Units units;
  final Fish fish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final level = day.bite.level;
    final color = biteLevelColor(level);
    // Звезда-бейдж — только для хорошего/отличного клёва; иначе значок по уровню.
    final showStar = level == BiteLevel.good || level == BiteLevel.excellent;
    // Своё фото-фон для тёмной темы: подводная сцена с лучами света.
    final isDark = theme.brightness == Brightness.dark;
    final bgAsset = isDark
        ? 'assets/images/back_dark.webp'
        : 'assets/images/carp_bg.webp';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A1B364A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Stack(
            children: [
              // Фото карпа — фон всей карточки.
              Positioned.fill(
                child: Image(
                  image: AssetImage(bgAsset),
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
              ),
              // Подсвет снизу — читаемость текста уровня/окна на фото.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        cs.surface.withValues(alpha: 0.55),
                        cs.surface.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.5],
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Левая панель: белая плашка с отступом 8px и скруглением ──
                  Expanded(
                    flex: 44,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  conditionIcon(day.condition),
                                  size: 20,
                                  color: conditionColor(day.condition),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    formatTempRange(
                                      units,
                                      day.minTempC,
                                      day.maxTempC,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _dateLabel(context, day.date),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(height: 1, color: cs.outlineVariant),
                            const SizedBox(height: 18),
                            Center(
                              child: _BiteDial(
                                value: day.bite.value,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ── Правая зона: рыба сверху + уровень и лучшее окно снизу ──
                  Expanded(
                    flex: 56,
                    child: Stack(
                      children: [
                        // Отдельная рыба поверх фона — крупная, в верхней части
                        // зоны. OverflowBox снимает ограничение по ширине, чтобы
                        // рыба рендерилась в реальном размере; хвост и верх
                        // уходят за край и обрезаются скруглением карточки.
                        Positioned.fill(
                          child: ClipRect(
                            child: OverflowBox(
                              alignment: Alignment.topLeft,
                              maxWidth: double.infinity,
                              maxHeight: double.infinity,
                              child: Transform.translate(
                                offset: const Offset(18, -46),
                                child: Image.asset(
                                  fishAsset(fish),
                                  height: 210,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 16, 16, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _CircleBadge(
                                      icon: showStar
                                          ? Icons.star_rounded
                                          : _levelIcon(level),
                                      background: color,
                                      iconColor: Colors.white,
                                      iconScale: 0.66,
                                    ),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        biteLevelLabel(l10n, level),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: color,
                                              height: 1.1,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _CircleBadge(
                                      icon: Icons.access_time_filled,
                                      background: cs.surface,
                                      iconColor: color,
                                      iconScale: 0.66,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _windowText(l10n, day.bestWindow),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: cs.onSurface,
                                              fontWeight: FontWeight.w500,
                                              height: 1.25,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Текст лучшего окна: подпись на первой строке, время — всегда на второй.
String _windowText(AppLocalizations l10n, BiteWindow? window) {
  if (window == null) return l10n.fcBestWindowEmpty;
  String hm(DateTime t) => '${t.hour}:00';
  return '${l10n.fcBestWindow}\n${hm(window.from)}–${hm(window.to)}';
}

/// Значок-«пилюля» уровня для дней без звезды (средний/слабый клёв).
IconData _levelIcon(BiteLevel level) => switch (level) {
  BiteLevel.excellent => Icons.star_rounded,
  BiteLevel.good => Icons.star_rounded,
  BiteLevel.medium => Icons.trending_flat,
  BiteLevel.low => Icons.trending_down,
  BiteLevel.veryLow => Icons.trending_down,
};

/// Круглый бейдж-иконка для блока индекса (звезда уровня, часы окна).
class _CircleBadge extends StatelessWidget {
  const _CircleBadge({
    required this.icon,
    required this.background,
    required this.iconColor,
    this.size = 30,
    this.iconScale = 0.48,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final double size;

  /// Доля диаметра, которую занимает иконка (звезда крупнее часов).
  final double iconScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, size: size * iconScale, color: iconColor),
    );
  }
}

/// Держит поддерево живым в ленивом списке: off-screen дети ListView обычно
/// уничтожаются и пересоздаются при возврате в видимую область, из-за чего
/// внутренние [_CountUp] заново запускали анимацию «просчёта» при скролле.
/// С keep-alive состояние сохраняется — числа остаются на месте.
class _KeepAlive extends StatefulWidget {
  const _KeepAlive({required this.child});
  final Widget child;

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

/// Анимация «просчёта»: значение катится от 0 до [value] при появлении виджета
/// и при смене значения. Создаёт ощущение, что число пересчитывается — нужно
/// при загрузке прогноза и переключении дня (для последнего родитель меняет
/// key, чтобы виджет пересоздался и анимация началась с нуля заново).
class _CountUp extends StatefulWidget {
  const _CountUp({
    super.key,
    required this.value,
    required this.builder,
    this.duration = const Duration(milliseconds: 750),
  });

  final double value;
  final Widget Function(BuildContext context, double value) builder;
  final Duration duration;

  @override
  State<_CountUp> createState() => _CountUpState();
}

class _CountUpState extends State<_CountUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  double _from = 0;

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void didUpdateWidget(_CountUp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _from = oldWidget.value;
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
      animation: _curve,
      builder: (context, _) {
        final v = _from + (widget.value - _from) * _curve.value;
        return widget.builder(context, v);
      },
    );
  }
}

class _BiteDial extends StatelessWidget {
  const _BiteDial({super.key, required this.value, required this.color});
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SizedBox(
      width: 104,
      height: 104,
      child: _CountUp(
        value: value.toDouble(),
        builder: (context, v) => Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 104,
              height: 104,
              child: CircularProgressIndicator(
                value: v / 100,
                strokeWidth: 9,
                strokeCap: StrokeCap.round,
                color: color,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
            // Чуть приподнимаем цифру и подпись относительно центра кольца.
            Transform.translate(
              offset: const Offset(0, -4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${v.round()}',
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.fcIndexCaption,
                    style: theme.textTheme.labelSmall?.copyWith(
                      // Цвет как у цифры (тёмный), но шрифт чуть меньше.
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Как ловить сегодня (саммари тактики) ────────────────────

class _TacticsSummary extends StatelessWidget {
  const _TacticsSummary({
    required this.day,
    required this.dayIndex,
    required this.prev,
    required this.fish,
  });
  final DayForecast day;
  final int dayIndex;
  final DayForecast? prev;
  final Fish fish;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final advice = AdviceEngine.forDay(day, fish, prev: prev);
    // Заголовок следует за выбранным днём: сегодня / завтра / дата.
    final title = switch (dayIndex) {
      0 => l10n.fcHowToFish,
      1 => l10n.fcHowToFishTomorrow,
      _ => l10n.fcHowToFishOn(_dateLabel(context, day.date)),
    };
    AdviceTip byKind(AdviceKind k) => advice.firstWhere((t) => t.kind == k);
    // Порядок как на референсе: Место → Глубина → Насадка.
    final tips = [
      byKind(AdviceKind.location),
      byKind(AdviceKind.depth),
      byKind(AdviceKind.bait),
    ];

    return Column(
      children: [
        _SectionTitle(
          title,
          action: InkWell(
            onTap: () => showAdviceSheet(context),
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.tabAdvice,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _Card(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final tip in tips) Expanded(child: _TacticColumn(tip: tip)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Привязывает короткие слова (1–2 буквы: предлоги/союзы «в», «и», «с» …) к
/// следующему слову неразрывным пробелом, чтобы они не висели в конце строки.
final _hangingShorts = RegExp(
  r'(^|[\s«"(])([A-Za-zА-Яа-яЁё]{1,2})\s+',
  caseSensitive: false,
);
String _fixHanging(String s) =>
    s.replaceAllMapped(_hangingShorts, (m) => '${m[1]}${m[2]} ');

/// Одна колонка тактики: иллюстрация слева + подпись-категория и значение.
class _TacticColumn extends StatelessWidget {
  const _TacticColumn({required this.tip});
  final AdviceTip tip;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    // При смене дня картинка и значение мягко сменяются кросс-фейдом с лёгким
    // зумом — в такт «просчёту» чисел. Категория (Место/Глубина/Насадка)
    // закреплена за колонкой и не меняется, поэтому без анимации.
    Widget fadeScale(Widget child, Animation<double> animation) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(animation),
          child: child,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: fadeScale,
              child: Image.asset(
                adviceIconAsset(
                  tip.code,
                  dark: theme.brightness == Brightness.dark,
                ),
                key: ValueKey(tip.code),
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            adviceKindTitle(l10n, tip.kind),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Text(
              _fixHanging(adviceTitle(l10n, tip)),
              key: ValueKey(adviceTitle(l10n, tip)),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Твой спот: пространственный разбор по карте OSM + ветру ──

/// Блок «Твой спот»: что за водоём рядом и где сегодня вероятнее активная рыба.
/// Надстройка над погодным прогнозом — при отсутствии воды/на фолбэке мягко
/// уходит в приглашение задать спот, не ломая экран.
class _SpotAdviceCard extends ConsumerWidget {
  const _SpotAdviceCard({required this.day});
  final DayForecast day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final location = ref.watch(activeLocationProvider);
    final onFallback = location == kDefaultLocation;

    final Widget body;
    if (onFallback) {
      // Спот не выбран — честно предлагаем задать, а не разбираем фолбэк-точку.
      body = const _SpotEmpty();
    } else {
      body = ref
          .watch(waterBodyProvider)
          .when(
            loading: () => const _SpotLoading(),
            error: (_, _) => const _SpotError(),
            data: (waterBody) {
              if (waterBody == null) return const _SpotEmpty();
              final advice = SpotAdvisor.analyze(
                waterBody,
                day.representative,
                spotLat: location.latitude,
                spotLon: location.longitude,
              );
              return _SpotContent(
                advice: advice,
                windDirDeg: day.representative.windDirDeg,
                windSpeedMs: day.representative.windSpeedMs,
                onShowMap: () async {
                  final updated = await Navigator.of(context).push<GeoPoint>(
                    MaterialPageRoute<GeoPoint>(
                      builder: (_) => MapPickerScreen(
                        initialCenter:
                            LatLng(location.latitude, location.longitude),
                        viewSpot: location,
                        windDirDeg: day.representative.windDirDeg,
                        windSpeedMs: day.representative.windSpeedMs,
                      ),
                    ),
                  );
                  if (updated == null || updated == location) return;
                  // Подвинули метку: replace — no-op, если точка не сохранена в
                  // списке спотов; setLocation двигает активную точку прогноза.
                  ref.read(savedSpotsProvider.notifier).replace(location, updated);
                  ref.read(activeLocationProvider.notifier).setLocation(updated);
                },
              );
            },
          );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(l10n.spotTitle),
        const SizedBox(height: 10),
        body,
      ],
    );
  }
}

/// Нет воды рядом / спот не выбран — приглашение задать спот на карте.
class _SpotEmpty extends StatelessWidget {
  const _SpotEmpty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.travel_explore, size: 20, color: cs.onSurfaceVariant),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.spotNoWater,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => showLocationSheet(context),
              icon: const Icon(Icons.add_location_alt_outlined, size: 18),
              label: Text(l10n.spotSetOnMap),
              style: OutlinedButton.styleFrom(
                foregroundColor: cs.primary,
                side: BorderSide(color: cs.primary.withValues(alpha: 0.45)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotLoading extends StatelessWidget {
  const _SpotLoading();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: SizedBox(
        height: 56,
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpotError extends ConsumerWidget {
  const _SpotError();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return _Card(
      child: Row(
        children: [
          Icon(Icons.cloud_off_outlined, size: 20, color: cs.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.spotCheckFailed,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
                height: 1.35,
              ),
            ),
          ),
          TextButton(
            onPressed: () => ref.invalidate(waterBodyProvider),
            child: Text(l10n.fcRetry),
          ),
        ],
      ),
    );
  }
}

/// Водоём найден: тип/размер + ветровая подсказка + берег + дисклеймер.
/// Каждая строка несёт свой источник — чтобы было видно, на чём основано.
class _SpotContent extends StatelessWidget {
  const _SpotContent({
    required this.advice,
    required this.windDirDeg,
    required this.windSpeedMs,
    required this.onShowMap,
  });
  final SpotAdvice advice;

  /// Ветер для компаса в шапке: направление (откуда дует, °) и скорость (м/с).
  final double windDirDeg;
  final double windSpeedMs;

  /// Открыть карту с этим спотом (посмотреть, где он).
  final VoidCallback onShowMap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final typeText = spotTypeLabel(l10n, advice.body.type);
    final sizeText = spotSizeLabel(l10n, advice.body.areaHa);
    final name = advice.body.name;
    // Имя из OSM — в заголовок; тип и размер уходят в подпись под ним. Если
    // имени нет, тип сам становится заголовком.
    final headTitle = name ?? typeText;
    final headMeta = [
      if (name != null) typeText,
      ?sizeText,
    ].join(' · ');

    final tipText = spotTipText(l10n, advice);
    final whereText = spotWhereText(l10n, advice);

    Widget divider() => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(height: 1, color: cs.outlineVariant),
    );

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Что за водоём — из карты. Иконка карты у названия (открывает карту),
          // компас ветра — в правом верхнем углу (как на экране выбора спота).
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.water, size: 20, color: cs.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            headTitle,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: onShowMap,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              Icons.map_outlined,
                              size: 18,
                              color: cs.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (headMeta.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          headMeta,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        l10n.spotSourceMap,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _SpotCompass(windDirDeg: windDirDeg, windSpeedMs: windSpeedMs),
            ],
          ),
          // Подсказки буллетами с галочками (слева) + иллюстрация спота справа:
          // тип воды + активный берег (или «none», если берег не выражен).
          if (tipText != null || whereText != null) ...[
            divider(),
            Row(
              // Текст и картинка центрируются друг относительно друга: если
              // буллетов мало (короче картинки) — текст не липнет к верху.
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (tipText != null) _SpotBullet(tipText),
                      if (whereText != null) _SpotBullet(whereText),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _SpotIllustration(advice: advice),
              ],
            ),
          ],
          divider(),
          // Честная граница: чего карта и погода не знают.
          Text(
            l10n.spotDisclaimer,
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

/// Компас ветра в шапке карточки: роза С/В/Ю/З (север подсвечен) и стрелка в
/// сторону потока. Без подписи — как на экране выбора спота, только компас.
class _SpotCompass extends StatelessWidget {
  const _SpotCompass({required this.windDirDeg, required this.windSpeedMs});
  final double windDirDeg;
  final double windSpeedMs;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final calm = windSpeedMs < 1.0;
    final flowDeg = (windDirDeg + 180) % 360; // куда дует

    Widget cardinal(String t, Alignment a, {bool north = false}) => Align(
          alignment: a,
          child: Text(
            t,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 9,
              height: 1,
              fontWeight: north ? FontWeight.w800 : FontWeight.w600,
              color: north ? cs.primary : cs.onSurfaceVariant,
            ),
          ),
        );

    return SizedBox(
      width: 54,
      height: 54,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: cs.outlineVariant),
            ),
          ),
          cardinal(l10n.fcWindN, Alignment.topCenter, north: true),
          cardinal(l10n.fcWindE, Alignment.centerRight),
          cardinal(l10n.fcWindS, Alignment.bottomCenter),
          cardinal(l10n.fcWindW, Alignment.centerLeft),
          if (calm)
            Icon(Icons.circle, size: 6, color: cs.onSurfaceVariant)
          else
            Transform.rotate(
              angle: flowDeg * math.pi / 180,
              child: Icon(Icons.navigation, size: 20, color: cs.primary),
            ),
        ],
      ),
    );
  }
}

/// Иллюстрация спота справа от подсказок: тип воды + активный берег. Картинка
/// схематична (север вверху) — глубину и дно не показывает.
class _SpotIllustration extends StatelessWidget {
  const _SpotIllustration({required this.advice});
  final SpotAdvice advice;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.asset(
        spotIllustrationAsset(advice, dark: dark),
        width: 132,
        height: 132,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Строка-подсказка буллетом с галочкой.
class _SpotBullet extends StatelessWidget {
  const _SpotBullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(Icons.check_circle, size: 18, color: cs.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Когда: день по периодам ─────────────────────────────────

enum _Period { night, morning, day, evening }

class _DayPeriods extends StatelessWidget {
  const _DayPeriods({required this.day});
  final DayForecast day;

  bool _inRange(int h, int a, int b) {
    a = (a + 24) % 24;
    b = (b + 24) % 24;
    if (a <= b) return h >= a && h < b;
    return h >= a || h < b; // переход через полночь
  }

  _Period _periodOf(int h, int sr, int ss) {
    if (_inRange(h, sr - 1, sr + 3)) return _Period.morning;
    if (_inRange(h, ss - 2, ss + 2)) return _Period.evening;
    if (_inRange(h, sr + 3, ss - 2)) return _Period.day;
    return _Period.night;
  }

  ({IconData icon, String label, int start, int end, Color accent}) _meta(
    _Period p,
    int sr,
    int ss,
    AppLocalizations l10n,
  ) {
    switch (p) {
      case _Period.morning:
        return (
          icon: Icons.wb_twilight_rounded,
          label: l10n.fcPeriodMorning,
          start: (sr - 1 + 24) % 24,
          end: (sr + 3) % 24,
          accent: const Color(0xFF1D8B53), // рассвет — зелёный
        );
      case _Period.day:
        return (
          icon: Icons.wb_sunny_rounded,
          label: l10n.fcPeriodDay,
          start: (sr + 3) % 24,
          end: (ss - 2 + 24) % 24,
          accent: const Color(0xFFFFB300), // день — янтарный
        );
      case _Period.evening:
        return (
          icon: Icons.wb_twilight_rounded,
          label: l10n.fcPeriodEvening,
          start: (ss - 2 + 24) % 24,
          end: (ss + 2) % 24,
          accent: const Color(0xFFF57C00), // закат — оранжевый
        );
      case _Period.night:
        return (
          icon: Icons.nightlight_round,
          label: l10n.fcPeriodNight,
          start: (ss + 2) % 24,
          end: (sr - 1 + 24) % 24,
          accent: const Color(0xFF5C6BC0), // ночь — индиго
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sun = day.representative;
    int roundH(DateTime t) => t.hour + (t.minute >= 30 ? 1 : 0);
    final sr = roundH(sun.sunrise);
    final ss = roundH(sun.sunset);

    // Часы, сгруппированные по периодам — из фактических почасовых значений.
    final byPeriod = <_Period, List<HourForecast>>{};
    for (final h in day.hours) {
      (byPeriod[_periodOf(h.time.hour, sr, ss)] ??= []).add(h);
    }
    int avgOf(_Period p) {
      final hs = byPeriod[p];
      if (hs == null || hs.isEmpty) return 0;
      var s = 0;
      for (final h in hs) {
        s += h.bite.value;
      }
      return (s / hs.length).round();
    }
    // Представитель периода — час, чей индекс ближе всего к среднему: его разбор
    // факторов и режим времени суток честно отражают показанное число.
    WeatherPoint? repOf(_Period p, int avg) {
      final hs = byPeriod[p];
      if (hs == null || hs.isEmpty) return null;
      var best = hs.first;
      var bestDist = (best.bite.value - avg).abs();
      for (final h in hs) {
        final d = (h.bite.value - avg).abs();
        if (d < bestDist) {
          best = h;
          bestDist = d;
        }
      }
      return best.weather;
    }

    const order = [
      _Period.night,
      _Period.morning,
      _Period.day,
      _Period.evening,
    ];
    final metas = [for (final p in order) _meta(p, sr, ss, l10n)];
    final avgs = [for (final p in order) avgOf(p)];
    final reps = [for (var i = 0; i < order.length; i++) repOf(order[i], avgs[i])];
    return _Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < order.length; i++) ...[
            if (i != 0) const SizedBox(width: 4),
            Expanded(
              child: _PeriodCard(
                meta: metas[i],
                avg: avgs[i],
                onTap: reps[i] == null
                    ? null
                    : () => showPeriodSheet(
                          context,
                          meta: metas[i],
                          avg: avgs[i],
                          weather: reps[i]!,
                        ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PeriodCard extends StatelessWidget {
  const _PeriodCard({required this.meta, required this.avg, this.onTap});

  final ({IconData icon, String label, int start, int end, Color accent}) meta;
  final int avg;

  /// Тап по карточке открывает модалку с разбором оценки периода.
  final VoidCallback? onTap;

  String _hh(int h) => '${h.toString().padLeft(2, '0')}:00';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accent = meta.accent;
    final card = Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(meta.icon, size: 24, color: accent),
          const SizedBox(height: 10),
          Text(
            meta.label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${_hh(meta.start)} – ${_hh(meta.end)}',
              style: theme.textTheme.labelSmall?.copyWith(color: cs.onSurface),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  biteRateLabel(l10n, avg),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$avg',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: accent,
              height: 1,
            ),
          ),
        ],
      ),
    );
    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: card,
    );
  }
}

/// Модалка-разбор оценки периода (Ночь/Утро/День/Вечер): объясняет, почему
/// именно столько — поправка времени суток (зорьки/ночь) поверх базовой
/// обстановки. Закрывает вопросы вида «почему ночью ниже, чем утром».
Future<void> showPeriodSheet(
  BuildContext context, {
  required ({IconData icon, String label, int start, int end, Color accent})
      meta,
  required int avg,
  required WeatherPoint weather,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _PeriodSheet(meta: meta, avg: avg, weather: weather),
  );
}

class _PeriodSheet extends ConsumerWidget {
  const _PeriodSheet({
    required this.meta,
    required this.avg,
    required this.weather,
  });

  final ({IconData icon, String label, int start, int end, Color accent}) meta;
  final int avg;
  final WeatherPoint weather;

  String _hh(int h) => '${h.toString().padLeft(2, '0')}:00';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final units = ref.watch(unitsProvider);
    final engine = ref.watch(biteEngineProvider);
    // Поправка времени суток вместе с её причиной — основа объяснения периода.
    final tod = engine.timeOfDayBreakdown(weather);
    final accent = meta.accent;
    final adjColor = todAdjustmentColor(tod.multiplier);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: cs.outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Шапка: иконка периода, подпись + диапазон часов, крупная оценка.
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(meta.icon, color: accent, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meta.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_hh(meta.start)} – ${_hh(meta.end)}',
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: cs.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$avg',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: accent,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      biteRateLabel(l10n, avg),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ── Блок «Время суток»: главное, что отличает периоды друг от друга.
            _PeriodSheetTitle(l10n.fcPeriodTimeEffect),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: adjColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    todAdjustmentBadge(tod.multiplier),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: adjColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.fcTodAdjCaption,
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.water_drop_outlined,
                    size: 16, color: cs.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  '${l10n.fcPeriodWater} ${formatTemp(units, weather.waterTempC)}',
                  style: theme.textTheme.labelMedium
                      ?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              todRegimePhrase(l10n, tod.regime, weather, engine.config, units),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface, // основной цвет текста (белый в тёмной теме)
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodSheetTitle extends StatelessWidget {
  const _PeriodSheetTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

/// «Погода днём»: 4 равные колонки через тонкие вертикальные разделители —
/// иконка, крупное значение, деталь и подпись-категория снизу.
class _ConditionsRow extends StatelessWidget {
  const _ConditionsRow({super.key, required this.weather, required this.units});
  final WeatherPoint weather;
  final Units units;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final calm = weather.windSpeedMs < 0.5;
    final trend = weather.pressureTrend6h;
    final windSuffix = units.wind == WindUnit.kmh
        ? l10n.fcUnitKmhSuffix
        : l10n.fcUnitMsSuffix;
    final items = <_CondItem>[
      _CondItem(
        icon: Icons.speed,
        target: units.pressureValue(weather.pressureHpa).toDouble(),
        format: (v) => '${v.round()}',
        detail: pressureUnitLabel(l10n, units.pressure),
        trend: trend <= -1
            ? Icons.south
            : trend >= 1
            ? Icons.north
            : null,
      ),
      if (calm)
        _CondItem(icon: Icons.air, staticValue: l10n.fcWindCalm, detail: '')
      else
        _CondItem(
          icon: Icons.air,
          target: units.windValue(weather.windSpeedMs).toDouble(),
          format: (v) => '${v.round()} $windSuffix',
          detail: windCardinalLabel(l10n, weather.windCardinal),
        ),
      _CondItem(
        icon: Icons.water_drop,
        target: units.tempValue(weather.waterTempC).toDouble(),
        format: (v) => '${v.round()}°',
        detail: l10n.fcChipWater,
      ),
      _CondItem(
        icon: Icons.nightlight,
        target: weather.moonIllumination * 100,
        format: (v) => '${v.round()}%',
        detail: moonPhaseLabel(l10n, weather.time),
      ),
    ];
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i != 0)
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(vertical: 2),
                color: cs.outlineVariant,
              ),
            Expanded(child: _CondColumn(item: items[i])),
          ],
        ],
      ),
    );
  }
}

class _CondItem {
  const _CondItem({
    required this.icon,
    required this.detail,
    this.staticValue,
    this.target,
    this.format,
    this.trend,
  });
  final IconData icon;
  final String detail;
  // Либо статичная строка (например «Штиль»)…
  final String? staticValue;
  // …либо число с форматтером — тогда показываем с count-up анимацией.
  final double? target;
  final String Function(double)? format;
  final IconData? trend;
}

class _CondColumn extends StatelessWidget {
  const _CondColumn({required this.item});
  final _CondItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Иконка и значение — в одну строку, чтобы карточка была ниже.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 18, color: cs.primary),
                const SizedBox(width: 5),
                Builder(
                  builder: (context) {
                    final style = theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    );
                    if (item.target != null) {
                      return _CountUp(
                        value: item.target!,
                        builder: (_, v) => Text(item.format!(v), style: style),
                      );
                    }
                    return Text(item.staticValue ?? '', style: style);
                  },
                ),
                if (item.trend != null) ...[
                  const SizedBox(width: 2),
                  Icon(item.trend, size: 13, color: cs.onSurfaceVariant),
                ],
              ],
            ),
          ),
          if (item.detail.isNotEmpty) ...[
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.detail,
                // Серый «легенда»-текст — обычным начертанием.
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// «Ближайшие дни»: 3 крупные карточки + ссылка «Смотреть неделю» (открывает
/// полную неделю листом). Тап по карточке переключает выбранный день.
class _UpcomingDays extends ConsumerWidget {
  const _UpcomingDays({
    super.key,
    required this.forecast,
    required this.selectedIndex,
  });
  final Forecast forecast;
  final int selectedIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final dayCount = forecast.days.length;
    // Всегда показываем сегодня и завтра; третья карточка — выбранный день,
    // если он дальше послезавтра, иначе день 2.
    final indices = <int>[
      if (dayCount > 0) 0,
      if (dayCount > 1) 1,
      if (dayCount > 2) (selectedIndex >= 2 ? selectedIndex : 2),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _SectionTitle(l10n.fcUpcomingDays)),
            InkWell(
              onTap: () => showWeekSheet(context),
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.fcSeeWeek,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < indices.length; j++) ...[
                if (j != 0) const SizedBox(width: 4),
                Expanded(
                  child: _DayBigCard(
                    label: indices[j] == 0
                        ? l10n.fcToday
                        : indices[j] == 1
                        ? l10n.fcTomorrow
                        : _weekdayLabel(
                            context,
                            forecast.days[indices[j]].date,
                          ),
                    isToday: indices[j] == 0,
                    value: forecast.days[indices[j]].bite.value,
                    // Тренд индекса день-к-дню: сравниваем с предыдущим
                    // календарным днём. Для первого дня (нет вчера) — null.
                    trend: indices[j] > 0
                        ? forecast.days[indices[j]].bite.value -
                              forecast.days[indices[j] - 1].bite.value
                        : null,
                    selected: indices[j] == selectedIndex,
                    onTap: () => ref
                        .read(selectedDayIndexProvider.notifier)
                        .select(indices[j]),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DayBigCard extends StatelessWidget {
  const _DayBigCard({
    required this.label,
    required this.isToday,
    required this.value,
    required this.trend,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool isToday;
  final int value;

  /// Разница индекса с предыдущим днём: >0 — рост, <0 — спад, 0 — без
  /// изменений, null — нет предыдущего дня (первая карточка).
  final int? trend;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final t = trend;
    final IconData? trendIcon = t == null
        ? null
        : t > 0
        ? Icons.arrow_upward_rounded
        : t < 0
        ? Icons.arrow_downward_rounded
        : Icons.trending_flat;
    final Color trendColor = (t == null || t == 0)
        ? cs.onSurfaceVariant
        : t > 0
        ? const Color(0xFF1D8B53)
        : const Color(0xFFCB4B3F);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          // Активная карточка остаётся белой — на выбор указывает только обводка.
          color: cs.surface,
          borderRadius: BorderRadius.circular(18),
          // Толщину держим постоянной (1.5px) — иначе при выборе контент
          // сдвигается на 0.5px (Container добавляет паддинг по ширине рамки).
          // На выбор указывает только цвет обводки.
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                // «Сегодня» — акцентным цветом.
                color: isToday ? cs.primary : cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                if (trendIcon != null) ...[
                  Icon(trendIcon, size: 22, color: trendColor),
                  const SizedBox(width: 6),
                ],
                _CountUp(
                  value: value.toDouble(),
                  builder: (_, v) => Text(
                    '${v.round()}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Полная неделя — лист со всеми днями (по ссылке «Смотреть неделю»).
Future<void> showWeekSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _WeekSheet(),
  );
}

class _WeekSheet extends ConsumerWidget {
  const _WeekSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final forecast = ref.watch(forecastProvider).value;
    final units = ref.watch(unitsProvider);
    final selectedIndex = ref.watch(selectedDayIndexProvider);
    final days = forecast?.days ?? const [];
    var bestIndex = 0;
    for (var i = 1; i < days.length; i++) {
      if (days[i].bite.value > days[bestIndex].bite.value) bestIndex = i;
    }
    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: cs.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.fcWeekTitle,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
          ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              children: [
                for (var i = 0; i < days.length; i++)
                  _WeekSheetRow(
                    label: i == 0
                        ? l10n.fcToday
                        : i == 1
                        ? l10n.fcTomorrow
                        : '${_weekdayLabel(context, days[i].date)} ${days[i].date.day}',
                    day: days[i],
                    units: units,
                    selected: i == selectedIndex,
                    isBest: i == bestIndex && days.length > 1,
                    onTap: () {
                      ref.read(selectedDayIndexProvider.notifier).select(i);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekSheetRow extends StatelessWidget {
  const _WeekSheetRow({
    required this.label,
    required this.day,
    required this.units,
    required this.selected,
    required this.isBest,
    required this.onTap,
  });

  final String label;
  final DayForecast day;
  final Units units;
  final bool selected;
  final bool isBest;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final color = biteValueColor(day.bite.value);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.08) : null,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? color.withValues(alpha: 0.4) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 96,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            Icon(
              conditionIcon(day.condition),
              size: 20,
              color: conditionColor(day.condition),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                formatTempRange(units, day.minTempC, day.maxTempC),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            if (isBest) ...[
              const Icon(
                Icons.star_rounded,
                size: 18,
                color: Color(0xFFFFC107),
              ),
              const SizedBox(width: 6),
            ],
            Container(
              width: 42,
              padding: const EdgeInsets.symmetric(vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${day.bite.value}',
                style: TextStyle(fontWeight: FontWeight.w800, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// «Почему такой прогноз»: не семь одинаковых полосок, а что реально двигает
/// балл — 2–3 сильных фактора в плюс и явные минусы. Ранжируем по качеству.
class _WhySummary extends StatelessWidget {
  const _WhySummary({required this.score});
  final BiteScore score;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.fcWhyTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      whyExplanation(l10n, score),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Иллюстрация ведущего фактора прогноза. Если под состояние нет
              // ассета (или он не загрузился) — запасной зелёный щит в кружке.
              SizedBox(width: 92, height: 92, child: _whyVisual(context, cs)),
            ],
          ),
          const SizedBox(height: 8),
          // Кнопка начинается по левой линии контента (без бокового паддинга).
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => showForecastStory(context),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 4),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: cs.primary,
              ),
              icon: const Icon(Icons.help_outline, size: 18),
              label: Text(
                l10n.fcHowItWorksBtn,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _whyVisual(BuildContext context, ColorScheme cs) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final asset = whyIllustrationAsset(score, dark: dark);
    if (asset == null) return _whyShield(cs);
    return Image.asset(
      asset,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _whyShield(cs),
    );
  }

  // Запасной зелёный щит (бренд) для состояний без иллюстрации.
  Widget _whyShield(ColorScheme cs) => Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: cs.primary.withValues(alpha: 0.10),
        ),
        child: Icon(Icons.verified_user, size: 44, color: cs.primary),
      );
}


