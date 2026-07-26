import '../entities/city.dart';
import '../entities/weather_snapshot.dart';
import '../repositories/weather_repository.dart';

/// Reads cached weather unless a refresh was explicitly requested.
class LoadWeather {
  final WeatherRepository _repository;

  const LoadWeather(this._repository);

  Future<WeatherSnapshot?> call(City city, {bool forceRefresh = false}) async {
    if (forceRefresh) return _repository.fetchWeather(city);
    final cached = await _repository.loadCachedWeather(city);
    if (cached != null) return cached;
    return _repository.fetchWeather(city);
  }
}

/// Searches locations through the weather domain boundary.
class SearchCities {
  final WeatherRepository _repository;

  const SearchCities(this._repository);

  Future<List<City>> call(String query) => _repository.searchCities(query);
}
