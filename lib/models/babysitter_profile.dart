// lib/models/babysitter_profile.dart
class BabysitterProfile {
  final String uid;
  final String fullName;
  final double hourlyRate;
  final List<String> certifications; // e.g. ["CPR", "First Aid", "Childcare Degree"]
  final bool backgroundCheckPassed;
  final String bio;
  final List<String> preferredWorkAreas;
  final double rating; // average rating
  final int ratingCount;

  BabysitterProfile({
    required this.uid,
    required this.fullName,
    required this.hourlyRate,
    this.certifications = const [],
    this.backgroundCheckPassed = false,
    this.bio = '',
    this.preferredWorkAreas = const [],
    this.rating = 0.0,
    this.ratingCount = 0,
  });

  factory BabysitterProfile.fromMap(String uid, Map<String, dynamic> data) {
    return BabysitterProfile(
      uid: uid,
      fullName: data['fullName'] ?? '',
      hourlyRate: (data['hourlyRate'] ?? 0).toDouble(),
      certifications: List<String>.from(data['certifications'] ?? []),
      backgroundCheckPassed: data['backgroundCheckPassed'] ?? false,
      bio: data['bio'] ?? '',
      preferredWorkAreas: List<String>.from(data['preferredWorkAreas'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      ratingCount: data['ratingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'hourlyRate': hourlyRate,
      'certifications': certifications,
      'backgroundCheckPassed': backgroundCheckPassed,
      'bio': bio,
      'preferredWorkAreas': preferredWorkAreas,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }
}
