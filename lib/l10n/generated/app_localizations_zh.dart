// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get about => '关于';

  @override
  String get themeMode => '主题';

  @override
  String get system => '系统';

  @override
  String get light => '浅色';

  @override
  String get dark => '深色';

  @override
  String get temperatureUnit => '温度单位';

  @override
  String get cityManager => '城市管理';

  @override
  String get cities => '个城市';

  @override
  String get main => '默认城市';

  @override
  String get noCitiesAdded => '暂无城市';

  @override
  String deleteCityMessage(String cityName) {
    return '确定要删除 \"$cityName\" 吗？';
  }

  @override
  String get delete => '删除';

  @override
  String get search => '搜索';

  @override
  String get searchHint => '输入城市名称...';

  @override
  String get searchHintOnSurface => '输入城市名称以开始搜索';

  @override
  String get noResults => '未找到结果';

  @override
  String get searchError => '搜索错误';

  @override
  String get weatherUnknown => '未知';

  @override
  String get weatherClear => '晴';

  @override
  String get weatherCloudy => '多云';

  @override
  String get weatherOvercast => '阴天';

  @override
  String get weatherFoggy => '有雾';

  @override
  String get weatherDrizzle => '细雨';

  @override
  String get weatherRain => '雨';

  @override
  String get weatherRainShower => '大雨';

  @override
  String get weatherSnowy => '雪';

  @override
  String get weatherThunderstorm => '雷暴';

  @override
  String get windDirectionNorth => '北';

  @override
  String get windDirectionNortheast => '东北';

  @override
  String get windDirectionEast => '东';

  @override
  String get windDirectionSoutheast => '东南';

  @override
  String get windDirectionSouth => '南';

  @override
  String get windDirectionSouthwest => '西南';

  @override
  String get windDirectionWest => '西';

  @override
  String get windDirectionNorthwest => '西北';

  @override
  String get humidity => '湿度';

  @override
  String get pressure => '气压';

  @override
  String get visibility => '能见度';

  @override
  String get feelsLike => '体感';

  @override
  String get windSpeed => '风速';

  @override
  String get windDirection => '风向';

  @override
  String get precipitation => '降水量';

  @override
  String get precipitationIntensity => '降水强度';

  @override
  String get weatherMap => '天气地图';

  @override
  String get mapZoomIn => '放大';

  @override
  String get mapZoomOut => '缩小';

  @override
  String get hourlyForecast => '逐小时预报';

  @override
  String get next7Days => '未来7天';

  @override
  String get detailedData => '详细数据';

  @override
  String get customizeHomepage => '自定义首页';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get monetColor => 'Monet取色';

  @override
  String get retry => '重试';

  @override
  String get uvIndex => '紫外线指数';

  @override
  String get addCity => '添加城市';

  @override
  String get addByLocation => '定位添加';

  @override
  String get locating => '正在获取位置信息...';

  @override
  String get locationPermissionDenied => '无法获取定位权限或定位服务未开启';

  @override
  String get locationNotRecognized => '无法获取当前位置';

  @override
  String get locatingSuccess => '获取位置信息成功，请稍后...';

  @override
  String get airQuality => '空气质量';

  @override
  String get airQualityGood => '优';

  @override
  String get airQualityModerate => '良';

  @override
  String get airQualityFair => '一般';

  @override
  String get airQualityPoor => '较差';

  @override
  String get airQualityVeryPoor => '极差';

  @override
  String get airQualityExtremelyPoor => '危险';

  @override
  String get addHomeWidget => '添加桌面小部件';

  @override
  String get ignoreBatteryOptimization => '忽略电池优化';

  @override
  String get iBODesc => '使Zephyr在后台时可自动更新天气';

  @override
  String get iBODisabled => '电池优化已关闭';

  @override
  String get starUs => '给我们点个Star';

  @override
  String get alert => '预警';

  @override
  String get hourlyWindSpeed => '逐小时风速';

  @override
  String get hourlyWindSpeedDesc => '每小时的风速。可滑动图表查看每小时的详细风速数据。';

  @override
  String get hourlyPressure => '逐小时气压';

  @override
  String get hourlyPressureDesc => '每小时的海平面气压与地面气压。可滑动图表查看每小时的详细气压数据。';

  @override
  String get eAQIGrading => '空气质量分级';

  @override
  String get eAQIDesc => '该数值越高，对人体健康的潜在危害就越大。若数据源为OpenMeteo，则采用欧洲标准空气质量分类；否则遵循当地质量分级标准。';

  @override
  String get weatherSource => '自定义天气源';

  @override
  String get customColor => '自定义颜色';

  @override
  String get celsius => '摄氏度';

  @override
  String get fahrenheit => '华氏度';

  @override
  String get weatherDataError => '天气数据获取失败';

  @override
  String get checkNetworkAndRetry => '请检查您的网络连接并重试';

  @override
  String get today => '今日';

  @override
  String get customizeHomepageDesc => '长按拖动来调整顺序，点击开关显示或隐藏组件。';

  @override
  String get customizeHomepageSaved => '主页布局已保存。';

  @override
  String get lastUpdated => '上次更新';

  @override
  String get selectWidgetType => '选择要添加的小部件';

  @override
  String get currentWeatherWidget => '当前天气小部件';

  @override
  String get currentWeatherWidgetDesc => '显示主城市的当前天气信息。';

  @override
  String get forecastWeatherWidget => '预报天气小部件';

  @override
  String get forecastWeatherWidgetDesc => '显示主城市的7日天气预报。';

  @override
  String get test => '测试';

  @override
  String get llmConfiguration => 'LLM配置';

  @override
  String get llmProviders => 'LLM供应商';

  @override
  String get llmAddProvider => '添加供应商';

  @override
  String get llmNoProviders => '暂无供应商\n点击添加按钮添加供应商';

  @override
  String get llmModelName => '模型名称';

  @override
  String get llmSaved => 'LLM配置已保存';

  @override
  String get name => '名称';

  @override
  String get template => '端点类型';

  @override
  String get testSuccess => '测试成功';

  @override
  String get testError => '测试失败';

  @override
  String get aiAdviceTitle => '智能天气建议';

  @override
  String get aiAdviceNotConfigured => '智能天气建议服务依赖于您配置的LLM服务，您还没有配置';

  @override
  String get aiAdviceGoConfigure => 'LLM配置';

  @override
  String get aiAdviceServiceDisabled => '智能天气建议服务未启用';

  @override
  String get aiAdviceServiceEnabled => '智能天气建议服务已启用';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw(): super('zh_TW');

  @override
  String get about => '關於';

  @override
  String get themeMode => '主題模式';

  @override
  String get system => '系統';

  @override
  String get light => '淺色';

  @override
  String get dark => '深色';

  @override
  String get temperatureUnit => '溫度單位';

  @override
  String get cityManager => '城市管理';

  @override
  String get cities => '个城市';

  @override
  String get main => '預設城市';

  @override
  String get noCitiesAdded => '暫無已添加的城市';

  @override
  String deleteCityMessage(String cityName) {
    return '確定要刪除 \"$cityName\" 嗎？';
  }

  @override
  String get delete => '刪除';

  @override
  String get search => '搜索';

  @override
  String get searchHint => '輸入城市名稱...';

  @override
  String get searchHintOnSurface => '輸入城市名稱以開始搜索';

  @override
  String get noResults => '未找到結果';

  @override
  String get searchError => '搜索錯誤';

  @override
  String get weatherUnknown => '未知';

  @override
  String get weatherClear => '晴';

  @override
  String get weatherCloudy => '多雲';

  @override
  String get weatherOvercast => '陰';

  @override
  String get weatherFoggy => '有霧';

  @override
  String get weatherDrizzle => '细雨';

  @override
  String get weatherRain => '雨';

  @override
  String get weatherRainShower => '大雨';

  @override
  String get weatherSnowy => '雪';

  @override
  String get weatherThunderstorm => '雷暴';

  @override
  String get windDirectionNorth => '北';

  @override
  String get windDirectionNortheast => '東北';

  @override
  String get windDirectionEast => '東';

  @override
  String get windDirectionSoutheast => '東南';

  @override
  String get windDirectionSouth => '南';

  @override
  String get windDirectionSouthwest => '西南';

  @override
  String get windDirectionWest => '西';

  @override
  String get windDirectionNorthwest => '西北';

  @override
  String get humidity => '濕度';

  @override
  String get pressure => '氣壓';

  @override
  String get visibility => '能見度';

  @override
  String get feelsLike => '體感';

  @override
  String get windSpeed => '風速';

  @override
  String get windDirection => '風向';

  @override
  String get precipitation => '降水量';

  @override
  String get precipitationIntensity => '降水強度';

  @override
  String get weatherMap => '天氣地圖';

  @override
  String get mapZoomIn => '放大';

  @override
  String get mapZoomOut => '縮小';

  @override
  String get hourlyForecast => '逐小時預報';

  @override
  String get next7Days => '未來7天';

  @override
  String get detailedData => '詳細數據';

  @override
  String get customizeHomepage => '自定主頁';

  @override
  String get settings => '設置';

  @override
  String get language => '語言';

  @override
  String get monetColor => 'Monet取色';

  @override
  String get retry => '重試';

  @override
  String get uvIndex => '紫外線指數';

  @override
  String get addCity => '添加城市';

  @override
  String get addByLocation => '定位添加';

  @override
  String get locating => '正在獲取位置信息...';

  @override
  String get locationPermissionDenied => '無法獲取定位權限或定位服務未開啟';

  @override
  String get locationNotRecognized => '無法識別當前位置';

  @override
  String get locatingSuccess => '獲取位置信息成功，請稍後...';

  @override
  String get airQuality => '空氣質量';

  @override
  String get airQualityGood => '優';

  @override
  String get airQualityModerate => '良';

  @override
  String get airQualityFair => '一般';

  @override
  String get airQualityPoor => '較差';

  @override
  String get airQualityVeryPoor => '極差';

  @override
  String get airQualityExtremelyPoor => '危險';

  @override
  String get addHomeWidget => '添加小部件至桌面';

  @override
  String get ignoreBatteryOptimization => '忽略電池優化';

  @override
  String get iBODesc => '允許 Zephyr 在後台自動更新天氣數據';

  @override
  String get iBODisabled => '電池優化已禁用';

  @override
  String get starUs => '給我们點個Star';

  @override
  String get alert => '預警';

  @override
  String get hourlyWindSpeed => '逐小時風速';

  @override
  String get hourlyWindSpeedDesc => '每小時風速。可以手動滑動图表查看每小时的详细风速数据。';

  @override
  String get hourlyPressure => '逐小時氣壓';

  @override
  String get hourlyPressureDesc => '每小時的海平面氣壓和地面氣壓，hPa為氣壓單位。可以手動滑動图表查看每小时的详细氣壓数据。';

  @override
  String get eAQIGrading => '空氣品質分級';

  @override
  String get eAQIDesc => '此數值越高，對人體健康的潛在危害就越大。若您的數據來源為OpenMeteo，則採用歐洲標準空氣品質分級；否則將遵循當地品質分級標準。';

  @override
  String get weatherSource => '自定天氣源';

  @override
  String get customColor => '自定顏色';

  @override
  String get celsius => '攝氏度';

  @override
  String get fahrenheit => '華氏度';

  @override
  String get weatherDataError => '無法獲取天氣數據';

  @override
  String get checkNetworkAndRetry => '請檢查您的網路設定後重試';

  @override
  String get today => '今日';

  @override
  String get customizeHomepageDesc => '長按拖動來調整組件順序，點擊開關顯示或隱藏組件。';

  @override
  String get customizeHomepageSaved => '主頁佈局已保存。';

  @override
  String get lastUpdated => '最後更新';

  @override
  String get selectWidgetType => '選擇要添加的小部件';

  @override
  String get currentWeatherWidget => '當前天氣小部件';

  @override
  String get currentWeatherWidgetDesc => '顯示主城市的當前天氣資訊。';

  @override
  String get forecastWeatherWidget => '預報天氣小部件';

  @override
  String get forecastWeatherWidgetDesc => '顯示主城市的7日天氣預報。';

  @override
  String get test => '測試';

  @override
  String get llmConfiguration => 'LLM配置';

  @override
  String get llmProviders => 'LLM提供者';

  @override
  String get llmAddProvider => '添加LLM提供者';

  @override
  String get llmNoProviders => '暫無已添加的LLM提供者\n點擊右上角添加按鈕添加提供者';

  @override
  String get llmModelName => 'LLM模型名稱';

  @override
  String get llmSaved => 'LLM配置已保存';

  @override
  String get name => '名稱';

  @override
  String get template => '端點類型';

  @override
  String get testSuccess => '測試成功';

  @override
  String get testError => '測試失敗';

  @override
  String get aiAdviceTitle => '智能天氣建議';

  @override
  String get aiAdviceNotConfigured => '智能天氣建議服務依賴於LLM配置，您沒有配置LLM';

  @override
  String get aiAdviceGoConfigure => 'LLM配置';

  @override
  String get aiAdviceServiceDisabled => '智能天氣建議服務被關閉';

  @override
  String get aiAdviceServiceEnabled => '智能天氣建議服務已經開啓';
}
