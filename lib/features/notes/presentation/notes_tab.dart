import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/units/units.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/states.dart';
import '../../forecast/presentation/forecast_format.dart';
import '../application/notes_providers.dart';
import '../data/note_photo_service.dart';
import '../domain/note.dart';
import 'note_edit_screen.dart';
import 'photo_viewer.dart';

String _fmtDate(DateTime t) {
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.day)}.${two(t.month)}.${t.year} · ${two(t.hour)}:${two(t.minute)}';
}

class NotesTab extends ConsumerWidget {
  const NotesTab({super.key});

  Future<void> _openEditor(BuildContext context, {Note? note}) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute(builder: (_) => NoteEditScreen(existing: note)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notes = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabNotes), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context),
        tooltip: l10n.noteNew,
        child: const Icon(Icons.add),
      ),
      body: notes.isEmpty
          ? EmptyState(
              illustration:
                  Theme.of(context).brightness == Brightness.dark
                  ? 'assets/images/notes/dark/empty.webp'
                  : 'assets/images/notes/empty.webp',
              title: l10n.notesEmptyTitle,
              subtitle: l10n.notesEmptySubtitle,
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: notes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final note = notes[i];
                return Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.endToStart,
                  background: _DeleteBg(label: l10n.commonDelete),
                  onDismissed: (_) {
                    ref.read(notesProvider.notifier).removeById(note.id);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(l10n.noteDeleted),
                          // Иначе action делает persist=true и тост не скрывается.
                          persist: false,
                          action: SnackBarAction(
                            label: l10n.commonUndo,
                            onPressed: () => ref
                                .read(notesProvider.notifier)
                                .restore(note),
                          ),
                        ),
                      );
                  },
                  child: _NoteCard(
                    note: note,
                    onTap: () => _openEditor(context, note: note),
                  ),
                );
              },
            ),
    );
  }

}

class _DeleteBg extends StatelessWidget {
  const _DeleteBg({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete_outline, color: theme.colorScheme.error),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: theme.colorScheme.error)),
        ],
      ),
    );
  }
}

class _NoteCard extends ConsumerWidget {
  const _NoteCard({required this.note, required this.onTap});
  final Note note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final units = ref.watch(unitsProvider);
    final photoService = ref.read(notePhotoServiceProvider);

    final c = note.conditions;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20),
          // Тёмная тема — без обводки; на глубоком фоне карточку выделяет
          // цвет поверхности, а нажатие — ripple от InkWell.
          border: theme.brightness == Brightness.dark
              ? null
              : Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_fmtDate(note.createdAt),
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: cs.onSurfaceVariant)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (note.text.trim().isNotEmpty)
                        Text(
                          note.text.trim(),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 15, height: 1.3),
                        ),
                      if (note.location != null) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 15, color: cs.primary),
                            const SizedBox(width: 3),
                            Flexible(
                              child: Text(
                                note.location!.isUnnamed
                                    ? l10n.locCurrent
                                    : note.location!.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium
                                    ?.copyWith(color: cs.primary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (note.photos.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  _NotePhotoThumb(
                    photos: note.photos,
                    photoService: photoService,
                  ),
                ],
              ],
            ),
            if (c != null) ...[
              const SizedBox(height: 14),
              Divider(
                  height: 1,
                  color: cs.outlineVariant.withValues(alpha: 0.5)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _WxItem(
                    icon: Icons.speed,
                    text: formatPressure(l10n, units, c.pressureHpa),
                  ),
                  const SizedBox(width: 24),
                  _WxItem(
                    icon: Icons.air,
                    text: c.windMs < 0.5
                        ? l10n.fcWindCalm
                        : formatWind(l10n, units, c.windMs),
                  ),
                  const SizedBox(width: 24),
                  _WxItem(
                    icon: Icons.water_drop,
                    text: formatTemp(units, c.waterTempC),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: biteValueColor(c.biteIndex)
                          .withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${c.biteIndex}',
                      style: TextStyle(
                        color: biteValueColor(c.biteIndex),
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Иконка + значение для снимка условий (давление/ветер/вода).
class _WxItem extends StatelessWidget {
  const _WxItem({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Text(text,
            style: theme.textTheme.labelLarge
                ?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

/// Превью первого фото со счётчиком; тап открывает галерею заметки.
class _NotePhotoThumb extends StatelessWidget {
  const _NotePhotoThumb({required this.photos, required this.photoService});
  final List<String> photos;
  final NotePhotoService photoService;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => openPhotoViewer(
        context,
        [for (final p in photos) photoService.fileFor(p)],
        0,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Image.file(
              photoService.fileFor(photos.first),
              width: 96,
              height: 88,
              fit: BoxFit.cover,
              cacheWidth: 288,
              errorBuilder: (_, _, _) => Container(
                width: 96,
                height: 88,
                color: cs.surfaceContainerHighest,
                child: Icon(Icons.broken_image_outlined,
                    color: cs.onSurfaceVariant),
              ),
            ),
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.photo_library_outlined,
                        size: 12, color: Colors.white),
                    const SizedBox(width: 3),
                    Text('${photos.length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
