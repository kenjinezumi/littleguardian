// lib/providers/job_provider.dart
import 'package:flutter/material.dart';

class JobProvider extends ChangeNotifier {
  /// In-memory store mapping parentEmail -> list of jobs.
  /// Each job is a Map with fields: "title", "description", "rate", etc.
  final Map<String, List<Map<String, String>>> _jobsByParent = {};

  /// Returns a list of the parent's jobs.
  List<Map<String, String>> fetchParentJobs(String parentEmail) {
    // If we haven't seen this parent yet, initialize an empty list for them.
    if (!_jobsByParent.containsKey(parentEmail)) {
      _jobsByParent[parentEmail] = [];
    }
    return _jobsByParent[parentEmail]!;
  }

  /// Create a new job for this parent in memory.
  /// Then call notifyListeners() so UI updates automatically.
  void createJob(String parentEmail, Map<String, String> job) {
    if (!_jobsByParent.containsKey(parentEmail)) {
      _jobsByParent[parentEmail] = [];
    }
    _jobsByParent[parentEmail]!.add(job);
    notifyListeners();
  }

  /// Returns fake "available jobs" for babysitters to see.
  Future<List<Map<String, String>>> fetchAvailableJobs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    // some static data:
    return [
      {
        "title": "Weekend babysitting",
        "description": "Sat 6PM - 12AM",
        "rate": "\$20/hr",
      },
      {
        "title": "Morning sitter needed",
        "description": "Weekdays 8AM - 12PM",
        "rate": "\$15/hr",
      },
    ];
  }
}
