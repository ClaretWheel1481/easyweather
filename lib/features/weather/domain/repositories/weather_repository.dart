import '../entities/city.dart';
import '../entities/weather_snapshot.dart';

/// Provides weather information independently of HTTP and local storage.
abstract interface class WeatherRepository {
  Future<List<City>> searchCities(String query);
  Future<WeatherSnapshot?> loadCachedWeather(City city);
  Future<WeatherSnapshot?> fetchWeather(City city);
  Future<bool> checkConnectivity();
}
