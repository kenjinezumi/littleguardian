// lib/pages/parent/look_for_babysitter_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import './look_for_babysitter_list_view.dart';
import './look_for_babysitter_map_view.dart';

/// The "Look for Babysitter" tab toggles between a list and a map
class LookForBabysitterPage extends StatefulWidget {
  const LookForBabysitterPage({Key? key}) : super(key: key);

  @override
  State<LookForBabysitterPage> createState() => _LookForBabysitterPageState();
}

class _LookForBabysitterPageState extends State<LookForBabysitterPage> {
  bool _showMap = false;
  List<Map<String, String>> _babysitters = [];

  @override
  void initState() {
    super.initState();
    _loadBabysitters();
  }

  // For demonstration, you might load from a ProfileProvider or your own logic
  Future<void> _loadBabysitters() async {
    // For example, we could fetch from a "list of babysitter profiles"
    // if you have them in Firestore or a local map. 
    // We'll mock it here:
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      _babysitters = [
        {
          "name": "Sitter One",
          "lat": "37.7749",
          "lng": "-122.4194",
          "desc": "5 years exp, CPR certified",
        },
        {
          "name": "Sitter Two",
          "lat": "34.0522",
          "lng": "-118.2437",
          "desc": "Loves pets, flexible schedule",
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toggle row
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Babysitter View:"),
              Row(
                children: [
                  Switch(
                    value: _showMap,
                    onChanged: (val) => setState(() => _showMap = val),
                  ),
                  const SizedBox(width: 8),
                  Text(_showMap ? "Map" : "List"),
                ],
              ),
            ],
          ),
        ),

        // The main content
        Expanded(
          child: _showMap
              ? LookForBabysitterMapView(babysitters: _babysitters)
              : LookForBabysitterListView(babysitters: _babysitters),
        ),
      ],
    );
  }
}
