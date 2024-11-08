import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(
      int id, String title, DateTime dueTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final scheduledNotificationDateTime =
        dueTime.subtract(const Duration(minutes: 10));

    final tz.TZDateTime tzScheduledNotificationDateTime =
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.timeZoneDatabase.locations['Asia/Kolkata'] ?? tz.UTC,
        );

    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Todo Reminder',
        'Your todo "$title" is due in 10 minutes',
        tzScheduledNotificationDateTime,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      print('--> Error scheduling notification: $e');
    }
  }

  Future<void> checkPendingNotifications() async {

    final List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    print('--> Number of pending notifications: ${pendingNotifications.length}');
    if (pendingNotifications.isEmpty) {
      print('--> No pending notifications found.');
    } else {
      for (var notification in pendingNotifications) {
        print(
            '--> Pending notification: ${notification.id}, ${notification.title}, ${notification.body}, ${notification.payload}');
      }
    }
  }

  // Test with immediate notification
  Future<void> testImmediateNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await flutterLocalNotificationsPlugin.show(
        0,
        'Immediate Test Notification',
        'This is a test notification',
        platformChannelSpecifics,
      );
    } catch (e) {
      print('--> Error showing immediate notification: $e');
    }
  }
}



