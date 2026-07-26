import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

import '../../features/weather/domain/entities/weather_warning.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (kDebugMode) {
    print(
        "Handling notification tap in background: ${notificationResponse.payload}");
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  // Serialize warning notifications so concurrent weather refreshes cannot
  // read and update the persisted de-duplication set at the same time.
  static Future<void> _warningNotificationQueue = Future<void>.value();

  static const String _legacyNotifiedWarningIdsKey =
      'notified_weather_warning_ids';
  static const String _warningRecordsKey =
      'weather_warning_notification_records';
  static const String _lastWarningCleanupKey =
      'weather_warning_last_cleanup_at';
  static const Duration _warningRecordRetention = Duration(days: 7);

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      await Permission.notification.request();
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('UTC'));

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true);

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _notificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {
          if (kDebugMode) {
            debugPrint('notification payload: ${response.payload}');
          }
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error initializing NotificationService: $e");
      }
    }
  }

  Future<void> showWarningNotifications(List<WeatherWarning> warnings) {
    final operation = _warningNotificationQueue.then((_) async {
      try {
        await _showNewWarningNotifications(warnings);
      } catch (e) {
        if (kDebugMode) {
          debugPrint("Error showing weather warning notifications: $e");
        }
      }
    });
    _warningNotificationQueue = operation;
    return operation;
  }

  Future<void> _showNewWarningNotifications(
      List<WeatherWarning> warnings) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    final warningRecords = _loadWarningRecords(prefs, now);
    await _cleanupWarningRecords(prefs, warningRecords, now);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'weather_warnings_channel',
      'Weather Warnings',
      channelDescription: 'Channel for weather warning notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    for (final warning in warnings) {
      final warningKey = _getWarningKey(warning);
      if (warningRecords.containsKey(warningKey)) {
        // Keep active warnings alive so they are not removed during cleanup.
        warningRecords[warningKey] = now;
        continue;
      }

      try {
        await _notificationsPlugin.show(
          id: _getNotificationId(warningKey),
          title: warning.title,
          body: warning.text,
          notificationDetails: platformChannelSpecifics,
          payload: 'weather_warning:$warningKey',
        );
        warningRecords[warningKey] = now;
        if (kDebugMode) {
          debugPrint("Showing notification: ${warning.title}");
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint("Error showing notification: $e");
        }
      }
    }

    await prefs.setString(_warningRecordsKey, jsonEncode(warningRecords));
    await prefs.remove(_legacyNotifiedWarningIdsKey);
  }

  // Load the timestamped records and migrate the previous string-list format.
  Map<String, int> _loadWarningRecords(
      SharedPreferences prefs, int migratedAt) {
    final records = <String, int>{};
    final encodedRecords = prefs.getString(_warningRecordsKey);
    if (encodedRecords != null) {
      try {
        final decoded = jsonDecode(encodedRecords);
        if (decoded is Map) {
          for (final entry in decoded.entries) {
            if (entry.key is String && entry.value is num) {
              records[entry.key as String] = (entry.value as num).toInt();
            }
          }
        }
      } catch (_) {
        // Invalid persisted data is ignored and rebuilt from future warnings.
      }
      return records;
    }

    final legacyIds = prefs.getStringList(_legacyNotifiedWarningIdsKey) ?? [];
    for (final warningKey in legacyIds) {
      records[warningKey] = migratedAt;
    }
    return records;
  }

  // Remove warnings unseen for seven days, but only run this scan weekly.
  Future<void> _cleanupWarningRecords(
      SharedPreferences prefs, Map<String, int> records, int now) async {
    final lastCleanupAt = prefs.getInt(_lastWarningCleanupKey);
    if (lastCleanupAt != null &&
        now - lastCleanupAt < _warningRecordRetention.inMilliseconds) {
      return;
    }

    records.removeWhere((_, lastSeenAt) =>
        now - lastSeenAt >= _warningRecordRetention.inMilliseconds);
    await prefs.setInt(_lastWarningCleanupKey, now);
  }

  // Prefer the server-provided ID; the field-based fallback supports APIs
  // that omit it while remaining stable across weather refreshes.
  String _getWarningKey(WeatherWarning warning) {
    if (warning.id.isNotEmpty) {
      return 'id:${warning.id}';
    }
    return 'fallback:${jsonEncode([
          warning.sender,
          warning.pubTime,
          warning.title,
          warning.startTime,
          warning.endTime,
          warning.type,
          warning.text,
        ])}';
  }

  // Use a stable positive ID so each warning gets its own system notification.
  int _getNotificationId(String warningKey) {
    var hash = 0x811c9dc5;
    for (final unit in warningKey.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }
}
