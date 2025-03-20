// lib/pages/babysitter/babysitter_jobs_map_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BabysitterJobsMapView extends StatelessWidget {
  final List<Map<String, String>> jobs;
  const BabysitterJobsMapView({Key? key, required this.jobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1) Build a list of markers from lat/lng
    final markers = <Marker>[];

    for (final job in jobs) {
      final latStr = job["lat"];
      final lngStr = job["lng"];
      if (latStr == null || lngStr == null) continue;

      final lat = double.tryParse(latStr);
      final lng = double.tryParse(lngStr);
      if (lat == null || lng == null) continue;

      final jobId = job["jobId"] ?? "job_${markers.length}";
      final title = job["title"] ?? "Job";
      final desc = job["description"] ?? "";

      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: LatLng(lat, lng),
          builder: (ctx) => const Icon(Icons.place, color: Colors.red),
        ),
      );
    }

    // 2) Decide on a fallback center if no markers
    //    e.g., SF => lat=37.7749, lng=-122.4194, or anything you want
    LatLng fallbackCenter = LatLng(37.7749, -122.4194);
    double fallbackZoom = markers.isNotEmpty ? 12 : 2.0;

    if (markers.isNotEmpty) {
      fallbackCenter = markers.first.point;
    }

    // 3) We'll build a FlutterMap with OSM tile layer
    //    We'll overlay a message if no markers
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: fallbackCenter,
            zoom: fallbackZoom,
          ),
          children: [
            // Basic OSM tile layer
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.littleguardian',
            ),
            // Marker layer
            MarkerLayer(
              markers: markers,
            ),
          ],
        ),

        if (markers.isEmpty)
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black54,
                child: const Text(
                  "No jobs have location data.\n(Showing default OSM map)",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
