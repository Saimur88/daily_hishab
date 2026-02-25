  import 'package:flutter/material.dart';
  import '../models/transaction.dart';
  import '../repositories/transaction_repository.dart';

  class AddTransactionProvider extends ChangeNotifier{


    final TextEditingController controller = TextEditingController();
    final TransactionRepository _repository = TransactionRepository();

    bool _isEditing = false;
    bool get isEditing => _isEditing;

    void setEditing(bool value) {
      _isEditing = value;
    }


    bool _initialized = false;

    void loadFromTransaction(Transaction tx) async {
      if(_initialized) return;
      _isEditing = true;
      controller.text = tx.amount.toString();
      _type = tx.type;
      _selectedCategory = tx.category;
      _initialized = true;
      notifyListeners();
    }

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

    void setType (TransactionType type ){
      _type = type;
      _ensureValidCategory();
      notifyListeners();
    }

    TransactionType get type => _type;
    String get selectedCategory => _selectedCategory;

    List<String> get categories =>
        type == TransactionType.expense ? _expenseCategories : _incomeCategories;

    String get header =>
        type == TransactionType.expense ? "Add Expense" : "Add Income";

    String get categoryLabel =>
        type == TransactionType.expense ? "Expense Category" : "Income Category";


    Future<void> addExpenseSheet() async {
      // Firebase will come here later)
      _type = TransactionType.expense;
      _selectedCategory = _expenseCategories.first;
      if(!_isEditing)controller.clear();
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
      if(!_isEditing)controller.clear();
      notifyListeners();
    }
    void _ensureValidCategory(){
      final list = categories;
      if(list.isEmpty) return;
      if(!list.contains(_selectedCategory)){
        _selectedCategory = list.first;

      }
    }

  }