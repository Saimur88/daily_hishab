import 'package:flutter/material.dart';
import '../models/transaction.dart';

class AddTransactionProvider extends ChangeNotifier{

  final TextEditingController controller = TextEditingController();

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  //Bottom Sheet Materials

  final List<String> _expenseCategories = ['Shopping', 'Entertainment', 'Other'];
  final List<String> _incomeCategories = ['Salary', 'Bonus', 'Business','Other'];

  TransactionType _type = TransactionType.expense;
  String _selectedCategory = "Shopping";

  TransactionType get type => _type;
  String get selectedCategory => _selectedCategory;

  List<String> get categories =>
      type == TransactionType.expense ? _expenseCategories : _incomeCategories;

  String get header =>
      type == TransactionType.expense ? "Add Expense" : "Add Income";

  String get category_label =>
      type == TransactionType.expense ? "Expense Category" : "Income Category";


  Future<void> addExpenseSheet() async {
    // Firebase will come here later)
    _type = TransactionType.expense;
    _selectedCategory = _expenseCategories.first;
    controller.clear();
    notifyListeners();
  }

  void changeSelected(String val){
    _selectedCategory =  val;
    notifyListeners();
  }

  Future<void> addIncomeSheet() async {
    // Firebase will come here later)
    _type = TransactionType.income;
    _selectedCategory = _incomeCategories.first;
    controller.clear();
    notifyListeners();
  }

}