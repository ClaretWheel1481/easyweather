import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

/// Forecast and current conditions used by the weather feature.
@JsonSerializable(explicitToJson: true)
class WeatherData {
  final CurrentWeather? current;
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;
  DateTime? lastUpdated;

  WeatherData({
    this.current,
    required this.hourly,
    required this.daily,
    this.lastUpdated,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}

@JsonSerializable()
class CurrentWeather {
  final double temperature;
  @JsonKey(name: 'weather_code')
  final int weatherCode;
  @JsonKey(name: 'wind_speed')
  final double windSpeed;
  @JsonKey(name: 'wind_direction')
  final double? windDirection;
  @JsonKey(name: 'apparent_temperature')
  final double? apparentTemperature;
  final double? humidity;
  @JsonKey(name: 'surface_pressure')
  final double? surfacePressure;
  @JsonKey(name: 'pm2_5')
  final double? pm25;
  final double? pm10;
  final double? ozone;
  @JsonKey(name: 'nitrogen_dioxide')
  final double? nitrogenDioxide;
  @JsonKey(name: 'sulfur_dioxide')
  final double? sulphurDioxide;
  final double? visibility;
  final double? aqi;

  CurrentWeather({
    required this.temperature,
    required this.weatherCode,
    required this.windSpeed,
    this.windDirection,
    this.apparentTemperature,
    this.humidity,
    this.surfacePressure,
    this.pm25,
    this.pm10,
    this.ozone,
    this.nitrogenDioxide,
    this.sulphurDioxide,
    this.visibility,
    this.aqi,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentWeatherToJson(this);
}

@JsonSerializable()
class HourlyWeather {
  final String time;
  final double? temperature;
  @JsonKey(name: 'weather_code')
  final int? weatherCode;
  final double? precipitation;
  final double? visibility;
  @JsonKey(name: 'wind_speed')
  final double? windSpeed;
  @JsonKey(name: 'pressure_msl')
  final double? pressureMsl;
  @JsonKey(name: 'surface_pressure')
  final double? surfacePressure;

  HourlyWeather({
    required this.time,
    this.temperature,
    this.weatherCode,
    this.precipitation,
    this.visibility,
    this.windSpeed,
    this.pressureMsl,
    this.surfacePressure,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) =>
      _$HourlyWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$HourlyWeatherToJson(this);
}

@JsonSerializable()
class DailyWeather {
  final String date;
  @JsonKey(name: 'temp_max')
  final double? tempMax;
  @JsonKey(name: 'temp_min')
  final double? tempMin;
  @JsonKey(name: 'weather_code')
  final int? weatherCode;
  @JsonKey(name: 'uv_index_max')
  final double? uvIndexMax;

  DailyWeather({
    required this.date,
    this.tempMax,
    this.tempMin,
    this.weatherCode,
    this.uvIndexMax,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherFromJson(json);
  Map<String, dynamic> toJson() => _$DailyWeatherToJson(this);
}
