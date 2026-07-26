import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/app_preferences.dart';

/// SharedPreferences adapter for application appearance and weather settings.
class SharedPreferencesAppPreferences implements AppPreferences {
  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();

  @override
  Future<int> loadThemeModeIndex() async =>
      (await _preferences).getInt('theme_mode') ?? 0;

  @override
  Future<void> saveThemeModeIndex(int value) async =>
      (await _preferences).setInt('theme_mode', value);

  @override
  Future<String> loadTemperatureUnit() async =>
      (await _preferences).getString('temp_unit') ?? 'C';

  @override
  Future<void> saveTemperatureUnit(String value) async =>
      (await _preferences).setString('temp_unit', value);

  @override
  Future<String> loadWeatherSource() async =>
      (await _preferences).getString('weather_source') ?? 'OpenMeteo';

  @override
  Future<void> saveWeatherSource(String value) async =>
      (await _preferences).setString('weather_source', value);

  @override
  Future<bool> loadDynamicColorEnabled() async =>
      (await _preferences).getBool('dynamic_color_enabled') ?? false;

  @override
  Future<void> saveDynamicColorEnabled(bool value) async =>
      (await _preferences).setBool('dynamic_color_enabled', value);

  @override
  Future<int?> loadCustomColor() async =>
      (await _preferences).getInt('custom_color');

  @override
  Future<void> saveCustomColor(int value) async =>
      (await _preferences).setInt('custom_color', value);

  @override
  Future<void> saveLocaleCode(String value) async =>
      (await _preferences).setString('locale_code', value);

  @override
  Future<String?> loadLlmProviders() async =>
      (await _preferences).getString('llm_configured_providers');

  @override
  Future<void> saveLlmProviders(String value) async =>
      (await _preferences).setString('llm_configured_providers', value);
}
