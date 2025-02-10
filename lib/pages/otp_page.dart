// otp_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();

  // We expect the verificationId to be passed in as an argument to this route
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  String? verificationId; // will hold the verificationId from arguments

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the verificationId passed from the previous screen
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      verificationId = args;
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final code = _otpController.text.trim();
    if (verificationId == null || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid code or verification ID.')),
      );
      return;
    }
    try {
      // Create a PhoneAuthCredential with the code and verification ID :contentReference[oaicite:7]{index=7}
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      );
      // Sign in the user with this credential
      await FirebaseAuth.instance.signInWithCredential(credential);
      // If successful, remove all previous routes and go to Home
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify OTP: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OTP Verification')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter the OTP sent to your phone:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '6-digit code',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _verifyCode,
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
