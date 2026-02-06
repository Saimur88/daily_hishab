import 'package:flutter/material.dart';
import 'package:daily_hishab/repositories/transaction_repository.dart';
import 'package:daily_hishab/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {

  final List<Transaction> _transactions =[];


  final TransactionRepository _repository = TransactionRepository();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Transaction> get transactions => _transactions;

  TransactionProvider() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final fetchedTransactions = await _repository.fetchTransactions();
      _transactions //Cascade operator
        ..clear() //cant do _transactions = fetchedTransactions bu .clear() can be done
        ..addAll(fetchedTransactions);
      notifyListeners();
    }catch (e){
      _errorMessage = 'Failed to fetch transactions.';
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(Transaction tx) async {
    await _repository.addTransaction(tx);

    _transactions.add(tx);
    notifyListeners();
  }

  Future<void> updateTransaction (Transaction updatedTX) async {
    final index = _transactions.indexWhere((tx) => tx.id == updatedTX.id);
  if(index == -1) return;
  _transactions[index] = updatedTX;
  notifyListeners();

  }

  // Future<void> addTransaction(Transaction tx) async {
  //   await _repository.addTransaction(tx);
  //   await loadTransactions();
  // }


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
  Future<void> deleteTransaction(Transaction tx) async {
    //later will come firebase
    _transactions.remove(tx);
    notifyListeners();
  }


}
