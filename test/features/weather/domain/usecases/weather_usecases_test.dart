import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr/features/weather/domain/entities/city.dart';
import 'package:zephyr/features/weather/domain/entities/weather.dart';
import 'package:zephyr/features/weather/domain/entities/weather_snapshot.dart';
import 'package:zephyr/features/weather/domain/repositories/weather_repository.dart';
import 'package:zephyr/features/weather/domain/usecases/weather_usecases.dart';

void main() {
  final city =
      City(name: 'Paris', country: 'France', lat: 48.8566, lon: 2.3522);
  final snapshot = WeatherSnapshot(
    weather: WeatherData(hourly: [], daily: []),
    warnings: const [],
  );

  test('LoadWeather returns fresh weather when no cache exists', () async {
    final repository = _FakeWeatherRepository(fresh: snapshot);

    final result = await LoadWeather(repository)(city);

    expect(result, same(snapshot));
    expect(repository.fetchCount, 1);
  });

  test('LoadWeather bypasses cache on an explicit refresh', () async {
    final repository =
        _FakeWeatherRepository(cached: snapshot, fresh: snapshot);

    await LoadWeather(repository)(city, forceRefresh: true);

    expect(repository.cacheCount, 0);
    expect(repository.fetchCount, 1);
  });
}

class _FakeWeatherRepository implements WeatherRepository {
  final WeatherSnapshot? cached;
  final WeatherSnapshot? fresh;
  int cacheCount = 0;
  int fetchCount = 0;

  _FakeWeatherRepository({this.cached, this.fresh});

  @override
  Future<bool> checkConnectivity() async => true;

  @override
  Future<WeatherSnapshot?> fetchWeather(City city) async {
    fetchCount++;
    return fresh;
  }

  @override
  Future<WeatherSnapshot?> loadCachedWeather(City city) async {
    cacheCount++;
    return cached;
  }

  @override
  Future<List<City>> searchCities(String query) async => [];
}
