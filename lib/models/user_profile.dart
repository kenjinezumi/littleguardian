// lib/models/user_profile.dart
class UserProfile {
  final String email;      // key to identify
  final String role;       // 'parent' or 'babysitter'
  final String name;
  final String phone;
  final String address;
  final String bio;
  final String avatarUrl;  // link or local asset

  const UserProfile({
    required this.email,
    required this.role,
    required this.name,
    required this.phone,
    required this.address,
    required this.bio,
    required this.avatarUrl,
  });

  UserProfile copyWith({
    String? name,
    String? phone,
    String? address,
    String? bio,
    String? avatarUrl,
  }) {
    return UserProfile(
      email: email,
      role: role,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
