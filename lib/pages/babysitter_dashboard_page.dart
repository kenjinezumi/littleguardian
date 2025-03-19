// babysitter_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class BabysitterDashboardPage extends StatelessWidget {
  const BabysitterDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For babysitters, maybe show "My Jobs," quick stats, or schedule at a glance
    return Scaffold(
      appBar: AppBar(title: const Text('Babysitter Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _jobsList(context),
      ),
    );
  }

  Widget _jobsList(BuildContext context) {
    final bookingProv = Provider.of<BookingProvider>(context);
    final myBookings = bookingProv.userBookings; // loaded in initState of HomePage
    if (myBookings.isEmpty) {
      return const Center(child: Text('No upcoming jobs'));
    }
    return ListView.builder(
      itemCount: myBookings.length,
      itemBuilder: (ctx, index) {
        final booking = myBookings[index];
        return Card(
          child: ListTile(
            title: Text('Parent: ${booking.parentId}'),
            subtitle: Text(
              'Booking: ${booking.startTime} - ${booking.endTime}\nStatus: ${booking.status}',
            ),
          ),
        );
      },
    );
  }
}
