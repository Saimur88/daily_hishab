enum TransactionType { expense, income }

class Transaction {
  final double amount;
  final String category;
  final TransactionType type;

  Transaction({required this.amount,required this.category,required this.type});

  @override
  String toString() {
    return 'Transaction{amount: $amount, category: $category, type: $type}';
  }
}