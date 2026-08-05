import '../import.dart';

// 天气渐变背景组件
class WeatherBg extends StatefulWidget {
  final int? weatherCode;
  const WeatherBg({super.key, this.weatherCode});

  @override
  State<WeatherBg> createState() => _WeatherBgState();
}

class _WeatherBgState extends State<WeatherBg> {
  @override
  Widget build(BuildContext context) {
    final code = widget.weatherCode;
    LinearGradient gradient;
    final isRain = rainWeatherCodes.contains(code);
    final isThunder = thunderWeatherCodes.contains(code);
    final isSnow = [71, 73, 75, 77, 85, 86].contains(code);
    if (code == 0) {
      // 晴天
      gradient = const LinearGradient(
        colors: [Color(0xFF64B5F6), Color(0xFFE3F2FD)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if ([1, 2, 3].contains(code)) {
      // 多云
      gradient = const LinearGradient(
        colors: [Color.fromARGB(255, 175, 222, 243), Color(0xFFECEFF1)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if ([45, 48].contains(code)) {
      // 雾天
      gradient = const LinearGradient(
        colors: [Color(0xFFECEFF1), Color(0xFFB0BEC5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (isRain) {
      // 雨天
      gradient = const LinearGradient(
        colors: [Color(0xFF1976D2), Color(0xFF90A4AE)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (isSnow) {
      // 雪天
      gradient = const LinearGradient(
        colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (isThunder) {
      // 雷暴
      gradient = const LinearGradient(
        colors: [Color(0xFF263238), Color(0xFF607D8B)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      // 默认蓝灰
      gradient = const LinearGradient(
        colors: [Color(0xFF90CAF9), Color(0xFFB0BEC5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
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
