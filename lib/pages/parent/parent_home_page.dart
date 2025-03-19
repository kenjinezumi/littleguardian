// lib/pages/parent_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  int _selectedIndex = 0;

  final _pages = [
    const _MyJobsPage(),
    const _BookingsPage(),
    const _ParentProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Home")),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) {
          setState(() => _selectedIndex = idx);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: "My Jobs"),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: "Bookings"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                // Fake create job
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Create a job (TODO)")),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _MyJobsPage extends StatelessWidget {
  const _MyJobsPage();

  @override
  Widget build(BuildContext context) {
    // Fake data
    final myJobs = [
      {"title": "Saturday Night Sitter", "time": "7PM - 11PM"},
      {"title": "Morning Helper", "time": "8AM - 12PM"},
    ];
    if (myJobs.isEmpty) {
      return const Center(child: Text("No posted jobs."));
    }
    return ListView.builder(
      itemCount: myJobs.length,
      itemBuilder: (ctx, i) {
        final job = myJobs[i];
        return Card(
          margin: const EdgeInsets.all(12),
          child: ListTile(
            title: Text(job["title"] ?? ""),
            subtitle: Text(job["time"] ?? ""),
          ),
        );
      },
    );
  }
}

class _BookingsPage extends StatelessWidget {
  const _BookingsPage();

  @override
  Widget build(BuildContext context) {
    // Fake data
    final myBookings = [
      {"babysitter": "Jane S.", "time": "Tomorrow 6PM - 10PM"},
    ];
    if (myBookings.isEmpty) {
      return const Center(child: Text("No bookings yet."));
    }
    return ListView.builder(
      itemCount: myBookings.length,
      itemBuilder: (ctx, i) {
        final b = myBookings[i];
        return Card(
          margin: const EdgeInsets.all(12),
          child: ListTile(
            title: Text("Babysitter: ${b["babysitter"]}"),
            subtitle: Text(b["time"] ?? ""),
          ),
        );
      },
    );
  }
}

class _ParentProfilePage extends StatelessWidget {
  const _ParentProfilePage();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text("Logged in as: ${auth.email}",
              style: Theme.of(context).textTheme.titleMedium),
          Text("Role: ${auth.role}"),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            onPressed: () async {
              await context.read<MyAuthProvider>().fakeLogout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
