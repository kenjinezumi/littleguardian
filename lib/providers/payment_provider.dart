import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment.dart';

class PaymentProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> processPayment(PaymentTransaction payment) async {
    // 1. Integrate with Stripe/PayPal/other to charge parent's card
    // 2. On success, store record in Firestore
    final docRef = _db.collection('payments').doc(payment.transactionId);
    await docRef.set(payment.toMap());
    // 3. Mark as completed if success
  }

  Future<void> addTip(String transactionId, double tip) async {
    await _db.collection('payments').doc(transactionId).update({'tip': tip});
  }

  Future<List<PaymentTransaction>> fetchTransactions(String userId) async {
    // Return all payments where user is payer or payee
    final payerSnap = await _db
        .collection('payments')
        .where('payerId', isEqualTo: userId)
        .get();
    final payeeSnap = await _db
        .collection('payments')
        .where('payeeId', isEqualTo: userId)
        .get();

    final allDocs = [...payerSnap.docs, ...payeeSnap.docs];
    // Deduplicate by doc ID if needed
    final map = {
      for (var d in allDocs) d.id: d.data()
    };
    final List<PaymentTransaction> result = map.entries.map((entry) {
      return PaymentTransaction.fromMap(
        entry.key,
        entry.value as Map<String, dynamic>,
      );
    }).toList();
    return result;
  }
}
