// lib/pages/booking_details_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class BookingDetailsPage extends StatelessWidget {
  const BookingDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We expect an argument for the bookingId
    final args = ModalRoute.of(context)?.settings.arguments;
    final bookingId = args is String ? args : null;

    if (bookingId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Booking Details")),
        body: const Center(child: Text("No Booking ID found")),
      );
    }

    final bookingProv = context.read<BookingProvider>();
    final booking = bookingProv.fetchBookingById(bookingId);

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Booking Details")),
        body: const Center(child: Text("Booking not found.")),
      );
    }

    final parentEmail = booking["parentEmail"] ?? "";
    final sitterEmail = booking["babysitterEmail"] ?? "";
    final jobTitle = booking["jobTitle"] ?? "";
    final start = booking["startTime"] ?? "";
    final end = booking["endTime"] ?? "";
    final status = booking["status"] ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("Booking Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: ListTile(
            title: Text(jobTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            subtitle: Text(
              "Parent: $parentEmail\nBabysitter: $sitterEmail\n"
              "Start: $start\nEnd: $end\nStatus: $status",
            ),
          ),
        ),
      ),
    );
  }
}
