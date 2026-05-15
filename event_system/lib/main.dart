import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../pages/login_page.dart';
import '../pages/EventPage.dart';
import '../pages/schedule_page.dart';
import '../pages/dashboard_page.dart';
import 'pages/profile_page.dart';
import '../pages/CreatEventPage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EventManagerApp());
}

class EventManagerApp extends StatelessWidget {
  const EventManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const EventPage(),
        '/schedule': (context) => const ScheduleScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/profile': (context) => const ProfilePage(),
        '/create': (context) => const CreateEventPage(),
      },
    );
  }
}