import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zephyr/app_constants.dart';

import '../../domain/entities/city.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../../domain/entities/weather_warning.dart';

/// HTTP adapter for the public weather API.
class WeatherRemoteDataSource {
  final Dio _client;

  WeatherRemoteDataSource({Dio? client}) : _client = client ?? Dio();

  Future<WeatherSnapshot?> fetchWeather({
    required City city,
    required String language,
    required String source,
    required String temperatureUnit,
  }) async {
    try {
      final sourceParameter = _sourceParameter(source);
      final unit = _unitParameter(temperatureUnit, sourceParameter);
      final response = await _get(Uri.parse(
        '${AppConstants.forecastUrl}?latitude=${city.lat}&longitude=${city.lon}'
        '&accept-language=$language&source=$sourceParameter&unit=$unit',
      ));
      if (response.statusCode != 200 || response.data == null) return null;
      final weather = WeatherData.fromJson(
        jsonDecode(response.data!) as Map<String, dynamic>,
      );
      weather.lastUpdated = DateTime.now();
      final warnings = await fetchWarnings(city: city, language: language);
      return WeatherSnapshot(weather: weather, warnings: warnings);
    } catch (_) {
      return null;
    }
  }

  Future<List<City>> searchCities({
    required String query,
    required String language,
    required String source,
  }) async {
    try {
      final response = await _get(Uri.parse(
        '${AppConstants.searchUrl}?query=${Uri.encodeQueryComponent(query)}'
        '&accept-language=$language&source=${_sourceParameter(source)}',
      ));
      if (response.statusCode != 200 || response.data == null) return [];
      final values = jsonDecode(response.data!) as List<dynamic>;
      return values
          .whereType<Map<String, dynamic>>()
          .map((value) {
            final address =
                value['address'] as Map<String, dynamic>? ?? const {};
            return City(
              name: value['name'] as String? ?? '',
              admin: address['state'] as String?,
              country: address['country'] as String? ?? '',
              lat: double.tryParse(value['lat']?.toString() ?? '') ?? 0,
              lon: double.tryParse(value['lon']?.toString() ?? '') ?? 0,
            );
          })
          .where((city) => city.lat != 0 && city.lon != 0)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<WeatherWarning>> fetchWarnings({
    required City city,
    required String language,
  }) async {
    try {
      final response = await _get(Uri.parse(
        '${AppConstants.alertUrl}?location=${city.lon},${city.lat}&lang=$language',
      ));
      if (response.statusCode != 200 || response.data == null) return [];
      final value = jsonDecode(response.data!) as Map<String, dynamic>;
      if (value['code'] != '200') return [];
      return (value['warning'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(WeatherWarning.fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> checkConnectivity() async {
    try {
      final response = await _get(
        Uri.parse(AppConstants.healthCheckUrl),
        headers: {
          'Application': 'Zephyr',
          'User-Agent': 'Zephyr/${AppConstants.appVersion}'
        },
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<Response<String>> _get(Uri uri, {Map<String, String>? headers}) =>
      _client
          .getUri<String>(
            uri,
            options: Options(
              headers: headers,
              responseType: ResponseType.plain,
              validateStatus: (_) => true,
            ),
          )
          .timeout(const Duration(seconds: 8));

  String? _sourceParameter(String source) => switch (source) {
        'QWeather' => 'qweather',
        'OpenMeteo' => 'om',
        _ => null,
      };

  String _unitParameter(String unit, String? source) => source == 'om'
      ? (unit == 'F' ? 'fahrenheit' : 'celsius')
      : (unit == 'F' ? 'i' : 'm');
}
