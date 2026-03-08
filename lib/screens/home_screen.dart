import 'package:daily_hishab/providers/add_transaction_provider.dart';
import 'package:daily_hishab/widgets/balance_summary_card.dart';
import 'package:daily_hishab/widgets/connectivity_banner.dart';
import 'package:daily_hishab/widgets/income_history_sliver_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/add_transaction_sheet.dart';
import '../widgets/expense_by_category_card.dart';
import '../widgets/expense_history_sliver_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final provider = context.read<TransactionProvider>();
    final transactions = transactionProvider.transactions;
    final categoryMap = transactionProvider.expenseByCategory;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    const spinkit = SpinKitRotatingCircle(color: Colors.blue, size: 50.0);

    return Scaffold(
      backgroundColor: scheme.inversePrimary,
      extendBodyBehindAppBar: true,
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
            if (error != null) {
              final messenger = ScaffoldMessenger.of(context);
              messenger.hideCurrentSnackBar();
              messenger.showSnackBar(SnackBar(content: Text(error)));
            }
          }
        },
        child: Icon(Ionicons.add_outline),
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: SafeArea(
              child: Builder(
                builder: (_) {
                  if (transactionProvider.isFetching) {
                    return Center(child: spinkit);
                  }
                  final error = transactionProvider.errorMessage;
                  if (error != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(error),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: provider.loadTransactions,
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: BalanceSummaryCard(
                            balance: transactionProvider.balance,
                            totalExpense: transactionProvider.totalExpense,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary,
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Expense By Category',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).canvasColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: ExpenseByCategoryCard(
                            categoryMap: categoryMap,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.5),
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Expense History',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: ExpenseHistorySliverList(
                          transactions: transactions,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverToBoxAdapter(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.5),
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Income History',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).canvasColor,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: IncomeHistorySliverList(
                          transactions: transactions,
                        ),
                      ),
                    ],
                  );
                  //   Column(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     SizedBox(height: 20),
                  //     BalanceSummaryCard(
                  //       balance: transactionProvider.balance,
                  //       totalExpense: transactionProvider.totalExpense,
                  //     ),
                  //     SizedBox(height: 20),
                  //     Card(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //         elevation: 2,
                  //         color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
                  //         child: SizedBox(
                  //           width: 250,
                  //           height: 50,
                  //           child: Center(
                  //             child: Text('Expense By Category',
                  //                 style: TextStyle(
                  //
                  //               fontWeight: FontWeight.bold,
                  //                 color: Theme.of(context).canvasColor,
                  //                 fontSize: 20),
                  //             ),
                  //           ),
                  //         ),
                  //     ),
                  //     ExpenseByCategoryCard(categoryMap: categoryMap),
                  //     SizedBox(height: 20),
                  //     Card(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       elevation: 2,
                  //       color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
                  //       child: SizedBox(
                  //         width: 250,
                  //         height: 50,
                  //         child: Center(
                  //           child: Text('Expense History',
                  //             style: TextStyle(
                  //
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Theme.of(context).canvasColor,
                  //                 fontSize: 20),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(child: ExpenseHistoryList(transactions: transactions)),
                  //     SizedBox(height: 10,),
                  //     Card(
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       elevation: 2,
                  //       color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.5),
                  //       child: SizedBox(
                  //         width: 250,
                  //         height: 50,
                  //         child: Center(
                  //           child: Text('Income History',
                  //             style: TextStyle(
                  //
                  //                 fontWeight: FontWeight.bold,
                  //                 color: Theme.of(context).canvasColor,
                  //                 fontSize: 20),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(child: IncomeHistoryList(transactions: transactions,))
                  //   ],
                  // );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
