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

  Future<Transaction> addTransaction(Transaction transaction) async {
    // Firebase will come here later
    final docRef = _db.doc();
    final newTransaction =  Transaction(
        id: docRef.id,
        amount: transaction.amount,
        category: transaction.category,
        type: transaction.type,
        timestamp: transaction.timestamp);

    await docRef.set({
      'amount': newTransaction.amount,
      'category': newTransaction.category,
      'type': newTransaction.type == TransactionType.income ? 'income' : 'expense',
      'timestamp': Timestamp.fromDate(newTransaction.timestamp),
    });
    return newTransaction;
  }

  Future<void> updateTransaction(Transaction transaction) async {
    // Firebase will come here later
    await _db.doc(transaction.id).update({
      'amount': transaction.amount,
      'category': transaction.category,
      'timestamp': Timestamp.fromDate(transaction.timestamp),
      'type': transaction.type == TransactionType.income ? 'income' : 'expense'
    });
  }

  Future<void> deleteTransaction(String id) async {
    // Firebase will come here later
    await _db.doc(id).delete();
  }
}
