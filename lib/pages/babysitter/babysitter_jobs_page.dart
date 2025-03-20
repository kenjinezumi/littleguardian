// lib/pages/babysitter/babysitter_jobs_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/job_provider.dart';
import './babysitter_jobs_list_view.dart';
import './babysitter_jobs_map_view.dart';
import '../../models/babysitter_job_filter.dart';
import 'babysitter_job_filter_page.dart'; // new

class BabysitterJobsPage extends StatefulWidget {
  const BabysitterJobsPage({Key? key}) : super(key: key);

  @override
  State<BabysitterJobsPage> createState() => _BabysitterJobsPageState();
}

class _BabysitterJobsPageState extends State<BabysitterJobsPage> {
  bool _showMap = false;
  List<Map<String, String>> _availableJobs = [];

  // Keep track of the current filters
  BabysitterJobFilterModel _filters = BabysitterJobFilterModel();

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    final jobProv = context.read<JobProvider>();
    final allJobs = await jobProv.fetchAllJobs();
    setState(() => _availableJobs = allJobs);
  }

  // Example filter logic
  List<Map<String, String>> get _filteredJobs {
    return _availableJobs.where((job) {
      // parse fields from job for filter checks
      final rateDouble = double.tryParse(job["rate"] ?? "999") ?? 999;
      // if no rate in the job data, fallback
      if (rateDouble < _filters.minRate) return false;
      if (rateDouble > _filters.maxRate) return false;

      // we won't do distance calc here unless we store parent's lat/lng & sitter lat/lng
      // but you can do Haversine or lat/long distance check if you want

      // time shifts, if the job has e.g. "morning,afternoon" in job["shifts"]?
      final shifts = job["shifts"] ?? ""; 
      // if babysitter wants morning but job doesn't have it
      if (_filters.morningShift && !shifts.contains("morning")) return false;
      if (_filters.afternoonShift && !shifts.contains("afternoon")) return false;
      if (_filters.eveningShift && !shifts.contains("evening")) return false;
      if (_filters.nightShift && !shifts.contains("night")) return false;

      // If job says "pets: yes" but sitter not comfortable
      final pets = (job["pets"] == "yes");
      if (pets && !_filters.comfortableWithPets) return false;

      // specialNeeds: yes
      final specialNeeds = (job["specialNeeds"] == "yes");
      if (specialNeeds && !_filters.comfortableWithSpecialNeeds) return false;

      // days: "weekdays,weekends"?
      final days = job["days"] ?? "";
      if (_filters.weekdays && !days.contains("weekdays")) return false;
      if (_filters.weekends && !days.contains("weekends")) return false;

      return true;
    }).toList();
  }

  Future<void> _openFilterPage() async {
    // navigate & wait for new filters
    final updated = await Navigator.push<BabysitterJobFilterModel>(
      context,
      MaterialPageRoute(
        builder: (_) => BabysitterJobFilterPage(currentFilters: _filters),
      ),
    );
    if (updated != null) {
      setState(() => _filters = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayedJobs = _filteredJobs;
    return Column(
      children: [
        // top row
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Jobs View:"),
              Row(
                children: [
                  Switch(
                    value: _showMap,
                    onChanged: (val) => setState(() => _showMap = val),
                  ),
                  const SizedBox(width: 8),
                  Text(_showMap ? "Map" : "List"),
                  const SizedBox(width: 16),
                  // The filter "wheel" icon
                  IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: _openFilterPage,
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _showMap
              ? BabysitterJobsMapView(jobs: displayedJobs)
              : BabysitterJobsListView(jobs: displayedJobs),
        ),
      ],
    );
  }
}
