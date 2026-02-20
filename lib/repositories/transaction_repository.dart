import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:daily_hishab/models/transaction.dart';

class TransactionRepository {
  final CollectionReference _db = FirebaseFirestore.instance.collection(
    'transactions',
  );

  Future<List<Transaction>> fetchTransactions() async {
    final querySnapshot = await _db
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Transaction(
        id: doc.id,
        amount: (data['amount'] as num).toDouble(),
        category: data['category'],
        type: data['type'] == 'income'
            ? TransactionType.income
            : TransactionType.expense,
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Future<void> addTransaction(Transaction transaction) async {
    // Firebase will come here later
    await _db.add({
      'amount': transaction.amount,
      'category': transaction.category,
      'type': transaction.type == TransactionType.income ? 'income' : 'expense',
      'timestamp': Timestamp.fromDate(transaction.timestamp),
    });
  }

  Future<void> deleteTransaction(String id) async {
    // Firebase will come here later
    await _db.doc(id).delete();
  }
}
