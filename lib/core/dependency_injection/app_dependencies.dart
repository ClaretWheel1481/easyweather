import 'package:zephyr/features/weather/data/datasources/weather_local_data_source.dart';
import 'package:zephyr/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:zephyr/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:zephyr/features/weather/domain/repositories/city_repository.dart';
import 'package:zephyr/features/weather/domain/repositories/weather_repository.dart';
import 'package:zephyr/features/weather/domain/usecases/city_usecases.dart';
import 'package:zephyr/features/weather/domain/usecases/weather_usecases.dart';
import 'package:zephyr/features/settings/data/repositories/shared_preferences_app_preferences.dart';
import 'package:zephyr/features/settings/domain/repositories/app_preferences.dart';

// Application composition root. Presentation receives only domain contracts/use cases.
class AppDependencies {
  AppDependencies._();

  static final _weatherLocalDataSource = WeatherLocalDataSource();
  static final AppPreferences appPreferences =
      SharedPreferencesAppPreferences();
  static final CityRepository cityRepository =
      CityRepositoryImpl(_weatherLocalDataSource);
  static final WeatherRepository weatherRepository = WeatherRepositoryImpl(
    _weatherLocalDataSource,
    WeatherRemoteDataSource(),
  );

  static final loadSavedCities = LoadSavedCities(cityRepository);
  static final saveCity = SaveCity(cityRepository);
  static final loadWeather = LoadWeather(weatherRepository);
  static final searchCities = SearchCities(weatherRepository);
}
