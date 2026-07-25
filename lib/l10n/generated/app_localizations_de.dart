// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get about => 'Über';

  @override
  String get themeMode => 'Design-Modus';

  @override
  String get system => 'System';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get temperatureUnit => 'Temperatureinheit';

  @override
  String get cityManager => 'Städte verwalten';

  @override
  String get cities => 'Städte';

  @override
  String get main => 'Standardstadt';

  @override
  String get noCitiesAdded => 'Noch keine Städte hinzugefügt';

  @override
  String deleteCityMessage(String cityName) {
    return 'Möchten Sie \"$cityName\" wirklich löschen?';
  }

  @override
  String get delete => 'Löschen';

  @override
  String get search => 'Suchen';

  @override
  String get searchHint => 'Stadtname eingeben...';

  @override
  String get searchHintOnSurface => 'Geben Sie einen Städtenamen ein, um die Suche zu starten';

  @override
  String get noResults => 'Keine Ergebnisse gefunden';

  @override
  String get searchError => 'Suchfehler';

  @override
  String get weatherUnknown => 'Unbekannt';

  @override
  String get weatherClear => 'Klar';

  @override
  String get weatherCloudy => 'Bewölkt';

  @override
  String get weatherOvercast => 'Bewölkt';

  @override
  String get weatherFoggy => 'Nebel';

  @override
  String get weatherDrizzle => 'Nieselregen';

  @override
  String get weatherRain => 'Regen';

  @override
  String get weatherRainShower => 'Regenregen';

  @override
  String get weatherSnowy => 'Schnee';

  @override
  String get weatherThunderstorm => 'Gewitter';

  @override
  String get windDirectionNorth => 'Nord';

  @override
  String get windDirectionNortheast => 'Nordost';

  @override
  String get windDirectionEast => 'Ost';

  @override
  String get windDirectionSoutheast => 'Südost';

  @override
  String get windDirectionSouth => 'Süd';

  @override
  String get windDirectionSouthwest => 'Südwest';

  @override
  String get windDirectionWest => 'West';

  @override
  String get windDirectionNorthwest => 'Nordwest';

  @override
  String get humidity => 'Luftfeucht.';

  @override
  String get pressure => 'Luftdruck';

  @override
  String get visibility => 'Sichtweite';

  @override
  String get feelsLike => 'Gefühlt';

  @override
  String get windSpeed => 'Windgeschw.';

  @override
  String get windDirection => 'Windricht.';

  @override
  String get precipitation => 'Niederschlag';

  @override
  String get weatherMap => 'Wetterkarte';

  @override
  String get hourlyForecast => 'Stündliche Vorhersage';

  @override
  String get next7Days => 'Nächste 7 Tage';

  @override
  String get detailedData => 'Detaillierte Daten';

  @override
  String get customizeHomepage => 'Homepage anpassen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get monetColor => 'Monet-Farbe';

  @override
  String get retry => 'Wiederholen';

  @override
  String get uvIndex => 'UV-Index';

  @override
  String get addCity => 'Stadt hinzufügen';

  @override
  String get addByLocation => 'Per Standort hinzufügen';

  @override
  String get locating => 'Standort wird ermittelt...';

  @override
  String get locationPermissionDenied => 'Standortberechtigung verweigert oder Ortungsdienst nicht aktiviert';

  @override
  String get locationNotRecognized => 'Aktueller Standort nicht erkannt';

  @override
  String get locatingSuccess => 'Standort erfolgreich ermittelt, bitte warten...';

  @override
  String get airQuality => 'Luftqual.';

  @override
  String get airQualityGood => 'Gut';

  @override
  String get airQualityModerate => 'Mäßig';

  @override
  String get airQualityFair => 'Messe';

  @override
  String get airQualityPoor => 'Ungesund';

  @override
  String get airQualityVeryPoor => 'Sehr ungesund';

  @override
  String get airQualityExtremelyPoor => 'Gefährlich';

  @override
  String get addHomeWidget => 'Homescreen-Widget hinzufügen';

  @override
  String get ignoreBatteryOptimization => 'Batterieoptimierung ignorieren';

  @override
  String get iBODesc => 'Ermöglicht Zephyr die automatische Wetteraktualisierung im Hintergrund';

  @override
  String get iBODisabled => 'Batterieoptimierung ist bereits deaktiviert';

  @override
  String get starUs => 'Einen Stern auf GitHub';

  @override
  String get alert => 'Warnungen';

  @override
  String get hourlyWindSpeed => 'Stündliche Windgeschwindigkeit';

  @override
  String get hourlyWindSpeedDesc => 'Stündliche Windgeschwindigkeit. Sie können die Karte manuell scrollen, um detaillierte stündliche Windgeschwindigkeitsdaten anzuzeigen.';

  @override
  String get hourlyPressure => 'Stündlicher Luftdruck';

  @override
  String get hourlyPressureDesc => 'Stündlicher Luftdruck auf Meereshöhe und Oberflächendruck auf Bodenhöhe, hPa ist die Einheit des Luftdrucks. Sie können das Diagramm manuell verschieben, um detaillierte stündliche Luftdruckdaten zu sehen.';

  @override
  String get eAQIGrading => 'Bewertung des Luftqualitätsindex';

  @override
  String get eAQIDesc => 'Je höher dieser Wert ist, desto größer ist das potenzielle Gesundheitsrisiko für den Menschen. Wenn Ihre Datenquelle OpenMeteo ist, wird die europäische Standardklassifizierung für Luftqualität verwendet; andernfalls gelten die lokalen Qualitätsbewertungsstandards.';

  @override
  String get weatherSource => 'Wetterquelle';

  @override
  String get customColor => 'Benutzerdefinierte Farbe';

  @override
  String get celsius => 'Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';

  @override
  String get weatherDataError => 'Wetterdaten konnten nicht abgerufen werden';

  @override
  String get checkNetworkAndRetry => 'Bitte überprüfen Sie Ihre Netzwerkverbindung und versuchen Sie es erneut.';

  @override
  String get today => 'Heute';

  @override
  String get customizeHomepageDesc => 'Halten Sie gedrückt, um die Reihenfolge zu verschieben und neu anzuordnen. Tippen Sie auf die Umschaltfläche, um Komponenten ein- oder auszublenden.';

  @override
  String get customizeHomepageSaved => 'Das Layout der Startseite wurde gespeichert.';

  @override
  String get lastUpdated => 'Zuletzt aktualisiert';

  @override
  String get selectWidgetType => 'Wähle den Widget-Typ aus, den du hinzufügen möchtest';

  @override
  String get currentWeatherWidget => 'Aktuelles Wetter-Widget';

  @override
  String get currentWeatherWidgetDesc => 'Zeigt die aktuellen Wetterinformationen der Hauptstadt an.';

  @override
  String get forecastWeatherWidget => 'Wettervorhersage-Widget';

  @override
  String get forecastWeatherWidgetDesc => 'Zeigt die 7-Tage-Wettervorhersage der Hauptstadt an.';

  @override
  String get test => 'Test';

  @override
  String get llmConfiguration => 'LLM Konfiguration';

  @override
  String get llmProviders => 'LLM Anbieter';

  @override
  String get llmAddProvider => 'LLM Anbieter hinzufügen';

  @override
  String get llmNoProviders => 'Noch keine Anbieter.\nKlicken Sie auf +, um einen hinzuzufügen.';

  @override
  String get llmModelName => 'LLM Modellname';

  @override
  String get llmSaved => 'LLM gespeichert';

  @override
  String get name => 'Name';

  @override
  String get template => 'Endpunkttyp';

  @override
  String get testSuccess => 'Test erfolgreich';

  @override
  String get testError => 'Test fehlgeschlagen';

  @override
  String get aiAdviceTitle => 'KI-Beratung';

  @override
  String get aiAdviceNotConfigured => 'Der KI-Beratungsdienst basiert auf LLM, Sie haben kein LLM konfiguriert';

  @override
  String get aiAdviceGoConfigure => 'LLM-Konfiguration';

  @override
  String get aiAdviceServiceDisabled => 'KI-Beratungsdienst ist nicht aktiviert';

  @override
  String get aiAdviceServiceEnabled => 'KI-Beratungsdienst ist aktiviert';
}
