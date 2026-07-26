import 'import.dart';

// 支持的语言列表
final List<Locale> supportedLocales =
    appLanguages.map((e) => e.locale).toList();

class ZephyrApp extends StatefulWidget {
  const ZephyrApp({super.key});

  @override
  State<ZephyrApp> createState() => _ZephyrAppState();
}

class _ZephyrAppState extends State<ZephyrApp> {
  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final preferences = AppDependencies.appPreferences;
    final themeModeIndex = await preferences.loadThemeModeIndex();
    themeModeNotifier.value = ThemeMode.values[themeModeIndex];
    final dynamicColorEnabled = await preferences.loadDynamicColorEnabled();
    dynamicColorEnabledNotifier.value = dynamicColorEnabled;
    final customColorValue =
        await preferences.loadCustomColor() ?? Colors.blue.toARGB32();
    customColorNotifier.value = Color(customColorValue);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: dynamicColorEnabledNotifier,
          builder: (context, dynamicColorEnabled, __) {
            return ValueListenableBuilder<String>(
              valueListenable: localeCodeNotifier,
              builder: (context, localeCode, ___) {
                return ValueListenableBuilder<Color>(
                  valueListenable: customColorNotifier,
                  builder: (context, customColor, ____) {
                    final locale = appLanguages
                        .firstWhere((l) => l.code == localeCode)
                        .locale;

                    if (dynamicColorEnabled) {
                      return DynamicColorBuilder(
                        builder: (ColorScheme? lightDynamic,
                            ColorScheme? darkDynamic) {
                          return MaterialApp(
                            title: AppConstants.appName,
                            locale: locale,
                            supportedLocales: supportedLocales,
                            localizationsDelegates:
                                AppLocalizations.localizationsDelegates,
                            theme: ThemeData(
                              colorScheme: lightDynamic ??
                                  ColorScheme.fromSeed(seedColor: customColor),
                              useMaterial3: true,
                            ),
                            darkTheme: ThemeData(
                              colorScheme: darkDynamic ??
                                  ColorScheme.fromSeed(
                                      seedColor: customColor,
                                      brightness: Brightness.dark),
                              useMaterial3: true,
                            ),
                            themeMode: mode,
                            home: const HomePage(),
                            routes: {
                              '/search': (_) => const SearchPage(),
                              '/settings': (_) => const SettingsPage(),
                              '/layout-settings': (_) =>
                                  const LayoutSettingsView(),
                              '/llm-settings': (_) => const LLMSettingsPage(),
                            },
                          );
                        },
                      );
                    } else {
                      return MaterialApp(
                        title: AppConstants.appName,
                        locale: locale,
                        supportedLocales: supportedLocales,
                        localizationsDelegates:
                            AppLocalizations.localizationsDelegates,
                        theme: ThemeData(
                          colorScheme:
                              ColorScheme.fromSeed(seedColor: customColor),
                          useMaterial3: true,
                        ),
                        darkTheme: ThemeData(
                          colorScheme: ColorScheme.fromSeed(
                              seedColor: customColor,
                              brightness: Brightness.dark),
                          useMaterial3: true,
                        ),
                        themeMode: mode,
                        home: const HomePage(),
                        routes: {
                          '/search': (_) => const SearchPage(),
                          '/settings': (_) => const SettingsPage(),
                          '/layout-settings': (_) => const LayoutSettingsView(),
                          '/llm-settings': (_) => const LLMSettingsPage(),
                        },
                      );
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
