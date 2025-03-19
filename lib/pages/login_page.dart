// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  String _role = 'parent';
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _fakeLogin() async {
    setState(() => _loading = true);

    final email = _emailCtrl.text.trim().isNotEmpty
        ? _emailCtrl.text.trim()
        : 'guest@example.com';

    final auth = Provider.of<MyAuthProvider>(context, listen: false);
    await auth.fakeLogin(email: email, role: _role);

    setState(() => _loading = false);

    if (auth.role == 'parent') {
      Navigator.pushReplacementNamed(context, '/parentHome');
    } else {
      Navigator.pushReplacementNamed(context, '/babysitterHome');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text("Fake Login", style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _role,
                    items: const [
                      DropdownMenuItem(value: 'parent', child: Text("Parent")),
                      DropdownMenuItem(value: 'babysitter', child: Text("Babysitter")),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _role = val);
                    },
                    decoration: const InputDecoration(labelText: "Role"),
                  ),
                  const SizedBox(height: 24),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _fakeLogin,
                          child: const Text("Log In"),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
