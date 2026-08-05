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
  final RainCollisionController _rainCollisionController =
      RainCollisionController();
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

    final content = ListView.builder(
      // Leave open gutters outside component bounds for uninterrupted rain.
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: kToolbarHeight + 72, bottom: 16),
      itemCount: _layout.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          // The summary has no outer material surface, so it must not create
          // an invisible full-width rain collision region.
          return _buildMainWeatherSummary(context);
        }

        final componentId = _layout[index - 1];
        // Each builder registers only its painted surface, excluding headings.
        return _buildComponentById(componentId);
      },
    );

    final weatherCode = widget.weather.current?.weatherCode;
    final isThunder = isThunderWeather(weatherCode);
    final hasRain = isRainWeather(weatherCode) || isThunder;
    if (!hasRain) return content;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            content,
            // Paint rain after the content so impacts remain visible while
            // IgnorePointer preserves every Home interaction.
            IgnorePointer(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  RainAnimation(
                    maxHeight: constraints.maxHeight,
                    collisionController: _rainCollisionController,
                  ),
                  if (isThunder) const ThunderFlashAnimation(),
                ],
              ),
            ),
          ],
        );
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
          collisionController: _rainCollisionController,
        );
      case 'details':
        return _buildDetailsWidget(context);
      case 'weather_map':
        return _buildWeatherMap(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMainWeatherSummary(BuildContext context) {
    final current = widget.weather.current;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);
    final hasWarning = widget.warnings.isNotEmpty;

    if (current == null) return const SizedBox.shrink();

    // Theme surface colors cannot guarantee contrast on weather gradients.
    final useLightForeground = theme.brightness == Brightness.dark ||
        isRainWeather(current.weatherCode) ||
        isThunderWeather(current.weatherCode);
    final summaryForeground = useLightForeground
        ? const Color(0xFFF4F7FB)
        : const Color(0xFF263238).withValues(alpha: 0.86);
    final summarySecondary = summaryForeground.withValues(
      alpha: useLightForeground ? 0.82 : 0.68,
    );
    final summaryShadows = useLightForeground
        ? <Shadow>[
            Shadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ]
        : const <Shadow>[];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              Icon(
                weatherIcon(current.weatherCode),
                size: 64,
                color: summaryForeground,
                shadows: summaryShadows,
              ),
              const SizedBox(height: 4),
              ValueListenableBuilder<String>(
                valueListenable: tempUnitNotifier,
                builder: (context, unit, _) {
                  return Column(
                    children: [
                      Text(
                        '${current.temperature}°$unit',
                        style: textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: summaryForeground,
                          shadows: summaryShadows,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        getLocalizedWeatherDesc(context, current.weatherCode),
                        style: textTheme.titleLarge?.copyWith(
                          color: summarySecondary,
                          shadows: summaryShadows,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: WeatherInfoTile(
                              icon: Icons.thermostat_rounded,
                              label: l10n.feelsLike,
                              value: current.apparentTemperature != null
                                  ? current.apparentTemperature!
                                      .toStringAsFixed(1)
                                  : '-',
                              unit: '°$unit',
                              foregroundColor: summaryForeground,
                            ),
                          ),
                          Expanded(
                            child: WeatherInfoTile(
                              icon: Icons.water_drop_rounded,
                              label: l10n.humidity,
                              value: current.humidity != null
                                  ? current.humidity!.toStringAsFixed(0)
                                  : '-',
                              unit: '%',
                              foregroundColor: summaryForeground,
                            ),
                          ),
                          Expanded(
                            child: WeatherInfoTile(
                              icon: Icons.navigation_rounded,
                              label: l10n.windDirection,
                              value: current.windDirection != null
                                  ? getLocalizedWindDirection(
                                      context,
                                      current.windDirection!,
                                    )
                                  : '-',
                              unit: '',
                              foregroundColor: summaryForeground,
                            ),
                          ),
                          Expanded(
                            child: WeatherInfoTile(
                              icon: current.pm25 != null
                                  ? getAirQualityIcon(
                                      getAirQualityLevel(euAQI: current.aqi),
                                    )
                                  : Icons.air_rounded,
                              label: l10n.airQuality,
                              value: current.pm25 != null
                                  ? getLocalizedAirQualityDesc(
                                      context,
                                      getAirQualityLevel(euAQI: current.aqi),
                                    )
                                  : '-',
                              unit: '',
                              foregroundColor: summaryForeground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              if (widget.weather.lastUpdated != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: summarySecondary,
                          shadows: summaryShadows,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${l10n.lastUpdated}: ${DateFormat('HH:mm').format(widget.weather.lastUpdated!)}',
                          style: textTheme.labelMedium?.copyWith(
                            color: summarySecondary,
                            shadows: summaryShadows,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
          if (hasWarning)
            PositionedDirectional(
              top: 0,
              end: 0,
              // A positioned alert never changes the summary's height.
              child: RainCollisionSurface(
                controller: _rainCollisionController,
                child: IconButton.filledTonal(
                  onPressed: _showWarningBannerDialog,
                  tooltip: l10n.alert,
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.errorContainer,
                    foregroundColor: colorScheme.onErrorContainer,
                  ),
                  icon: const Icon(Icons.warning_amber_rounded),
                ),
              ),
            ),
        ],
      ),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: RainCollisionSurface(
                      controller: _rainCollisionController,
                      child: Container(
                        width: 75,
                        decoration: BoxDecoration(
                          color:
                              isNow ? colorScheme.primary : colorScheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: isNow
                              ? Border.all(
                                  color: colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              hourStr,
                              style: textTheme.bodyMedium?.copyWith(
                                color: isNow
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Icon(
                              weatherIcon(h.weatherCode),
                              color: isNow
                                  ? colorScheme.onPrimary
                                  : colorScheme.primary,
                              size: 28,
                            ),
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
                      ),
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
        Rainfall24hView(
          hourly: widget.weather.hourly,
          collisionController: _rainCollisionController,
        ),
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
        RainCollisionSurface(
          controller: _rainCollisionController,
          child: WeatherMap(city: widget.city),
        ),
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
        RainCollisionSurface(
          controller: _rainCollisionController,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
              child: SizedBox(
                height: 230,
                child: FutureWeatherBand(
                  daily: daily,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
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
        RainCollisionSurface(
          controller: _rainCollisionController,
          child: DetailedDataWidget(
            current: current,
            daily: daily.first,
            hourly: widget.weather.hourly,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
