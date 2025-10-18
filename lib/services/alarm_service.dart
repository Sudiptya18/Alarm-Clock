import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/alarm.dart';
import '../main.dart';

class AlarmService extends ChangeNotifier {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<Alarm> _alarms = [];
  List<Alarm> get alarms => List.unmodifiable(_alarms);

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();

    await _loadAlarms();
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      'alarm_channel',
      'Alarm Notifications',
      description: 'Notifications for alarm clock',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledColor: Colors.red,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  Future<void> _onNotificationTapped(NotificationResponse response) async {
    if (response.payload != null) {
      final payload = jsonDecode(response.payload!);
      final alarmId = payload['alarmId'] as String;
      final hasMathChallenge = payload['hasMathChallenge'] as bool;
      
      // Cancel the notification
      await _notificationsPlugin.cancel(alarmId.hashCode);
      
      // Navigate to alarm ringing screen
      if (navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamed('/alarm_ringing');
      }
      
      print('Alarm notification tapped: $alarmId, Math Challenge: $hasMathChallenge');
    }
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getStringList('alarms') ?? [];

    _alarms = alarmsJson
        .map((json) => Alarm.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = _alarms
        .map((alarm) => jsonEncode(alarm.toJson()))
        .toList();

    await prefs.setStringList('alarms', alarmsJson);
  }

  Future<void> addAlarm(Alarm alarm) async {
    _alarms.add(alarm);
    await _saveAlarms();
    await _scheduleAlarm(alarm);
    notifyListeners();
  }

  Future<void> updateAlarm(Alarm updatedAlarm) async {
    final index = _alarms.indexWhere((alarm) => alarm.id == updatedAlarm.id);
    if (index != -1) {
      await _cancelAlarm(_alarms[index]);
      _alarms[index] = updatedAlarm;
      await _saveAlarms();
      await _scheduleAlarm(updatedAlarm);
      notifyListeners();
    }
  }

  Future<void> deleteAlarm(String alarmId) async {
    final alarm = _alarms.firstWhere((alarm) => alarm.id == alarmId);
    await _cancelAlarm(alarm);
    _alarms.removeWhere((alarm) => alarm.id == alarmId);
    await _saveAlarms();
    notifyListeners();
  }

  Future<void> toggleAlarm(String alarmId) async {
    final index = _alarms.indexWhere((alarm) => alarm.id == alarmId);
    if (index != -1) {
      final alarm = _alarms[index];
      final updatedAlarm = alarm.copyWith(isEnabled: !alarm.isEnabled);

      if (alarm.isEnabled) {
        await _cancelAlarm(alarm);
      } else {
        await _scheduleAlarm(updatedAlarm);
      }

      _alarms[index] = updatedAlarm;
      await _saveAlarms();
      notifyListeners();
    }
  }

  Future<void> _scheduleAlarm(Alarm alarm) async {
    if (!alarm.isEnabled) return;

    final now = DateTime.now();
    var alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.time.hour,
      alarm.time.minute,
    );

    // If alarm time has passed today, schedule for tomorrow
    if (alarmTime.isBefore(now)) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    // Handle repeat days
    if (alarm.repeatDays.isNotEmpty) {
      for (final day in alarm.repeatDays) {
        final daysUntilTarget = (day - now.weekday) % 7;
        final targetDate = now.add(Duration(days: daysUntilTarget));
        final targetAlarmTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          alarm.time.hour,
          alarm.time.minute,
        );

        if (targetAlarmTime.isAfter(now)) {
          await _scheduleNotification(
            alarm.id,
            alarm.title,
            targetAlarmTime,
            alarm.hasMathChallenge,
          );
        }
      }
    } else {
      // One-time alarm
      await _scheduleNotification(
        alarm.id,
        alarm.title,
        alarmTime,
        alarm.hasMathChallenge,
      );
    }
  }

  Future<void> _scheduleNotification(
    String alarmId,
    String title,
    DateTime scheduledTime,
    bool hasMathChallenge,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      channelDescription: 'Notifications for alarm clock',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledColor: Colors.red,
      ledOnMs: 1000,
      ledOffMs: 500,
      ongoing: true,
      autoCancel: false,
      showWhen: true,
      ticker: 'Alarm is ringing!',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'alarm.mp3',
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      alarmId.hashCode,
      title,
      hasMathChallenge
          ? 'Solve math problems to stop the alarm!'
          : 'Tap to stop the alarm',
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: jsonEncode({
        'alarmId': alarmId,
        'hasMathChallenge': hasMathChallenge,
      }),
    );
  }

  Future<void> _cancelAlarm(Alarm alarm) async {
    await _notificationsPlugin.cancel(alarm.id.hashCode);
  }

  Future<void> cancelAllAlarms() async {
    await _notificationsPlugin.cancelAll();
  }

  Alarm? getAlarmById(String id) {
    try {
      return _alarms.firstWhere((alarm) => alarm.id == id);
    } catch (e) {
      return null;
    }
  }

  // Test method to schedule an alarm for testing (1 minute from now)
  Future<void> scheduleTestAlarm() async {
    final testTime = DateTime.now().add(const Duration(minutes: 1));
    
    await _scheduleNotification(
      'test_alarm',
      'Test Alarm',
      testTime,
      false,
    );
  }
}
