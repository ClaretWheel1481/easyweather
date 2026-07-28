// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_advice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIAdvice _$AIAdviceFromJson(Map<String, dynamic> json) => AIAdvice(
      advice: json['advice'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      city: json['city'] as String,
    );

Map<String, dynamic> _$AIAdviceToJson(AIAdvice instance) => <String, dynamic>{
      'advice': instance.advice,
      'timestamp': instance.timestamp.toIso8601String(),
      'city': instance.city,
    };
