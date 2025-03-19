// lib/models/job_post.dart
class JobPost {
  final String jobId;
  final String parentId;
  final String title;
  final String description;
  final bool isRecurring;
  final DateTime startTime;
  final DateTime endTime;
  final double offeredRate;
  final List<String> requiredCertifications; // e.g. ["CPR", "First Aid"]

  JobPost({
    required this.jobId,
    required this.parentId,
    required this.title,
    required this.description,
    this.isRecurring = false,
    required this.startTime,
    required this.endTime,
    required this.offeredRate,
    this.requiredCertifications = const [],
  });

  JobPost copyWith({
    String? jobId,
    String? parentId,
    String? title,
    String? description,
    bool? isRecurring,
    DateTime? startTime,
    DateTime? endTime,
    double? offeredRate,
    List<String>? requiredCertifications,
  }) {
    return JobPost(
      jobId: jobId ?? this.jobId,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      isRecurring: isRecurring ?? this.isRecurring,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      offeredRate: offeredRate ?? this.offeredRate,
      requiredCertifications: requiredCertifications ?? this.requiredCertifications,
    );
  }

  factory JobPost.fromMap(String id, Map<String, dynamic> data) {
    return JobPost(
      jobId: id,
      parentId: data['parentId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isRecurring: data['isRecurring'] ?? false,
      startTime: DateTime.parse(data['startTime']),
      endTime: DateTime.parse(data['endTime']),
      offeredRate: (data['offeredRate'] ?? 0).toDouble(),
      requiredCertifications:
          List<String>.from(data['requiredCertifications'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'title': title,
      'description': description,
      'isRecurring': isRecurring,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'offeredRate': offeredRate,
      'requiredCertifications': requiredCertifications,
    };
  }
}
