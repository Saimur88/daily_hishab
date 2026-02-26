import 'package:daily_hishab/providers/add_transaction_provider.dart';
import 'package:daily_hishab/widgets/balance_summary_card.dart';
import 'package:daily_hishab/widgets/income_history_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/expense_by_category_card.dart';
import '../widgets/expense_history_list.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final provider = context.read<TransactionProvider>();
    final transactions = transactionProvider.transactions;
    final categoryMap = transactionProvider.expenseByCategory;

    return Scaffold(
      drawer: Drawer(backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) {
              return ChangeNotifierProvider(
                create: (_) => AddTransactionProvider(),
              child: const AddTransactionSheet(),
              );
            },
          );
          if (result != null) {
            await provider.addTransaction(result);
            final error = provider.errorMessage;
            if(error != null){
              final messenger = ScaffoldMessenger.of(context);
              messenger.hideCurrentSnackBar();
              messenger.showSnackBar(SnackBar(content: Text(error)));
            }
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            child: Icon(Icons.person_outline),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
        centerTitle: true,
        title: Text("Daily Hishab"),
      ),
      body: SafeArea(
        child: Builder(
          builder: (_) {
            if(transactionProvider.isFetching){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final error = transactionProvider.errorMessage;
            if (error != null) {
              return Center(
                child: Column(
                  children: [
                    Text(error),
                    const SizedBox(height: 16,),
                    ElevatedButton(
                        onPressed: transactionProvider.loadTransactions,
                        child: Text('Retry'))
                  ],
                ),
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                BalanceSummaryCard(
                  balance: transactionProvider.balance,
                  totalExpense: transactionProvider.totalExpense,
                ),
                SizedBox(height: 20),
                Text('Expense By Category', style: TextStyle(fontSize: 20)),
                ExpenseByCategoryCard(categoryMap: categoryMap),
                SizedBox(height: 20),
                Text('Expense History', style: TextStyle(fontSize: 20)),
                Expanded(child: ExpenseHistoryList(transactions: transactions)),
                Text('Income History', style: TextStyle(fontSize: 20)),
                Expanded(child: IncomeHistoryList(transactions: transactions,))
              ],
            );
          }
        ),
      ),
    );
  }
}
