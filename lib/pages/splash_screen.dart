// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check auth state after a short delay to allow splash animation to be seen
    Future.delayed(Duration(seconds: 2), () {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Not logged in, go to login
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Logged in, go to home
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/splash_anim.json', 
          width: 200, height: 200, fit: BoxFit.contain),
      ),
    );
  }
}
