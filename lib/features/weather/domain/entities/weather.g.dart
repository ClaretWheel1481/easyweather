// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      current: json['current'] == null
          ? null
          : CurrentWeather.fromJson(json['current'] as Map<String, dynamic>),
      hourly: (json['hourly'] as List<dynamic>)
          .map((e) => HourlyWeather.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily: (json['daily'] as List<dynamic>)
          .map((e) => DailyWeather.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'current': instance.current?.toJson(),
      'hourly': instance.hourly.map((e) => e.toJson()).toList(),
      'daily': instance.daily.map((e) => e.toJson()).toList(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

CurrentWeather _$CurrentWeatherFromJson(Map<String, dynamic> json) =>
    CurrentWeather(
      temperature: (json['temperature'] as num).toDouble(),
      weatherCode: (json['weather_code'] as num).toInt(),
      windSpeed: (json['wind_speed'] as num).toDouble(),
      windDirection: (json['wind_direction'] as num?)?.toDouble(),
      apparentTemperature: (json['apparent_temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      surfacePressure: (json['surface_pressure'] as num?)?.toDouble(),
      pm25: (json['pm2_5'] as num?)?.toDouble(),
      pm10: (json['pm10'] as num?)?.toDouble(),
      ozone: (json['ozone'] as num?)?.toDouble(),
      nitrogenDioxide: (json['nitrogen_dioxide'] as num?)?.toDouble(),
      sulphurDioxide: (json['sulfur_dioxide'] as num?)?.toDouble(),
      visibility: (json['visibility'] as num?)?.toDouble(),
      aqi: (json['aqi'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CurrentWeatherToJson(CurrentWeather instance) =>
    <String, dynamic>{
      'temperature': instance.temperature,
      'weather_code': instance.weatherCode,
      'wind_speed': instance.windSpeed,
      'wind_direction': instance.windDirection,
      'apparent_temperature': instance.apparentTemperature,
      'humidity': instance.humidity,
      'surface_pressure': instance.surfacePressure,
      'pm2_5': instance.pm25,
      'pm10': instance.pm10,
      'ozone': instance.ozone,
      'nitrogen_dioxide': instance.nitrogenDioxide,
      'sulfur_dioxide': instance.sulphurDioxide,
      'visibility': instance.visibility,
      'aqi': instance.aqi,
    };

HourlyWeather _$HourlyWeatherFromJson(Map<String, dynamic> json) =>
    HourlyWeather(
      time: json['time'] as String,
      temperature: (json['temperature'] as num?)?.toDouble(),
      weatherCode: (json['weather_code'] as num?)?.toInt(),
      precipitation: (json['precipitation'] as num?)?.toDouble(),
      visibility: (json['visibility'] as num?)?.toDouble(),
      windSpeed: (json['wind_speed'] as num?)?.toDouble(),
      pressureMsl: (json['pressure_msl'] as num?)?.toDouble(),
      surfacePressure: (json['surface_pressure'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HourlyWeatherToJson(HourlyWeather instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature': instance.temperature,
      'weather_code': instance.weatherCode,
      'precipitation': instance.precipitation,
      'visibility': instance.visibility,
      'wind_speed': instance.windSpeed,
      'pressure_msl': instance.pressureMsl,
      'surface_pressure': instance.surfacePressure,
    };

DailyWeather _$DailyWeatherFromJson(Map<String, dynamic> json) => DailyWeather(
      date: json['date'] as String,
      tempMax: (json['temp_max'] as num?)?.toDouble(),
      tempMin: (json['temp_min'] as num?)?.toDouble(),
      weatherCode: (json['weather_code'] as num?)?.toInt(),
      uvIndexMax: (json['uv_index_max'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DailyWeatherToJson(DailyWeather instance) =>
    <String, dynamic>{
      'date': instance.date,
      'temp_max': instance.tempMax,
      'temp_min': instance.tempMin,
      'weather_code': instance.weatherCode,
      'uv_index_max': instance.uvIndexMax,
    };
