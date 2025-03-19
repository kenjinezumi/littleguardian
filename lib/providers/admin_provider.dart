// lib/providers/admin_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch unverified users
  Future<List<Map<String, dynamic>>> fetchUnverifiedUsers() async {
    final snap = await _db
        .collection('users')
        .where('isVerified', isEqualTo: false)
        .get();
    return snap.docs.map((d) => {
      ...d.data(),
      'uid': d.id
    }).toList();
  }

  /// Verify user
  Future<void> verifyUser(String userId) async {
    await _db.collection('users').doc(userId).update({'isVerified': true});
  }

  /// Basic analytics
  Future<int> getUserCount() async {
    final snap = await _db.collection('users').get();
    return snap.size;
  }

  // Handle complaints, disputes, etc.:
  Future<void> resolveDispute(String disputeId, String resolution) async {
    await _db.collection('disputes').doc(disputeId).update({
      'status': 'resolved',
      'resolution': resolution,
    });
  }
}
