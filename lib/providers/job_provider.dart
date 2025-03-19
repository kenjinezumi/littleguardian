// lib/providers/job_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_post.dart';

class JobProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool _loading = false;
  bool get loading => _loading;

  List<JobPost> _myPostedJobs = [];
  List<JobPost> get myPostedJobs => _myPostedJobs;

  Future<void> createJobPost(JobPost job) async {
    final docRef = _db.collection('jobPosts').doc();
    final newJob = job.copyWith(jobId: docRef.id);
    await docRef.set(newJob.toMap());
    // Optionally add to local list
  }

  Future<void> loadParentJobs(String parentId) async {
    _loading = true;
    notifyListeners();
    final snapshot = await _db
        .collection('jobPosts')
        .where('parentId', isEqualTo: parentId)
        .get();
    _myPostedJobs = snapshot.docs.map((doc) {
      return JobPost.fromMap(doc.id, doc.data());
    }).toList();
    _loading = false;
    notifyListeners();
  }

  Future<List<JobPost>> fetchAllJobs() async {
    final snap = await _db.collection('jobPosts').get();
    return snap.docs.map((doc) => JobPost.fromMap(doc.id, doc.data())).toList();
  }

  // Or advanced filtering for babysitters
  Future<List<JobPost>> searchJobs({String? location, double? minRate}) async {
    // A more complex query can be done
    final snap = await _db.collection('jobPosts').get();
    final all = snap.docs
        .map((doc) => JobPost.fromMap(doc.id, doc.data()))
        .toList();
    // Filter locally or with Firestore queries
    return all;
  }
}
