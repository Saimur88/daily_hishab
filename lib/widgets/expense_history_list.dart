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
    final expenseTransaction = transactions
    .where((t) => t.type == TransactionType.expense)
    .toList();
    if (expenseTransaction.isEmpty) {
      return Text(
        "No expenses yet. \nAdd your first one to get started",
        textAlign: TextAlign.center,
      );
    } else {
      return ListView.builder(
        itemCount: expenseTransaction.length,
        itemBuilder: (context, index) {
          final indexedTransaction = expenseTransaction[index];
          return Dismissible(
            key: ValueKey(indexedTransaction.id),
            direction: DismissDirection.endToStart,
            background: Container(color:  Colors.transparent,),
            secondaryBackground: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              color: Colors.red.shade400,
              child: const Icon(Icons.delete_forever, color: Colors.white),
            ),
            confirmDismiss: (_) async {
              return await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete Transaction'),
                  content: const Text('This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              },
            onDismissed: (_) {
                context.read<TransactionProvider>().deleteTransaction(
                  indexedTransaction.id,
                );
            },
            child: InkWell(
              onLongPress: () async {
                  final updatedTransaction = await showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) {
                        final provider = AddTransactionProvider();
                        provider.loadFromTransaction(indexedTransaction);
                        return provider;
                      },
                      child: AddTransactionSheet(
                        existingTransaction: indexedTransaction,

                      ),
                    ),
                  );
                  if (updatedTransaction != null) {
                    context.read<TransactionProvider>().updateTransaction(
                      updatedTransaction,
                    );
                  }
              },
              child: Card(
                elevation: 2,
                child: ListTile(
                  leading: Text('${index + 1}.', style: TextStyle(fontSize: 15)),
                  title: Text(
                    indexedTransaction.category,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  trailing: Text(indexedTransaction.amount.toStringAsFixed(2),style: TextStyle(
                    fontSize: 15,
                  ),),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}