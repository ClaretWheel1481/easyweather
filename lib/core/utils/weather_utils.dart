import '../import.dart';

const Set<int> rainWeatherCodes = <int>{
  51,
  53,
  55,
  56,
  57,
  61,
  63,
  65,
  66,
  67,
  80,
  81,
  82,
};
const Set<int> thunderWeatherCodes = <int>{95, 96, 99};

// 天气代码转图标
IconData weatherIcon(int? code) {
  if (code == null) return Icons.help_outline;
  if (code == 0) return Icons.wb_sunny;
  if ([1, 2].contains(code)) return Icons.cloud_queue;
  if (code == 3) return Icons.cloud;
  if ([45, 48].contains(code)) return Icons.foggy;
  if (rainWeatherCodes.contains(code)) {
    return Icons.grain;
  }
  if ([71, 73, 75, 77, 85, 86].contains(code)) return Icons.ac_unit;
  if (thunderWeatherCodes.contains(code)) return Icons.flash_on;
  return Icons.cloud_queue;
}

// 天气代码转描述
String weatherDesc(int? code) {
  if (code == null) return 'weatherUnknown';
  switch (code) {
    case 0:
      return 'weatherClear';
    case 1:
    case 2:
      return 'weatherCloudy';
    case 3:
      return 'weatherOvercast';
    case 45:
    case 48:
      return 'weatherFoggy';
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return 'weatherDrizzle';
    case 61:
    case 63:
    case 66:
    case 80:
    case 81:
      return 'weatherRain';
    case 65:
    case 67:
    case 82:
      return 'weatherRainShower';
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return 'weatherSnowy';
    case 95:
    case 96:
    case 99:
      return 'weatherThunderstorm';
    default:
      return 'weatherCloudy';
  }
}

// 仅中英文的天气描述
String getWeatherDescForWidget(int code, String lang) {
  final descKey = weatherDesc(code);

  switch (descKey) {
    case 'weatherUnknown':
      return lang == 'zh_CN' ? '未知' : 'Unknown';
    case 'weatherClear':
      return lang == 'zh_CN' ? '晴天' : 'Clear';
    case 'weatherCloudy':
      return lang == 'zh_CN' ? '多云' : 'Cloudy';
    case 'weatherOvercast':
      return lang == 'zh_CN' ? '阴' : 'Overcast';
    case 'weatherFoggy':
      return lang == 'zh_CN' ? '雾' : 'Foggy';
    case 'weatherDrizzle':
      return lang == 'zh_CN' ? '小雨' : 'Drizzle';
    case 'weatherRain':
      return lang == 'zh_CN' ? '雨' : 'Rain';
    case 'weatherRainShower':
      return lang == 'zh_CN' ? '暴雨' : 'RainShower';
    case 'weatherSnowy':
      return lang == 'zh_CN' ? '雪' : 'Snowy';
    case 'weatherThunderstorm':
      return lang == 'zh_CN' ? '雷暴' : 'Thunderstorm';
    default:
      return lang == 'zh_CN' ? '未知' : 'Unknown';
  }
}

// 获取国际化的天气描述
String getLocalizedWeatherDesc(BuildContext context, int? code) {
  final l10n = AppLocalizations.of(context);
  final descKey = weatherDesc(code);

  switch (descKey) {
    case 'weatherUnknown':
      return l10n.weatherUnknown;
    case 'weatherClear':
      return l10n.weatherClear;
    case 'weatherCloudy':
      return l10n.weatherCloudy;
    case 'weatherOvercast':
      return l10n.weatherOvercast;
    case 'weatherFoggy':
      return l10n.weatherFoggy;
    case 'weatherDrizzle':
      return l10n.weatherDrizzle;
    case 'weatherRain':
      return l10n.weatherRain;
    case 'weatherRainShower':
      return l10n.weatherRainShower;
    case 'weatherSnowy':
      return l10n.weatherSnowy;
    case 'weatherThunderstorm':
      return l10n.weatherThunderstorm;
    default:
      return l10n.weatherUnknown;
  }
}

// 空气质量等级
enum AirQualityLevel {
  good,
  fair,
  moderate,
  poor,
  veryPoor,
  extremelyPoor,
}

// 返回空气质量等级
AirQualityLevel getAirQualityLevel({double? euAQI}) {
  if (euAQI == null) {
    return AirQualityLevel.extremelyPoor;
  }
  if (euAQI >= 0 && euAQI <= 20) {
    return AirQualityLevel.good;
  } else if (euAQI > 20 && euAQI <= 40) {
    return AirQualityLevel.fair;
  } else if (euAQI > 40 && euAQI <= 60) {
    return AirQualityLevel.moderate;
  } else if (euAQI > 60 && euAQI <= 80) {
    return AirQualityLevel.poor;
  } else if (euAQI > 80 && euAQI <= 100) {
    return AirQualityLevel.veryPoor;
  } else {
    return AirQualityLevel.extremelyPoor;
  }
}

// 获取空气质量等级对应的图标
IconData getAirQualityIcon(AirQualityLevel level) {
  switch (level) {
    case AirQualityLevel.good:
      return Icons.sentiment_very_satisfied;
    case AirQualityLevel.fair:
      return Icons.sentiment_satisfied;
    case AirQualityLevel.moderate:
      return Icons.sentiment_neutral;
    case AirQualityLevel.poor:
      return Icons.sentiment_dissatisfied;
    case AirQualityLevel.veryPoor:
      return Icons.sentiment_very_dissatisfied;
    case AirQualityLevel.extremelyPoor:
      return Icons.warning;
  }
}

// 获取国际化的空气质量描述
String getLocalizedAirQualityDesc(BuildContext context, AirQualityLevel level) {
  final l10n = AppLocalizations.of(context);

  switch (level) {
    case AirQualityLevel.good:
      return l10n.airQualityGood;
    case AirQualityLevel.moderate:
      return l10n.airQualityModerate;
    case AirQualityLevel.fair:
      return l10n.airQualityFair;
    case AirQualityLevel.poor:
      return l10n.airQualityPoor;
    case AirQualityLevel.veryPoor:
      return l10n.airQualityVeryPoor;
    case AirQualityLevel.extremelyPoor:
      return l10n.airQualityExtremelyPoor;
  }
}

// 风向角度转文本
String windDirectionText(double deg) {
  // 0/360为北，顺时针
  const dirs = [
    'windDirectionNorth',
    'windDirectionNortheast',
    'windDirectionEast',
    'windDirectionSoutheast',
    'windDirectionSouth',
    'windDirectionSouthwest',
    'windDirectionWest',
    'windDirectionNorthwest',
    'windDirectionNorth'
  ];
  int idx = ((deg + 22.5) % 360 ~/ 45).toInt();
  return dirs[idx];
}

// 获取国际化的风向描述
String getLocalizedWindDirection(BuildContext context, double deg) {
  final l10n = AppLocalizations.of(context);
  final dirKey = windDirectionText(deg);

  switch (dirKey) {
    case 'windDirectionNorth':
      return l10n.windDirectionNorth;
    case 'windDirectionNortheast':
      return l10n.windDirectionNortheast;
    case 'windDirectionEast':
      return l10n.windDirectionEast;
    case 'windDirectionSoutheast':
      return l10n.windDirectionSoutheast;
    case 'windDirectionSouth':
      return l10n.windDirectionSouth;
    case 'windDirectionSouthwest':
      return l10n.windDirectionSouthwest;
    case 'windDirectionWest':
      return l10n.windDirectionWest;
    case 'windDirectionNorthwest':
      return l10n.windDirectionNorthwest;
    default:
      return l10n.windDirectionNorth;
  }
}

// 欧标分级颜色
Color getAqiColor(String type, double value, ColorScheme colorScheme) {
  if (type == 'aqi') {
    if (value <= 20) return Colors.green;
    if (value <= 40) return Colors.lightGreen;
    if (value <= 60) return Colors.yellow;
    if (value <= 80) return Colors.orange;
    if (value <= 100) return Colors.red;
    return Colors.brown;
  }
  if (type == 'pm2_5') {
    if (value <= 10) return Colors.green;
    if (value <= 20) return Colors.lightGreen;
    if (value <= 25) return Colors.yellow;
    if (value <= 50) return Colors.orange;
    if (value <= 75) return Colors.red;
    return Colors.brown;
  }
  if (type == 'pm10') {
    if (value <= 20) return Colors.green;
    if (value <= 40) return Colors.lightGreen;
    if (value <= 50) return Colors.yellow;
    if (value <= 100) return Colors.orange;
    if (value <= 150) return Colors.red;
    return Colors.brown;
  }
  if (type == 'no2') {
    if (value <= 40) return Colors.green;
    if (value <= 90) return Colors.lightGreen;
    if (value <= 120) return Colors.yellow;
    if (value <= 230) return Colors.orange;
    if (value <= 340) return Colors.red;
    return Colors.brown;
  }
  if (type == 'o3') {
    if (value <= 50) return Colors.green;
    if (value <= 100) return Colors.lightGreen;
    if (value <= 130) return Colors.yellow;
    if (value <= 240) return Colors.orange;
    if (value <= 380) return Colors.red;
    return Colors.brown;
  }
  if (type == 'so2') {
    if (value <= 100) return Colors.green;
    if (value <= 200) return Colors.lightGreen;
    if (value <= 350) return Colors.yellow;
    if (value <= 500) return Colors.orange;
    if (value <= 750) return Colors.red;
    return Colors.brown;
  }
  if (type == 'co') {
    if (value <= 2000) return Colors.green;
    if (value <= 4000) return Colors.lightGreen;
    if (value <= 10000) return Colors.yellow;
    if (value <= 20000) return Colors.orange;
    if (value <= 30000) return Colors.red;
    return Colors.brown;
  }
  return colorScheme.primary;
}

// 获取各污染物最大值（欧标）
double getAqiMaxValue(String type) {
  switch (type) {
    case 'pm2_5':
      return 800;
    case 'pm10':
      return 1200;
    case 'no2':
      return 1000;
    case 'o3':
      return 800;
    case 'so2':
      return 1250;
    default:
      return 100;
  }
}
