import '../import.dart';

const weatherCacheMaxAgeMinutes = 28;
const weatherCacheMaxAge = Duration(minutes: weatherCacheMaxAgeMinutes);

// 加载缓存的天气数据(缓存28分钟避免后台刷新服务仍然加载缓存数据)
Future<Map<String, dynamic>?> loadCachedWeather(City city,
    {int maxAgeMinutes = weatherCacheMaxAgeMinutes}) async {
  final prefs = await SharedPreferences.getInstance();
  final weatherSource = prefs.getString('weather_source') ?? 'OpenMeteo';
  final key = 'weather_${city.lat}_${city.lon}_$weatherSource';
  final str = prefs.getString(key);
  if (str == null) return null;
  final map = json.decode(str);
  final ts = map['ts'] as int?;
  if (ts != null &&
      DateTime.now().millisecondsSinceEpoch - ts > maxAgeMinutes * 60000) {
    return null;
  }
  try {
    final weather = WeatherData.fromJson(map['data']);
    if (ts != null) {
      weather.lastUpdated = DateTime.fromMillisecondsSinceEpoch(ts);
    }
    final warningsRaw = map['warnings'] as List<dynamic>?;
    final warnings = warningsRaw == null
        ? <WeatherWarning>[]
        : warningsRaw.map((e) => WeatherWarning.fromJson(e)).toList();
    return {'weather': weather, 'warnings': warnings};
  } catch (_) {
    return null;
  }
}

// 缓存天气数据
Future<void> cacheWeather(City city, WeatherData data,
    List<WeatherWarning> warnings, DateTime timestamp) async {
  final prefs = await SharedPreferences.getInstance();
  final weatherSource = prefs.getString('weather_source') ?? 'OpenMeteo';
  final key = 'weather_${city.lat}_${city.lon}_$weatherSource';
  await prefs.setString(
    key,
    json.encode({
      'data': data.toJson(),
      'warnings': warnings.map((w) => w.toJson()).toList(),
      'ts': timestamp.millisecondsSinceEpoch,
    }),
  );
}
