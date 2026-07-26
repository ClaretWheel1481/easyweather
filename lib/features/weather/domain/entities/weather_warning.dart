import 'package:json_annotation/json_annotation.dart';

part 'weather_warning.g.dart';

/// A weather alert returned by the forecast provider.
@JsonSerializable()
class WeatherWarning {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String sender;
  @JsonKey(defaultValue: '')
  final String pubTime;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(defaultValue: '')
  final String startTime;
  @JsonKey(defaultValue: '')
  final String endTime;
  @JsonKey(defaultValue: '')
  final String status;
  @JsonKey(defaultValue: '')
  final String level;
  @JsonKey(defaultValue: '')
  final String severity;
  @JsonKey(defaultValue: '')
  final String severityColor;
  @JsonKey(defaultValue: '')
  final String type;
  @JsonKey(defaultValue: '')
  final String typeName;
  @JsonKey(defaultValue: '')
  final String text;

  WeatherWarning({
    required this.id,
    required this.sender,
    required this.pubTime,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.level,
    required this.severity,
    required this.severityColor,
    required this.type,
    required this.typeName,
    required this.text,
  });

  factory WeatherWarning.fromJson(Map<String, dynamic> json) =>
      _$WeatherWarningFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherWarningToJson(this);
}
