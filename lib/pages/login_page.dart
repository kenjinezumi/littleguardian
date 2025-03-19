// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart' show MyAuthProvider;
import '../models/app_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);

    // Create a dummy AppUser (you can choose role = 'parent', 'babysitter', or 'admin')
    final fake = AppUser(
      uid: 'fakeUID123',
      email: _emailCtrl.text.trim().isNotEmpty
          ? _emailCtrl.text.trim()
          : 'fake@example.com',
      role: 'parent', // or 'babysitter'
      isVerified: true,
    );

    // Grab your MyAuthProvider and set the fake user
    final auth = Provider.of<MyAuthProvider>(context, listen: false);
    auth.setFakeUser(fake);

    setState(() => _loading = false);

    // Now choose where to navigate
    if (fake.role == 'parent') {
      Navigator.pushReplacementNamed(context, '/parentHome');
    } else if (fake.role == 'babysitter') {
      Navigator.pushReplacementNamed(context, '/babysitterHome');
    } else if (fake.role == 'admin') {
      Navigator.pushReplacementNamed(context, '/adminDashboard');
    } else {
      Navigator.pushReplacementNamed(context, '/parentHome');
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Minimal UI with two textfields for show
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text("Fake Login (Testing)", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),
              TextField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email (Optional)"),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passCtrl,
                decoration: const InputDecoration(labelText: "Password (Optional)"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text("Log In (Fake)"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
