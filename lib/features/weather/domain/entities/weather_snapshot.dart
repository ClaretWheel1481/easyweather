import 'weather.dart';
import 'weather_warning.dart';

/// A coherent weather result containing both forecast and active warnings.
class WeatherSnapshot {
  final WeatherData weather;
  final List<WeatherWarning> warnings;

  const WeatherSnapshot({required this.weather, required this.warnings});
}
