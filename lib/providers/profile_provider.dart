// lib/providers/profile_provider.dart
import 'package:flutter/material.dart';

/// For demonstration, we skip Firestore and use a simple in-memory map.
class ProfileProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  // Mock child profile logic (if you need it)
  // For now, just store an empty list or in-memory data
  // If you want ChildProfile, define it, but we keep it minimal
  //List<ChildProfile> _children = [];
  //List<ChildProfile> get children => _children;

  /// A local Map storing user data: userId -> Map
  /// So we can simulate "fetchProfile" and "updateProfile"
  final Map<String, Map<String, dynamic>> _userProfiles = {
    "parentA@example.com": {
      "role": "parent",
      "name": "Parent A",
      "phone": "555-1234",
      "address": "123 Maple St",
      "bio": "Loving parent of 2 kids",
      "avatarUrl": "https://i.pravatar.cc/150?u=parentA",
    },
    "sitter1@example.com": {
      "role": "babysitter",
      "name": "Sitter One",
      "phone": "555-9999",
      "address": "456 Oak Lane",
      "bio": "Experienced babysitter with CPR cert",
      "avatarUrl": "https://i.pravatar.cc/150?u=sitter1",
    },
  };

  /// Mock fetchProfile: returns a Future so we can mimic an async call
  Future<Map<String, dynamic>?> fetchProfile(String userId, String role) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));
    _loading = false;
    notifyListeners();

    return _userProfiles[userId]; // null if not found
  }

  /// Mock updateProfile: merges fields into the local map
  Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));

    final existing = _userProfiles[userId];
    if (existing == null) {
      _userProfiles[userId] = data;
    } else {
      existing.addAll(data); // merges
    }

    _loading = false;
    notifyListeners();
  }
}
