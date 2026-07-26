// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIConfig _$AIConfigFromJson(Map<String, dynamic> json) => AIConfig(
      id: json['id'] as String? ?? '',
      provider: json['provider'] as String,
      providerName: json['providerName'] as String?,
      apiKey: json['apiKey'] as String,
      customEndpoint: json['customEndpoint'] as String? ?? '',
      model: json['model'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      customHeaders: (json['customHeaders'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$AIConfigToJson(AIConfig instance) => <String, dynamic>{
      'id': instance.id,
      'provider': instance.provider,
      'providerName': instance.providerName,
      'apiKey': instance.apiKey,
      'customEndpoint': instance.customEndpoint,
      'model': instance.model,
      'enabled': instance.enabled,
      'customHeaders': instance.customHeaders,
    };

AIProvider _$AIProviderFromJson(Map<String, dynamic> json) => AIProvider(
      name: json['name'] as String,
      endpoint: json['endpoint'] as String,
      model: json['model'] as String,
      headers: Map<String, String>.from(json['headers'] as Map),
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$AIProviderToJson(AIProvider instance) =>
    <String, dynamic>{
      'name': instance.name,
      'endpoint': instance.endpoint,
      'model': instance.model,
      'headers': instance.headers,
      'description': instance.description,
    };
