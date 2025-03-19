// lib/pages/parent/parent_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
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

// "My Jobs" tab
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
        final lat = job["lat"] ?? "N/A";
        final lng = job["lng"] ?? "N/A";
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(title),
            subtitle: Text("$desc\nRate: $rate\nLocation: $lat, $lng"),
          ),
        );
      },
    );
  }
}

// "Bookings" and "Profile" placeholders
class ParentBookingsPage extends StatelessWidget {
  const ParentBookingsPage({Key? key}) : super(key: key);
  // ...
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Parent Bookings (TODO)"));
  }
}

class ParentProfilePage extends StatelessWidget {
  const ParentProfilePage({Key? key}) : super(key: key);
  // ...
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Parent Profile (TODO)"));
  }
}
