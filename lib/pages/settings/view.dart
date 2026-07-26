import 'import.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode? _themeMode;
  String? _tempUnit;
  bool _loading = true;
  bool _dynamicColorEnabled = false;
  String? _weatherSource;
  Color _customColor = Colors.blue;

  // LLM Settings
  bool _llmEnabled = false;

  // 城市管理相关
  List<City> _cities = [];
  int _mainCityIndex = 0;
  bool _cityLoading = true;
  bool _cityManagerExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadCities();
  }

  Future<void> _loadSettings() async {
    final preferences = AppDependencies.appPreferences;
    final aiConfig = await AIAdvisorService.getConfig();
    final themeModeIndex = await preferences.loadThemeModeIndex();
    final temperatureUnit = await preferences.loadTemperatureUnit();
    final weatherSource = await preferences.loadWeatherSource();
    final dynamicColorEnabled = await preferences.loadDynamicColorEnabled();
    final customColorValue =
        await preferences.loadCustomColor() ?? Colors.blue.toARGB32();
    if (!mounted) return;

    setState(() {
      _themeMode = ThemeMode.values[themeModeIndex];
      _tempUnit = temperatureUnit;
      _weatherSource = weatherSource;
      _dynamicColorEnabled = dynamicColorEnabled;
      _customColor = Color(customColorValue);

      _llmEnabled = aiConfig?.enabled ?? true;

      _loading = false;
    });

    dynamicColorEnabledNotifier.value = _dynamicColorEnabled;
    customColorNotifier.value = _customColor;
  }

  Future<void> _loadCities() async {
    final cities = await AppDependencies.cityRepository.loadCities();
    final mainIndex = await AppDependencies.cityRepository.loadMainCityIndex();
    if (!mounted) return;
    setState(() {
      _cities = cities;
      _mainCityIndex = mainIndex < cities.length ? mainIndex : 0;
      _cityLoading = false;
    });
  }

  Future<void> _saveCities() async {
    await AppDependencies.cityRepository.saveCities(_cities);
    await AppDependencies.cityRepository.saveMainCityIndex(_mainCityIndex);
  }

  void _removeCity(int index) async {
    if (_cities.isEmpty) return;
    final city = _cities[index];
    final l10n = AppLocalizations.of(context);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(MaterialLocalizations.of(context).okButtonLabel),
        content: Text(l10n.deleteCityMessage(city.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirm == true) {
      setState(() {
        _cities.removeAt(index);
        if (_mainCityIndex >= _cities.length) {
          _mainCityIndex = 0;
        }
      });
      await _saveCities();
    }
  }

  void _setMainCity(int index) async {
    setState(() {
      _mainCityIndex = index;
    });
    await _saveCities();
  }

  Future<void> _saveThemeMode(ThemeMode mode) async {
    await AppDependencies.appPreferences.saveThemeModeIndex(mode.index);
    setState(() {
      _themeMode = mode;
    });
    themeModeNotifier.value = mode;
  }

  Future<void> _saveTempUnit(String unit) async {
    await AppDependencies.appPreferences.saveTemperatureUnit(unit);
    setState(() {
      _tempUnit = unit;
    });
    tempUnitNotifier.value = unit;
  }

  Future<void> _saveWeatherSources(String name) async {
    await AppDependencies.appPreferences.saveWeatherSource(name);
    setState(() {
      _weatherSource = name;
    });
    weatherSourceNotifier.value = name;
  }

  Future<void> _saveDynamicColorEnabled(bool enabled) async {
    await AppDependencies.appPreferences.saveDynamicColorEnabled(enabled);
    setState(() {
      _dynamicColorEnabled = enabled;
    });
    dynamicColorEnabledNotifier.value = enabled;
  }

  Future<void> _saveCustomColor(Color color) async {
    await AppDependencies.appPreferences.saveCustomColor(color.toARGB32());
    setState(() {
      _customColor = color;
    });
    customColorNotifier.value = color;
  }

  Future<void> _saveLLMEnabled(bool enabled) async {
    final config = await AIAdvisorService.getConfig();
    final newConfig = config?.copyWith(enabled: enabled) ??
        AIConfig(provider: '', apiKey: '', enabled: enabled);

    await AIAdvisorService.saveConfig(newConfig);

    setState(() {
      _llmEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.settings)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(l10n.settings),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 天气源选择
          WeatherSourceSelectorWidget(
              weatherSource: _weatherSource,
              onWeatherSourceChanged: _saveWeatherSources),
          const SizedBox(height: 16),
          // 城市管理
          CityManagerWidget(
            cities: _cities,
            mainCityIndex: _mainCityIndex,
            cityLoading: _cityLoading,
            cityManagerExpanded: _cityManagerExpanded,
            onSetMainCity: _setMainCity,
            onRemoveCity: _removeCity,
            onToggleExpand: () {
              setState(() {
                _cityManagerExpanded = !_cityManagerExpanded;
              });
            },
          ),
          const SizedBox(height: 16),
          // LLM Settings
          LLMSelectorWidget(
            enabled: _llmEnabled,
            onEnabledChanged: _saveLLMEnabled,
            onTap: () async {
              await Navigator.pushNamed(context, '/llm-settings');
            },
          ),
          const SizedBox(height: 16),
          // 自定义主页面
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.view_quilt,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(l10n.customizeHomepage,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
                onTap: () async {
                  await Navigator.pushNamed(context, '/layout-settings');
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 温度单位
          TempUnitSelectorWidget(
            tempUnit: _tempUnit,
            onTempUnitChanged: _saveTempUnit,
          ),
          const SizedBox(height: 16),
          // 主题模式 + Monet取色 + 自定义颜色
          ThemeModeSelectorWidget(
            themeMode: _themeMode,
            dynamicColorEnabled: _dynamicColorEnabled,
            customColor: _customColor,
            onThemeModeChanged: _saveThemeMode,
            onDynamicColorChanged: _saveDynamicColorEnabled,
            onCustomColorChanged: _saveCustomColor,
          ),
          const SizedBox(height: 16),
          // 语言选择
          const LanguageSelectorWidget(),

          const SizedBox(height: 16),
          const RequestHomewidgetWidget(),
          const SizedBox(height: 16),
          const IgnoreBatteryOptimizationWidget(),
          const SizedBox(height: 16),
          // 关于
          const AboutAppWidget(),
        ],
      ),
    );
  }
}
