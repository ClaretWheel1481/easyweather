import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/city.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/weather_warning.dart';
import '../../domain/entities/weather_snapshot.dart';

/// SharedPreferences implementation for city and weather cache persistence.
class WeatherLocalDataSource {
  static const _citiesKey = 'cities';
  static const _mainCityIndexKey = 'main_city_index';

  Future<List<City>> loadCities() async {
    final raw = (await SharedPreferences.getInstance()).getString(_citiesKey);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(City.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveCities(List<City> cities) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _citiesKey,
      jsonEncode(cities.map((city) => city.toJson()).toList()),
    );
  }

  Future<int> loadMainCityIndex() async =>
      (await SharedPreferences.getInstance()).getInt(_mainCityIndexKey) ?? 0;

  Future<void> saveMainCityIndex(int index) async =>
      (await SharedPreferences.getInstance()).setInt(_mainCityIndexKey, index);

  Future<WeatherSnapshot?> loadCachedWeather(
    City city, {
    int maxAgeMinutes = 28,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final source = preferences.getString('weather_source') ?? 'OpenMeteo';
    final raw = preferences.getString('${city.cacheKey}_$source');
    if (raw == null) return null;
    try {
      final value = jsonDecode(raw) as Map<String, dynamic>;
      final timestamp = value['ts'] as int?;
      if (timestamp != null &&
          DateTime.now().millisecondsSinceEpoch - timestamp >
              Duration(minutes: maxAgeMinutes).inMilliseconds) {
        return null;
      }
      final weatherJson = value['data'] as Map<String, dynamic>?;
      if (weatherJson == null) return null;
      final weather = WeatherData.fromJson(weatherJson);
      weather.lastUpdated = timestamp == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(timestamp);
      final warnings = (value['warnings'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(WeatherWarning.fromJson)
          .toList();
      return WeatherSnapshot(weather: weather, warnings: warnings);
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheWeather(City city, WeatherSnapshot snapshot) async {
    final preferences = await SharedPreferences.getInstance();
    final source = preferences.getString('weather_source') ?? 'OpenMeteo';
    final timestamp = snapshot.weather.lastUpdated ?? DateTime.now();
    await preferences.setString(
      '${city.cacheKey}_$source',
      jsonEncode({
        'data': snapshot.weather.toJson(),
        'warnings':
            snapshot.warnings.map((warning) => warning.toJson()).toList(),
        'ts': timestamp.millisecondsSinceEpoch,
      }),
    );
  }

  Future<String> weatherSource() async =>
      (await SharedPreferences.getInstance()).getString('weather_source') ??
      'OpenMeteo';

  Future<String> temperatureUnit() async =>
      (await SharedPreferences.getInstance()).getString('temp_unit') ?? 'C';

  Future<String> apiLanguage() async {
    const languages = {
      'zh_CN': 'zh-hans',
      'zh_TW': 'zh-hant',
    };
    final locale =
        (await SharedPreferences.getInstance()).getString('locale_code') ??
            'en';
    return languages[locale] ?? locale;
  }
}
