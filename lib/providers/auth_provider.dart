import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AppUser? _user;
  bool _isLoading = true;

  AuthProvider() {
    _init();
  }

  AppUser? get user => _user;
  bool get isLoading => _isLoading;

  void _init() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        _user = null;
        _isLoading = false;
        notifyListeners();
      } else {
        // Fetch Firestore user doc
        final doc = await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists) {
          _user = AppUser.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        }
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<String?> register(String email, String password, String role) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final uid = cred.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'role': role,
        'createdAt': DateTime.now().toIso8601String()
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
