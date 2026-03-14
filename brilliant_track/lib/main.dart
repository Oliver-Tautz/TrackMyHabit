import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/notification/notification_service.dart';
import 'services/in_app_reminder_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize notifications (will be no-op on unsupported platforms)
  try {
    await NotificationService().init();
  } catch (_) {}

  // Start in-app reminder service (fallback on platforms without OS notifications)
  InAppReminderService().start(navigatorKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'brilliant.track',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
