import '../../location/domain/geo_point.dart';

/// Снимок условий на момент создания заметки — чтобы потом видеть, при какой
/// погоде клевало (журнал как инструмент обучения).
class NoteConditions {
  const NoteConditions({
    required this.biteIndex,
    required this.pressureHpa,
    required this.pressureTrend6h,
    required this.windMs,
    required this.windDirDeg,
    required this.waterTempC,
  });

  final int biteIndex;
  final double pressureHpa;
  final double pressureTrend6h;
  final double windMs;
  final double windDirDeg;
  final double waterTempC;

  Map<String, dynamic> toJson() => {
        'idx': biteIndex,
        'p': pressureHpa,
        'pt': pressureTrend6h,
        'w': windMs,
        'wd': windDirDeg,
        'wt': waterTempC,
      };

  factory NoteConditions.fromJson(Map<String, dynamic> j) => NoteConditions(
        biteIndex: (j['idx'] as num).toInt(),
        pressureHpa: (j['p'] as num).toDouble(),
        pressureTrend6h: (j['pt'] as num).toDouble(),
        windMs: (j['w'] as num).toDouble(),
        windDirDeg: (j['wd'] as num).toDouble(),
        waterTempC: (j['wt'] as num).toDouble(),
      );
}

/// Заметка рыбака: текст-наблюдение + опционально место, фото (имена файлов на
/// устройстве) и снимок условий.
class Note {
  const Note({
    required this.id,
    required this.createdAt,
    required this.text,
    this.location,
    this.photos = const [],
    this.conditions,
  });

  final String id;
  final DateTime createdAt;
  final String text;
  final GeoPoint? location;

  /// Имена файлов фото в documents/notes (не абсолютные пути).
  final List<String> photos;
  final NoteConditions? conditions;

  Note copyWith({
    String? text,
    GeoPoint? location,
    bool clearLocation = false,
    List<String>? photos,
    NoteConditions? conditions,
  }) {
    return Note(
      id: id,
      createdAt: createdAt,
      text: text ?? this.text,
      location: clearLocation ? null : (location ?? this.location),
      photos: photos ?? this.photos,
      conditions: conditions ?? this.conditions,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ts': createdAt.millisecondsSinceEpoch,
        'text': text,
        if (location != null) 'loc': location!.toJson(),
        'photos': photos,
        if (conditions != null) 'cond': conditions!.toJson(),
      };

  factory Note.fromJson(Map<String, dynamic> j) => Note(
        id: j['id'] as String,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch((j['ts'] as num).toInt()),
        text: j['text'] as String? ?? '',
        location: j['loc'] == null
            ? null
            : GeoPoint.fromJson(j['loc'] as Map<String, dynamic>),
        photos: [for (final p in (j['photos'] as List? ?? const [])) p as String],
        conditions: j['cond'] == null
            ? null
            : NoteConditions.fromJson(j['cond'] as Map<String, dynamic>),
      );
}
