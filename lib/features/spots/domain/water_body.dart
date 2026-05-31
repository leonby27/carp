/// Водоём рядом со спотом, как его видит карта OpenStreetMap. Содержит ТОЛЬКО
/// то, что реально читается из карты: тип, имя, площадь и центр. Глубину, дно,
/// рельеф и запас рыбы карта не знает — их здесь принципиально нет.
enum WaterBodyType { lake, pond, reservoir, river, canal, other }

class WaterBody {
  const WaterBody({
    required this.type,
    required this.centroidLat,
    required this.centroidLon,
    this.name,
    this.areaHa,
  });

  final WaterBodyType type;

  /// Геометрический центр полигона — нужен, чтобы понять, на каком берегу
  /// относительно водоёма стоит спот пользователя.
  final double centroidLat;
  final double centroidLon;

  /// Название из OSM, если размечено (иначе null — не выдумываем).
  final String? name;

  /// Площадь, га. Для рек/каналов и неизвестной геометрии — null.
  final double? areaHa;

  /// Стоячая вода — для неё применима логика «рыба идёт за ветром» и берегов.
  /// На реках/каналах правит течение, поэтому береговую подсказку не даём.
  bool get hasShores =>
      type == WaterBodyType.lake ||
      type == WaterBodyType.pond ||
      type == WaterBodyType.reservoir;
}
