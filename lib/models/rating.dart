// lib/models/rating.dart
/// For reviews/ratings after job completion
class RatingModel {
  final String ratingId;
  final String bookingId;
  final String reviewerId;
  final String revieweeId;
  final int stars;
  final String reviewText;

  RatingModel({
    required this.ratingId,
    required this.bookingId,
    required this.reviewerId,
    required this.revieweeId,
    required this.stars,
    required this.reviewText,
  });

  factory RatingModel.fromMap(String id, Map<String, dynamic> data) {
    return RatingModel(
      ratingId: id,
      bookingId: data['bookingId'] ?? '',
      reviewerId: data['reviewerId'] ?? '',
      revieweeId: data['revieweeId'] ?? '',
      stars: data['stars'] ?? 0,
      reviewText: data['reviewText'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
      'stars': stars,
      'reviewText': reviewText,
    };
  }
}
