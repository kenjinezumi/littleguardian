// lib/models/booking.dart
class Booking {
  final String bookingId;
  final String jobId;
  final String parentId;
  final String babysitterId;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // requested, accepted, inProgress, completed, canceled
  final String? ratingId;
  final double? finalRate;

  Booking({
    required this.bookingId,
    required this.jobId,
    required this.parentId,
    required this.babysitterId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.ratingId,
    this.finalRate,
  });

  factory Booking.fromMap(String id, Map<String, dynamic> data) {
    return Booking(
      bookingId: id,
      jobId: data['jobId'] ?? '',
      parentId: data['parentId'] ?? '',
      babysitterId: data['babysitterId'] ?? '',
      startTime: DateTime.parse(data['startTime']),
      endTime: DateTime.parse(data['endTime']),
      status: data['status'] ?? 'requested',
      ratingId: data['ratingId'],
      finalRate: data['finalRate']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'parentId': parentId,
      'babysitterId': babysitterId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'ratingId': ratingId,
      'finalRate': finalRate,
    };
  }
}
