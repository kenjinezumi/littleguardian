// lib/models/app_user.dart
class AppUser {
  final String uid;
  final String email;
  final String role;      // 'parent', 'babysitter', 'admin'
  final bool isVerified;  // e.g. background check or ID verified

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
    this.isVerified = false,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      role: data['role'] ?? 'parent',
      isVerified: data['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role,
      'isVerified': isVerified,
    };
  }
}
