// lib/pages/signup_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' show MyAuthProvider;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String _role = 'parent';
  bool _loading = false;
  String? _error;

  Future<void> _signup() async {
    if (_passCtrl.text != _confirmCtrl.text) {
      setState(() => _error = "Passwords do not match");
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    final auth = Provider.of<MyAuthProvider>(context, listen: false);
    final res = await auth.register(_emailCtrl.text.trim(), _passCtrl.text.trim(), _role);
    setState(() => _loading = false);

    if (res == null) {
      if (auth.user?.role == 'parent') {
        Navigator.pushReplacementNamed(context, '/parentHome');
      } else if (auth.user?.role == 'babysitter') {
        Navigator.pushReplacementNamed(context, '/babysitterHome');
      } else if (auth.user?.role == 'admin') {
        Navigator.pushReplacementNamed(context, '/adminDashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/parentHome');
      }
    } else {
      setState(() => _error = res);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up - LittleGuardian")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            TextField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmCtrl,
              decoration: const InputDecoration(labelText: "Confirm Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'parent', child: Text("Parent")),
                DropdownMenuItem(value: 'babysitter', child: Text("Babysitter")),
                DropdownMenuItem(value: 'admin', child: Text("Admin")),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _role = val);
                }
              },
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _signup,
                    child: const Text("Sign Up"),
                  ),
          ],
        ),
      ),
    );
  }
}
