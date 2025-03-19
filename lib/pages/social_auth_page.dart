// lib/pages/social_auth_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' show MyAuthProvider;

class SocialAuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<MyAuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Social Sign-In")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sign In with Google / Facebook (Stub)"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Example Google sign-in flow
                await auth.signInWithGoogle();
                final role = auth.user?.role;
                if (role == 'parent') {
                  Navigator.pushReplacementNamed(context, '/parentHome');
                } else if (role == 'babysitter') {
                  Navigator.pushReplacementNamed(context, '/babysitterHome');
                } else if (role == 'admin') {
                  Navigator.pushReplacementNamed(context, '/adminDashboard');
                } else {
                  Navigator.pushReplacementNamed(context, '/parentHome');
                }
              },
              child: const Text("Sign in with Google"),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement Facebook sign-in
              },
              child: const Text("Sign in with Facebook"),
            ),
          ],
        ),
      ),
    );
  }
}
