import 'package:daily_hishab/core/formatters/formatters.dart';
import 'package:daily_hishab/models/transaction.dart';
import 'package:daily_hishab/providers/add_transaction_provider.dart';
import 'package:daily_hishab/widgets/add_transaction_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';


class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  const TransactionList({required this.transactions, super.key});



  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    if (transactions.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "No expenses yet. \nAdd your first one to get started",
            textAlign: TextAlign.center,
          ),),
      );
    } else {
      return SliverList.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final indexedTransaction = transactions[index];
          return Dismissible(
            key: ValueKey(indexedTransaction.id),
            direction: DismissDirection.endToStart,
            background: Container(color:  Colors.transparent,),
            secondaryBackground: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                color: scheme.error,
                child: const Icon(Icons.delete_forever, color: Colors.white),
              ),
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
                        context.pop(false);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        (context).pop(true);
                      },
                      child: Text('Delete',style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (_) async {
              await context.read<TransactionProvider>().deleteTransaction(
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
                  trailing: Text(AppFormattrers.formatCurrency(indexedTransaction.type == TransactionType.income? indexedTransaction.amount : -indexedTransaction.amount),style: TextStyle(
                      fontSize: 15,
                      color: indexedTransaction.type == TransactionType.income ? scheme.secondary : scheme.error,
                      fontWeight: FontWeight.bold
                  ),),
                  subtitle: Text(AppFormattrers.formatDateTime(indexedTransaction.timestamp)),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}