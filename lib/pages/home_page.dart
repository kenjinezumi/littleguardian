// home_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    String displayText = 'Welcome!';
    if (user != null) {
      // If the user has an email (for email/Google sign-in), show it
      displayText = user.phoneNumber != null && user.phoneNumber!.isNotEmpty
          ? 'Welcome, ${user.phoneNumber}!'   // logged in via phone
          : 'Welcome, ${user.email}!';
    }
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(displayText, style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
