import 'dart:convert';

import '../import.dart';

class AIAdviceWidget extends StatefulWidget {
  final City city;
  final WeatherData weather;
  final List<WeatherWarning> warnings;

  const AIAdviceWidget({
    super.key,
    required this.city,
    required this.weather,
    required this.warnings,
  });

  @override
  State<AIAdviceWidget> createState() => _AIAdviceWidgetState();
}

class _AIAdviceWidgetState extends State<AIAdviceWidget> {
  Future<_AIAdviceLoadResult>? _aiAdviceFuture;

  @override
  void initState() {
    super.initState();
    _aiAdviceFuture = _loadAIAdvice();
  }

  @override
  void didUpdateWidget(covariant AIAdviceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldRefreshAIAdvice(oldWidget)) {
      _refreshAIAdvice();
    }
  }

  bool _shouldRefreshAIAdvice(AIAdviceWidget oldWidget) {
    if (oldWidget.city.name != widget.city.name ||
        oldWidget.city.lat != widget.city.lat ||
        oldWidget.city.lon != widget.city.lon) {
      return true;
    }

    return _weatherSignature(oldWidget.weather, oldWidget.warnings) !=
        _weatherSignature(widget.weather, widget.warnings);
  }

  String _weatherSignature(
    WeatherData weather,
    List<WeatherWarning> warnings,
  ) {
    final current = weather.current;
    final firstHour = weather.hourly.isNotEmpty ? weather.hourly.first : null;
    return [
      weather.lastUpdated?.millisecondsSinceEpoch ?? 0,
      current?.temperature ?? '',
      current?.apparentTemperature ?? '',
      current?.humidity ?? '',
      current?.windSpeed ?? '',
      current?.weatherCode ?? '',
      firstHour?.precipitation ?? '',
      jsonEncode(warnings.map((warning) => warning.toJson()).toList()),
    ].join('|');
  }

  void _refreshAIAdvice() {
    setState(() {
      _aiAdviceFuture = _loadAIAdvice();
    });
  }

  Future<_AIAdviceLoadResult> _loadAIAdvice() async {
    final config = await AIAdvisorService.getConfig();

    if (!_isAiConfigured(config) || !(config?.enabled ?? false)) {
      return _AIAdviceLoadResult(config: config);
    }

    final response = await AIAdvisorService.getAdvice(
      widget.weather,
      widget.city.name,
      widget.warnings,
    );
    return _AIAdviceLoadResult(config: config, adviceResponse: response);
  }

  bool _isAiConfigured(AIConfig? config) {
    if (config == null) return false;
    return config.apiKey.trim().isNotEmpty &&
        config.customEndpoint.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(l10n.aiAdviceTitle),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<_AIAdviceLoadResult>(
                future: _aiAdviceFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // A centered spinner gives the asynchronous state a clear focal point.
                    return Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colorScheme.primary,
                          backgroundColor: colorScheme.primaryContainer,
                        ),
                      ),
                    );
                  }

                  final result = snapshot.data;
                  final config = result?.config;
                  final hasConfiguredAI = _isAiConfigured(config);

                  if (!hasConfiguredAI) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.aiAdviceNotConfigured,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () async {
                            await Navigator.pushNamed(
                              context,
                              '/llm-settings',
                            );
                            if (mounted) {
                              _refreshAIAdvice();
                            }
                          },
                          child: Text(l10n.aiAdviceGoConfigure),
                        ),
                      ],
                    );
                  }

                  if (!(config?.enabled ?? false) ||
                      result?.adviceResponse == null) {
                    return Text(
                      l10n.aiAdviceServiceDisabled,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    );
                  }

                  final response = result!.adviceResponse!;
                  if (!response.success || response.advice == null) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          response.error ?? 'Failed to get AI advice',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _refreshAIAdvice,
                          child: Text(l10n.retry),
                        ),
                      ],
                    );
                  }

                  // The generated insight is intentionally the only success action.
                  return Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      response.advice!.advice,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        height: 1.45,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _AIAdviceLoadResult {
  final AIConfig? config;
  final AIAdviceResponse? adviceResponse;

  const _AIAdviceLoadResult({
    required this.config,
    this.adviceResponse,
  });
}
