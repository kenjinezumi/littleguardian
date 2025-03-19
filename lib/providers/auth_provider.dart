// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../models/app_user.dart';

class MyAuthProvider extends ChangeNotifier {
  // If you DO NOT want real Firebase,
  // remove or comment out these lines:
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // ...

  AppUser? _user;
  bool _isLoading = true;

  AppUser? get user => _user;
  bool get isLoading => _isLoading;

  MyAuthProvider() {
    _isLoading = false;
    // not doing real Firebase init
  }

  /// Fake sets a user for basic testing
  void setFakeUser(AppUser fake) {
    _user = fake;
    _isLoading = false;
    notifyListeners();
  }

  /// Fake Register
  Future<String?> register(String email, String password, String role) async {
    // Do nothing, always "succeed"
    return null;
  }

  /// Fake Login
  Future<String?> login(String email, String password) async {
    // Do nothing, always "succeed"
    return null;
  }

  /// Fake Logout
  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }

  // STUB Methods for phone auth
  Future<void> requestPhoneOTP(String phoneNumber) async {
    // Just print or do nothing
    debugPrint("Fake phone OTP requested for $phoneNumber");
    // no real phone logic
  }

  Future<String?> verifyPhoneOTP(String smsCode) async {
    // Always "succeed"
    debugPrint("Fake verify phone OTP: $smsCode");
    // Return null = success
    return null;
  }

  // Stub method for Google sign-in
  Future<void> signInWithGoogle() async {
    debugPrint("Fake Google login (stub).");
    // For example, set a dummy user:
    setFakeUser(AppUser(
      uid: 'fakeGoogleUID',
      email: 'fake.googleuser@example.com',
      role: 'parent',
      isVerified: true,
    ));
  }
}
