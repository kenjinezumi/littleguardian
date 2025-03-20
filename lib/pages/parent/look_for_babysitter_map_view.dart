// lib/pages/parent/look_for_babysitter_map_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LookForBabysitterMapView extends StatelessWidget {
  final List<Map<String, String>> babysitters;
  const LookForBabysitterMapView({Key? key, required this.babysitters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>[];

    for (final sitter in babysitters) {
      final latStr = sitter["lat"];
      final lngStr = sitter["lng"];
      if (latStr == null || lngStr == null) continue;
      final lat = double.tryParse(latStr);
      final lng = double.tryParse(lngStr);
      if (lat == null || lng == null) continue;

      final name = sitter["name"] ?? "Sitter";
      final desc = sitter["desc"] ?? "";
      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: LatLng(lat, lng),
          builder: (ctx) => const Icon(Icons.place, color: Colors.red),
        ),
      );
    }

    // fallback center if no markers
    LatLng fallbackCenter = LatLng(37.7749, -122.4194); // SF
    double fallbackZoom = markers.isNotEmpty ? 12 : 2.0;
    if (markers.isNotEmpty) {
      fallbackCenter = markers.first.point;
    }

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: fallbackCenter,
            zoom: fallbackZoom,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.littleguardian',
            ),
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
                color: Colors.black54,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  "No babysitters have location data.\n(Showing default OSM map)",
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
