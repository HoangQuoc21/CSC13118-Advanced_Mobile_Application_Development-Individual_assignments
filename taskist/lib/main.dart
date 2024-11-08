import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'package:taskist/ui/my_app.dart';
import 'package:taskist/services/notification_services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:taskist/utils/utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Timezone
  tz.initializeTimeZones();

  // Request NOTIFICATION permission
  await requestNotificationPermission();
  await requestExactAlarmPermission();

  // Initialize NotificationService
  final NotificationService notificationService = NotificationService();

  // Check pending notifications
  //notificationService.checkPendingNotifications();

  // Test immediate notification
  //await notificationService.testImmediateNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoProvider()),
        Provider<NotificationService>.value(value: notificationService),
      ],
      child: const MyApp(),
    ),
  );
}
