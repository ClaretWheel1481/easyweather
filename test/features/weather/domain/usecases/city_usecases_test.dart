import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr/features/weather/domain/entities/city.dart';
import 'package:zephyr/features/weather/domain/repositories/city_repository.dart';
import 'package:zephyr/features/weather/domain/usecases/city_usecases.dart';

void main() {
  final berlin = City(
    name: 'Berlin',
    country: 'Germany',
    lat: 52.52,
    lon: 13.405,
  );
  final paris = City(
    name: 'Paris',
    country: 'France',
    lat: 48.8566,
    lon: 2.3522,
  );

  test('LoadSavedCities puts the saved primary city first', () async {
    final repository =
        _FakeCityRepository(cities: [berlin, paris], mainIndex: 1);

    final cities = await LoadSavedCities(repository)();

    expect(cities, [paris, berlin]);
  });

  test('SaveCity does not persist an existing location twice', () async {
    final repository = _FakeCityRepository(cities: [berlin]);

    await SaveCity(repository)(berlin);

    expect(repository.savedCities, isNull);
  });

  test('SaveCity persists a new location', () async {
    final repository = _FakeCityRepository(cities: [berlin]);

    await SaveCity(repository)(paris);

    expect(repository.savedCities, [berlin, paris]);
  });
}

class _FakeCityRepository implements CityRepository {
  final List<City> cities;
  final int mainIndex;
  List<City>? savedCities;

  _FakeCityRepository({required this.cities, this.mainIndex = 0});

  @override
  Future<List<City>> loadCities() async => List.of(cities);

  @override
  Future<int> loadMainCityIndex() async => mainIndex;

  @override
  Future<void> saveCities(List<City> cities) async {
    savedCities = List.of(cities);
  }

  @override
  Future<void> saveMainCityIndex(int index) async {}
}
