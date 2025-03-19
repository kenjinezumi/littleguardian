// lib/pages/parent/parent_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import 'job_creation_page.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const MyJobsPage(),
      const ParentBookingsPage(),
      const ParentProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Home")),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: "My Jobs"),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: "Bookings"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const JobCreationPage()),
                );
              },
            )
          : null,
    );
  }
}

// A placeholder for the "My Jobs" tab
class MyJobsPage extends StatelessWidget {
  const MyJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("My Jobs (TODO)"));
  }
}

// The "My Bookings" tab for parent
class ParentBookingsPage extends StatelessWidget {
  const ParentBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    final bookingProv = context.watch<BookingProvider>();

    // Retrieve all bookings for the parent's email
    final parentBookings = bookingProv.fetchParentBookings(auth.email);

    if (parentBookings.isEmpty) {
      return const Center(child: Text("No bookings yet."));
    }

    return ListView.builder(
      itemCount: parentBookings.length,
      itemBuilder: (ctx, i) {
        final b = parentBookings[i];
        final bookingId = b["bookingId"] ?? "";
        final jobTitle = b["jobTitle"] ?? "Unknown Job";
        final sitter = b["babysitterEmail"] ?? "N/A";
        final timeRange = "${b["startTime"]} - ${b["endTime"]}";
        final status = b["status"] ?? "";

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(jobTitle),
            subtitle: Text("Babysitter: $sitter\n$timeRange\nStatus: $status"),
            onTap: () {
              // Navigate to booking details
              Navigator.pushNamed(context, '/bookingDetails', arguments: bookingId);
            },
          ),
        );
      },
    );
  }
}

// The "Profile" tab for parent
class ParentProfilePage extends StatelessWidget {
  const ParentProfilePage({Key? key}) : super(key: key);

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
