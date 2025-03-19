// lib/pages/babysitter/babysitter_home_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart' show MyAuthProvider;
import '../../providers/job_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/job_post.dart';
import '../../models/booking.dart';

class BabysitterHomePage extends StatefulWidget {
  const BabysitterHomePage({Key? key}) : super(key: key);

  @override
  State<BabysitterHomePage> createState() => _BabysitterHomePageState();
}

class _BabysitterHomePageState extends State<BabysitterHomePage> {
  int _selectedIndex = 0;
  List<JobPost> _allJobs = [];
  List<Booking> _bookings = [];

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

    _allJobs = await jobProv.fetchAllJobs();
    await bookingProv.loadBookings(user.uid, 'babysitter');
    setState(() {
      _bookings = bookingProv.myBookings;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<MyAuthProvider>(context, listen: false);

    final pages = [
      _jobsTab(),
      _bookingsTab(),
      _profileTab(auth),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Babysitter Home"),
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
          NavigationDestination(icon: Icon(Icons.search), label: "Jobs"),
          NavigationDestination(icon: Icon(Icons.calendar_month), label: "Bookings"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _jobsTab() {
    if (_allJobs.isEmpty) {
      return const Center(child: Text("No jobs available."));
    }
    return ListView.builder(
      itemCount: _allJobs.length,
      itemBuilder: (ctx, i) {
        final job = _allJobs[i];
        return Card(
          child: ListTile(
            title: Text(job.title),
            subtitle: Text("${job.startTime} - ${job.endTime} / \$${job.offeredRate}/hr"),
            trailing: ElevatedButton(
              onPressed: () => _applyForJob(job),
              child: const Text("Apply"),
            ),
          ),
        );
      },
    );
  }

  Future<void> _applyForJob(JobPost job) async {
    // In real scenario: create booking doc or notify parent
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Applied for job: ${job.title}")),
    );
  }

  Widget _bookingsTab() {
    if (_bookings.isEmpty) {
      return const Center(child: Text("No bookings yet."));
    }
    return ListView.builder(
      itemCount: _bookings.length,
      itemBuilder: (ctx, i) {
        final b = _bookings[i];
        return Card(
          child: ListTile(
            title: Text("Booking: ${b.bookingId}"),
            subtitle: Text(
                "From: ${b.startTime} - ${b.endTime}\nStatus: ${b.status}"),
            trailing: _buildBookingActions(b),
          ),
        );
      },
    );
  }

  Widget _buildBookingActions(Booking b) {
    if (b.status == 'requested') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: () {
              Provider.of<BookingProvider>(context, listen: false)
                  .updateBookingStatus(b.bookingId, 'accepted');
            },
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              Provider.of<BookingProvider>(context, listen: false)
                  .updateBookingStatus(b.bookingId, 'canceled');
            },
          ),
        ],
      );
    } else if (b.status == 'accepted') {
      return IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: () {
          Provider.of<BookingProvider>(context, listen: false)
              .updateBookingStatus(b.bookingId, 'inProgress');
        },
      );
    } else if (b.status == 'inProgress') {
      return IconButton(
        icon: const Icon(Icons.check_circle),
        onPressed: () {
          Provider.of<BookingProvider>(context, listen: false)
              .updateBookingStatus(b.bookingId, 'completed');
        },
      );
    }
    // Return a placeholder widget rather than `null`
    return const SizedBox.shrink();
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
              // TODO: View or edit babysitter profile
            },
            child: const Text("My Profile"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Manage availability
            },
            child: const Text("Availability / Training"),
          ),
        ],
      ),
    );
  }
}
