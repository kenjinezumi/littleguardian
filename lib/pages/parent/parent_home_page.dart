// lib/pages/parent/parent_home_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' show MyAuthProvider;
import '../../providers/job_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/job_post.dart';
import '../../models/booking.dart';
import 'job_creation_page.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final jobProv = Provider.of<JobProvider>(context, listen: false);
    final bookingProv = Provider.of<BookingProvider>(context, listen: false);

    await jobProv.loadParentJobs(user.uid);
    await bookingProv.loadBookings(user.uid, 'parent');
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<MyAuthProvider>(context, listen: false);
    final jobProv = Provider.of<JobProvider>(context);
    final bookingProv = Provider.of<BookingProvider>(context);

    final jobs = jobProv.myPostedJobs;
    final bookings = bookingProv.myBookings;

    final pages = [
      _jobsTab(jobs),
      _bookingsTab(bookings),
      _profileTab(auth),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
              if (!mounted) return;
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: "Jobs"),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: "Bookings"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const JobCreationPage()));
              },
            )
          : null,
    );
  }

  Widget _jobsTab(List<JobPost> jobs) {
    if (jobs.isEmpty) {
      return const Center(child: Text("No jobs posted yet."));
    }
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (ctx, i) {
        final job = jobs[i];
        return Card(
          child: ListTile(
            title: Text(job.title),
            subtitle: Text("${job.startTime} - ${job.endTime}"),
          ),
        );
      },
    );
  }

  Widget _bookingsTab(List<Booking> bookings) {
    if (bookings.isEmpty) {
      return const Center(child: Text("No bookings yet."));
    }
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (ctx, i) {
        final b = bookings[i];
        return Card(
          child: ListTile(
            title: Text("Babysitter: ${b.babysitterId}"),
            subtitle: Text("From: ${b.startTime} to ${b.endTime}\nStatus: ${b.status}"),
          ),
        );
      },
    );
  }

  Widget _profileTab(MyAuthProvider auth) {
    final user = auth.user;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Logged in as: ${user?.email}"),
          Text("Role: ${user?.role}"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to parent's profile details
            },
            child: const Text("My Profile"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Manage children info
            },
            child: const Text("Family/Children Details"),
          ),
        ],
      ),
    );
  }
}
