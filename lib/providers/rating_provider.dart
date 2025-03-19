// lib/providers/profile_provider.dart
import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileProvider extends ChangeNotifier {
  /// In-memory store: email -> UserProfile
  final Map<String, UserProfile> _profilesMap = {
    "parentA@example.com": UserProfile(
      email: "parentA@example.com",
      role: "parent",
      name: "Parent A",
      phone: "555-1234",
      address: "123 Maple St",
      bio: "Loving parent of 2 kids. Enjoys family outings and reading.",
      avatarUrl: "https://i.pravatar.cc/150?u=parentA@example.com",
    ),
    "parentB@example.com": UserProfile(
      email: "parentB@example.com",
      role: "parent",
      name: "Parent B",
      phone: "555-5678",
      address: "456 Oak Ave",
      bio: "Working mom who needs occasional help with babysitting.",
      avatarUrl: "https://i.pravatar.cc/150?u=parentB@example.com",
    ),
    "sitter1@example.com": UserProfile(
      email: "sitter1@example.com",
      role: "babysitter",
      name: "Sitter One",
      phone: "555-1111",
      address: "789 Pine Rd",
      bio: "Certified babysitter with 5 years experience. Loves arts & crafts!",
      avatarUrl: "https://i.pravatar.cc/150?u=sitter1@example.com",
    ),
    "sitter2@example.com": UserProfile(
      email: "sitter2@example.com",
      role: "babysitter",
      name: "Sitter Two",
      phone: "555-2222",
      address: "1010 Birch Blvd",
      bio: "Part-time babysitter, student majoring in Early Childhood Ed.",
      avatarUrl: "https://i.pravatar.cc/150?u=sitter2@example.com",
    ),
  };

  /// Retrieve the profile for this email, or a default
  UserProfile fetchProfile(String email, String role) {
    // If not found, create a minimal placeholder
    if (!_profilesMap.containsKey(email)) {
      _profilesMap[email] = UserProfile(
        email: email,
        role: role,
        name: "New User",
        phone: "",
        address: "",
        bio: "",
        avatarUrl: "https://i.pravatar.cc/150?u=$email",
      );
    }
    return _profilesMap[email]!;
  }

  /// Update the profile in memory
  void updateProfile(UserProfile updated) {
    _profilesMap[updated.email] = updated;
    notifyListeners();
  }
}
