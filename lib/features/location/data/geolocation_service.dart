import 'package:geolocator/geolocator.dart';

import '../domain/geo_point.dart';

/// Итог попытки определить координаты устройства.
enum LocationStatus { unknown, granted, denied, serviceDisabled }

class LocationResult {
  const LocationResult(this.point, this.status);

  final GeoPoint? point;
  final LocationStatus status;
}

/// Тонкая обёртка над geolocator. Возвращает координаты устройства и статус —
/// чтобы UI мог честно показать, почему мы остались на фолбэк-локации
/// (выключен сервис / нет доступа), а не молча подсунуть Москву.
class GeolocationService {
  const GeolocationService();

  Future<LocationResult> currentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return const LocationResult(null, LocationStatus.serviceDisabled);
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return const LocationResult(null, LocationStatus.denied);
    }

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
    return LocationResult(
      GeoPoint(name: '', latitude: pos.latitude, longitude: pos.longitude),
      LocationStatus.granted,
    );
  }
}
