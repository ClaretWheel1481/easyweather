import '../entities/city.dart';
import '../repositories/city_repository.dart';

/// Loads cities with the saved primary city placed first.
class LoadSavedCities {
  final CityRepository _repository;

  const LoadSavedCities(this._repository);

  Future<List<City>> call() async {
    final cities = await _repository.loadCities();
    final mainIndex = await _repository.loadMainCityIndex();
    if (mainIndex <= 0 || mainIndex >= cities.length) return cities;
    final mainCity = cities.removeAt(mainIndex);
    return [mainCity, ...cities];
  }
}

/// Adds a city once, preserving the current city order.
class SaveCity {
  final CityRepository _repository;

  const SaveCity(this._repository);

  Future<void> call(City city) async {
    final cities = await _repository.loadCities();
    if (!cities.any((item) => item.lat == city.lat && item.lon == city.lon)) {
      cities.add(city);
      await _repository.saveCities(cities);
    }
  }
}
