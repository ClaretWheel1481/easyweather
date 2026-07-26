// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_warning.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherWarning _$WeatherWarningFromJson(Map<String, dynamic> json) =>
    WeatherWarning(
      id: json['id'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      pubTime: json['pubTime'] as String? ?? '',
      title: json['title'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      status: json['status'] as String? ?? '',
      level: json['level'] as String? ?? '',
      severity: json['severity'] as String? ?? '',
      severityColor: json['severityColor'] as String? ?? '',
      type: json['type'] as String? ?? '',
      typeName: json['typeName'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );

Map<String, dynamic> _$WeatherWarningToJson(WeatherWarning instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'pubTime': instance.pubTime,
      'title': instance.title,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'status': instance.status,
      'level': instance.level,
      'severity': instance.severity,
      'severityColor': instance.severityColor,
      'type': instance.type,
      'typeName': instance.typeName,
      'text': instance.text,
    };
