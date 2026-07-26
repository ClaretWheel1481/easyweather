// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_advice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIAdvice _$AIAdviceFromJson(Map<String, dynamic> json) => AIAdvice(
      suggestion: json['suggestion'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      city: json['city'] as String,
    );

Map<String, dynamic> _$AIAdviceToJson(AIAdvice instance) => <String, dynamic>{
      'suggestion': instance.suggestion,
      'timestamp': instance.timestamp.toIso8601String(),
      'city': instance.city,
    };
