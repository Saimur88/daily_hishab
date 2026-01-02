import 'package:daily_hishab/widgets/add_transaction_sheet.dart';
import 'package:daily_hishab/widgets/balance_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';
import '../widgets/expense_by_category_card.dart';
import '../widgets/expense_history_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final transactions = transactionProvider.transactions;
    final categoryMap = transactionProvider.expenseByCategory;

    return Scaffold(
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return AddTransactionSheet();
            },
          );
          if (result != null) {
            context.read<TransactionProvider>().addTransaction(result);
          }
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        actions: [
          CircleAvatar(
            backgroundColor: Colors.amber,
            child: Icon(Icons.person_outline),
          ),
        ],
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text("Daily Hishab"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            BalanceSummaryCard(balance: transactionProvider.balance, totalExpense: transactionProvider.totalExpense,),
            SizedBox(height: 20),
            Text('Expense By Category', style: TextStyle(fontSize: 20)),
            ExpenseByCategoryCard(categoryMap: categoryMap),
            SizedBox(height: 20),
            Text('Expense History', style: TextStyle(fontSize: 20)),
           Expanded(child: ExpenseHistoryList(transactions: transactions))
          ],
        ),
      ),
    );
  }
}
