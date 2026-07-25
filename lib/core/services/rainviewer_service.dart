import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zephyr/app_constants.dart';
import 'package:zephyr/core/services/weather_cache.dart';

class RainViewerService {
  static final Dio _dio = Dio();
  static const _tileTemplateKey = 'rainviewer_tile_template';
  static const _tileTemplateTimestampKey = 'rainviewer_tile_template_ts';

  // Retrieves the latest radar frame so the map can overlay current rainfall.
  static Future<String?> getLatestRadarTileTemplate() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedTemplate = prefs.getString(_tileTemplateKey);
    final cachedTimestamp = prefs.getInt(_tileTemplateTimestampKey);
    if (cachedTemplate != null && cachedTimestamp != null) {
      final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedTimestamp);
      if (DateTime.now().difference(cachedAt) <= weatherCacheMaxAge) {
        return cachedTemplate;
      }
    }

    try {
      final response = await _dio
          .getUri<String>(
            Uri.parse(AppConstants.rainViewerUrl),
            options: Options(
              responseType: ResponseType.plain,
              validateStatus: (_) => true,
            ),
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;

      final payload = jsonDecode(response.data!) as Map<String, dynamic>;
      final host = payload['host'];
      final frames = (payload['radar'] as Map<String, dynamic>?)?['past'];
      if (host is! String || frames is! List || frames.isEmpty) return null;

      final latestFrame = frames.last as Map<String, dynamic>?;
      final path = latestFrame?['path'];
      if (path is! String) return null;

      final template = '$host$path/256/{z}/{x}/{y}/2/1_1.png';
      await prefs.setString(_tileTemplateKey, template);
      await prefs.setInt(
        _tileTemplateTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      return template;
    } catch (_) {
      return null;
    }
  }
}
