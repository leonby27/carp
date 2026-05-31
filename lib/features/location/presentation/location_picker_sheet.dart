import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../l10n/app_localizations.dart';
import '../../forecast/application/forecast_providers.dart';
import '../../spots/application/spots_providers.dart';
import '../../spots/presentation/map_picker_screen.dart';
import '../application/location_providers.dart';
import '../domain/geo_point.dart';

/// Лист выбора активной локации: текущее место, сохранённые споты, добавить на
/// карте. Вызывается из шапки «Прогноза», чтобы менять точку не уходя на «Споты».
Future<void> showLocationSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    // Потолок высоты: иначе при длинном списке лист тянется выше экрана —
    // ручка и заголовок уезжают за верх, не закрыть и не проскроллить.
    // С ограничением заголовок остаётся на месте, а список скроллится внутри.
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.85,
    ),
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _LocationSheet(),
  );
}

String _coords(GeoPoint p) =>
    '${p.latitude.toStringAsFixed(4)}, ${p.longitude.toStringAsFixed(4)}';

class _LocationSheet extends ConsumerWidget {
  const _LocationSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final active = ref.watch(activeLocationProvider);
    final spots = ref.watch(savedSpotsProvider);

    void select(GeoPoint point) {
      HapticFeedback.selectionClick();
      ref.read(activeLocationProvider.notifier).setLocation(point);
      Navigator.of(context).pop();
    }

    // Открыть ту же форму, что и при создании места (карта + поиск + имя), но с
    // готовыми именем и позицией. Лист остаётся под ней. По «Сохранить» заменяем
    // место в списке и, если оно активно, двигаем активную точку прогноза.
    Future<void> editSpot(GeoPoint spot) async {
      final wasActive = active == spot;
      final spotsNotifier = ref.read(savedSpotsProvider.notifier);
      final activeNotifier = ref.read(activeLocationProvider.notifier);
      // Ветер показываем только для активного места — прогноз считается именно
      // для него; для остальных точек ветра под рукой нет, не выдумываем.
      final fc = wasActive ? ref.read(forecastProvider).value : null;
      final rep = (fc != null && fc.days.isNotEmpty)
          ? fc.days.first.representative
          : null;
      final updated = await Navigator.of(context, rootNavigator: true)
          .push<GeoPoint>(
        MaterialPageRoute<GeoPoint>(
          builder: (_) => MapPickerScreen(
            initialCenter: LatLng(spot.latitude, spot.longitude),
            initialName: spot.isUnnamed ? null : spot.name,
            windDirDeg: rep?.windDirDeg,
            windSpeedMs: rep?.windSpeedMs,
          ),
        ),
      );
      if (updated == null || updated == spot) return;
      // Имя очистили — сохраняем прежнее, чтобы место не стало безымянным.
      final result = updated.isUnnamed && !spot.isUnnamed
          ? updated.copyWith(name: spot.name)
          : updated;
      spotsNotifier.replace(spot, result);
      if (wasActive) activeNotifier.setLocation(result);
    }

    Future<void> useCurrent() async {
      HapticFeedback.selectionClick();
      // Берём нотифаер ДО pop: после закрытия листа его ref уже невалиден.
      final activeNotifier = ref.read(activeLocationProvider.notifier);
      Navigator.of(context).pop();
      await activeNotifier.useDeviceLocation();
    }

    Future<void> addOnMap() async {
      // Нотифаеры и клиенты живут в ProviderScope, переживают закрытие листа —
      // в отличие от ref этого виджета. Поэтому захватываем их заранее.
      final nav = Navigator.of(context, rootNavigator: true);
      final spotsNotifier = ref.read(savedSpotsProvider.notifier);
      final activeNotifier = ref.read(activeLocationProvider.notifier);
      final reverseClient = ref.read(reverseGeocodingClientProvider);
      final lang = Localizations.localeOf(context).languageCode;
      final count = spots.length;
      nav.pop(); // закрываем лист
      final result = await nav.push<GeoPoint>(
        MaterialPageRoute(
          builder: (_) => MapPickerScreen(
            initialCenter: LatLng(active.latitude, active.longitude),
          ),
        ),
      );
      if (result == null) return;

      // Спот добавляем и делаем активным СРАЗУ — с запасным именем, если оно
      // не задано. Обратный геокодинг (может занять секунды) идёт в фоне и потом
      // меняет подпись на ближайший населённый пункт, не блокируя UI.
      final placeholder = result.isUnnamed
          ? result.copyWith(name: l10n.spotDefaultName(count + 1))
          : result;
      spotsNotifier.add(placeholder);
      activeNotifier.setLocation(placeholder);

      if (result.isUnnamed) {
        unawaited(() async {
          final settlement = await reverseClient.nearestSettlement(
            result.latitude,
            result.longitude,
            language: lang,
          );
          if (settlement == null || settlement.isEmpty) return;
          final renamed = placeholder.copyWith(name: settlement);
          spotsNotifier.replace(placeholder, renamed);
          activeNotifier.renameIfCurrent(placeholder, renamed);
        }());
      }
    }

    Future<void> confirmDelete(int index, GeoPoint spot) async {
      final theme = Theme.of(context);
      final wasActive = active == spot;
      final spotsNotifier = ref.read(savedSpotsProvider.notifier);
      final activeNotifier = ref.read(activeLocationProvider.notifier);
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.spotDeleteConfirm),
          content: Text(spot.isUnnamed ? l10n.locCurrent : spot.name),
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
              child: Text(l10n.commonDelete),
            ),
          ],
        ),
      );
      if (ok != true) return;
      spotsNotifier.removeAt(index);
      // Удалили активный спот — прогноз не должен «висеть» на исчезнувшей точке:
      // переключаемся на текущее местоположение.
      if (wasActive) await activeNotifier.useDeviceLocation();
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
                l10n.locationSheetTitle,
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
              padding: const EdgeInsets.only(bottom: 12),
              children: [
                ListTile(
                  leading: Icon(Icons.my_location, color: cs.primary),
                  title: Text(l10n.spotsUseCurrent),
                  onTap: useCurrent,
                ),
                if (spots.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.spotsSavedTitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  for (var i = 0; i < spots.length; i++)
                    _SpotRow(
                      spot: spots[i],
                      active: active == spots[i],
                      onTap: () => select(spots[i]),
                      onEdit: () => editSpot(spots[i]),
                      onDelete: () => confirmDelete(i, spots[i]),
                    ),
                ],
                const Divider(height: 8),
                ListTile(
                  leading: Icon(Icons.add_location_alt_outlined,
                      color: cs.onSurfaceVariant),
                  title: Text(l10n.spotsAddOnMap),
                  onTap: addOnMap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotRow extends StatelessWidget {
  const _SpotRow({
    required this.spot,
    required this.active,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final GeoPoint spot;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    return ListTile(
      onTap: onTap,
      leading: Icon(
        active ? Icons.check_circle : Icons.location_on_outlined,
        color: active ? cs.primary : cs.onSurfaceVariant,
      ),
      title: Text(
        spot.isUnnamed ? l10n.locCurrent : spot.name,
        style: TextStyle(fontWeight: active ? FontWeight.w700 : FontWeight.w500),
      ),
      subtitle: Text(_coords(spot)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.edit_outlined, color: cs.onSurfaceVariant),
            tooltip: l10n.spotEdit,
            onPressed: onEdit,
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.delete_outline, color: cs.onSurfaceVariant),
            tooltip: l10n.commonDelete,
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
