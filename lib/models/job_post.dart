// lib/models/job_post.dart
class JobPost {
  final String jobId;
  final String parentId;
  final String title;
  final String description;
  final double offeredRate;

  JobPost({
    required this.jobId,
    required this.parentId,
    required this.title,
    required this.description,
    required this.offeredRate,
  });

  // If you need fromMap / toMap for real DB usage, add them
}
