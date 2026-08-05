import '../import.dart';
import 'location_service.dart';

class WeatherFetchService {
  static bool _isFetching = false;

  static Future<City?> _loadPrimaryCity({
    required bool refreshCurrentLocation,
  }) async {
    final repository = AppDependencies.cityRepository;
    final locationEnabled = await repository.loadCurrentLocationEnabled();

    if (locationEnabled) {
      var locationCity = await repository.loadCurrentLocationCity();
      if (refreshCurrentLocation) {
        // Prefer a fresh background fix, then fall back to the persisted fix.
        final position = await LocationService.getCurrentPosition(
          requestPermission: false,
          timeLimit: const Duration(seconds: 15),
        );
        if (position != null) {
          final locationChanged = locationCity == null ||
              LocationService.hasMeaningfulLocationChange(
                locationCity,
                position,
              );
          if (locationChanged) {
            final updatedCity =
                await LocationService.getCityFromPosition(position);
            if (updatedCity != null) {
              await repository.saveCurrentLocationCity(updatedCity);
              locationCity = updatedCity;
            }
          }
        }
      }
      if (locationCity != null) return locationCity;
    }

    final cities = await repository.loadCities();
    return cities.isEmpty ? null : cities.first;
  }

  static Future<Map<String, dynamic>?> getFreshWeatherData(City city) async {
    try {
      if (kDebugMode) debugPrint('获取城市天气: ${city.name}');

      final snapshot =
          await AppDependencies.weatherRepository.fetchWeather(city);
      if (snapshot != null) {
        final weather = snapshot.weather;
        final warnings = snapshot.warnings;
        await NotificationService().showWarningNotifications(warnings);
        if (kDebugMode) debugPrint('天气数据获取并缓存成功 for ${city.name}');

        final primaryCity =
            await _loadPrimaryCity(refreshCurrentLocation: false);
        if (primaryCity?.lat == city.lat && primaryCity?.lon == city.lon) {
          await ForecastWidgetService.updateAllWidgets(
            city: city,
            weatherData: weather,
          );
        }

        return {'weather': weather, 'warnings': warnings};
      } else {
        if (kDebugMode) debugPrint('天气数据获取失败 for ${city.name}');
        return null;
      }
    } catch (e) {
      if (kDebugMode) debugPrint('获取天气失败 for ${city.name}: $e');
      return null;
    }
  }

  static Future<void> fetchAndCacheWeather() async {
    if (_isFetching) {
      if (kDebugMode) debugPrint('已经在获取天气数据，跳过本次请求');
      return;
    }

    _isFetching = true;
    try {
      if (kDebugMode) debugPrint('后台任务开始获取天气数据...');

      final mainCity =
          await _loadPrimaryCity(refreshCurrentLocation: true);
      if (mainCity == null) {
        if (kDebugMode) debugPrint('后台任务: 城市列表为空');
        return;
      }

      await getFreshWeatherData(mainCity);
    } catch (e) {
      if (kDebugMode) debugPrint('后台任务获取天气失败: $e');
    } finally {
      _isFetching = false;
    }
  }
}
