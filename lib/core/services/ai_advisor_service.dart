import 'package:dio/dio.dart';
import '../import.dart';

class AIAdvisorService {
  static final Dio _dio = Dio();
  static const String _aiConfigKey = 'ai_config';
  static const String _adviceCacheKey = 'ai_advice_cache_';
  static const Duration _cacheDuration = Duration(hours: 2);

  // 获取 AI 配置
  static Future<AIConfig?> getConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final configJson = prefs.getString(_aiConfigKey);

    if (configJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(configJson);
        return AIConfig.fromJson(json);
      } catch (e) {
        debugPrint('Unmarshal failed: $e');
      }
    }
    return null;
  }

  // 保存 AI 配置
  static Future<bool> saveConfig(AIConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final json = config.toJson();
    return await prefs.setString(_aiConfigKey, jsonEncode(json));
  }

  // 生成建议缓存键（城市 + 天气源）
  static String _buildCacheKey(String cityName, String weatherSource) {
    final cacheCityName = cityName.trim().toLowerCase();
    return '$_adviceCacheKey${cacheCityName}_$weatherSource';
  }

  // 基于关键天气字段生成签名，用于判断缓存是否可复用
  static String _buildWeatherSignature(
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

  // 读取建议缓存：同时校验数据结构、过期时间与天气签名
  static Future<AIAdvice?> _getCachedAdvice(
    String cityName,
    WeatherData weather,
    List<WeatherWarning> warnings,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final weatherSource = prefs.getString('weather_source') ?? 'OpenMeteo';
    final cacheKey = _buildCacheKey(cityName, weatherSource);
    final adviceJson = prefs.getString(cacheKey);

    if (adviceJson == null) return null;

    try {
      final Map<String, dynamic> json = jsonDecode(adviceJson);
      final ts = json['ts'] as int?;
      final weatherSig = json['weather_sig'] as String?;
      final adviceMap = json['advice'];

      if (ts == null || adviceMap is! Map<String, dynamic>) {
        return null;
      }

      final isExpired = DateTime.now().millisecondsSinceEpoch - ts >
          _cacheDuration.inMilliseconds;
      if (isExpired) {
        return null;
      }

      if (weatherSig != _buildWeatherSignature(weather, warnings)) {
        return null;
      }

      return AIAdvice.fromJson(adviceMap);
    } catch (e) {
      debugPrint('Parse cached advice failed: $e');
      return null;
    }
  }

  // 写入建议缓存：保存建议正文、天气签名与时间戳
  static Future<bool> _cacheAdvice(
    String cityName,
    WeatherData weather,
    List<WeatherWarning> warnings,
    AIAdvice advice,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final weatherSource = prefs.getString('weather_source') ?? 'OpenMeteo';
    final cacheKey = _buildCacheKey(cityName, weatherSource);

    return await prefs.setString(
      cacheKey,
      jsonEncode({
        'advice': advice.toJson(),
        'weather_sig': _buildWeatherSignature(weather, warnings),
        'ts': DateTime.now().millisecondsSinceEpoch,
      }),
    );
  }

  // 获取 AI 建议：
  static Future<AIAdviceResponse> getAdvice(
      WeatherData weather, String cityName,
      [List<WeatherWarning> warnings = const []]) async {
    try {
      // 先校验配置状态
      final config = await getConfig();
      if (config == null || !config.enabled) {
        return AIAdviceResponse.error('LLM feature disabled');
      }

      if (config.customEndpoint.isEmpty) {
        return AIAdviceResponse.error('No LLM providers');
      }

      // 缓存命中直接返回
      final cachedAdvice = await _getCachedAdvice(cityName, weather, warnings);
      if (cachedAdvice != null) {
        return AIAdviceResponse.success(cachedAdvice);
      }

      // 未命中缓存时请求模型
      final systemPrompt = PromptBuilder.buildHealthSystemPrompt();
      final weatherPrompt =
          PromptBuilder.buildHealthPrompt(weather, cityName, warnings);
      final response = await _sendRequest(systemPrompt, weatherPrompt, config);

      if (response.statusCode == 200) {
        final advice = _parseAIResponse(response.data ?? '', cityName);
        if (advice != null) {
          // 请求成功后写回缓存
          await _cacheAdvice(cityName, weather, warnings, advice);
          return AIAdviceResponse.success(advice);
        }
        return AIAdviceResponse.error('Failed to parse AI response');
      }

      return AIAdviceResponse.error('Request failed: ${response.statusCode}');
    } catch (e) {
      return AIAdviceResponse.error('Failed to parse advice: $e');
    }
  }

  // 发送 AI 请求：根据 provider 组装 Header 与请求体
  static Future<Response<String>> _sendRequest(
    String systemPrompt,
    String weatherPrompt,
    AIConfig config,
  ) async {
    final model = config.model.isNotEmpty ? config.model : 'default';
    final provider = AIProviderTemplates.resolveEndpointType(config.provider);
    final endpoint = provider == AIProviderTemplates.gemini
        ? _buildGeminiEndpoint(config.customEndpoint, model)
        : config.customEndpoint;

    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    headers.addAll(config.customHeaders);

    if (provider == AIProviderTemplates.anthropic) {
      headers['x-api-key'] = config.apiKey;
      headers['anthropic-version'] = '2023-06-01';
    } else if (provider == AIProviderTemplates.gemini) {
      headers['x-goog-api-key'] = config.apiKey;
    } else {
      if (!headers.containsKey('Authorization')) {
        headers['Authorization'] = 'Bearer ${config.apiKey}';
      }
    }

    for (final key in headers.keys) {
      if (headers[key]!.contains('{api_key}')) {
        headers[key] = headers[key]!.replaceAll('{api_key}', config.apiKey);
      }
    }

    // Keep stable instructions separate from the current weather context.
    final body = _buildRequestBody(
      systemPrompt,
      weatherPrompt,
      model,
      provider,
    );

    return _dio.postUri<String>(
      Uri.parse(endpoint),
      data: jsonEncode(body),
      options: Options(
        headers: headers,
        responseType: ResponseType.plain,
        validateStatus: (_) => true,
      ),
    );
  }

  // Build the official Gemini generateContent endpoint from the user inputs.
  static String _buildGeminiEndpoint(String endpoint, String model) {
    final endpointValue = endpoint.trim();
    if (endpointValue.contains(':generateContent')) {
      return endpointValue;
    }
    return '${endpointValue.replaceFirst(RegExp(r'[/]+$'), '')}/'
        '$model:generateContent';
  }

  // 构建不同 provider 的请求体
  static Map<String, dynamic> _buildRequestBody(
    String systemPrompt,
    String weatherPrompt,
    String model,
    String provider,
  ) {
    switch (provider) {
      case AIProviderTemplates.openAIResponses:
        return {
          'model': model,
          'instructions': systemPrompt,
          'input': weatherPrompt,
        };
      case AIProviderTemplates.anthropic:
        return {
          'model': model,
          'max_tokens': 1024,
          'system': systemPrompt,
          'messages': [
            {'role': 'user', 'content': weatherPrompt}
          ],
        };
      case AIProviderTemplates.gemini:
        return {
          'systemInstruction': {
            'parts': [
              {'text': systemPrompt}
            ],
          },
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': weatherPrompt}
              ],
            }
          ],
        };
      case AIProviderTemplates.openAICompatible:
      default:
        return {
          'model': model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': weatherPrompt},
          ],
        };
    }
  }

  // 解析 AI 响应：兼容 Gemini/OpenAI/Claude/通用结构
  static AIAdvice? _parseAIResponse(String responseBody, String cityName) {
    try {
      Map<String, dynamic> content;

      try {
        content = jsonDecode(responseBody);
      } catch (_) {
        final jsonRegex = RegExp(r'\{.*\}', dotAll: true);
        final match = jsonRegex.firstMatch(responseBody);
        if (match == null) {
          throw Exception('Unable to parse JSON');
        }
        content = jsonDecode(match.group(0)!);
      }

      String adviceText = '';

      if (content.containsKey('candidates')) {
        final parts = content['candidates']?[0]?['content']?['parts'];
        if (parts != null && parts is List && parts.isNotEmpty) {
          adviceText = parts[0]['text'] ?? '';
        }
      } else if (content.containsKey('choices')) {
        final messageContent = content['choices']?[0]?['message']?['content'];
        if (messageContent != null) {
          adviceText = messageContent;
        }
      } else if (content['output_text'] is String) {
        adviceText = content['output_text'];
      } else if (content['output'] is List) {
        final outputTexts = <String>[];
        for (final item in content['output']) {
          final parts = item is Map ? item['content'] : null;
          if (parts is List) {
            for (final part in parts) {
              if (part is Map && part['text'] is String) {
                outputTexts.add(part['text'] as String);
              }
            }
          }
        }
        adviceText = outputTexts.join();
      } else if (content.containsKey('content')) {
        final contentList = content['content'];
        if (contentList is List && contentList.isNotEmpty) {
          adviceText = contentList[0]['text'] ?? '';
        } else if (contentList is String) {
          adviceText = contentList;
        }
      } else if (content.containsKey('message')) {
        final messageContent = content['message']?['content'];
        if (messageContent != null) {
          adviceText = messageContent;
        }
      } else if (content.containsKey('response')) {
        adviceText = content['response'];
      } else if (content.containsKey('advice')) {
        adviceText = content['advice'];
      }

      if (adviceText.isNotEmpty) {
        final adviceJson = _extractJsonFromText(adviceText);
        if (adviceJson != null && adviceJson.containsKey('advice')) {
          adviceText = adviceJson['advice'];
        }
      }

      if (adviceText.isEmpty) {
        throw Exception('Can\'t find advice in response');
      }

      return AIAdvice(
        advice: adviceText,
        timestamp: DateTime.now(),
        city: cityName,
      );
    } catch (e) {
      debugPrint('Failed to parse JSON: $e');
      return null;
    }
  }

  // Extracts the advice JSON object embedded in a provider response.
  static Map<String, dynamic>? _extractJsonFromText(String text) {
    try {
      final jsonRegex = RegExp(r'\{[^{}]*"advice"[^{}]*\}', dotAll: true);
      final match = jsonRegex.firstMatch(text);
      if (match != null) {
        return jsonDecode(match.group(0)!);
      }
    } catch (e) {
      debugPrint('Extract json failed: $e');
    }
    return null;
  }

  // 清空所有 AI 建议缓存
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_adviceCacheKey)) {
        await prefs.remove(key);
      }
    }
  }
}
