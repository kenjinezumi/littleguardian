// bookings_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../providers/auth_provider.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookingProv = Provider.of<BookingProvider>(context);
    final allBookings = bookingProv.userBookings;
    if (allBookings.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),
        body: const Center(child: Text('No bookings yet')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: ListView.builder(
        itemCount: allBookings.length,
        itemBuilder: (ctx, i) {
          final b = allBookings[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text('Booking: ${b.startTime} - ${b.endTime}'),
              subtitle: Text('Status: ${b.status}'),
            ),
          );
        },
      ),
    );
  }
}
