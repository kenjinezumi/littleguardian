import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
// Remove import to job_post.dart if you used it

class BabysitterHomePage extends StatefulWidget {
  const BabysitterHomePage({Key? key}) : super(key: key);

  @override
  State<BabysitterHomePage> createState() => _BabysitterHomePageState();
}

class _BabysitterHomePageState extends State<BabysitterHomePage> {
  int _selectedIndex = 0;
  // No longer a List<JobPost>, but a List of maps
  List<Map<String, String>> _availableJobs = [];
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
    final jobs = await jobProv.fetchAvailableJobs(); // returns List<Map<String, String>>
    setState(() {
      // Now both sides match: jobs is a List<Map<String, String>>
      _availableJobs = jobs;
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

class JobsPage extends StatelessWidget {
  final List<Map<String, String>> availableJobs;
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
        final title = job["title"] ?? "Untitled";
        final desc = job["description"] ?? "";
        final rate = job["rate"] ?? "";
        return Card(
          margin: const EdgeInsets.all(12),
          child: ListTile(
            title: Text(title),
            subtitle: Text("$desc • $rate"),
            trailing: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Applied to $title")),
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
    // show babysitter's profile or usage
    return const Center(child: Text("Babysitter Profile (TODO)"));
  }
}
