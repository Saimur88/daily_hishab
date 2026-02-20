enum TransactionType { expense , income }
class Transaction {
  final String id;
  final double amount;
  final String category;
  final TransactionType type;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.amount,
    required this.category,
    required this.type,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'Transaction{amount: $amount, category: $category, type: $type}';
  }
}