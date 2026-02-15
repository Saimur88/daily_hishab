import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';

import '../models/transaction.dart';

class IncomeHistoryList extends StatelessWidget {
  final List<Transaction> transactions;
  const IncomeHistoryList({required this.transactions,super.key});

  @override
  Widget build(BuildContext context) {
    final incomeTransactions = transactions
    .where((t)=> t.type == TransactionType.income)
    .toList();

    if (incomeTransactions.isEmpty) {
      return const Center(
        child: Text('No Income History \n Add Income To Get Started',
        textAlign: TextAlign.center,
        ),
      );
  }
    return ListView.builder(
      itemCount: incomeTransactions.length,
        itemBuilder:(context, index){
        final transaction = incomeTransactions[index];
        return Card(
          elevation: 2,
          child: ListTile(
            leading: Text('${index + 1}.', style: TextStyle(fontSize: 15)),
            title: Text(
              transaction.category,
              style: TextStyle(fontWeight: FontWeight.w500),

            ),
            trailing: Text(transaction.amount.toStringAsFixed(2),style: TextStyle(
              fontSize: 15,
            ),),
          ),
        );
        } );
  }
}
