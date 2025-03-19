// lib/pages/babysitter/babysitter_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/user_profile.dart'; // <-- if using a local model
import '../profile_edit_page.dart';       // <-- Import the edit page route

class BabysitterHomePage extends StatefulWidget {
  const BabysitterHomePage({Key? key}) : super(key: key);

  @override
  State<BabysitterHomePage> createState() => _BabysitterHomePageState();
}

class _BabysitterHomePageState extends State<BabysitterHomePage> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const BabysitterJobsPage(),
      const BabysitterBookingsPage(),
      const BabysitterProfilePage(), // The profile tab
    ];
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

// Fake "Jobs" tab
class BabysitterJobsPage extends StatelessWidget {
  const BabysitterJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Available Jobs (TODO)"));
  }
}

class BabysitterBookingsPage extends StatelessWidget {
  const BabysitterBookingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();
    final bookingProv = context.watch<BookingProvider>();

    final sitterBookings = bookingProv.fetchBabysitterBookings(auth.email);
    if (sitterBookings.isEmpty) {
      return const Center(child: Text("No bookings yet."));
    }

    return ListView.builder(
      itemCount: sitterBookings.length,
      itemBuilder: (ctx, i) {
        final b = sitterBookings[i];
        final bookingId = b["bookingId"] ?? "";
        final jobTitle = b["jobTitle"] ?? "Unknown Job";
        final parent = b["parentEmail"] ?? "N/A";
        final timeRange = "${b["startTime"]} - ${b["endTime"]}";
        final status = b["status"] ?? "";

        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(jobTitle),
            subtitle: Text("Parent: $parent\n$timeRange\nStatus: $status"),
            onTap: () {
              Navigator.pushNamed(context, '/bookingDetails', arguments: bookingId);
            },
          ),
        );
      },
    );
  }
}

// The "Profile" tab for babysitter
class BabysitterProfilePage extends StatelessWidget {
  const BabysitterProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<MyAuthProvider>();

    // For demonstration, we build a sample user profile.
    // In a real app, you might fetch from Firestore or ProfileProvider.
    final userProfile = UserProfile(
      email: auth.email,
      role: auth.role,
      name: "Sitter's Name",
      phone: "555-9999",
      address: "456 Oak Lane",
      bio: "Experienced babysitter with CPR cert!",
      avatarUrl: "https://i.pravatar.cc/150?u=${auth.email}",
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text("Logged in as: ${auth.email}"),
            Text("Role: ${auth.role}"),
            const SizedBox(height: 20),

            // Display some info from userProfile
            Text("Name: ${userProfile.name}"),
            Text("Phone: ${userProfile.phone}"),
            Text("Address: ${userProfile.address}"),
            Text("Bio: ${userProfile.bio}"),
            const SizedBox(height: 20),

            // "Edit Profile" button
            ElevatedButton(
              onPressed: () {
                // Navigate to ProfileEditPage with userProfile
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileEditPage(profile: userProfile),
                  ),
                );
              },
              child: const Text("Edit Profile"),
            ),

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
      ),
    );
  }
}
