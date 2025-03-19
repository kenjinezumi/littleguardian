// lib/pages/parent_home_page.dart
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
      const BookingsPage(),
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
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text("New Job"),
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

// MyJobsPage listens for changes from JobProvider
class MyJobsPage extends StatelessWidget {
  const MyJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    final jobProv = context.watch<JobProvider>();

    // fetch parent's jobs based on parent's email
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
          margin: const EdgeInsets.all(12),
          child: ListTile(
            title: Text(title),
            subtitle: Text("$desc • $rate"),
          ),
        );
      },
    );
  }
}

class BookingsPage extends StatelessWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fake data
    final bookings = [
      {"babysitter": "Jane S.", "time": "Tomorrow 6PM - 10PM"},
    ];
    if (bookings.isEmpty) {
      return const Center(child: Text("No bookings yet."));
    }
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (ctx, i) {
        final b = bookings[i];
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

class ParentProfilePage extends StatelessWidget {
  const ParentProfilePage({Key? key}) : super(key: key);

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
