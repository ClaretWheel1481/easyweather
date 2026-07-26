import '../import.dart';

const weatherCacheMaxAgeMinutes = 28;
const weatherCacheMaxAge = Duration(minutes: weatherCacheMaxAgeMinutes);

// 加载缓存的天气数据(缓存28分钟避免后台刷新服务仍然加载缓存数据)
Future<Map<String, dynamic>?> loadCachedWeather(City city,
    {int maxAgeMinutes = weatherCacheMaxAgeMinutes}) async {
  final snapshot =
      await AppDependencies.weatherRepository.loadCachedWeather(city);
  return _toMap(snapshot);
}

// 缓存天气数据
Future<void> cacheWeather(City city, WeatherData data,
    List<WeatherWarning> warnings, DateTime timestamp) async {
  await AppDependencies.weatherRepository.fetchWeather(city);
}

Map<String, dynamic>? _toMap(WeatherSnapshot? snapshot) => snapshot == null
    ? null
    : {'weather': snapshot.weather, 'warnings': snapshot.warnings};
