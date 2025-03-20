// lib/pages/babysitter/babysitter_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import 'babysitter_jobs_page.dart';
import 'babysitter_profile_page.dart';

class BabysitterHomePage extends StatefulWidget {
  const BabysitterHomePage({Key? key}) : super(key: key);

  @override
  State<BabysitterHomePage> createState() => _BabysitterHomePageState();
}

class _BabysitterHomePageState extends State<BabysitterHomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const BabysitterJobsPage(),
      const BabysitterBookingsPage(),
      const BabysitterProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Babysitter Home"),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: "Jobs"),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: "Bookings"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

// ---------- BabysitterBookingsPage -----------
class BabysitterBookingsPage extends StatelessWidget {
  const BabysitterBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    final bookingProv = context.watch<BookingProvider>();
    final sitterBookings = bookingProv.fetchBabysitterBookings(auth.email);

    if (sitterBookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/illustrations/no_bookings.png', height: 150),
              const SizedBox(height: 16),
              Text(
                "No bookings yet.",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Check the Jobs tab for available positions!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sitterBookings.length,
      itemBuilder: (ctx, i) {
        final b = sitterBookings[i];
        final jobTitle = b["jobTitle"] ?? "Unknown Job";
        final status = b["status"] ?? "requested";

        Color chipColor;
        switch (status) {
          case 'confirmed':
            chipColor = Colors.green.shade200;
            break;
          case 'completed':
            chipColor = Colors.blue.shade200;
            break;
          default:
            chipColor = Colors.orange.shade200;
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              jobTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Row(
              children: [
                Chip(
                  label: Text(status),
                  backgroundColor: chipColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
