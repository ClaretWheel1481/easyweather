import '../import.dart';

class LayoutService {
  static const String _layoutKey = 'home_layout';

  static final List<String> layout = [
    'ai_advice',
    'hourly_forecast',
    'rainfall_chart',
    'weather_map',
    'daily_forecast',
    'details',
  ];

  Future<List<String>> getLayout() async {
    final prefs = await SharedPreferences.getInstance();
    final userLayout = prefs.getStringList(_layoutKey);

    if (userLayout == null) {
      return layout;
    }

    return userLayout;
  }

  Future<void> saveLayout(List<String> layout) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_layoutKey, layout);
    layoutVersionNotifier.value++;
  }

  List<String> getDefaultLayout() {
    return layout;
  }
}
