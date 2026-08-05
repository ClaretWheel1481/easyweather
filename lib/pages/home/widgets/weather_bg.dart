import '../import.dart';

// 天气渐变背景组件
class WeatherBg extends StatefulWidget {
  final int? weatherCode;
  const WeatherBg({super.key, this.weatherCode});

  @override
  State<WeatherBg> createState() => _WeatherBgState();
}

class _WeatherBgState extends State<WeatherBg> {
  // Keep visual tokens separate from weather-code selection.
  static const LinearGradient _clearGradient = LinearGradient(
    colors: [Color(0xFF64B5F6), Color(0xFFE3F2FD)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient _cloudyGradient = LinearGradient(
    colors: [Color.fromARGB(255, 175, 222, 243), Color(0xFFECEFF1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient _overcastGradient = LinearGradient(
    colors: [Color(0xFF90A4AE), Color(0xFFCFD8DC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient _fogGradient = LinearGradient(
    colors: [Color(0xFFECEFF1), Color(0xFFB0BEC5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient _rainGradient = LinearGradient(
    colors: [Color(0xFF1976D2), Color(0xFF90A4AE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient _snowGradient = LinearGradient(
    colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient _thunderGradient = LinearGradient(
    colors: [Color(0xFF263238), Color(0xFF607D8B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient _fallbackGradient = LinearGradient(
    colors: [Color(0xFF90CAF9), Color(0xFFB0BEC5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final code = widget.weatherCode;
    final description = weatherDesc(code);
    final isSnow = description == 'weatherSnowy';
    final gradient = switch (description) {
      'weatherClear' => _clearGradient,
      'weatherCloudy' => _cloudyGradient,
      'weatherOvercast' => _overcastGradient,
      'weatherFoggy' => _fogGradient,
      'weatherDrizzle' || 'weatherRain' || 'weatherRainShower' => _rainGradient,
      'weatherSnowy' => _snowGradient,
      'weatherThunderstorm' => _thunderGradient,
      _ => _fallbackGradient,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: gradient,
              ),
            ),
            // Rain and thunder effects are painted with Home content so rain
            // can collide with the rendered component bounds.
            if (isSnow)
              SnowAnimation(
                maxHeight: constraints.maxHeight,
              ),
            if (Theme.of(context).brightness == Brightness.dark)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.25),
                ),
              ),
          ],
        );
      },
    );
  }
}
