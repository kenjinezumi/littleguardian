// lib/providers/babysitter_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/babysitter_profile.dart';

class BabysitterProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  BabysitterProfile? _myProfile;
  bool _loading = false;

  BabysitterProfile? get myProfile => _myProfile;
  bool get loading => _loading;

  Future<void> loadBabysitterProfile(String uid) async {
    _loading = true;
    notifyListeners();
    final doc = await _db.collection('babysitterProfiles').doc(uid).get();
    if (doc.exists) {
      _myProfile = BabysitterProfile.fromMap(doc.id, doc.data()!);
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> updateBabysitterProfile(BabysitterProfile profile) async {
    await _db
        .collection('babysitterProfiles')
        .doc(profile.uid)
        .set(profile.toMap(), SetOptions(merge: true));
    _myProfile = profile;
    notifyListeners();
  }

  /// Searching for babysitters (for auto-match or parent's view)
  Future<List<BabysitterProfile>> searchBabysitters({
    String? location,
    double? maxRate,
    List<String>? certs,
  }) async {
    // For demonstration, fetch all, then filter locally
    final snap = await _db.collection('babysitterProfiles').get();
    final all = snap.docs
        .map((d) => BabysitterProfile.fromMap(d.id, d.data()))
        .toList();

    List<BabysitterProfile> filtered = all;

    if (location != null && location.isNotEmpty) {
      filtered = filtered.where((b) => b.preferredWorkAreas.contains(location)).toList();
    }
    if (maxRate != null) {
      filtered = filtered.where((b) => b.hourlyRate <= maxRate).toList();
    }
    if (certs != null && certs.isNotEmpty) {
      filtered = filtered.where((b) {
        for (var cert in certs) {
          if (!b.certifications.contains(cert)) return false;
        }
        return true;
      }).toList();
    }
    return filtered;
  }
}
