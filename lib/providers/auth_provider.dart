// lib/providers/my_auth_provider.dart
import 'package:flutter/material.dart';

/// A minimal "fake" auth system that tracks role and email in memory.
class MyAuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _role = 'parent'; // or 'babysitter'
  String _email = '';

  bool get isLoggedIn => _isLoggedIn;
  String get role => _role;
  String get email => _email;

  /// Fake login method
  Future<void> fakeLogin({required String email, required String role}) async {
    // pretend to wait a bit
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = true;
    _role = role;
    _email = email;
    notifyListeners();
  }

  /// Fake logout
  Future<void> fakeLogout() async {
    _isLoggedIn = false;
    _role = 'parent';
    _email = '';
    notifyListeners();
  }
}
