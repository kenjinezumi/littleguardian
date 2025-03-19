// lib/pages/babysitter_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/job_provider.dart';
import '../models/job_post.dart';

class BabysitterHomePage extends StatefulWidget {
  const BabysitterHomePage({Key? key}) : super(key: key);

  @override
  State<BabysitterHomePage> createState() => _BabysitterHomePageState();
}

class _BabysitterHomePageState extends State<BabysitterHomePage> {
  int _selectedIndex = 0;
  List<JobPost> _availableJobs = [];
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      JobsPage(availableJobs: _availableJobs),
      const MyBookingsPage(),
      const BabysitterProfilePage(),
    ];
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final jobProv = context.read<JobProvider>();
    final jobs = await jobProv.fetchAvailableJobs(); // returns List<JobPost>
    setState(() {
      _availableJobs = jobs;
      // Update the pages with new data
      _pages = [
        JobsPage(availableJobs: _availableJobs),
        const MyBookingsPage(),
        const BabysitterProfilePage(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Babysitter Home")),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) {
          setState(() => _selectedIndex = idx);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: "Jobs"),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: "Bookings"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class JobsPage extends StatelessWidget {
  final List<JobPost> availableJobs;
  const JobsPage({Key? key, required this.availableJobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (availableJobs.isEmpty) {
      return const Center(child: Text("No jobs available."));
    }
    return ListView.builder(
      itemCount: availableJobs.length,
      itemBuilder: (ctx, i) {
        final job = availableJobs[i];
        return Card(
          margin: const EdgeInsets.all(12),
          child: ListTile(
            title: Text(job.title),
            subtitle: Text(job.description),
            trailing: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Applied to ${job.title}")),
                );
              },
              child: const Text("Apply"),
            ),
          ),
        );
      },
    );
  }
}

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fake data
    final bookings = [
      {"parent": "Doe Family", "time": "Tomorrow 4PM - 9PM"},
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
            title: Text("Parent: ${b["parent"]}"),
            subtitle: Text(b["time"] ?? ""),
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
    return Padding(
      padding: const EdgeInsets.all(24),
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
