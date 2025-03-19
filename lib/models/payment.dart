// lib/models/payment.dart

class PaymentTransaction {
  final String transactionId;
  final String bookingId;
  final String payerId; // parent's UID
  final String payeeId; // babysitter's UID
  final double amount;
  final DateTime timestamp;
  final bool isCompleted;
  final double? tip;

  PaymentTransaction({
    required this.transactionId,
    required this.bookingId,
    required this.payerId,
    required this.payeeId,
    required this.amount,
    required this.timestamp,
    this.isCompleted = false,
    this.tip,
  });

  factory PaymentTransaction.fromMap(String id, Map<String, dynamic> data) {
    return PaymentTransaction(
      transactionId: id,
      bookingId: data['bookingId'] ?? '',
      payerId: data['payerId'] ?? '',
      payeeId: data['payeeId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      timestamp: DateTime.parse(data['timestamp']),
      isCompleted: data['isCompleted'] ?? false,
      tip: data['tip']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'payerId': payerId,
      'payeeId': payeeId,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
      'isCompleted': isCompleted,
      'tip': tip,
    };
  }
}
