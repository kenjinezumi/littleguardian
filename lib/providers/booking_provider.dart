// lib/providers/booking_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _loading = false;
  bool get loading => _loading;

  List<Booking> _myBookings = [];
  List<Booking> get myBookings => _myBookings;

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
      // babysitter
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

  Future<void> createBooking(Booking booking) async {
    await _db
        .collection('bookings')
        .doc(booking.bookingId)
        .set(booking.toMap());
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _db
        .collection('bookings')
        .doc(bookingId)
        .update({'status': status});
  }
}
