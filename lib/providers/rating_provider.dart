// lib/providers/rating_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rating.dart';

class RatingProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createRating(RatingModel rating) async {
    final docRef = _db.collection('ratings').doc(rating.ratingId);
    await docRef.set(rating.toMap());
    // Update booking doc to link rating
    await _db
        .collection('bookings')
        .doc(rating.bookingId)
        .update({'ratingId': rating.ratingId, 'status': 'completed'});
  }

  // Could also fetch ratings by babysitterId to compute overall rating, etc.
}
