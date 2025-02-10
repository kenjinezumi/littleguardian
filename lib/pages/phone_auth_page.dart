// phone_auth_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthPage extends StatefulWidget {
  @override
  _PhoneAuthPageState createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final _phoneController = TextEditingController();
  bool _isSendingCode = false; // to show a loader if needed

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _requestOTP() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number.')),
      );
      return;
    }
    setState(() { _isSendingCode = true; });
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-verification (Android) - sign in immediately and navigate to Home
        await auth.signInWithCredential(credential);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() { _isSendingCode = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone verification failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() { _isSendingCode = false; });
        // Navigate to OTP page with the verificationId
        Navigator.pushNamed(
          context,
          '/otp',
          arguments: verificationId,
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out (not necessarily an error)
        // You might allow resending code here in a real app.
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Authentication')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Enter your phone number to receive an OTP:', 
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '+1 234 567 890', // example format
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            _isSendingCode 
              ? CircularProgressIndicator() 
              : ElevatedButton(
                  onPressed: _requestOTP,
                  child: Text('Send OTP'),
                ),
          ],
        ),
      ),
    );
  }
}
