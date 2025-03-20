// lib/pages/babysitter/babysitter_jobs_map_view.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BabysitterJobsMapView extends StatelessWidget {
  final List<Map<String, String>> jobs;
  const BabysitterJobsMapView({Key? key, required this.jobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return const Center(child: Text("No jobs to show on map."));
    }

    final markers = <Marker>{};
    for (final job in jobs) {
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
