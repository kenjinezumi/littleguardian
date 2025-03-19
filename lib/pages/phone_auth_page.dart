// lib/pages/phone_auth_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' show MyAuthProvider;

class PhoneAuthPage extends StatefulWidget {
  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _phoneCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _sendOTP() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter phone number")));
      return;
    }
    final auth = Provider.of<MyAuthProvider>(context, listen: false);
    setState(() => _loading = true);
    await auth.requestPhoneOTP(phone);
    setState(() => _loading = false);
    Navigator.pushNamed(context, '/otp');
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Authentication")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Enter phone number to receive an OTP"),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendOTP,
                    child: const Text("Send OTP"),
                  ),
          ],
        ),
      ),
    );
  }
}
