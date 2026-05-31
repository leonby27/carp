import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/persistence/prefs_service.dart';
import '../data/note_photo_service.dart';
import '../domain/note.dart';

final notePhotoServiceProvider =
    Provider<NotePhotoService>((ref) => NotePhotoService());

/// Заметки пользователя. Источник истины — prefs (JSON); фото лежат файлами
/// в documents и удаляются вместе с заметкой.
class NotesNotifier extends Notifier<List<Note>> {
  @override
  List<Note> build() {
    final notes = _load();
    // Подчищаем неиспользуемые фото-файлы на старте (см. garbageCollect).
    Future.microtask(_gc);
    return notes;
  }

  List<Note> _load() {
    final raw = sharedPrefs.getString(PrefsKeys.notes);
    if (raw == null) return const [];
    try {
      final list = jsonDecode(raw) as List;
      return [
        for (final e in list) Note.fromJson(e as Map<String, dynamic>),
      ]..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // новые сверху
    } catch (_) {
      return const [];
    }
  }

  Future<void> _gc() async {
    final referenced = {for (final n in state) ...n.photos};
    await ref.read(notePhotoServiceProvider).garbageCollect(referenced);
  }

  /// Создать новую или обновить существующую заметку (по id).
  void upsert(Note note) {
    final next = [...state];
    final idx = next.indexWhere((n) => n.id == note.id);
    if (idx >= 0) {
      next[idx] = note;
    } else {
      next.add(note);
    }
    next.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = next;
    _persist();
  }

  void removeById(String id) {
    state = [...state]..removeWhere((n) => n.id == id);
    _persist();
    // Файлы НЕ удаляем здесь: это даёт возможность undo. Осиротевшие фото
    // подчистит garbageCollect при следующем запуске.
  }

  /// Вернуть удалённую заметку (для undo).
  void restore(Note note) => upsert(note);

  void _persist() {
    sharedPrefs.setString(
      PrefsKeys.notes,
      jsonEncode([for (final n in state) n.toJson()]),
    );
  }
}

final notesProvider =
    NotifierProvider<NotesNotifier, List<Note>>(NotesNotifier.new);
