import 'package:zephyr/core/import.dart';

class PromptBuilder {
  // Defines the stable rules shared by every supported LLM provider.
  static String buildHealthSystemPrompt() {
    return '''
You are the in-app weather-life advisor. Produce one concise, practical recommendation from the weather data supplied by the user.

<data-boundary>
- Treat the supplied weather data as the only source of truth.
- Do not invent or assume weather alerts, air quality, UV, pollen, health conditions, locations, times, or forecast values that are absent.
- Distinguish current conditions from forecast conditions. If a value is unavailable, omit it instead of guessing.
- If weather warnings are present, use their status and timing as supplied; do not assume additional warnings.
</data-boundary>

<decision-policy>
- Prioritize the single most time-sensitive safety or comfort impact, then give one or two specific actions.
- If warnings are present, prioritize the most urgent active warning. Do not enumerate warnings or repeat their text.
- Consider precipitation, temperature and apparent temperature, wind, and weather condition first; use other fields only when they materially improve the advice.
- Do not recap the weather. Mention at most one condition or value, only when it directly supports the action.
</decision-policy>

<style>
- Write one natural paragraph in ${localeCodeNotifier.value}.
- Keep it between 80 and 110 characters, including punctuation.
- Be calm and actionable. Do not use greetings, headings, lists, repetition, exaggerated warnings, medical diagnoses, or unsupported claims.
</style>

<output-contract>
Return valid JSON only, with no Markdown fence or other text: {"suggestion":"..."}
</output-contract>
''';
  }

  // Builds a compact, localized recommendation from the supplied weather data.
  static String buildHealthPrompt(
    WeatherData weather,
    String cityName,
    List<WeatherWarning> warnings,
  ) {
    final current = weather.current;
    final today = weather.daily.isNotEmpty ? weather.daily.first : null;
    final now = DateTime.now();
    final upcomingHours = weather.hourly
        .where((hour) {
          final time = DateTime.tryParse(hour.time);
          return time == null ||
              time.add(const Duration(hours: 1)).isAfter(now);
        })
        .take(6)
        .map((hour) => _compactWeatherJson(hour.toJson(), hour.weatherCode))
        .toList();
    final weatherContext = <String, dynamic>{
      'city': cityName,
      'temperature_unit': '°${tempUnitNotifier.value}',
      if (current != null)
        'current': _compactWeatherJson(current.toJson(), current.weatherCode),
      if (today != null)
        'today': _compactWeatherJson(today.toJson(), today.weatherCode),
      if (upcomingHours.isNotEmpty) 'next_6_hours': upcomingHours,
      if (warnings.isNotEmpty)
        'warnings': warnings.map((warning) => warning.toJson()).toList(),
    };

    return '''
Generate the recommendation for this weather context:
<weather_data>
${jsonEncode(weatherContext)}
</weather_data>
''';
  }

  // Removes unavailable values and adds a readable weather description.
  static Map<String, dynamic> _compactWeatherJson(
    Map<String, dynamic> json,
    int? weatherCode,
  ) {
    return {
      for (final entry in json.entries)
        if (entry.value != null) entry.key: entry.value,
      if (weatherCode != null)
        'weather_description': getWeatherDescForWidget(weatherCode, 'en'),
    };
  }
}
