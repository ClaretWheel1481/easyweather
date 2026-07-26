import 'package:json_annotation/json_annotation.dart';

part 'ai_advice.g.dart';

/// An actionable recommendation generated from a weather snapshot.
@JsonSerializable()
class AIAdvice {
  final String suggestion;
  final DateTime timestamp;
  final String city;

  const AIAdvice({
    required this.suggestion,
    required this.timestamp,
    required this.city,
  });

  factory AIAdvice.fromJson(Map<String, dynamic> json) =>
      _$AIAdviceFromJson(json);
  Map<String, dynamic> toJson() => _$AIAdviceToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AIAdvice &&
          runtimeType == other.runtimeType &&
          city == other.city &&
          timestamp.difference(other.timestamp).inMinutes < 60;

  @override
  int get hashCode => city.hashCode ^ timestamp.hashCode;
}

/// Result wrapper for a provider call, keeping errors out of the UI flow.
class AIAdviceResponse {
  final bool success;
  final AIAdvice? advice;
  final String? error;

  AIAdviceResponse({required this.success, this.advice, this.error});

  factory AIAdviceResponse.success(AIAdvice advice) =>
      AIAdviceResponse(success: true, advice: advice);

  factory AIAdviceResponse.error(String error) =>
      AIAdviceResponse(success: false, error: error);
}
