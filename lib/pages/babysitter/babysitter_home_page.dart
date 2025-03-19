// lib/pages/babysitter/babysitter_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/booking_provider.dart';

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
      appBar: AppBar(title: const Text("Babysitter Home")),
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

// Fake "Jobs" tab
class BabysitterJobsPage extends StatelessWidget {
  const BabysitterJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Available Jobs (TODO)"));
  }
}

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
        final bookingId = b["bookingId"] ?? "";
        final jobTitle = b["jobTitle"] ?? "Unknown Job";
        final parent = b["parentEmail"] ?? "N/A";
        final timeRange = "${b["startTime"]} - ${b["endTime"]}";
        final status = b["status"] ?? "";

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(jobTitle),
            subtitle: Text("Parent: $parent\n$timeRange\nStatus: $status"),
            onTap: () {
              Navigator.pushNamed(context, '/bookingDetails', arguments: bookingId);
            },
          ),
        );
      },
    );
  }
}

class BabysitterProfilePage extends StatelessWidget {
  const BabysitterProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Logged in as: ${auth.email}"),
          Text("Role: ${auth.role}"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await context.read<MyAuthProvider>().fakeLogout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
