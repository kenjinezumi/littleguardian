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
import 'parent_profile_page.dart';
import 'look_for_babysitter_page.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  // For a subtle scale animation on the FAB
  late final AnimationController _fabCtrl;
  late final Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _pages = [
      const MyJobsPage(),
      const ParentBookingsPage(),
      const LookForBabysitterPage(),
      const ParentProfilePage(),
    ];

    // Micro-animation for FAB
    _fabCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.9,
      upperBound: 1.0,
    );
    _fabScale = CurvedAnimation(parent: _fabCtrl, curve: Curves.easeOutBack);
    _fabCtrl.forward(); // default is scaled up
  }

  @override
  void dispose() {
    _fabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showFab = _selectedIndex == 0;

    return Scaffold(
      appBar: AppBar(title: const Text("Parent Home")),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: "My Jobs"),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: "Bookings"),
          NavigationDestination(icon: Icon(Icons.search), label: "Babysitters"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: showFab
          ? ScaleTransition(
              scale: _fabScale,
              child: FloatingActionButton(
                onPressed: () {
                  // bounce animation
                  _fabCtrl.reverse().then((_) => _fabCtrl.forward());
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JobCreationPage()),
                  );
                },
                child: const Icon(Icons.add),
              ),
            )
          : null,
    );
  }
}

// -- MyJobsPage --
class MyJobsPage extends StatelessWidget {
  const MyJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    final jobProv = context.watch<JobProvider>();
    final myJobs = jobProv.fetchParentJobs(auth.email);

    if (myJobs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Friendly illustration for empty state
              Image.asset(
                'assets/illustrations/no_jobs.png',
                height: 150,
              ),
              const SizedBox(height: 16),
              Text(
                "No posted jobs yet.",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                "Tap the + button to create a new babysitting job.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: myJobs.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (ctx, i) {
        final job = myJobs[i];
        final title = job["title"] ?? "Untitled";
        final desc = job["description"] ?? "";
        final rate = job["rate"] ?? "";

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Text("$desc / $rate", style: Theme.of(context).textTheme.bodyMedium),
          ),
        );
      },
    );
  }
}

// -- ParentBookingsPage --
class ParentBookingsPage extends StatelessWidget {
  const ParentBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    final bookingProv = context.watch<BookingProvider>();
    final parentBookings = bookingProv.fetchParentBookings(auth.email);

    if (parentBookings.isEmpty) {
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
                "Try searching for a babysitter to schedule.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: parentBookings.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (ctx, i) {
        final b = parentBookings[i];
        final jobTitle = b["jobTitle"] ?? "Unknown Job";
        final status = b["status"] ?? "requested";

        // color-coded status
        Color chipColor;
        switch (status) {
          case 'confirmed':
            chipColor = Colors.green.shade200;
            break;
          case 'completed':
            chipColor = Colors.blue.shade200;
            break;
          default:
            chipColor = Colors.orange.shade200; // requested, etc.
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
