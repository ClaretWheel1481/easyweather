// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get about => 'About';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get temperatureUnit => 'Temperature Unit';

  @override
  String get cityManager => 'City Manager';

  @override
  String get cities => 'cities';

  @override
  String get main => 'Default';

  @override
  String get noCitiesAdded => 'No cities added';

  @override
  String deleteCityMessage(String cityName) {
    return 'Are you sure you want to delete \"$cityName\"?';
  }

  @override
  String get delete => 'Delete';

  @override
  String get search => 'Search';

  @override
  String get searchHint => 'Enter city name...';

  @override
  String get searchHintOnSurface => 'Enter city name to start searching';

  @override
  String get noResults => 'No results found';

  @override
  String get searchError => 'Search error';

  @override
  String get weatherUnknown => 'Unknown';

  @override
  String get weatherClear => 'Clear';

  @override
  String get weatherCloudy => 'Cloudy';

  @override
  String get weatherOvercast => 'Overcast';

  @override
  String get weatherFoggy => 'Foggy';

  @override
  String get weatherDrizzle => 'Drizzle';

  @override
  String get weatherRain => 'Rain';

  @override
  String get weatherRainShower => 'Rain Shower';

  @override
  String get weatherSnowy => 'Snowy';

  @override
  String get weatherThunderstorm => 'Thunderstorm';

  @override
  String get windDirectionNorth => 'North';

  @override
  String get windDirectionNortheast => 'Northeast';

  @override
  String get windDirectionEast => 'East';

  @override
  String get windDirectionSoutheast => 'Southeast';

  @override
  String get windDirectionSouth => 'South';

  @override
  String get windDirectionSouthwest => 'Southwest';

  @override
  String get windDirectionWest => 'West';

  @override
  String get windDirectionNorthwest => 'Northwest';

  @override
  String get humidity => 'Humidity';

  @override
  String get pressure => 'Pressure';

  @override
  String get visibility => 'Visibility';

  @override
  String get feelsLike => 'Feels Like';

  @override
  String get windSpeed => 'Wind Speed';

  @override
  String get windDirection => 'Wind Direction';

  @override
  String get precipitation => 'Precipitation';

  @override
  String get precipitationIntensity => 'Precipitation Intensity';

  @override
  String get weatherMap => 'Weather Map';

  @override
  String get mapZoomIn => 'Zoom in';

  @override
  String get mapZoomOut => 'Zoom out';

  @override
  String get hourlyForecast => 'Hourly Forecast';

  @override
  String get next7Days => 'Next 7 Days';

  @override
  String get detailedData => 'Detailed Data';

  @override
  String get customizeHomepage => 'Customize Homepage';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get monetColor => 'Dynamic Color';

  @override
  String get retry => 'Retry';

  @override
  String get uvIndex => 'UV Index';

  @override
  String get addCity => 'Add City';

  @override
  String get addByLocation => 'Add by Location';

  @override
  String get locating => 'Getting location information...';

  @override
  String get locationPermissionDenied => 'Unable to get location permission or location service is disabled';

  @override
  String get locationNotRecognized => 'Unable to recognize the current location';

  @override
  String get locatingSuccess => 'Location obtained successfully, please wait...';

  @override
  String get airQuality => 'Air Quality';

  @override
  String get airQualityGood => 'Good';

  @override
  String get airQualityModerate => 'Moderate';

  @override
  String get airQualityFair => 'Fair';

  @override
  String get airQualityPoor => 'Poor';

  @override
  String get airQualityVeryPoor => 'Very Poor';

  @override
  String get airQualityExtremelyPoor => 'Hazardous';

  @override
  String get addHomeWidget => 'Add Desktop Widget';

  @override
  String get ignoreBatteryOptimization => 'Ignore Battery Optimization';

  @override
  String get iBODesc => 'Allows Zephyr to update weather data in the background';

  @override
  String get iBODisabled => 'Battery Optimization is disabled';

  @override
  String get starUs => 'Star us on GitHub';

  @override
  String get alert => 'Alerts';

  @override
  String get hourlyWindSpeed => 'Hourly Wind Speed';

  @override
  String get hourlyWindSpeedDesc => 'Hourly wind speed. You can manually scroll the chart to view detailed hourly wind speed data.';

  @override
  String get hourlyPressure => 'Hourly Air Pressure';

  @override
  String get hourlyPressureDesc => 'Hourly air pressure at sea level and surface pressure at ground level, hPa is the unit of air pressure. You can manually slide the chart to see detailed hourly barometric pressure data.';

  @override
  String get eAQIGrading => 'Air Quality Index Grading';

  @override
  String get eAQIDesc => 'The higher this figure, the greater the potential harm to human health. If your data source is OpenMeteo, it uses the European standard air quality classification; otherwise, it follows local quality grading standards.';

  @override
  String get weatherSource => 'Weather Source';

  @override
  String get customColor => 'Custom Color';

  @override
  String get celsius => 'Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';

  @override
  String get weatherDataError => 'Failed to fetch weather data';

  @override
  String get checkNetworkAndRetry => 'Please check your network connection and try again';

  @override
  String get today => 'Today';

  @override
  String get customizeHomepageDesc => 'Long press and drag to reorder items. Tap the toggle to show or hide components.';

  @override
  String get customizeHomepageSaved => 'Homepage layout saved.';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get selectWidgetType => 'Select Widget Type';

  @override
  String get currentWeatherWidget => 'Current Weather Widget';

  @override
  String get currentWeatherWidgetDesc => 'Displays the current weather conditions of the selected city.';

  @override
  String get forecastWeatherWidget => 'Forecast Widget';

  @override
  String get forecastWeatherWidgetDesc => 'Displays the weather forecast for the next 7 days.';

  @override
  String get test => 'Test';

  @override
  String get llmConfiguration => 'LLM Configuration';

  @override
  String get llmProviders => 'Providers';

  @override
  String get llmAddProvider => 'Add Provider';

  @override
  String get llmNoProviders => 'No providers yet.\nClick + to add one';

  @override
  String get llmModelName => 'Model Name';

  @override
  String get llmSaved => 'LLM configuration saved';

  @override
  String get name => 'Name';

  @override
  String get template => 'Endpoint Type';

  @override
  String get testSuccess => 'Test successful';

  @override
  String get testError => 'Test error';

  @override
  String get aiAdviceTitle => 'AI Advice';

  @override
  String get aiAdviceNotConfigured => 'You have not configured AI advice yet';

  @override
  String get aiAdviceGoConfigure => 'Configure AI';

  @override
  String get aiAdviceServiceDisabled => 'AI advice service is disabled. Please enable it in Settings.';

  @override
  String get aiAdviceServiceEnabled => 'AI advice service is enabled';
}
