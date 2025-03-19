// lib/models/child_profile.dart
class ChildProfile {
  final String childId;
  final String parentId;
  final String name;
  final int age;
  final bool hasSpecialNeeds;
  final bool hasAllergies;
  final bool hasPets;
  final String notes;

  ChildProfile({
    required this.childId,
    required this.parentId,
    required this.name,
    required this.age,
    this.hasSpecialNeeds = false,
    this.hasAllergies = false,
    this.hasPets = false,
    this.notes = '',
  });

  factory ChildProfile.fromMap(String id, Map<String, dynamic> data) {
    return ChildProfile(
      childId: id,
      parentId: data['parentId'] ?? '',
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      hasSpecialNeeds: data['hasSpecialNeeds'] ?? false,
      hasAllergies: data['hasAllergies'] ?? false,
      hasPets: data['hasPets'] ?? false,
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'name': name,
      'age': age,
      'hasSpecialNeeds': hasSpecialNeeds,
      'hasAllergies': hasAllergies,
      'hasPets': hasPets,
      'notes': notes,
    };
  }
}
