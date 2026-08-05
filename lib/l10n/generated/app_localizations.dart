import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get themeMode;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @temperatureUnit.
  ///
  /// In en, this message translates to:
  /// **'Temperature Unit'**
  String get temperatureUnit;

  /// No description provided for @cityManager.
  ///
  /// In en, this message translates to:
  /// **'City Manager'**
  String get cityManager;

  /// No description provided for @cities.
  ///
  /// In en, this message translates to:
  /// **'cities'**
  String get cities;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get main;

  /// No description provided for @noCitiesAdded.
  ///
  /// In en, this message translates to:
  /// **'No cities added'**
  String get noCitiesAdded;

  /// No description provided for @deleteCityMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{cityName}\"?'**
  String deleteCityMessage(String cityName);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter city name...'**
  String get searchHint;

  /// No description provided for @searchHintOnSurface.
  ///
  /// In en, this message translates to:
  /// **'Enter city name to start searching'**
  String get searchHintOnSurface;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @searchError.
  ///
  /// In en, this message translates to:
  /// **'Search error'**
  String get searchError;

  /// No description provided for @weatherUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get weatherUnknown;

  /// No description provided for @weatherClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get weatherClear;

  /// No description provided for @weatherCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherCloudy;

  /// No description provided for @weatherOvercast.
  ///
  /// In en, this message translates to:
  /// **'Overcast'**
  String get weatherOvercast;

  /// No description provided for @weatherFoggy.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get weatherFoggy;

  /// No description provided for @weatherDrizzle.
  ///
  /// In en, this message translates to:
  /// **'Drizzle'**
  String get weatherDrizzle;

  /// No description provided for @weatherRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get weatherRain;

  /// No description provided for @weatherRainShower.
  ///
  /// In en, this message translates to:
  /// **'Rain Shower'**
  String get weatherRainShower;

  /// No description provided for @weatherSnowy.
  ///
  /// In en, this message translates to:
  /// **'Snowy'**
  String get weatherSnowy;

  /// No description provided for @weatherThunderstorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get weatherThunderstorm;

  /// No description provided for @windDirectionNorth.
  ///
  /// In en, this message translates to:
  /// **'North'**
  String get windDirectionNorth;

  /// No description provided for @windDirectionNortheast.
  ///
  /// In en, this message translates to:
  /// **'Northeast'**
  String get windDirectionNortheast;

  /// No description provided for @windDirectionEast.
  ///
  /// In en, this message translates to:
  /// **'East'**
  String get windDirectionEast;

  /// No description provided for @windDirectionSoutheast.
  ///
  /// In en, this message translates to:
  /// **'Southeast'**
  String get windDirectionSoutheast;

  /// No description provided for @windDirectionSouth.
  ///
  /// In en, this message translates to:
  /// **'South'**
  String get windDirectionSouth;

  /// No description provided for @windDirectionSouthwest.
  ///
  /// In en, this message translates to:
  /// **'Southwest'**
  String get windDirectionSouthwest;

  /// No description provided for @windDirectionWest.
  ///
  /// In en, this message translates to:
  /// **'West'**
  String get windDirectionWest;

  /// No description provided for @windDirectionNorthwest.
  ///
  /// In en, this message translates to:
  /// **'Northwest'**
  String get windDirectionNorthwest;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @pressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pressure;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @feelsLike.
  ///
  /// In en, this message translates to:
  /// **'Feels Like'**
  String get feelsLike;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'Wind Speed'**
  String get windSpeed;

  /// No description provided for @windDirection.
  ///
  /// In en, this message translates to:
  /// **'Wind Direction'**
  String get windDirection;

  /// No description provided for @precipitation.
  ///
  /// In en, this message translates to:
  /// **'Precipitation'**
  String get precipitation;

  /// No description provided for @precipitationIntensity.
  ///
  /// In en, this message translates to:
  /// **'Precipitation Intensity'**
  String get precipitationIntensity;

  /// No description provided for @weatherMap.
  ///
  /// In en, this message translates to:
  /// **'Weather Map'**
  String get weatherMap;

  /// No description provided for @mapZoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get mapZoomIn;

  /// No description provided for @mapZoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get mapZoomOut;

  /// No description provided for @hourlyForecast.
  ///
  /// In en, this message translates to:
  /// **'Hourly Forecast'**
  String get hourlyForecast;

  /// No description provided for @next7Days.
  ///
  /// In en, this message translates to:
  /// **'Next 7 Days'**
  String get next7Days;

  /// No description provided for @detailedData.
  ///
  /// In en, this message translates to:
  /// **'Detailed Data'**
  String get detailedData;

  /// No description provided for @customizeHomepage.
  ///
  /// In en, this message translates to:
  /// **'Customize Homepage'**
  String get customizeHomepage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @monetColor.
  ///
  /// In en, this message translates to:
  /// **'Dynamic Color'**
  String get monetColor;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @uvIndex.
  ///
  /// In en, this message translates to:
  /// **'UV Index'**
  String get uvIndex;

  /// No description provided for @addCity.
  ///
  /// In en, this message translates to:
  /// **'Add City'**
  String get addCity;

  /// No description provided for @addByLocation.
  ///
  /// In en, this message translates to:
  /// **'Add by Location'**
  String get addByLocation;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @locating.
  ///
  /// In en, this message translates to:
  /// **'Getting location information...'**
  String get locating;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Unable to get location permission or location service is disabled'**
  String get locationPermissionDenied;

  /// No description provided for @locationNotRecognized.
  ///
  /// In en, this message translates to:
  /// **'Unable to recognize the current location'**
  String get locationNotRecognized;

  /// No description provided for @locatingSuccess.
  ///
  /// In en, this message translates to:
  /// **'Location obtained successfully, please wait...'**
  String get locatingSuccess;

  /// No description provided for @airQuality.
  ///
  /// In en, this message translates to:
  /// **'Air Quality'**
  String get airQuality;

  /// No description provided for @airQualityGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get airQualityGood;

  /// No description provided for @airQualityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get airQualityModerate;

  /// No description provided for @airQualityFair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get airQualityFair;

  /// No description provided for @airQualityPoor.
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get airQualityPoor;

  /// No description provided for @airQualityVeryPoor.
  ///
  /// In en, this message translates to:
  /// **'Very Poor'**
  String get airQualityVeryPoor;

  /// No description provided for @airQualityExtremelyPoor.
  ///
  /// In en, this message translates to:
  /// **'Hazardous'**
  String get airQualityExtremelyPoor;

  /// No description provided for @addHomeWidget.
  ///
  /// In en, this message translates to:
  /// **'Add Desktop Widget'**
  String get addHomeWidget;

  /// No description provided for @ignoreBatteryOptimization.
  ///
  /// In en, this message translates to:
  /// **'Ignore Battery Optimization'**
  String get ignoreBatteryOptimization;

  /// No description provided for @iBODesc.
  ///
  /// In en, this message translates to:
  /// **'Allows Zephyr to update weather data in the background'**
  String get iBODesc;

  /// No description provided for @iBODisabled.
  ///
  /// In en, this message translates to:
  /// **'Battery Optimization is disabled'**
  String get iBODisabled;

  /// No description provided for @starUs.
  ///
  /// In en, this message translates to:
  /// **'Star us on GitHub'**
  String get starUs;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alert;

  /// No description provided for @hourlyWindSpeed.
  ///
  /// In en, this message translates to:
  /// **'Hourly Wind Speed'**
  String get hourlyWindSpeed;

  /// No description provided for @hourlyWindSpeedDesc.
  ///
  /// In en, this message translates to:
  /// **'Hourly wind speed. You can manually scroll the chart to view detailed hourly wind speed data.'**
  String get hourlyWindSpeedDesc;

  /// No description provided for @hourlyPressure.
  ///
  /// In en, this message translates to:
  /// **'Hourly Air Pressure'**
  String get hourlyPressure;

  /// No description provided for @hourlyPressureDesc.
  ///
  /// In en, this message translates to:
  /// **'Hourly air pressure at sea level and surface pressure at ground level, hPa is the unit of air pressure. You can manually slide the chart to see detailed hourly barometric pressure data.'**
  String get hourlyPressureDesc;

  /// No description provided for @eAQIGrading.
  ///
  /// In en, this message translates to:
  /// **'Air Quality Index Grading'**
  String get eAQIGrading;

  /// No description provided for @eAQIDesc.
  ///
  /// In en, this message translates to:
  /// **'The higher this figure, the greater the potential harm to human health. If your data source is OpenMeteo, it uses the European standard air quality classification; otherwise, it follows local quality grading standards.'**
  String get eAQIDesc;

  /// No description provided for @weatherSource.
  ///
  /// In en, this message translates to:
  /// **'Weather Source'**
  String get weatherSource;

  /// No description provided for @customColor.
  ///
  /// In en, this message translates to:
  /// **'Custom Color'**
  String get customColor;

  /// No description provided for @celsius.
  ///
  /// In en, this message translates to:
  /// **'Celsius'**
  String get celsius;

  /// No description provided for @fahrenheit.
  ///
  /// In en, this message translates to:
  /// **'Fahrenheit'**
  String get fahrenheit;

  /// No description provided for @weatherDataError.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch weather data'**
  String get weatherDataError;

  /// No description provided for @checkNetworkAndRetry.
  ///
  /// In en, this message translates to:
  /// **'Please check your network connection and try again'**
  String get checkNetworkAndRetry;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @customizeHomepageDesc.
  ///
  /// In en, this message translates to:
  /// **'Long press and drag to reorder items. Tap the toggle to show or hide components.'**
  String get customizeHomepageDesc;

  /// No description provided for @customizeHomepageSaved.
  ///
  /// In en, this message translates to:
  /// **'Homepage layout saved.'**
  String get customizeHomepageSaved;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @selectWidgetType.
  ///
  /// In en, this message translates to:
  /// **'Select Widget Type'**
  String get selectWidgetType;

  /// No description provided for @currentWeatherWidget.
  ///
  /// In en, this message translates to:
  /// **'Current Weather Widget'**
  String get currentWeatherWidget;

  /// No description provided for @currentWeatherWidgetDesc.
  ///
  /// In en, this message translates to:
  /// **'Displays the current weather conditions of the selected city.'**
  String get currentWeatherWidgetDesc;

  /// No description provided for @forecastWeatherWidget.
  ///
  /// In en, this message translates to:
  /// **'Forecast Widget'**
  String get forecastWeatherWidget;

  /// No description provided for @forecastWeatherWidgetDesc.
  ///
  /// In en, this message translates to:
  /// **'Displays the weather forecast for the next 7 days.'**
  String get forecastWeatherWidgetDesc;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// No description provided for @llmConfiguration.
  ///
  /// In en, this message translates to:
  /// **'LLM Configuration'**
  String get llmConfiguration;

  /// No description provided for @llmProviders.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get llmProviders;

  /// No description provided for @llmAddProvider.
  ///
  /// In en, this message translates to:
  /// **'Add Provider'**
  String get llmAddProvider;

  /// No description provided for @llmNoProviders.
  ///
  /// In en, this message translates to:
  /// **'No providers yet.\nClick + to add one'**
  String get llmNoProviders;

  /// No description provided for @llmModelName.
  ///
  /// In en, this message translates to:
  /// **'Model Name'**
  String get llmModelName;

  /// No description provided for @llmSaved.
  ///
  /// In en, this message translates to:
  /// **'LLM configuration saved'**
  String get llmSaved;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Endpoint Type'**
  String get template;

  /// No description provided for @testSuccess.
  ///
  /// In en, this message translates to:
  /// **'Test successful'**
  String get testSuccess;

  /// No description provided for @testError.
  ///
  /// In en, this message translates to:
  /// **'Test error'**
  String get testError;

  /// No description provided for @aiAdviceTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Advice'**
  String get aiAdviceTitle;

  /// No description provided for @aiAdviceNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'You have not configured AI advice yet'**
  String get aiAdviceNotConfigured;

  /// No description provided for @aiAdviceGoConfigure.
  ///
  /// In en, this message translates to:
  /// **'Configure AI'**
  String get aiAdviceGoConfigure;

  /// No description provided for @aiAdviceServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'AI advice service is disabled. Please enable it in Settings.'**
  String get aiAdviceServiceDisabled;

  /// No description provided for @aiAdviceServiceEnabled.
  ///
  /// In en, this message translates to:
  /// **'AI advice service is enabled'**
  String get aiAdviceServiceEnabled;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'it', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'it': return AppLocalizationsIt();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
