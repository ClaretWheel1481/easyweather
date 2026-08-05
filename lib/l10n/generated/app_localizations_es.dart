// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get about => 'Acerca de';

  @override
  String get themeMode => 'Modo de Tema';

  @override
  String get system => 'Sistema';

  @override
  String get light => 'Claro';

  @override
  String get dark => 'Oscuro';

  @override
  String get temperatureUnit => 'Unidad de Temperatura';

  @override
  String get cityManager => 'Gestor de Ciudades';

  @override
  String get cities => 'ciudades';

  @override
  String get main => 'Ciudad predeterminada';

  @override
  String get noCitiesAdded => 'No hay ciudades agregadas';

  @override
  String deleteCityMessage(String cityName) {
    return '¿Estás seguro de eliminar \"$cityName\"?';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String get search => 'Buscar';

  @override
  String get searchHint => 'Introduce nombre de ciudad...';

  @override
  String get searchHintOnSurface => 'Introduce nombre de ciudad para buscar';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get searchError => 'Error de búsqueda';

  @override
  String get weatherUnknown => 'Desconocido';

  @override
  String get weatherClear => 'Despejado';

  @override
  String get weatherCloudy => 'Nublado';

  @override
  String get weatherOvercast => 'Nublado';

  @override
  String get weatherFoggy => 'Niebla';

  @override
  String get weatherDrizzle => 'Llovizna';

  @override
  String get weatherRain => 'Lluvia';

  @override
  String get weatherRainShower => 'Ducha de lluvia';

  @override
  String get weatherSnowy => 'Nevado';

  @override
  String get weatherThunderstorm => 'Tormenta';

  @override
  String get windDirectionNorth => 'Norte';

  @override
  String get windDirectionNortheast => 'Noreste';

  @override
  String get windDirectionEast => 'Este';

  @override
  String get windDirectionSoutheast => 'Sureste';

  @override
  String get windDirectionSouth => 'Sur';

  @override
  String get windDirectionSouthwest => 'Suroeste';

  @override
  String get windDirectionWest => 'Oeste';

  @override
  String get windDirectionNorthwest => 'Noroeste';

  @override
  String get humidity => 'Humedad';

  @override
  String get pressure => 'Presión';

  @override
  String get visibility => 'Visibilidad';

  @override
  String get feelsLike => 'Sens. Térmica';

  @override
  String get windSpeed => 'Vel. Viento';

  @override
  String get windDirection => 'Dir. Viento';

  @override
  String get precipitation => 'Precipitación';

  @override
  String get precipitationIntensity => 'Intensidad de precipitación';

  @override
  String get weatherMap => 'Mapa meteorológico';

  @override
  String get mapZoomIn => 'Acercar';

  @override
  String get mapZoomOut => 'Alejar';

  @override
  String get hourlyForecast => 'Pronóstico Horario';

  @override
  String get next7Days => '7 Días';

  @override
  String get detailedData => 'Datos Detallados';

  @override
  String get customizeHomepage => 'Personalizar la página de inicio';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get monetColor => 'Color Dinámico';

  @override
  String get retry => 'Reintentar';

  @override
  String get uvIndex => 'Índice UV';

  @override
  String get addCity => 'Agregar Ciudad';

  @override
  String get addByLocation => 'Agregar por Ubicación';

  @override
  String get currentLocation => 'Ubicación actual';

  @override
  String get locating => 'Obteniendo ubicación...';

  @override
  String get locationPermissionDenied => 'Permiso de ubicación denegado o servicio desactivado';

  @override
  String get locationNotRecognized => 'Ubicación actual no reconocida';

  @override
  String get locatingSuccess => 'Ubicación obtenida, espere...';

  @override
  String get airQuality => 'CA';

  @override
  String get airQualityGood => 'Buena';

  @override
  String get airQualityModerate => 'Moderada';

  @override
  String get airQualityFair => 'Aceptable';

  @override
  String get airQualityPoor => 'Mala';

  @override
  String get airQualityVeryPoor => 'Muy Mala';

  @override
  String get airQualityExtremelyPoor => 'Peligrosa';

  @override
  String get addHomeWidget => 'Agregar Widget al Escritorio';

  @override
  String get ignoreBatteryOptimization => 'Ignorar Optimización de Batería';

  @override
  String get iBODesc => 'Permite a Zephyr actualizar los datos meteorológicos en segundo plano';

  @override
  String get iBODisabled => 'Optimización de batería desactivada';

  @override
  String get starUs => 'Valóranos en GitHub';

  @override
  String get alert => 'Alertas';

  @override
  String get hourlyWindSpeed => 'Velocidad horaria del viento';

  @override
  String get hourlyWindSpeedDesc => 'Velocidad del viento por hora. Puede desplazarse manualmente por el gráfico para ver datos detallados sobre la velocidad del viento por hora.';

  @override
  String get hourlyPressure => 'Presión atmosférica horaria';

  @override
  String get hourlyPressureDesc => 'Presión atmosférica horaria a nivel del mar y presión superficial a nivel del suelo, hPa es la unidad de presión atmosférica. Puede deslizar manualmente el gráfico para ver los datos detallados de la presión barométrica horaria.';

  @override
  String get eAQIGrading => 'Clasificación del índice de calidad del aire';

  @override
  String get eAQIDesc => 'Cuanto mayor sea esta cifra, mayor será el daño potencial para la salud humana. Si su fuente de datos es OpenMeteo, utiliza la clasificación europea estándar de calidad del aire; de lo contrario, sigue las normas locales de clasificación de calidad.';

  @override
  String get weatherSource => 'Fuente meteorológica';

  @override
  String get customColor => 'Color personalizado';

  @override
  String get celsius => 'Celsius';

  @override
  String get fahrenheit => 'Fahrenheit';

  @override
  String get weatherDataError => 'No se pudieron obtener los datos meteorológicos.';

  @override
  String get checkNetworkAndRetry => 'Comprueba tu conexión a Internet e inténtalo de nuevo.';

  @override
  String get today => 'Hoy';

  @override
  String get customizeHomepageDesc => 'Mantén pulsado para arrastrar y reorganizar el orden. Pulsa el botón para mostrar u ocultar componentes.';

  @override
  String get customizeHomepageSaved => 'Se ha guardado el diseño de la página de inicio.';

  @override
  String get lastUpdated => 'Última actualización';

  @override
  String get selectWidgetType => 'Selecciona el tipo de widget que deseas añadir';

  @override
  String get currentWeatherWidget => 'Widget del tiempo actual';

  @override
  String get currentWeatherWidgetDesc => 'Muestra la información meteorológica actual de la ciudad principal.';

  @override
  String get forecastWeatherWidget => 'Widget de previsión del tiempo';

  @override
  String get forecastWeatherWidgetDesc => 'Muestra la previsión meteorológica a 7 días de la ciudad principal.';

  @override
  String get test => 'Test';

  @override
  String get llmConfiguration => 'Configuración de LLM';

  @override
  String get llmProviders => 'Proveedores de LLM';

  @override
  String get llmAddProvider => 'Añadir proveedor';

  @override
  String get llmNoProviders => 'Aún no hay proveedores.\nHaga clic en + para añadir uno.';

  @override
  String get llmModelName => 'Nombre del modelo';

  @override
  String get llmSaved => 'Configuración guardada';

  @override
  String get name => 'Nombre';

  @override
  String get template => 'Tipo de endpoint';

  @override
  String get testSuccess => '¡Prueba exitosa!';

  @override
  String get testError => '¡Error de prueba!';

  @override
  String get aiAdviceTitle => 'Asesoría de IA';

  @override
  String get aiAdviceNotConfigured => 'El servicio de asesoría de IA depende de LLM, no has configurado LLM';

  @override
  String get aiAdviceGoConfigure => 'Configuración de LLM';

  @override
  String get aiAdviceServiceDisabled => 'El servicio de asesoría de IA no está habilitado';

  @override
  String get aiAdviceServiceEnabled => 'El servicio de asesoría de IA está habilitado';
}
