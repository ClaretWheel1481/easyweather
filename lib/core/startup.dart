import 'package:permission_handler/permission_handler.dart';
import 'import.dart';

// 运行后台自动获取天气数据任务
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      debugPrint('WorkManager任务开始: $task at ${DateTime.now()}');
      WidgetsFlutterBinding.ensureInitialized();

      // 轻量级初始化 - 避免重复初始化通知服务
      final prefs = await SharedPreferences.getInstance();

      // 只在必要时初始化通知服务
      bool notificationInitialized =
          prefs.getBool('notification_initialized_bg') ?? false;
      if (!notificationInitialized) {
        await NotificationService().init();
        await prefs.setBool('notification_initialized_bg', true);
        debugPrint('后台任务：通知服务初始化完成');
      }

      switch (task) {
        case "org.claret.easyweather.fetchWeatherTask":
          debugPrint('开始获取天气数据...');
          await WeatherFetchService.fetchAndCacheWeather();
          debugPrint('天气数据获取完成');
          break;
        default:
          debugPrint('未知任务: $task');
      }
      return Future.value(true);
    } catch (e, stackTrace) {
      debugPrint('WorkManager任务失败: $task');
      debugPrint('错误: $e');
      debugPrint('堆栈: $stackTrace');
      return Future.value(false);
    }
  });
}

Future<void> initAppSettings() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化通知服务
  await NotificationService().init();

  final prefs = await SharedPreferences.getInstance();

  // 必要的监听器
  themeModeNotifier.value = ThemeMode.values[prefs.getInt('theme_mode') ?? 0];
  tempUnitNotifier.value = prefs.getString('temp_unit') ?? 'C';
  dynamicColorEnabledNotifier.value =
      prefs.getBool('dynamic_color_enabled') ?? false;

  String determineLocaleCode() {
    final savedLocale = prefs.getString('locale_code');
    if (savedLocale != null && savedLocale.isNotEmpty) {
      return savedLocale;
    }

    final systemLocale = PlatformDispatcher.instance.locale;
    if (kDebugMode) {
      debugPrint('systemLocale: $systemLocale');
    }
    final localeString = systemLocale.toString();
    final languageCode = systemLocale.languageCode;

    return appLanguages
        .firstWhere(
          (l) => l.code == localeString || l.code == languageCode,
          orElse: () => appLanguages.firstWhere((l) => l.code == 'en'),
        )
        .code;
  }

  localeCodeNotifier.value = determineLocaleCode();

  if (prefs.containsKey('weather_source')) {
    weatherSourceNotifier.value =
        prefs.getString('weather_source') ?? 'OpenMeteo';
  } else {
    weatherSourceNotifier.value = 'OpenMeteo';
    prefs.setString('weather_source', 'OpenMeteo');
    kDebugMode ? debugPrint('默认天气源设置为OpenMeteo') : null;
  }
  await Workmanager().initialize(
    callbackDispatcher,
  );

  // 检查iOS后台权限
  if (Platform.isIOS) {
    final status = await Permission.backgroundRefresh.status;
    if (status != PermissionStatus.granted) {
      debugPrint('iOS后台App刷新权限未授予，WorkManager无法正常工作');
    } else {
      debugPrint('iOS后台App刷新权限已授予');
    }
    // 针对iOS 启动时获取网络权限
    await AppDependencies.weatherRepository.checkConnectivity();
  }

  // 避免重复注册WorkManager任务
  await _registerWeatherFetchTaskIfNotExists();
}

// 安全注册WorkManager任务，避免重复注册
Future<void> _registerWeatherFetchTaskIfNotExists() async {
  try {
    await Workmanager()
        .cancelByUniqueName("org.claret.easyweather.fetchWeatherTask");

    // 等待一小段时间确保取消操作完成
    await Future.delayed(const Duration(milliseconds: 100));

    await Workmanager().registerPeriodicTask(
      "org.claret.easyweather.fetchWeatherTask",
      "org.claret.easyweather.fetchWeatherTask",
      frequency: const Duration(minutes: 30),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresCharging: false,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace, // 确保替换现有任务
    );

    debugPrint('WorkManager天气任务注册/替换成功');
  } catch (e) {
    debugPrint('WorkManager任务操作失败: $e');
  }
}
