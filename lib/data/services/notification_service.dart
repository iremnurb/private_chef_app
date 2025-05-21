
/*import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    tz.initializeTimeZones(); // Timezone veritabanını initialize et
    tz.setLocalLocation(tz.getLocation('Europe/Istanbul')); // Yerel zaman dilimini ayarla

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        if (details.payload != null) {
          final mealId = int.tryParse(details.payload!) ?? 0;
          navigatorKey.currentState?.pushNamed(
            '/ogun_detay',
            arguments: mealId,
          );
        }
      },
    );
  }

  Future<bool> checkNotificationPermission() async {
    return true; // Bildirim izni AndroidManifest.xml'de tanımlı
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'diet_channel_id',
      'Diet Notifications',
      channelDescription: 'Notifications for meal reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      print('Bildirim başarıyla planlandı: ID $id, Saat: ${scheduledDateTime.toString()}');
    } catch (e) {
      print('Bildirim planlama hatası: $e');
      try {
        await _notificationsPlugin.show(
          id,
          title,
          body,
          notificationDetails,
          payload: payload,
        );
        print('Hata nedeniyle anında bildirim gösterildi: ID $id');
      } catch (showError) {
        print('Anında bildirim gösterilemedi: $showError');
      }
    }
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          navigatorKey.currentState?.pushNamed(
            '/ogun_detay',
            arguments: details.payload,
          );
        }
      },
    );

    // Bildirim izni iste (Android 13 ve sonrası için)
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'diet_channel_id',
      'Diet Notifications',
      channelDescription: 'Notifications for meal reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}