import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:daily_hishab/models/transaction.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionRepository {
  CollectionReference<Map<String, dynamic>> _txRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not authenticated');
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions');
  }

  Future<List<Transaction>> fetchTransactions() async {
    final querySnapshot =
    await _txRef().orderBy('timestamp', descending: true).get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Transaction(
        id: doc.id,
        amount: (data['amount'] as num).toDouble(),
        category: data['category'] as String,
        type: (data['type'] as String) == 'income'
            ? TransactionType.income
            : TransactionType.expense,
        timestamp: (data['timestamp'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Future<Transaction> addTransaction(Transaction tx) async {
    final docRef = _txRef().doc(); // reserves id

    final newTx = Transaction(
      id: docRef.id,
      amount: tx.amount,
      category: tx.category,
      type: tx.type,
      timestamp: tx.timestamp,
    );

    await docRef.set({
      'amount': newTx.amount,
      'category': newTx.category,
      'type': newTx.type == TransactionType.income ? 'income' : 'expense',
      'timestamp': Timestamp.fromDate(newTx.timestamp),
    });

    return newTx;
  }

  Future<void> updateTransaction(Transaction tx) async {
    await _txRef().doc(tx.id).update({
      'amount': tx.amount,
      'category': tx.category,
      'timestamp': Timestamp.fromDate(tx.timestamp),
      'type': tx.type == TransactionType.income ? 'income' : 'expense',
    });
  }

  Future<void> deleteTransaction(String id) async {
    await _txRef().doc(id).delete();
  }
}