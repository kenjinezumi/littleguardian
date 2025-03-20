// lib/pages/babysitter/babysitter_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import 'babysitter_jobs_page.dart';
import 'babysitter_profile_page.dart';

/// The main babysitter home, with bottom nav: Jobs, Bookings, Profile
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
      const BabysitterJobsPage(),       // 1) Jobs tab
      const BabysitterBookingsPage(),   // 2) Bookings tab
      const BabysitterProfilePage(),    // 3) Profile tab
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

/// Tab 2: Babysitter Bookings
class BabysitterBookingsPage extends StatelessWidget {
  const BabysitterBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    final bookingProv = context.watch<BookingProvider>();

    final sitterBookings = bookingProv.fetchBabysitterBookings(auth.email);
    if (sitterBookings.isEmpty) {
      return const Center(child: Text("No bookings yet."));
    }
    return ListView.builder(
      itemCount: sitterBookings.length,
      itemBuilder: (ctx, i) {
        final b = sitterBookings[i];
        final jobTitle = b["jobTitle"] ?? "Unknown Job";
        final status = b["status"] ?? "requested";
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(jobTitle),
            subtitle: Text("Status: $status"),
          ),
        );
      },
    );
  }
}
