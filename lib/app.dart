// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
// or whatever references you have

import 'splash_screen.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
import './pages/phone_auth_page.dart';
import './pages/otp_page.dart';

import 'providers/auth_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/rating_provider.dart';

class LittleGuardianApp extends StatelessWidget {
  const LittleGuardianApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<BookingProvider>(create: (_) => BookingProvider()),
        ChangeNotifierProvider<RatingProvider>(create: (_) => RatingProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LittleGuardian',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
        ),
        // We can use home: or initialRoute: or both
        // Let's demonstrate using routes + initialRoute:
        initialRoute: '/',
        routes: {
          // The splash screen is our initial route:
          '/': (ctx) =>  SplashScreen(),
          '/login': (ctx) =>  LoginPage(),
          '/home': (ctx) =>  HomePage(),
          '/phone': (ctx) =>  PhoneAuthPage(),
          '/otp': (ctx) =>  OtpPage(),
        },
      ),
    );
  }
}
