/// Application preference port; the presentation layer never sees storage APIs.
abstract interface class AppPreferences {
  Future<int> loadThemeModeIndex();
  Future<void> saveThemeModeIndex(int value);
  Future<String> loadTemperatureUnit();
  Future<void> saveTemperatureUnit(String value);
  Future<String> loadWeatherSource();
  Future<void> saveWeatherSource(String value);
  Future<bool> loadDynamicColorEnabled();
  Future<void> saveDynamicColorEnabled(bool value);
  Future<int?> loadCustomColor();
  Future<void> saveCustomColor(int value);
  Future<void> saveLocaleCode(String value);
  Future<String?> loadLlmProviders();
  Future<void> saveLlmProviders(String value);
}
