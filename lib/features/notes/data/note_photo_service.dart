import 'dart:io';

import 'package:image_picker/image_picker.dart';

import '../../../core/persistence/prefs_service.dart';

/// Работа с фото заметок строго на устройстве: импорт (камера/галерея) со
/// сжатием, копия в documents/notes, выдача файла по имени и удаление.
class NotePhotoService {
  NotePhotoService();

  final ImagePicker _picker = ImagePicker();

  String get _dirPath => '$appDocsPath/notes';

  /// Импортирует фото из [source], сжимает (~1600px, q85), копирует в
  /// хранилище приложения и возвращает ИМЯ файла (не путь) либо null.
  Future<String?> import(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final dir = Directory(_dirPath);
    if (!await dir.exists()) await dir.create(recursive: true);

    final ext = picked.path.contains('.') ? picked.path.split('.').last : 'jpg';
    final name = 'note_${DateTime.now().microsecondsSinceEpoch}.$ext';
    await File(picked.path).copy('$_dirPath/$name');
    return name;
  }

  /// Файл фото по имени — путь собираем на лету (см. [appDocsPath]).
  File fileFor(String name) => File('$_dirPath/$name');

  Future<void> deleteFiles(Iterable<String> names) async {
    for (final name in names) {
      final f = fileFor(name);
      try {
        if (await f.exists()) await f.delete();
      } catch (_) {
        // битый/отсутствующий файл — игнорируем.
      }
    }
  }

  /// Удаляет файлы, на которые не ссылается ни одна заметка. Запускается при
  /// старте — так удаление/отмена/брошенный черновик не оставляют мусор, а undo
  /// при удалении заметки работает (файлы не трогаем синхронно).
  Future<void> garbageCollect(Set<String> referenced) async {
    try {
      final dir = Directory(_dirPath);
      if (!await dir.exists()) return;
      await for (final entity in dir.list()) {
        if (entity is! File) continue;
        final name = entity.path.split('/').last;
        if (!referenced.contains(name)) {
          try {
            await entity.delete();
          } catch (_) {}
        }
      }
    } catch (_) {}
  }
}
