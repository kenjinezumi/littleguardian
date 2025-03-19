// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';
import 'providers/auth_provider.dart';
import 'providers/job_provider.dart';

// Pages
import 'pages/splash_screen.dart';
import 'pages/login_page.dart';
import 'pages/parent/parent_home_page.dart';
import 'pages/babysitter/babysitter_home_page.dart';

class LittleGuardianApp extends StatelessWidget {
  const LittleGuardianApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>(create: (_) => MyAuthProvider()),
        ChangeNotifierProvider<JobProvider>(create: (_) => JobProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LittleGuardian',
        theme: AppTheme.lightTheme,
        // We'll keep a simple named route approach:
        initialRoute: '/splash',
        routes: {
          '/splash': (ctx) => const SplashScreen(),
          '/login': (ctx) => const LoginPage(),
          '/parentHome': (ctx) => const ParentHomePage(),
          '/babysitterHome': (ctx) => const BabysitterHomePage(),
        },
      ),
    );
  }
}
