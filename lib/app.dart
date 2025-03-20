// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/job_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/profile_provider.dart';

// Pages
import 'pages/splash_screen.dart';
import 'pages/login_page.dart';
import 'pages/parent/parent_home_page.dart';
import 'pages/babysitter/babysitter_home_page.dart';
import 'pages/booking_details_page.dart';

class LittleGuardianApp extends StatelessWidget {
  const LittleGuardianApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyAuthProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Builder(
        // We use a Builder or Consumer to watch the ThemeProvider
        builder: (context) {
          final themeProv = context.watch<ThemeProvider>();
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'LittleGuardian',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            // This is the key line: use themeProv.themeMode
            themeMode: themeProv.themeMode, 

            initialRoute: '/splash',
            routes: {
              '/splash': (ctx) => const SplashScreen(),
              '/login': (ctx) => const LoginPage(),
              '/parentHome': (ctx) => const ParentHomePage(),
              '/babysitterHome': (ctx) => const BabysitterHomePage(),
              '/bookingDetails': (ctx) => const BookingDetailsPage(),
            },
          );
        },
      ),
    );
  }
}
