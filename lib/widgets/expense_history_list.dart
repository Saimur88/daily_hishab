import 'package:daily_hishab/models/transaction.dart';
import 'package:flutter/material.dart';

class ExpenseHistoryList extends StatelessWidget {
  final List<Transaction> transactions;
  const ExpenseHistoryList({required this.transactions, super.key});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Center(
        child: Text(
          "No expenses yet. \nAdd your first one to get started",
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return Card(
            child: ListTile(
              title: Text(
                tx.category,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                tx.type == TransactionType.expense ? 'Expense' : 'Income',
              ),
              trailing: Text(tx.amount.toStringAsFixed(2)),
            ),
          );
        },
      );
    }
  }
}
