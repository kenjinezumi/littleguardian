// lib/providers/profile_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/child_profile.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _loading = false;
  bool get loading => _loading;

  List<ChildProfile> _children = [];
  List<ChildProfile> get children => _children;

  /// Load child profiles for a parent
  Future<void> loadChildren(String parentId) async {
    _loading = true;
    notifyListeners();
    final snapshot = await _db
        .collection('childProfiles')
        .where('parentId', isEqualTo: parentId)
        .get();

    _children = snapshot.docs.map((doc) {
      return ChildProfile.fromMap(doc.id, doc.data());
    }).toList();
    _loading = false;
    notifyListeners();
  }

  /// Add or Update child profile
  Future<void> addChildProfile(ChildProfile child) async {
    final docRef = _db.collection('childProfiles').doc(child.childId);
    await docRef.set(child.toMap(), SetOptions(merge: true));
  }

  /// Update parent's extra details (address, emergency contacts, etc.)
  Future<void> updateParentDetails(String parentId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(parentId).update(data);
  }
}
