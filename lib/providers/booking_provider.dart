// lib/providers/booking_provider.dart
import 'package:flutter/material.dart';

class BookingProvider extends ChangeNotifier {
  /// In-memory list of all bookings, each as a Map.
  /// Example fields:
  /// {
  ///   "bookingId": "b123",
  ///   "parentEmail": "parentA@example.com",
  ///   "babysitterEmail": "sitter1@example.com",
  ///   "jobTitle": "Weekend babysitting",
  ///   "startTime": "2023-08-20 18:00",
  ///   "endTime": "2023-08-20 22:00",
  ///   "status": "confirmed"
  /// }
  ///
  /// Add more to simulate dev/test scenarios.
  final List<Map<String, String>> _allBookings = [
    {
      "bookingId": "bk1",
      "parentEmail": "parentA@example.com",
      "babysitterEmail": "sitter1@example.com",
      "jobTitle": "Saturday Night Out",
      "startTime": "2023-09-01 19:00",
      "endTime": "2023-09-01 23:00",
      "status": "confirmed",
    },
    {
      "bookingId": "bk2",
      "parentEmail": "parentA@example.com",
      "babysitterEmail": "sitter2@example.com",
      "jobTitle": "Morning Helper",
      "startTime": "2023-09-02 08:00",
      "endTime": "2023-09-02 12:00",
      "status": "completed",
    },
    {
      "bookingId": "bk3",
      "parentEmail": "parentB@example.com",
      "babysitterEmail": "sitter1@example.com",
      "jobTitle": "Evening Sitter Needed",
      "startTime": "2023-09-03 18:00",
      "endTime": "2023-09-03 22:00",
      "status": "confirmed",
    },
    {
      "bookingId": "bk4",
      "parentEmail": "parentB@example.com",
      "babysitterEmail": "sitter2@example.com",
      "jobTitle": "Full Day Sitter",
      "startTime": "2023-09-04 09:00",
      "endTime": "2023-09-04 17:00",
      "status": "requested",
    },
    {
      "bookingId": "bk5",
      "parentEmail": "parentA@example.com",
      "babysitterEmail": "sitter1@example.com",
      "jobTitle": "Late Night Event",
      "startTime": "2023-09-05 22:00",
      "endTime": "2023-09-06 02:00",
      "status": "canceled",
    },
    {
      "bookingId": "bk6",
      "parentEmail": "parentB@example.com",
      "babysitterEmail": "sitter1@example.com",
      "jobTitle": "Sunday Afternoon",
      "startTime": "2023-09-10 12:00",
      "endTime": "2023-09-10 16:00",
      "status": "completed",
    },
  ];

  /// Return all bookings that match the parent's email
  List<Map<String, String>> fetchParentBookings(String parentEmail) {
    return _allBookings
        .where((b) => b["parentEmail"] == parentEmail)
        .toList();
  }

  /// Return all bookings that match the babysitter's email
  List<Map<String, String>> fetchBabysitterBookings(String sitterEmail) {
    return _allBookings
        .where((b) => b["babysitterEmail"] == sitterEmail)
        .toList();
  }

  /// Return a single booking by bookingId
  Map<String, String>? fetchBookingById(String bookingId) {
    final booking = _allBookings.firstWhere(
      (b) => b["bookingId"] == bookingId,
      orElse: () => {},
    );
    return booking.isEmpty ? null : booking;
  }
}
