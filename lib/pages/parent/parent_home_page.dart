// lib/pages/parent/parent_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/booking_provider.dart';

// Child Pages
import 'job_creation_page.dart';
import 'parent_profile_page.dart'; // your existing profile page
import 'look_for_babysitter_page.dart'; // NEW: to be created (toggles list & map)

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
      const LookForBabysitterPage(), // NEW third tab
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
          NavigationDestination(icon: Icon(Icons.search), label: "Babysitters"), // new
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

// Existing My Jobs & Bookings
class MyJobsPage extends StatelessWidget {
  const MyJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    final jobProv = context.watch<JobProvider>();
    final myJobs = jobProv.fetchParentJobs(auth.email);

    if (myJobs.isEmpty) {
      return const Center(child: Text("No posted jobs yet."));
    }
    return ListView.builder(
      itemCount: myJobs.length,
      itemBuilder: (ctx, i) {
        final job = myJobs[i];
        final title = job["title"] ?? "Untitled";
        final desc = job["description"] ?? "";
        final rate = job["rate"] ?? "";
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(title),
            subtitle: Text("$desc / $rate"),
          ),
        );
      },
    );
  }
}

class ParentBookingsPage extends StatelessWidget {
  const ParentBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    final bookingProv = context.watch<BookingProvider>();
    final parentBookings = bookingProv.fetchParentBookings(auth.email);

    if (parentBookings.isEmpty) {
      return const Center(child: Text("No bookings yet."));
    }

    return ListView.builder(
      itemCount: parentBookings.length,
      itemBuilder: (ctx, i) {
        final b = parentBookings[i];
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
