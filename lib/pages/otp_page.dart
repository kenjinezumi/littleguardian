// lib/pages/otp_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart' show MyAuthProvider;

class OtpPage extends StatefulWidget {
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _verifyOTP() async {
    final smsCode = _otpCtrl.text.trim();
    if (smsCode.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter OTP")));
      return;
    }
    final auth = Provider.of<MyAuthProvider>(context, listen: false);
    setState(() => _loading = true);
    final res = await auth.verifyPhoneOTP(smsCode);
    setState(() => _loading = false);

    if (res == null) {
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
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $res")));
    }
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("OTP Verification")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Enter the OTP sent to your phone"),
            const SizedBox(height: 10),
            TextField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _verifyOTP,
                    child: const Text("Verify"),
                  ),
          ],
        ),
      ),
    );
  }
}
