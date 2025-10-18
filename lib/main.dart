import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/theme_service.dart';
import 'services/alarm_service.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/alarm_ringing_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();

  // Initialize services
  await ThemeService().initialize();
  await AlarmService().initialize();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const AlarmClockApp());
}

class AlarmClockApp extends StatelessWidget {
  const AlarmClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeService(),
      builder: (context, child) {
        return MaterialApp(
          title: 'Smart Alarm Clock',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: ThemeService().lightTheme,
          darkTheme: ThemeService().darkTheme,
          themeMode: ThemeService().isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const SplashScreen(),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/alarm_ringing': (context) => const AlarmRingingScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/alarm_ringing') {
              return MaterialPageRoute(
                builder: (context) => const AlarmRingingScreen(),
                settings: settings,
              );
            }
            return null;
          },
        );
      },
    );
  }
}
