// lib/pages/babysitter/babysitter_jobs_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import './babysitter_jobs_list_view.dart';
import './babysitter_jobs_map_view.dart';

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
    setState(() => _availableJobs = allJobs);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row for the toggle and text
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                ],
              ),
            ],
          ),
        ),

        // The main content
        Expanded(
          child: _showMap
              ? BabysitterJobsMapView(jobs: _availableJobs)
              : BabysitterJobsListView(jobs: _availableJobs),
        ),
      ],
    );
  }
}
