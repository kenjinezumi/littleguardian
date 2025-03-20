// lib/pages/babysitter/babysitter_home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Providers
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';
import '../../providers/booking_provider.dart';

// Child Pages
import 'babysitter_profile_page.dart'; // <--- Import from separate file

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
      const BabysitterProfilePage(), // separate file
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

/// Tab 1: Jobs (list/map toggle)
class BabysitterJobsPage extends StatefulWidget {
  const BabysitterJobsPage({Key? key}) : super(key: key);

  @override
  State<BabysitterJobsPage> createState() => _BabysitterJobsPageState();
}

class _BabysitterJobsPageState extends State<BabysitterJobsPage> {
  bool _showMap = false;
  List<Map<String, String>> _availableJobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final jobProv = context.read<JobProvider>();
    final allJobs = await jobProv.fetchAllJobs();
    setState(() {
      _availableJobs = allJobs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toggle row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Jobs View:"),
            ),
            Switch(
              value: _showMap,
              onChanged: (val) => setState(() => _showMap = val),
            ),
            Text(_showMap ? "Map" : "List"),
          ],
        ),
        Expanded(
          child: _showMap ? _buildMapView() : _buildListView(),
        ),
      ],
    );
  }

  Widget _buildListView() {
    if (_availableJobs.isEmpty) {
      return const Center(child: Text("No available jobs yet."));
    }
    return ListView.builder(
      itemCount: _availableJobs.length,
      itemBuilder: (ctx, i) {
        final job = _availableJobs[i];
        final title = job["title"] ?? "Untitled";
        final desc = job["description"] ?? "";
        final rate = job["rate"] ?? "";
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(title),
            subtitle: Text("$desc • $rate"),
            trailing: ElevatedButton(
              onPressed: () {
                // e.g. "Apply" logic
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

  Widget _buildMapView() {
    if (_availableJobs.isEmpty) {
      return const Center(child: Text("No jobs to show on map."));
    }

    final markers = <Marker>{};
    for (final job in _availableJobs) {
      final latStr = job["lat"];
      final lngStr = job["lng"];
      if (latStr == null || lngStr == null) continue;
      final lat = double.tryParse(latStr);
      final lng = double.tryParse(lngStr);
      if (lat == null || lng == null) continue;

      final jobId = job["jobId"] ?? "job${markers.length}";
      final title = job["title"] ?? "Job";
      final desc = job["description"] ?? "";
      markers.add(
        Marker(
          markerId: MarkerId(jobId),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: title, snippet: desc),
        ),
      );
    }

    if (markers.isEmpty) {
      return const Center(child: Text("No jobs have location data."));
    }
    final firstPos = markers.first.position;
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: firstPos, zoom: 12),
      markers: markers,
    );
  }
}

/// Tab 2: Babysitter Bookings
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
