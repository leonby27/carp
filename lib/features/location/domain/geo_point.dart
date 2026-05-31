/// Географическая точка прогноза: координаты + человекочитаемое имя.
/// Общая для табов «Прогноз» и «Споты». Пустое [name] означает «текущее
/// место» (определено по геолокации, без своего названия) — UI подставит
/// локализованную подпись.
class GeoPoint {
  const GeoPoint({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;

  bool get isUnnamed => name.trim().isEmpty;

  GeoPoint copyWith({String? name, double? latitude, double? longitude}) {
    return GeoPoint(
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'lat': latitude,
        'lon': longitude,
      };

  factory GeoPoint.fromJson(Map<String, dynamic> json) => GeoPoint(
        name: json['name'] as String? ?? '',
        latitude: (json['lat'] as num).toDouble(),
        longitude: (json['lon'] as num).toDouble(),
      );

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      other.name == name &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(name, latitude, longitude);
}

/// Фолбэк-локация до того, как сработает геолокация или пользователь выберет
/// спот на карте. Координаты — Москва.
const kDefaultLocation = GeoPoint(name: '', latitude: 55.7558, longitude: 37.6173);
