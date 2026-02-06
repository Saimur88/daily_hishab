import 'package:daily_hishab/models/transaction.dart';
import 'package:daily_hishab/providers/add_transaction_provider.dart';
import 'package:daily_hishab/widgets/add_transaction_sheet.dart';
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
          final transaction = transactions[index];
          return Dismissible(
            key: ValueKey(transaction),
            direction: DismissDirection.horizontal,
            background: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 20),
              color: Colors.blue,
              child: const Icon(Icons.edit,color: Colors.white,),
            ),
            secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              color: Colors.red.shade700,
              child: const Icon(Icons.delete_forever,color: Colors.white,),
            ),
            confirmDismiss: (direction) async {
              if(direction == DismissDirection.startToEnd){
                Future.microtask(() async {
                 final updatedTransaction = showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => ChangeNotifierProvider(
                        create:(_) {
                          final provider = AddTransactionProvider();
                          provider.loadFromTransaction(transaction);
                          return provider;
                          },
                    child: AddTransactionSheet(existingTransaction: transaction,),
                    ),
                 );
                 if(updatedTransaction != null){
                   return context.read<TransactionProvider>().updateTransaction(await updatedTransaction);
                 }
                });
                return false;


              } else {
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
              }
            },
            onDismissed: (direction){
              if(direction == DismissDirection.endToStart){
              context.read<TransactionProvider>().deleteTransaction(transaction);
              }
            },
            child: Card(
              elevation: 2,
              child: ListTile(
                leading: Text('${index + 1}.',style: TextStyle(
                  fontSize: 15,
                ),),
                title: Text(
                  transaction.category,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  transaction.type == TransactionType.expense ? 'Expense' : 'Income',
                ),
                trailing: Text(transaction.amount.toStringAsFixed(2)),
              ),
            ),
          );
        },
      );
    }
  }
}
