import '../import.dart';

class WeatherFetchService {
  static bool _isFetching = false;

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

        final cities = await AppDependencies.cityRepository.loadCities();
        if (cities.isNotEmpty &&
            cities.first.lat == city.lat &&
            cities.first.lon == city.lon) {
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

      final cities = await AppDependencies.cityRepository.loadCities();
      if (cities.isEmpty) {
        if (kDebugMode) debugPrint('后台任务: 城市列表为空');
        return;
      }

      final mainCity = cities.first;
      await getFreshWeatherData(mainCity);
    } catch (e) {
      if (kDebugMode) debugPrint('后台任务获取天气失败: $e');
    } finally {
      _isFetching = false;
    }
  }
}
