// lib/providers/job_provider.dart
import 'package:flutter/material.dart';
import '../models/job_post.dart';

class JobProvider extends ChangeNotifier {
  // Fake fetching a list of JobPost from a server/DB
  Future<List<JobPost>> fetchAvailableJobs() async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Return some dummy data as JobPost objects
    return [
      JobPost(
        jobId: '1',
        parentId: 'parentA',
        title: 'Weekend babysitting',
        description: 'Sat 6PM - 12AM',
        isRecurring: false,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 6)),
        offeredRate: 20.0,
      ),
      JobPost(
        jobId: '2',
        parentId: 'parentB',
        title: 'Morning sitter needed',
        description: 'Weekdays 8AM - 12PM',
        isRecurring: false,
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 4)),
        offeredRate: 15.0,
      ),
    ];
  }
}
