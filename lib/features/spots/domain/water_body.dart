/// Водоём рядом со спотом, как его видит карта OpenStreetMap. Содержит ТОЛЬКО
/// то, что реально читается из карты: тип, имя, площадь, центр и грубые
/// структурные признаки рядом (притоки, острова, дамбы, тростник). Глубину,
/// дно и запас рыбы карта не знает — их здесь принципиально нет.
enum WaterBodyType { lake, pond, reservoir, river, canal, other }

class WaterBody {
  const WaterBody({
    required this.type,
    required this.centroidLat,
    required this.centroidLon,
    this.name,
    this.areaHa,
    this.islandCount = 0,
    this.inflowNearSpot = false,
    this.reedsNearSpot = false,
    this.damNearSpot = false,
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

  /// Число островов в водоёме (inner-кольца мультиполигона). У островов часто
  /// держится рыба — структура, перепад глубин, укрытие.
  final int islandCount;

  /// Рядом со спотом (~150 м) в карту вписан водоток: река/ручей/канал. Признак
  /// течения и принесённого корма — перспективная точка, особенно в жару.
  final bool inflowNearSpot;

  /// Рядом со спотом (~130 м) размечена прибрежная растительность
  /// (тростник/камыш/болото) — укрытие и кормовая база для карпа.
  final bool reedsNearSpot;

  /// Рядом со спотом (~150 м) есть плотина/дамба — резкий перепад глубин,
  /// классическая структурная точка.
  final bool damNearSpot;

  /// Стоячая вода — для неё применима логика «рыба идёт за ветром» и берегов.
  /// На реках/каналах правит течение, поэтому береговую подсказку не даём.
  bool get hasShores =>
      type == WaterBodyType.lake ||
      type == WaterBodyType.pond ||
      type == WaterBodyType.reservoir;

  /// Есть ли хоть один структурный признак, который стоит показать пользователю.
  bool get hasStructureHints =>
      islandCount > 0 || inflowNearSpot || reedsNearSpot || damNearSpot;

  /// Тип сериализуем по имени (а не index) — устойчиво к перестановке enum.
  /// Структурные флаги пишем только когда true — кэш компактнее, а отсутствие
  /// ключа в старой записи корректно читается как «нет признака».
  Map<String, dynamic> toJson() => {
        'type': type.name,
        'lat': centroidLat,
        'lon': centroidLon,
        if (name != null) 'name': name,
        if (areaHa != null) 'areaHa': areaHa,
        if (islandCount > 0) 'islands': islandCount,
        if (inflowNearSpot) 'inflow': true,
        if (reedsNearSpot) 'reeds': true,
        if (damNearSpot) 'dam': true,
      };

  static WaterBody fromJson(Map<String, dynamic> json) => WaterBody(
        type: WaterBodyType.values.byName(json['type'] as String),
        centroidLat: (json['lat'] as num).toDouble(),
        centroidLon: (json['lon'] as num).toDouble(),
        name: json['name'] as String?,
        areaHa: (json['areaHa'] as num?)?.toDouble(),
        islandCount: (json['islands'] as num?)?.toInt() ?? 0,
        inflowNearSpot: json['inflow'] as bool? ?? false,
        reedsNearSpot: json['reeds'] as bool? ?? false,
        damNearSpot: json['dam'] as bool? ?? false,
      );
}
