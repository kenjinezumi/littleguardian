// lib/pages/parent/look_for_babysitter_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import './look_for_babysitter_list_view.dart';
import './look_for_babysitter_map_view.dart';
import 'look_for_babysitter_filters_page.dart'; // NEW
import '../../models/babysitter_filter.dart';

class LookForBabysitterPage extends StatefulWidget {
  const LookForBabysitterPage({Key? key}) : super(key: key);

  @override
  State<LookForBabysitterPage> createState() => _LookForBabysitterPageState();
}

class _LookForBabysitterPageState extends State<LookForBabysitterPage> {
  bool _showMap = false;
  List<Map<String, String>> _babysitters = [];
  
  // This holds current filter preferences
  BabysitterFilterModel _filters = BabysitterFilterModel();

  @override
  void initState() {
    super.initState();
    _loadBabysitters();
  }

  Future<void> _loadBabysitters() async {
    // e.g. fetch from a provider or mock data
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      // for demonstration
      _babysitters = [
        {
          "name": "Sitter One",
          "lat": "37.7749",
          "lng": "-122.4194",
          "desc": "5 years exp, CPR, \$15/hr",
          "experience": "5",
          "rate": "15",
          "cpr": "true",
          "firstAid": "false",
          "childEdu": "false",
          "availability": "morning,afternoon"
        },
        {
          "name": "Sitter Two",
          "lat": "34.0522",
          "lng": "-118.2437",
          "desc": "CPR + Child Ed, \$20/hr",
          "experience": "3",
          "rate": "20",
          "cpr": "true",
          "firstAid": "true",
          "childEdu": "true",
          "availability": "evening,night"
        },
      ];
    });
  }

  // Example method applying the filters to _babysitters
  List<Map<String, String>> get _filteredBabysitters {
    // Filter logic (simple example):
    return _babysitters.where((sitter) {
      final exp = int.tryParse(sitter["experience"] ?? "0") ?? 0;
      final rate = double.tryParse(sitter["rate"] ?? "999") ?? 999;
      final cpr = (sitter["cpr"] == "true");
      final firstAid = (sitter["firstAid"] == "true");
      final childEdu = (sitter["childEdu"] == "true");
      final availability = sitter["availability"] ?? "";
      
      // Check each filter field:
      if (exp < _filters.minExperience) return false;
      if (rate > _filters.maxRate) return false;
      if (_filters.cprCertified && !cpr) return false;
      if (_filters.firstAidCertified && !firstAid) return false;
      if (_filters.childEduCertified && !childEdu) return false;
      
      // For distance we might check lat/lng vs. parent's location (not shown)
      
      // For availability:
      if (_filters.morningAvailability && !availability.contains("morning")) return false;
      if (_filters.afternoonAvailability && !availability.contains("afternoon")) return false;
      if (_filters.eveningAvailability && !availability.contains("evening")) return false;
      if (_filters.nightAvailability && !availability.contains("night")) return false;

      return true;
    }).toList();
  }

  // Called when user clicks the wheel icon
  Future<void> _openFilterPreferences() async {
    // Show the preferences page, passing _filters
    final updatedFilters = await Navigator.push<BabysitterFilterModel>(
      context,
      MaterialPageRoute(
        builder: (_) => LookForBabysitterPreferencesPage(
          currentFilters: _filters,
        ),
      ),
    );
    // If user returned with updated filters, apply them
    if (updatedFilters != null) {
      setState(() {
        _filters = updatedFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredBabysitters; // apply filters
    return Column(
      children: [
        // Row with toggle + wheel icon
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            // "Babysitter View:"
            // Switch + label "Map" or "List"
            // Wheel icon to open preferences
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
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const Icon(Icons.tune), // a “wheel” or “tune” icon
                    onPressed: _openFilterPreferences,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _showMap
              ? LookForBabysitterMapView(babysitters: filteredList)
              : LookForBabysitterListView(babysitters: filteredList),
        ),
      ],
    );
  }
}
