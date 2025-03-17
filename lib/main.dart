// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'theme.dart';
import 'splash_screen.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
// If using Provider, import your providers, etc.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(const LittleGuardianApp());
}

class LittleGuardianApp extends StatelessWidget {
  const LittleGuardianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LittleGuardian',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // We'll use routes for easier navigation
      initialRoute: '/splash',
      routes: {
        '/splash': (ctx) =>  SplashScreen(),
        '/login': (ctx) => const LoginPage(),
        '/home': (ctx) => const HomePage(),
      },
    );
  }
}
