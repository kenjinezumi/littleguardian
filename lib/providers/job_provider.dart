// lib/providers/job_provider.dart
import 'package:flutter/material.dart';

class JobProvider extends ChangeNotifier {
  /// In-memory store mapping parentEmail -> list of jobs (Map).
  /// Now we start with some dummy data for demonstration.
  final Map<String, List<Map<String, String>>> _jobsByParent = {
    "parentA@example.com": [
      {
        "jobId": "job_1",
        "title": "Weekend babysitting",
        "description": "Sat 6PM - 12AM for 2 kids",
        "rate": "\$20/hr",
        // optional lat/lng for map
        "lat": "37.7749",
        "lng": "-122.4194",
      },
      {
        "jobId": "job_2",
        "title": "Sunday morning",
        "description": "Need help from 8AM - 11AM, 1 child",
        "rate": "\$18/hr",
        "lat": "37.7750",
        "lng": "-122.4189",
      },
    ],
    "parentB@example.com": [
      {
        "jobId": "job_3",
        "title": "Full day sitter",
        "description": "9AM - 5PM, 2 kids + 1 dog",
        "rate": "\$15/hr",
        "lat": "34.0522",
        "lng": "-118.2437",
      },
    ],
  };

  /// Returns a list of the parent's jobs.
  List<Map<String, String>> fetchParentJobs(String parentEmail) {
    if (!_jobsByParent.containsKey(parentEmail)) {
      _jobsByParent[parentEmail] = [];
    }
    return _jobsByParent[parentEmail]!;
  }

  /// Create a new job for this parent in memory, then notify.
  void createJob(String parentEmail, Map<String, String> job) {
    if (!_jobsByParent.containsKey(parentEmail)) {
      _jobsByParent[parentEmail] = [];
    }
    // Assign a "jobId" if needed
    final jobId = "job_${DateTime.now().millisecondsSinceEpoch}";
    job["jobId"] = jobId;

    _jobsByParent[parentEmail]!.add(job);
    notifyListeners();
  }

  /// Returns all posted jobs from every parent combined.
  /// This is what babysitters see in their "Available Jobs" tab.
  Future<List<Map<String, String>>> fetchAllJobs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final List<Map<String, String>> all = [];
    _jobsByParent.forEach((parentEmail, jobsList) {
      all.addAll(jobsList);
    });
    return all;
  }
}
