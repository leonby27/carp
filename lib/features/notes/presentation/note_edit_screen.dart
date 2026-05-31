import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/units/units.dart';
import '../../../l10n/app_localizations.dart';
import '../../forecast/application/forecast_providers.dart';
import '../../forecast/domain/weather_point.dart';
import '../../forecast/presentation/forecast_format.dart';
import '../../location/application/location_providers.dart';
import '../../location/domain/geo_point.dart';
import '../../spots/application/spots_providers.dart';
import '../application/notes_providers.dart';
import '../data/note_photo_service.dart';
import '../domain/note.dart';
import 'photo_viewer.dart';

class NoteEditScreen extends ConsumerStatefulWidget {
  const NoteEditScreen({super.key, this.existing});
  final Note? existing;

  @override
  ConsumerState<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends ConsumerState<NoteEditScreen> {
  late final TextEditingController _text =
      TextEditingController(text: widget.existing?.text ?? '');
  late GeoPoint? _location = widget.existing?.location;
  late final List<String> _photos = [...?widget.existing?.photos];
  late final NotePhotoService _photoService =
      ref.read(notePhotoServiceProvider);
  NoteConditions? _conditions;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // Снимок условий: у существующей берём её, у новой — ТЕКУЩИЙ ЧАС прогноза.
    if (widget.existing != null) {
      _conditions = widget.existing!.conditions;
    } else {
      final f = ref.read(forecastProvider).value;
      if (f != null) {
        final today = f.today;
        final nowHour = DateTime.now().hour;
        final match = today.hours.where((h) => h.time.hour == nowHour);
        final w = match.isEmpty ? today.representative : match.first.weather;
        final idx = match.isEmpty ? today.bite.value : match.first.bite.value;
        _conditions = NoteConditions(
          biteIndex: idx,
          pressureHpa: w.pressureHpa,
          pressureTrend6h: w.pressureTrend6h,
          windMs: w.windSpeedMs,
          windDirDeg: w.windDirDeg,
          waterTempC: w.waterTempC,
        );
      }
      // У новой заметки место по умолчанию — активная локация прогноза.
      _location = ref.read(activeLocationProvider);
    }
  }

  bool get _dirty {
    final e = widget.existing;
    if (e == null) {
      return _text.text.trim().isNotEmpty || _photos.isNotEmpty;
    }
    return _text.text.trim() != e.text.trim() ||
        !listEquals(_photos, e.photos) ||
        _location != e.location;
  }

  Future<void> _confirmDiscard() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.noteDiscardTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.noteDiscard),
          ),
        ],
      ),
    );
    if (ok == true && mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _addPhoto() async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(l10n.notePhotoCamera),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.notePhotoGallery),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    setState(() => _busy = true);
    final name = await _photoService.import(source);
    if (!mounted) return;
    setState(() {
      _busy = false;
      if (name != null) _photos.add(name);
    });
  }

  void _removePhoto(int index) {
    // Файл не трогаем здесь: если заметку не сохранят, ссылка не порвётся;
    // неиспользуемые файлы подчистит фоновый GC при следующем запуске.
    setState(() => _photos.removeAt(index));
  }

  Future<void> _pickLocation() async {
    final l10n = AppLocalizations.of(context);
    final spots = ref.read(savedSpotsProvider);
    // Результат: GeoPoint — место; 'none' — без места; null — лист закрыли.
    final result = await showModalBottomSheet<Object?>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.not_listed_location_outlined),
              title: Text(l10n.noteLocationNone),
              onTap: () => Navigator.of(ctx).pop('none'),
            ),
            ListTile(
              leading: const Icon(Icons.my_location),
              title: Text(l10n.spotsUseCurrent),
              onTap: () async {
                final res = await ref
                    .read(geolocationServiceProvider)
                    .currentLocation();
                if (!ctx.mounted) return;
                Navigator.of(ctx).pop(res.point); // null → без изменений
              },
            ),
            for (final s in spots)
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(s.isUnnamed ? l10n.locCurrent : s.name),
                onTap: () => Navigator.of(ctx).pop(s),
              ),
          ],
        ),
      ),
    );
    if (result == null) return; // лист закрыт без выбора
    setState(() => _location = result == 'none' ? null : result as GeoPoint);
  }

  void _save() {
    final text = _text.text.trim();
    if (text.isEmpty && _photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).noteEmptyError)),
      );
      return;
    }
    final note = Note(
      id: widget.existing?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
      text: text,
      location: _location,
      photos: List.unmodifiable(_photos),
      conditions: _conditions,
    );
    ref.read(notesProvider.notifier).upsert(note);
    Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.noteDeleteConfirm),
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
    if (ok == true && mounted) {
      ref.read(notesProvider.notifier).removeById(widget.existing!.id);
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final units = ref.watch(unitsProvider);
    final locationLabel = _location == null
        ? l10n.noteLocationNone
        : (_location!.isUnnamed ? l10n.locCurrent : _location!.name);

    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmDiscard();
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(
            widget.existing == null ? l10n.noteNewTitle : l10n.noteEditTitle),
        actions: [
          if (widget.existing != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          TextField(
            controller: _text,
            autofocus: widget.existing == null,
            maxLines: null,
            minLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: l10n.noteTextHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Место.
          _RowTile(
            icon: Icons.location_on_outlined,
            value: locationLabel,
            onTap: _pickLocation,
          ),
          const SizedBox(height: 16),
          // Фото.
          Text(l10n.notePhotosLabel,
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _photos.length; i++)
                _PhotoThumb(
                  file: _photoService.fileFor(_photos[i]),
                  onTap: () => openPhotoViewer(
                    context,
                    [for (final p in _photos) _photoService.fileFor(p)],
                    i,
                  ),
                  onRemove: () => _removePhoto(i),
                ),
              _AddPhotoTile(busy: _busy, onTap: _busy ? null : _addPhoto),
            ],
          ),
          if (_conditions != null) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                Text(l10n.noteConditionsTitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                _IndexPill(index: _conditions!.biteIndex),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: _NoteConditionsColumns(c: _conditions!, units: units),
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _save,
              child: Text(l10n.noteSave),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({
    required this.icon,
    required this.value,
    required this.onTap,
  });
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: cs.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium),
            ),
            Icon(Icons.chevron_right, size: 18, color: cs.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _PhotoThumb extends StatelessWidget {
  const _PhotoThumb({
    required this.file,
    required this.onTap,
    required this.onRemove,
  });
  final File file;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              file,
              width: 84,
              height: 84,
              fit: BoxFit.cover,
              cacheWidth: 256,
              errorBuilder: (_, _, _) => Container(
                width: 84,
                height: 84,
                color: cs.surfaceContainerHighest,
                child:
                    Icon(Icons.broken_image_outlined, color: cs.onSurfaceVariant),
              ),
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.busy, required this.onTap});
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
          color: cs.surfaceContainerLow,
        ),
        child: busy
            ? const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.2),
                ),
              )
            : Icon(Icons.add_a_photo_outlined, color: cs.onSurfaceVariant),
      ),
    );
  }
}

/// Компактная пилюля с индексом клёва, цвет — по шкале клёва.
class _IndexPill extends StatelessWidget {
  const _IndexPill({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = biteValueColor(index);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('$index',
          style: TextStyle(
              color: color, fontWeight: FontWeight.w800, fontSize: 14)),
    );
  }
}

/// Снимок условий заметки в той же колоночной вёрстке, что «Погода днём» на
/// «Прогнозе»: давление (+тренд) · ветер (+направление) · вода.
class _NoteConditionsColumns extends StatelessWidget {
  const _NoteConditionsColumns({required this.c, required this.units});
  final NoteConditions c;
  final Units units;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final calm = c.windMs < 0.5;
    final trend = c.pressureTrend6h;
    final windSuffix = units.wind == WindUnit.kmh
        ? l10n.fcUnitKmhSuffix
        : l10n.fcUnitMsSuffix;
    final cols = <Widget>[
      _NoteCondColumn(
        icon: Icons.speed,
        value: '${units.pressureValue(c.pressureHpa).round()}',
        detail: pressureUnitLabel(l10n, units.pressure),
        trend: trend <= -1
            ? Icons.south
            : trend >= 1
                ? Icons.north
                : null,
      ),
      _NoteCondColumn(
        icon: Icons.air,
        value: calm
            ? l10n.fcWindCalm
            : '${units.windValue(c.windMs).round()} $windSuffix',
        detail: calm ? '' : windCardinalLabel(l10n, cardinalFromDeg(c.windDirDeg)),
      ),
      _NoteCondColumn(
        icon: Icons.water_drop,
        value: '${units.tempValue(c.waterTempC).round()}°',
        detail: l10n.fcChipWater,
      ),
    ];
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cols.length; i++) ...[
            if (i != 0)
              Container(
                width: 1,
                margin: const EdgeInsets.symmetric(vertical: 2),
                color: cs.outlineVariant,
              ),
            Expanded(child: cols[i]),
          ],
        ],
      ),
    );
  }
}

class _NoteCondColumn extends StatelessWidget {
  const _NoteCondColumn({
    required this.icon,
    required this.value,
    required this.detail,
    this.trend,
  });
  final IconData icon;
  final String value;
  final String detail;
  final IconData? trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: cs.primary),
                const SizedBox(width: 5),
                Text(value,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                if (trend != null) ...[
                  const SizedBox(width: 2),
                  Icon(trend, size: 13, color: cs.onSurfaceVariant),
                ],
              ],
            ),
          ),
          if (detail.isNotEmpty) ...[
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(detail,
                  style: theme.textTheme.labelSmall?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w400)),
            ),
          ],
        ],
      ),
    );
  }
}
