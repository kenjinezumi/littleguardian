// lib/app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'splash_screen.dart';
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
        title: 'LittleGuardian',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
