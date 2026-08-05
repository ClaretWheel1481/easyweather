// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get about => 'À propos';

  @override
  String get themeMode => 'Mode de thème';

  @override
  String get system => 'Système';

  @override
  String get light => 'Clair';

  @override
  String get dark => 'Sombre';

  @override
  String get temperatureUnit => 'Unité de température';

  @override
  String get cityManager => 'Gestion des villes';

  @override
  String get cities => 'Villes';

  @override
  String get main => 'Ville par défaut';

  @override
  String get noCitiesAdded => 'Aucune ville ajoutée';

  @override
  String deleteCityMessage(String cityName) {
    return 'Êtes-vous sûr de vouloir supprimer \"$cityName\" ?';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get search => 'Rechercher';

  @override
  String get searchHint => 'Nom de la ville...';

  @override
  String get searchHintOnSurface => 'Entrez un nom de ville pour commencer';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get searchError => 'Erreur de recherche';

  @override
  String get weatherUnknown => 'Inconnu';

  @override
  String get weatherClear => 'Soleil';

  @override
  String get weatherCloudy => 'Nuageux';

  @override
  String get weatherOvercast => 'Ciel couvert';

  @override
  String get weatherFoggy => 'Brouillard';

  @override
  String get weatherDrizzle => 'Bruine';

  @override
  String get weatherRain => 'Pluie';

  @override
  String get weatherRainShower => 'Douche à effet pluie';

  @override
  String get weatherSnowy => 'Neige';

  @override
  String get weatherThunderstorm => 'Orage';

  @override
  String get windDirectionNorth => 'Nord';

  @override
  String get windDirectionNortheast => 'Nord-Est';

  @override
  String get windDirectionEast => 'Est';

  @override
  String get windDirectionSoutheast => 'Sud-Est';

  @override
  String get windDirectionSouth => 'Sud';

  @override
  String get windDirectionSouthwest => 'Sud-Ouest';

  @override
  String get windDirectionWest => 'Ouest';

  @override
  String get windDirectionNorthwest => 'Nord-Ouest';

  @override
  String get humidity => 'Humidité';

  @override
  String get pressure => 'Pression';

  @override
  String get visibility => 'Visibilité';

  @override
  String get feelsLike => 'Ressenti';

  @override
  String get windSpeed => 'V. du vent';

  @override
  String get windDirection => 'Dir. du vent';

  @override
  String get precipitation => 'Précipitations';

  @override
  String get precipitationIntensity => 'Intensité des précipitations';

  @override
  String get weatherMap => 'Carte météo';

  @override
  String get mapZoomIn => 'Zoom avant';

  @override
  String get mapZoomOut => 'Zoom arrière';

  @override
  String get hourlyForecast => 'Prévision horaire';

  @override
  String get next7Days => '7 prochains jours';

  @override
  String get detailedData => 'Données détaillées';

  @override
  String get customizeHomepage => 'Personnaliser la page d\'accueil';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get monetColor => 'Couleur dynamique';

  @override
  String get retry => 'Réessayer';

  @override
  String get uvIndex => 'Indice UV';

  @override
  String get addCity => 'Ajouter une ville';

  @override
  String get addByLocation => 'Ajouter par localisation';

  @override
  String get currentLocation => 'Position actuelle';

  @override
  String get locating => 'Obtention de la localisation...';

  @override
  String get locationPermissionDenied => 'Permission de localisation refusée ou service désactivé';

  @override
  String get locationNotRecognized => 'Localisation actuelle non reconnue';

  @override
  String get locatingSuccess => 'Localisation obtenue, veuillez patienter...';

  @override
  String get airQuality => 'AQ';

  @override
  String get airQualityGood => 'Bonne';

  @override
  String get airQualityModerate => 'Modérée';

  @override
  String get airQualityFair => 'Acceptable';

  @override
  String get airQualityPoor => 'Mauvaise';

  @override
  String get airQualityVeryPoor => 'Très mauvaise';

  @override
  String get airQualityExtremelyPoor => 'Dangereuse';

  @override
  String get addHomeWidget => 'Ajouter un widget au bureau';

  @override
  String get ignoreBatteryOptimization => 'Ignorer l\'optimisation de la batterie';

  @override
  String get iBODesc => 'Permet à Zephyr de mettre à jour les données météo en arrière-plan';

  @override
  String get iBODisabled => 'L\'optimisation de la batterie est désactivée';

  @override
  String get starUs => 'Étoilez-nous sur GitHub';

  @override
  String get alert => 'Alertes';

  @override
  String get hourlyWindSpeed => 'Vitesse horaire du vent';

  @override
  String get hourlyWindSpeedDesc => 'Vitesse horaire du vent. Vous pouvez faire défiler manuellement le graphique pour afficher les données détaillées relatives à la vitesse horaire du vent.';

  @override
  String get hourlyPressure => 'Pression atmosphérique horaire';

  @override
  String get hourlyPressureDesc => 'Pression atmosphérique horaire au niveau de la mer et pression de surface au niveau du sol, hPa étant l\'unité de pression atmosphérique. Vous pouvez faire glisser manuellement le graphique pour obtenir des données détaillées sur la pression barométrique horaire.';

  @override
  String get eAQIGrading => 'Classification de l\'indice de qualité de l\'air';

  @override
  String get eAQIDesc => 'Plus ce chiffre est élevé, plus le risque pour la santé humaine est important. Si votre source de données est OpenMeteo, elle utilise la classification européenne standard de la qualité de l\'air ; sinon, elle suit les normes locales de classification de la qualité.';

  @override
  String get weatherSource => 'Source météo';

  @override
  String get customColor => 'Couleur personnalisée';

  @override
  String get celsius => 'Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';

  @override
  String get weatherDataError => 'Échec de la récupération des données météorologiques';

  @override
  String get checkNetworkAndRetry => 'Veuillez vérifier votre connexion réseau et réessayer.';

  @override
  String get today => 'Auj.';

  @override
  String get customizeHomepageDesc => 'Appuyez et maintenez enfoncé pour faire glisser et réorganiser l\'ordre. Appuyez sur le bouton pour afficher ou masquer les composants.';

  @override
  String get customizeHomepageSaved => 'La mise en page de la page d\'accueil a été enregistrée.';

  @override
  String get lastUpdated => 'Dernière mise à jour';

  @override
  String get selectWidgetType => 'Sélectionnez le type de widget à ajouter';

  @override
  String get currentWeatherWidget => 'Widget météo actuelle';

  @override
  String get currentWeatherWidgetDesc => 'Affiche les informations météo actuelles de la ville principale.';

  @override
  String get forecastWeatherWidget => 'Widget prévisions météo';

  @override
  String get forecastWeatherWidgetDesc => 'Affiche les prévisions météo sur 7 jours de la ville principale.';

  @override
  String get test => 'Test';

  @override
  String get llmConfiguration => 'Configuration LLM';

  @override
  String get llmProviders => 'Fournisseurs LLM';

  @override
  String get llmAddProvider => 'Ajouter un fournisseur';

  @override
  String get llmNoProviders => 'Aucun fournisseur pour le moment\nCliquez sur + pour en ajouter un.';

  @override
  String get llmModelName => 'Nom du modèle';

  @override
  String get llmSaved => 'Modèle enregistré';

  @override
  String get name => 'Nom';

  @override
  String get template => 'Type de point de terminaison';

  @override
  String get testSuccess => 'Test réussi';

  @override
  String get testError => 'Erreur lors du test';

  @override
  String get aiAdviceTitle => 'Conseils IA';

  @override
  String get aiAdviceNotConfigured => 'Le service de conseil IA repose sur LLM, vous n\'avez pas configuré LLM';

  @override
  String get aiAdviceGoConfigure => 'Configuration LLM';

  @override
  String get aiAdviceServiceDisabled => 'Le service de conseil IA n\'est pas activé';

  @override
  String get aiAdviceServiceEnabled => 'Le service de conseil IA est activé';
}
