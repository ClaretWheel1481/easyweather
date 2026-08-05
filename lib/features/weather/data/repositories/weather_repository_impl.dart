import '../../domain/entities/city.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../../domain/repositories/city_repository.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_data_source.dart';
import '../datasources/weather_remote_data_source.dart';

/// Joins local persistence and remote weather infrastructure behind domain ports.
class CityRepositoryImpl implements CityRepository {
  final WeatherLocalDataSource _local;

  const CityRepositoryImpl(this._local);

  @override
  Future<List<City>> loadCities() => _local.loadCities();

  @override
  Future<int> loadMainCityIndex() => _local.loadMainCityIndex();

  @override
  Future<void> saveCities(List<City> cities) => _local.saveCities(cities);

  @override
  Future<void> saveMainCityIndex(int index) => _local.saveMainCityIndex(index);

  @override
  Future<bool> loadCurrentLocationEnabled() =>
      _local.loadCurrentLocationEnabled();

  @override
  Future<void> saveCurrentLocationEnabled(bool enabled) =>
      _local.saveCurrentLocationEnabled(enabled);

  @override
  Future<City?> loadCurrentLocationCity() =>
      _local.loadCurrentLocationCity();

  @override
  Future<void> saveCurrentLocationCity(City city) =>
      _local.saveCurrentLocationCity(city);
}

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherLocalDataSource _local;
  final WeatherRemoteDataSource _remote;

  const WeatherRepositoryImpl(this._local, this._remote);

  @override
  Future<bool> checkConnectivity() => _remote.checkConnectivity();

  @override
  Future<WeatherSnapshot?> loadCachedWeather(City city) =>
      _local.loadCachedWeather(city);

  @override
  Future<WeatherSnapshot?> fetchWeather(City city) async {
    final snapshot = await _remote.fetchWeather(
      city: city,
      language: await _local.apiLanguage(),
      source: await _local.weatherSource(),
      temperatureUnit: await _local.temperatureUnit(),
    );
    if (snapshot != null) await _local.cacheWeather(city, snapshot);
    return snapshot;
  }

  @override
  Future<List<City>> searchCities(String query) async => _remote.searchCities(
        query: query,
        language: await _local.apiLanguage(),
        source: await _local.weatherSource(),
      );
}
