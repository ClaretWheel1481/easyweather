// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get about => 'Informazioni';

  @override
  String get themeMode => 'Modalità Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Chiaro';

  @override
  String get dark => 'Scuro';

  @override
  String get temperatureUnit => 'Unità di Temperatura';

  @override
  String get cityManager => 'Gestore Città';

  @override
  String get cities => 'città';

  @override
  String get main => 'Città predefinita';

  @override
  String get noCitiesAdded => 'Nessuna città aggiunta';

  @override
  String deleteCityMessage(String cityName) {
    return 'Sei sicuro di voler eliminare \"$cityName\"?';
  }

  @override
  String get delete => 'Elimina';

  @override
  String get search => 'Cerca';

  @override
  String get searchHint => 'Inserisci nome città...';

  @override
  String get searchHintOnSurface => 'Inserisci nome città per iniziare la ricerca';

  @override
  String get noResults => 'Nessun risultato trovato';

  @override
  String get searchError => 'Errore di ricerca';

  @override
  String get weatherUnknown => 'Sconosciuto';

  @override
  String get weatherClear => 'Sereno';

  @override
  String get weatherCloudy => 'Nuvoloso';

  @override
  String get weatherOvercast => 'Giornata nuvolosa';

  @override
  String get weatherFoggy => 'Nebbia';

  @override
  String get weatherDrizzle => 'Pioggerella';

  @override
  String get weatherRain => 'Pioggia';

  @override
  String get weatherRainShower => 'Doccia a pioggia';

  @override
  String get weatherSnowy => 'Neve';

  @override
  String get weatherThunderstorm => 'Temporale';

  @override
  String get windDirectionNorth => 'Nord';

  @override
  String get windDirectionNortheast => 'Nordest';

  @override
  String get windDirectionEast => 'Est';

  @override
  String get windDirectionSoutheast => 'Sudest';

  @override
  String get windDirectionSouth => 'Sud';

  @override
  String get windDirectionSouthwest => 'Sudovest';

  @override
  String get windDirectionWest => 'Ovest';

  @override
  String get windDirectionNorthwest => 'Nordovest';

  @override
  String get humidity => 'Umidità';

  @override
  String get pressure => 'Pressione';

  @override
  String get visibility => 'Visibilità';

  @override
  String get feelsLike => 'Percepita';

  @override
  String get windSpeed => 'Vento';

  @override
  String get windDirection => 'Direzione';

  @override
  String get precipitation => 'Precip.';

  @override
  String get weatherMap => 'Mappa meteo';

  @override
  String get hourlyForecast => 'Previsioni Orarie';

  @override
  String get next7Days => 'Prossimi 7 Giorni';

  @override
  String get detailedData => 'Dati Dettagliati';

  @override
  String get customizeHomepage => 'Personalizza la homepage';

  @override
  String get settings => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get monetColor => 'Colore Dynamico';

  @override
  String get retry => 'Riprova';

  @override
  String get uvIndex => 'Indice UV';

  @override
  String get addCity => 'Aggiungi Città';

  @override
  String get addByLocation => 'Aggiungi per Posizione';

  @override
  String get locating => 'Ottenimento informazioni posizione...';

  @override
  String get locationPermissionDenied => 'Impossibile ottenere il permesso di posizione o il servizio di posizione è disabilitato';

  @override
  String get locationNotRecognized => 'Impossibile riconoscere la posizione corrente';

  @override
  String get locatingSuccess => 'Posizione ottenuta con successo, attendere...';

  @override
  String get airQuality => 'QA';

  @override
  String get airQualityGood => 'Buona';

  @override
  String get airQualityModerate => 'Moderata';

  @override
  String get airQualityFair => 'Discreta';

  @override
  String get airQualityPoor => 'Scarsa';

  @override
  String get airQualityVeryPoor => 'Molto Scarsa';

  @override
  String get airQualityExtremelyPoor => 'Pericolosa';

  @override
  String get addHomeWidget => 'Aggiungi widget per il desktop';

  @override
  String get ignoreBatteryOptimization => 'Ignora Ottimizzazione Batteria';

  @override
  String get iBODesc => 'Permette a Zephyr di aggiornare i dati meteo in background';

  @override
  String get iBODisabled => 'Ottimizzazione della batteria disattivata';

  @override
  String get starUs => 'Dateci una stella';

  @override
  String get alert => 'Avvertire';

  @override
  String get hourlyWindSpeed => 'Velocità oraria del vento';

  @override
  String get hourlyWindSpeedDesc => 'Velocità del vento oraria. È possibile scorrere manualmente il grafico per visualizzare i dati dettagliati relativi alla velocità del vento oraria.';

  @override
  String get hourlyPressure => 'Pressione oraria dell\'aria';

  @override
  String get hourlyPressureDesc => 'Pressione oraria dell\'aria al livello del mare e pressione superficiale al livello del suolo, hPa è l\'unità di misura della pressione dell\'aria. È possibile far scorrere manualmente il grafico per visualizzare i dati dettagliati della pressione barometrica oraria.';

  @override
  String get eAQIGrading => 'Classificazione dell\'indice di qualità dell\'aria';

  @override
  String get eAQIDesc => 'Più alto è questo valore, maggiore è il potenziale danno per la salute umana. Se la fonte dei dati è OpenMeteo, viene utilizzata la classificazione europea standard della qualità dell\'aria; in caso contrario, vengono seguiti gli standard locali di classificazione della qualità.';

  @override
  String get weatherSource => 'Fonte meteorologica';

  @override
  String get customColor => 'Colore personalizzato';

  @override
  String get celsius => 'Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';

  @override
  String get weatherDataError => 'Impossibile recuperare i dati meteorologici';

  @override
  String get checkNetworkAndRetry => 'Controlla la tua connessione di rete e riprova.';

  @override
  String get today => 'Oggi';

  @override
  String get customizeHomepageDesc => 'Tieni premuto per trascinare e riorganizzare l\'ordine. Tocca il pulsante per mostrare o nascondere i componenti.';

  @override
  String get customizeHomepageSaved => 'Il layout della homepage è stato salvato.';

  @override
  String get lastUpdated => 'Ultimo aggiornamento';

  @override
  String get selectWidgetType => 'Seleziona il tipo di widget da aggiungere';

  @override
  String get currentWeatherWidget => 'Widget meteo attuale';

  @override
  String get currentWeatherWidgetDesc => 'Mostra le informazioni meteo attuali della città principale.';

  @override
  String get forecastWeatherWidget => 'Widget previsioni meteo';

  @override
  String get forecastWeatherWidgetDesc => 'Mostra le previsioni meteo a 7 giorni della città principale.';

  @override
  String get test => 'Test';

  @override
  String get llmConfiguration => 'Configurazione LLM';

  @override
  String get llmProviders => 'Fornitori LLM';

  @override
  String get llmAddProvider => 'Aggiungi fornitore LLM';

  @override
  String get llmNoProviders => 'Nessun fornitore ancora disponibile\nClicca su + per aggiungerne uno.';

  @override
  String get llmModelName => 'Nome modello';

  @override
  String get llmSaved => 'Configurazione salvata';

  @override
  String get name => 'Nome';

  @override
  String get template => 'Tipo di endpoint';

  @override
  String get testSuccess => 'Test completato con successo';

  @override
  String get testError => 'Test fallito';

  @override
  String get aiAdviceTitle => 'Consulenza IA';

  @override
  String get aiAdviceNotConfigured => 'Il servizio di consulenza IA si basa su LLM, non hai configurato LLM';

  @override
  String get aiAdviceGoConfigure => 'Configurazione LLM';

  @override
  String get aiAdviceServiceDisabled => 'Il servizio di consulenza IA non è abilitato';

  @override
  String get aiAdviceServiceEnabled => 'Il servizio di consulenza IA è abilitato';
}
