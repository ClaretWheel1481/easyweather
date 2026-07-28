import 'package:flutter_test/flutter_test.dart';
import 'package:zephyr/features/ai/domain/entities/ai_advice.dart';
import 'package:zephyr/features/ai/domain/entities/ai_config.dart';

void main() {
  test('AIConfig serializes with its generated serializer', () {
    const config = AIConfig(
      id: 'test-provider',
      provider: 'openai_compatible',
      apiKey: 'test-key',
      customHeaders: {'X-Client': 'Zephyr'},
    );

    final restored = AIConfig.fromJson(config.toJson());

    expect(restored.provider, config.provider);
    expect(restored.id, config.id);
    expect(restored.customHeaders, config.customHeaders);
  });

  test('AIAdvice serializes with its generated serializer', () {
    final advice = AIAdvice(
      advice: 'Take an umbrella.',
      timestamp: DateTime.utc(2026, 7, 26),
      city: 'Shanghai',
    );

    final restored = AIAdvice.fromJson(advice.toJson());

    expect(restored.advice, advice.advice);
    expect(restored.city, advice.city);
  });
}
