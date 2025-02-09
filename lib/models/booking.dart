// lib/models/booking.dart
class Booking {
  final String bookingId;
  final String parentId;
  final String babysitterId;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // 'requested', 'confirmed', 'completed', etc.
  final String? ratingId; // if a rating has been provided

  Booking({
    required this.bookingId,
    required this.parentId,
    required this.babysitterId,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.ratingId,
  });

  factory Booking.fromMap(String id, Map<String, dynamic> data) {
    return Booking(
      bookingId: id,
      parentId: data['parentId'] ?? '',
      babysitterId: data['babysitterId'] ?? '',
      startTime: DateTime.parse(data['startTime']),
      endTime: DateTime.parse(data['endTime']),
      status: data['status'] ?? 'requested',
      ratingId: data['ratingId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'parentId': parentId,
      'babysitterId': babysitterId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'ratingId': ratingId,
    };
  }
}
