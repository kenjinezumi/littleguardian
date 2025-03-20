import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'theme.dart';
import 'pages/parent/parent_home_page.dart';
import 'providers/booking_provider.dart';
import 'providers/job_provider.dart';
import 'providers/profile_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide MyAuthProvider so all descendants can use context.watch<MyAuthProvider>()
        ChangeNotifierProvider<MyAuthProvider>(create: (_) => MyAuthProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),


      ],
      child: MaterialApp(
        title: 'My App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const ParentHomePage(),
      ),
    );
  }
}
