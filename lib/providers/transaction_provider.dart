import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:daily_hishab/repositories/transaction_repository.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];
  final TransactionRepository _repository = TransactionRepository();

  List<Transaction> get transactions => _transactions;

  Future<void> loadTransactions() async {
    final fetchedTransactions = await _repository.fetchTransactions();
    _transactions
      ..clear()
      ..addAll(fetchedTransactions);
    notifyListeners();
  }

  void addTransaction(Transaction tx) {
    _transactions.add(tx);
    notifyListeners();
  }

  double get totalExpense {
    double sum = 0;
    for (var tx in _transactions) {
      if (tx.type == TransactionType.expense) {
        sum += tx.amount;
      }
    }
    return sum;
  }

  double get totalIncome {
    double sum = 0;
    for (var tx in _transactions) {
      if (tx.type == TransactionType.income) {
        sum += tx.amount;
      }
    }
    return sum;
  }

  double get balance {
    return totalIncome - totalExpense;
  }
  Map<String, double> get expenseByCategory {
    final Map<String, double> data = {};

    for (var tx in _transactions) {
      if (tx.type == TransactionType.expense) {
        data[tx.category] = (data[tx.category] ?? 0) + tx.amount;
      }
    }

    return data;
  }


}
