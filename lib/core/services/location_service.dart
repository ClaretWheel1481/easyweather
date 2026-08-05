import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zephyr/features/weather/domain/entities/city.dart';

class LocationService {
  static const Duration activeRefreshCooldown = Duration(minutes: 15);
  static const double _minimumLocationChangeMeters = 100;
  static final Geocoding _geocoding = Geocoding();

  static bool isLocationFixFresh(DateTime? timestamp) {
    if (timestamp == null) return false;
    final age = DateTime.now().difference(timestamp);
    return !age.isNegative && age < activeRefreshCooldown;
  }

  static bool isNewerPosition(Position position, DateTime? timestamp) =>
      timestamp == null || position.timestamp.isAfter(timestamp);

  static bool hasMeaningfulLocationChange(
    City currentCity,
    Position newPosition,
  ) {
    final distance = Geolocator.distanceBetween(
      currentCity.lat,
      currentCity.lon,
      newPosition.latitude,
      newPosition.longitude,
    );
    // Ignore GPS drift smaller than either 100 m or the reported accuracy.
    final threshold = newPosition.accuracy > _minimumLocationChangeMeters
        ? newPosition.accuracy
        : _minimumLocationChangeMeters;
    return distance > threshold;
  }

  static Future<Position?> getCurrentPosition({
    bool requestPermission = true,
    Duration? timeLimit,
  }) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // Background tasks must never open a permission prompt.
        if (!requestPermission) return null;
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(timeLimit: timeLimit),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<Position?> getLastKnownPosition() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      // Reading the platform cache avoids waking GPS during quick resumes.
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }

  static Future<City?> getCityFromPosition(Position position) async {
    try {
      final placemarks = await _geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isEmpty) return null;

      final p = placemarks.first;
      // Use the best available place name; an empty result is a failed lookup.
      final subLocality = p.subLocality?.trim();
      final locality = p.locality?.trim();
      final placeName = subLocality?.isNotEmpty == true
          ? subLocality
          : locality?.isNotEmpty == true
              ? locality
              : p.name?.trim();
      if (placeName == null || placeName.isEmpty) return null;

      return City(
        name: placeName,
        admin: p.administrativeArea,
        country: p.country ?? '',
        lat: position.latitude,
        lon: position.longitude,
      );
    } catch (_) {
      return null;
    }
  }
}
