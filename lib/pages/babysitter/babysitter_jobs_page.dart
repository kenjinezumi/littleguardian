// lib/pages/babysitter/babysitter_jobs_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/job_provider.dart';
import './babysitter_jobs_list_view.dart';
import './babysitter_jobs_map_view.dart';
import '../../models/babysitter_job_filter.dart';
import 'babysitter_job_filter_page.dart';

class BabysitterJobsPage extends StatefulWidget {
  const BabysitterJobsPage({Key? key}) : super(key: key);

  @override
  State<BabysitterJobsPage> createState() => _BabysitterJobsPageState();
}

class _BabysitterJobsPageState extends State<BabysitterJobsPage>
    with SingleTickerProviderStateMixin {
  bool _showMap = false;
  List<Map<String, String>> _availableJobs = [];
  BabysitterJobFilterModel _filters = BabysitterJobFilterModel();

  // For a micro-animation on the Switch
  late final AnimationController _switchCtrl;
  late final Animation<double> _switchScale;

  @override
  void initState() {
    super.initState();
    _loadJobs();

    _switchCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.9,
      upperBound: 1.0,
    );
    _switchScale = CurvedAnimation(parent: _switchCtrl, curve: Curves.easeOutBack);
    _switchCtrl.forward();
  }

  @override
  void dispose() {
    _switchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    final jobProv = context.read<JobProvider>();
    final allJobs = await jobProv.fetchAllJobs();
    setState(() => _availableJobs = allJobs);
  }

  List<Map<String, String>> get _filteredJobs {
    return _availableJobs.where((job) {
      final rateDouble = double.tryParse(job["rate"] ?? "999") ?? 999;
      if (rateDouble < _filters.minRate) return false;
      if (rateDouble > _filters.maxRate) return false;

      final shifts = job["shifts"] ?? "";
      if (_filters.morningShift && !shifts.contains("morning")) return false;
      if (_filters.afternoonShift && !shifts.contains("afternoon")) return false;
      if (_filters.eveningShift && !shifts.contains("evening")) return false;
      if (_filters.nightShift && !shifts.contains("night")) return false;

      final pets = (job["pets"] == "yes");
      if (pets && !_filters.comfortableWithPets) return false;

      final specialNeeds = (job["specialNeeds"] == "yes");
      if (specialNeeds && !_filters.comfortableWithSpecialNeeds) return false;

      final days = job["days"] ?? "";
      if (_filters.weekdays && !days.contains("weekdays")) return false;
      if (_filters.weekends && !days.contains("weekends")) return false;

      return true;
    }).toList();
  }

  Future<void> _openFilterPage() async {
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jobs View:",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Row(
                children: [
                  ScaleTransition(
                    scale: _switchScale,
                    child: Switch(
                      value: _showMap,
                      onChanged: (val) {
                        setState(() => _showMap = val);
                        // subtle scale bounce
                        _switchCtrl.reverse().then((_) => _switchCtrl.forward());
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(_showMap ? "Map" : "List", style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 16),
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
