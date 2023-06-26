import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TaskReminderHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    tz.initializeTimeZones();

    await Workmanager().registerOneOffTask(
      'taskReminder',
      'taskReminderTask',
      initialDelay: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) {
      if (task == 'taskReminderTask') {
        // Handle task reminder logic here
        // You can schedule the next reminder or perform any necessary actions
      }

      return Future.value(true);
    });
  }

  static Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static Future<void> scheduleTaskReminder({
    required String id,
    required String title,
    required String description,
    required DateTime taskDateTime,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: "your_channel_description",
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    debugPrint("Schedule set!");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      title, // Notification title
      description, // Notification body
      tz.TZDateTime.from(taskDateTime, tz.local), // Scheduled date and time
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
