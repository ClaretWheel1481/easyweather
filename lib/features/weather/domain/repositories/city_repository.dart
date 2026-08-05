import '../entities/city.dart';

/// Persists the user's ordered city list without exposing storage details.
abstract interface class CityRepository {
  Future<List<City>> loadCities();
  Future<void> saveCities(List<City> cities);
  Future<int> loadMainCityIndex();
  Future<void> saveMainCityIndex(int index);

  // Keeps the device location separate from the user's sortable city list.
  Future<bool> loadCurrentLocationEnabled();
  Future<void> saveCurrentLocationEnabled(bool enabled);
  Future<City?> loadCurrentLocationCity();
  Future<void> saveCurrentLocationCity(City city);
}
