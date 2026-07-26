import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr/features/weather/domain/entities/city.dart';
import 'package:zephyr/features/weather/domain/entities/weather.dart';

void main() {
  test('WeatherData serializes with its generated serializer', () {
    final weather = WeatherData(
      current: CurrentWeather(
        temperature: 20,
        weatherCode: 1,
        windSpeed: 3,
      ),
      hourly: [],
      daily: [],
    );

    final json = weather.toJson();
    final restored = WeatherData.fromJson(json);

    expect(json['current'], containsPair('weather_code', 1));
    expect(restored.current?.temperature, 20);
  });

  test('City serializes with its generated serializer', () {
    const city = City(
      name: 'Shanghai',
      admin: 'Shanghai',
      country: 'China',
      lat: 31.2304,
      lon: 121.4737,
    );

    final restored = City.fromJson(city.toJson());

    expect(restored.name, city.name);
    expect(restored.lat, city.lat);
    expect(restored.lon, city.lon);
  });
}
