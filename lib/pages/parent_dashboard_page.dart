// parent_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../providers/auth_provider.dart';

class ParentDashboardPage extends StatelessWidget {
  const ParentDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example: Show recommended babysitters, quick booking shortcuts, etc.
    // If you want advanced AI-based suggestions or categories, add them here.
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Example greeting:
            Text(
              'Hello, Parent!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            // Book something quickly or see recommended babysitters
            Text(
              'Recommended Babysitters',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            // In real code, you’d fetch from a provider or service:
            // e.g. recommendedBabysitters = ...
            // Then build a horizontal list or grid.
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _babysitterCard('Jane Doe', 4.8),
                  _babysitterCard('Mary P.', 4.6),
                  _babysitterCard('Evelyn R.', 4.9),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Upcoming bookings snippet:
            Text(
              'Upcoming Bookings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _upcomingBookingsList(context),
          ],
        ),
      ),
    );
  }

  Widget _babysitterCard(String name, double rating) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text('$name\n⭐ $rating', textAlign: TextAlign.center),
      ),
    );
  }

  Widget _upcomingBookingsList(BuildContext context) {
    final bookingProv = Provider.of<BookingProvider>(context);
    // bookingProv.userBookings might be loaded based on parentId
    final upcomingBookings = bookingProv.userBookings
        .where((b) => b.status == 'confirmed')
        .take(3) // just show first 3
        .toList();

    if (upcomingBookings.isEmpty) {
      return const Text('No upcoming bookings');
    }

    return Column(
      children: upcomingBookings.map((b) {
        return Card(
          child: ListTile(
            title: Text('Babysitter: ${b.babysitterId}'),
            subtitle: Text('On ${b.startTime}'),
          ),
        );
      }).toList(),
    );
  }
}
