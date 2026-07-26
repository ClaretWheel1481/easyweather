import 'package:json_annotation/json_annotation.dart';

part 'ai_config.g.dart';

/// The active provider configuration for the AI advice feature.
@JsonSerializable()
class AIConfig {
  final String id;
  final String provider;
  final String? providerName;
  final String apiKey;
  final String customEndpoint;
  final String model;
  final bool enabled;
  final Map<String, String> customHeaders;

  const AIConfig({
    this.id = '',
    required this.provider,
    this.providerName,
    required this.apiKey,
    this.customEndpoint = '',
    this.model = '',
    this.enabled = false,
    this.customHeaders = const {},
  });

  factory AIConfig.fromJson(Map<String, dynamic> json) =>
      _$AIConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AIConfigToJson(this);

  AIConfig copyWith({
    String? id,
    String? provider,
    String? providerName,
    String? apiKey,
    String? customEndpoint,
    String? model,
    bool? enabled,
    Map<String, String>? customHeaders,
  }) =>
      AIConfig(
        id: id ?? this.id,
        provider: provider ?? this.provider,
        providerName: providerName ?? this.providerName,
        apiKey: apiKey ?? this.apiKey,
        customEndpoint: customEndpoint ?? this.customEndpoint,
        model: model ?? this.model,
        enabled: enabled ?? this.enabled,
        customHeaders: customHeaders ?? this.customHeaders,
      );
}

@JsonSerializable()
class AIProvider {
  final String name;
  final String endpoint;
  final String model;
  final Map<String, String> headers;
  final String description;

  const AIProvider({
    required this.name,
    required this.endpoint,
    required this.model,
    required this.headers,
    this.description = '',
  });

  factory AIProvider.fromJson(Map<String, dynamic> json) =>
      _$AIProviderFromJson(json);
  Map<String, dynamic> toJson() => _$AIProviderToJson(this);
}
