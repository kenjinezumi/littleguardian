// lib/providers/booking_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Booking> _myBookings = [];
  bool _loading = false;

  List<Booking> get myBookings => _myBookings;
  bool get loading => _loading;

  /// Loads bookings for a given user (parent or babysitter).
  Future<void> loadBookings(String userId, String role) async {
    _loading = true;
    notifyListeners();

    QuerySnapshot snapshot;
    if (role == 'parent') {
      snapshot = await _db
          .collection('bookings')
          .where('parentId', isEqualTo: userId)
          .get();
    } else {
      snapshot = await _db
          .collection('bookings')
          .where('babysitterId', isEqualTo: userId)
          .get();
    }

    _myBookings = snapshot.docs.map((doc) {
      return Booking.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();

    _loading = false;
    notifyListeners();
  }

  Future<void> createBooking({
    required String parentId,
    required String babysitterId,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    final docRef = _db.collection('bookings').doc();
    final booking = Booking(
      bookingId: docRef.id,
      parentId: parentId,
      babysitterId: babysitterId,
      startTime: startTime,
      endTime: endTime,
      status: 'requested',
    );
    await docRef.set(booking.toMap());
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _db.collection('bookings').doc(bookingId).update({'status': status});
  }
}
