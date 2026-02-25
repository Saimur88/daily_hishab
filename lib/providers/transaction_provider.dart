import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:daily_hishab/repositories/transaction_repository.dart';
import 'package:daily_hishab/models/transaction.dart';

class TransactionProvider extends ChangeNotifier {

  final List<Transaction> _transactions =[];


  final TransactionRepository _repository = TransactionRepository();
  bool _isFetching = false;
  bool _isMutating = false;
  bool get isMutating => _isMutating;
  String? _errorMessage;

  bool get isFetching => _isFetching;
  String? get errorMessage => _errorMessage;

  List<Transaction> get transactions => _transactions;

  TransactionProvider() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    _isFetching = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final fetchedTransactions = await _repository.fetchTransactions();
      _transactions //Cascade operator
        ..clear() //cant do _transactions = fetchedTransactions bu .clear() can be done
        ..addAll(fetchedTransactions);
    } catch (e){
      _errorMessage = e.toString();
    }finally{
      _isFetching = false;
      notifyListeners();
    }




  }

  Future<void> addTransaction(Transaction tx) async {
    _isMutating = true;
    _errorMessage = null;
    notifyListeners();
    try{
      final createdTransaction = await _repository.addTransaction(tx);
      _transactions.insert(0,createdTransaction);
    } catch(e){
      _errorMessage = e.toString();
    }finally{
      _isMutating = false;
      notifyListeners();
    }
  }

  Future<void> updateTransaction (Transaction updatedTX) async {
    _isMutating = true;
    _errorMessage = null;
    notifyListeners();
    try{
      await _repository.updateTransaction(updatedTX);
      final index = _transactions.indexWhere((tx) => tx.id == updatedTX.id);
      if(index == -1) return;
      _transactions[index] = updatedTX;
    }catch (e){
      _errorMessage = e.toString();
    }finally{
      _isMutating = false;
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    _isMutating = true;
    _errorMessage = null;
    notifyListeners();

    final index = _transactions.indexWhere((tx) => tx.id == id);
    if(index == -1) {
      _isMutating = false;
      notifyListeners();
      return;
    }

    final removed = _transactions.removeAt(index);
    notifyListeners();


    try{
      await _repository.deleteTransaction(id);
    }catch (e) {
      _transactions.insert(index, removed);
      _errorMessage = e.toString();
    }finally{
      _isMutating = false;
      notifyListeners();
    }
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
