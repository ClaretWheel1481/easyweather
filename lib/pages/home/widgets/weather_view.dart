import 'package:intl/intl.dart';

import 'ai_advice_widget.dart';
import '../import.dart';

class WeatherView extends StatefulWidget {
  final City city;
  final WeatherData weather;
  final List<WeatherWarning> warnings;
  const WeatherView(
      {super.key,
      required this.city,
      required this.weather,
      this.warnings = const []});

  @override
  State<WeatherView> createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView>
    with SingleTickerProviderStateMixin {
  final LayoutService _layoutService = LayoutService();
  List<String> _layout = [];
  bool _layoutLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadLayout();
    layoutVersionNotifier.addListener(_onLayoutChanged);
  }

  @override
  void dispose() {
    layoutVersionNotifier.removeListener(_onLayoutChanged);
    super.dispose();
  }

  void _onLayoutChanged() {
    _loadLayout();
  }

  Future<void> _loadLayout() async {
    final layout = await _layoutService.getLayout();
    if (mounted) {
      setState(() {
        _layout = layout;
        _layoutLoaded = true;
      });
    }
  }

  String formatPubTime(String pubTime) {
    try {
      final dt = DateTime.parse(pubTime).toLocal();
      return DateFormat('yyyy-MM-dd HH:mm').format(dt);
    } catch (e) {
      return pubTime;
    }
  }

  void _showWarningBannerDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SharedAxisTransition(
          fillColor: Colors.transparent,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.vertical,
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: WarningBanner(
                warnings: widget.warnings,
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_layoutLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
          left: 12, right: 12, top: kToolbarHeight + 72, bottom: 16),
      itemCount: _layout.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildMainWeatherCard(context);
        }
        final componentId = _layout[index - 1];
        return _buildComponentById(componentId);
      },
    );
  }

  Widget _buildComponentById(String id) {
    // TODO: Add more components
    switch (id) {
      case 'hourly_forecast':
        return _buildHourlyForecast(context);
      case 'rainfall_chart':
        return _buildRainfallChart(context);
      case 'daily_forecast':
        return _buildDailyForecast(context);
      case 'ai_advice':
        return AIAdviceWidget(
          city: widget.city,
          weather: widget.weather,
          warnings: widget.warnings,
        );
      case 'details':
        return _buildDetailsWidget(context);
      case 'weather_map':
        return _buildWeatherMap(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMainWeatherCard(BuildContext context) {
    final current = widget.weather.current;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hasWarning = widget.warnings.isNotEmpty;

    if (current == null) return const SizedBox.shrink();

    return Column(
      children: [
        Stack(
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              color: colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Icon(weatherIcon(current.weatherCode),
                        size: 72, color: colorScheme.primary),
                    const SizedBox(height: 8),
                    ValueListenableBuilder<String>(
                      valueListenable: tempUnitNotifier,
                      builder: (context, unit, _) => Text(
                        '${current.temperature}°$unit',
                        style: textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(getLocalizedWeatherDesc(context, current.weatherCode),
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        WeatherInfoTile(
                          icon: Icons.thermostat,
                          label: AppLocalizations.of(context).feelsLike,
                          value: current.apparentTemperature != null
                              ? current.apparentTemperature!.toStringAsFixed(1)
                              : '-',
                          unit: '°${tempUnitNotifier.value}',
                        ),
                        WeatherInfoTile(
                          icon: Icons.water_drop,
                          label: AppLocalizations.of(context).humidity,
                          value: current.humidity != null
                              ? current.humidity!.toStringAsFixed(0)
                              : '-',
                          unit: '%',
                        ),
                        WeatherInfoTile(
                          icon: Icons.navigation,
                          label: AppLocalizations.of(context).windDirection,
                          value: current.windDirection != null
                              ? getLocalizedWindDirection(
                                  context, current.windDirection!)
                              : '-',
                          unit: '',
                        ),
                        WeatherInfoTile(
                          icon: current.pm25 != null
                              ? getAirQualityIcon(
                                  getAirQualityLevel(euAQI: current.aqi))
                              : Icons.air,
                          label: AppLocalizations.of(context).airQuality,
                          value: current.pm25 != null
                              ? getLocalizedAirQualityDesc(context,
                                  getAirQualityLevel(euAQI: current.aqi))
                              : '-',
                          unit: '',
                        ),
                      ],
                    ),
                    if (widget.weather.lastUpdated != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${AppLocalizations.of(context).lastUpdated}: ${DateFormat('HH:mm').format(widget.weather.lastUpdated!)}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimaryContainer
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (hasWarning)
              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(24),
                  elevation: 3,
                  shadowColor: colorScheme.error.withValues(alpha: 0.2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: _showWarningBannerDialog,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: colorScheme.onError),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(context).alert,
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onError,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHourlyForecast(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (widget.weather.hourly.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(AppLocalizations.of(context).hourlyForecast),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            final now = DateTime.now();
            int startIdx = 0;
            for (int i = 0; i < widget.weather.hourly.length; i++) {
              final t = DateTime.tryParse(widget.weather.hourly[i].time);
              if (t != null &&
                  (t.isAfter(now) ||
                      (t.hour == now.hour &&
                          t.day == now.day &&
                          t.month == now.month &&
                          t.year == now.year))) {
                startIdx = i;
                break;
              }
            }
            final endIdx = (startIdx + 24) <= widget.weather.hourly.length
                ? (startIdx + 24)
                : widget.weather.hourly.length;
            final hours = widget.weather.hourly.sublist(startIdx, endIdx);
            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: hours.length,
                itemBuilder: (context, i) {
                  final h = hours[i];
                  final t = DateTime.tryParse(h.time);
                  final hourStr = t != null
                      ? '${t.hour.toString().padLeft(2, '0')}:00'
                      : '';
                  final isNow = i == 0;
                  return Container(
                    width: 75,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isNow ? colorScheme.primary : colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: isNow
                          ? Border.all(color: colorScheme.primary, width: 2)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(hourStr,
                            style: textTheme.bodyMedium?.copyWith(
                                color: isNow
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Icon(weatherIcon(h.weatherCode),
                            color: isNow
                                ? colorScheme.onPrimary
                                : colorScheme.primary,
                            size: 28),
                        const SizedBox(height: 4),
                        ValueListenableBuilder<String>(
                          valueListenable: tempUnitNotifier,
                          builder: (context, unit, _) => Text(
                            h.temperature != null
                                ? '${h.temperature!.toStringAsFixed(1)}°$unit'
                                : '-',
                            style: textTheme.titleMedium?.copyWith(
                              color: isNow
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRainfallChart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Rainfall24hView(hourly: widget.weather.hourly),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWeatherMap(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(AppLocalizations.of(context).weatherMap),
        const SizedBox(height: 8),
        WeatherMap(city: widget.city),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDailyForecast(BuildContext context) {
    final daily = widget.weather.daily;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (daily.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(AppLocalizations.of(context).next7Days),
        const SizedBox(height: 8),
        Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
            child: SizedBox(
              height: 230,
              child: FutureWeatherBand(
                  daily: daily, colorScheme: colorScheme, textTheme: textTheme),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDetailsWidget(BuildContext context) {
    final current = widget.weather.current;
    final daily = widget.weather.daily;

    if (current == null || daily.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(AppLocalizations.of(context).detailedData),
        const SizedBox(height: 8),
        DetailedDataWidget(
            current: current,
            daily: daily.first,
            hourly: widget.weather.hourly),
        const SizedBox(height: 12),
      ],
    );
  }
}
