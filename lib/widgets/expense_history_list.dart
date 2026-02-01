import 'package:daily_hishab/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

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
          return Dismissible(
            key: ValueKey(tx),
            direction: DismissDirection.horizontal,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete,color: Colors.white,),
            ),
            secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              color: Colors.red.shade700,
              child: const Icon(Icons.delete_forever,color: Colors.white,),
            ),
            confirmDismiss: (_) async {
              return await showDialog(
                  context: context,
                  builder:(_) => AlertDialog(
                    title: const Text('Delete Transaction'),
                    content: const Text('This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.of(context).pop(false);
                      }, child: const Text('Cancel')),
                      TextButton(onPressed: (){
                        Navigator.of(context).pop(true);
                      }, child: const Text('Delete')),
                    ],
                  ));
            },
            onDismissed: (_){
              context.read<TransactionProvider>().deleteTransaction(tx);
            },
            child: Card(
              elevation: 2,
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
            ),
          );
        },
      );
    }
  }
}
