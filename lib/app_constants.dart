class AppConstants {
  static const String appName = 'Zephyr';
  static const String appVersion = 'v2.2.5';
  static const String appDescription =
      'Simple and fast real-time weather forecast software.';
  static const String appUrl = 'https://github.com/LanceHuang245/Zephyr';
  static const String backendUrl = 'https://github.com/LanceHuang245/Zeus';

  static const List<String> weatherSources = [
    'OpenMeteo',
    'QWeather',
  ];

  // API url (免费提供，有一定用量限制，请勿滥用或攻击该服务器)
  static const String weatherUrl = "https://zephyr.claret.space/api/v1";

  // Forecast API Url 用于获取天气数据
  static const String forecastUrl = '$weatherUrl/weather/forecast';

  // Alerts API Url 用于获取全球天气预警
  static const String alertUrl = '$weatherUrl/weather/alert';

  // City Search API Url 用于城市搜索
  static const String searchUrl = '$weatherUrl/city/search';

  // HealthCheck API Url 用于检查服务器是否正常
  static const String healthCheckUrl = '$weatherUrl/healthcheck';

  // RainViewer API Url 用于获取最新雷达降雨图层
  static const String rainViewerUrl =
      'https://api.rainviewer.com/public/weather-maps.json';

  // OpenStreetMap Url 地图PNG链接
  static const String openStreetMapTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
}
