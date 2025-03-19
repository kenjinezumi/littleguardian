// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart' show MyAuthProvider;
import 'providers/profile_provider.dart';
import 'providers/babysitter_provider.dart';
import 'providers/job_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/rating_provider.dart';
import 'providers/admin_provider.dart';

import 'pages/splash_screen.dart';
import 'pages/login_page.dart';
import 'pages/signup_page.dart';
import 'pages/phone_auth_page.dart';
import 'pages/otp_page.dart';
import 'pages/social_auth_page.dart';
import 'pages/parent/parent_home_page.dart';
import 'pages/babysitter/babysitter_home_page.dart';
import 'pages/admin/admin_dashboard_page.dart';

class LittleGuardianApp extends StatelessWidget {
  const LittleGuardianApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAuthProvider>(create: (_) => MyAuthProvider()),
        ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
        ChangeNotifierProvider<BabysitterProvider>(create: (_) => BabysitterProvider()),
        ChangeNotifierProvider<JobProvider>(create: (_) => JobProvider()),
        ChangeNotifierProvider<BookingProvider>(create: (_) => BookingProvider()),
        ChangeNotifierProvider<PaymentProvider>(create: (_) => PaymentProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
        ChangeNotifierProvider<RatingProvider>(create: (_) => RatingProvider()),
        ChangeNotifierProvider<AdminProvider>(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LittleGuardian',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (ctx) => const SplashScreen(),
          '/login': (ctx) => const LoginPage(),
          '/signup': (ctx) => const SignUpPage(),
          '/phoneAuth': (ctx) => PhoneAuthPage(),
          '/otp': (ctx) => OtpPage(),
          '/socialAuth': (ctx) => SocialAuthPage(),
          '/parentHome': (ctx) => const ParentHomePage(),
          '/babysitterHome': (ctx) => const BabysitterHomePage(),
          '/adminDashboard': (ctx) => const AdminDashboardPage(),
        },
      ),
    );
  }
}
