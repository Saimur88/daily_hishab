import 'package:daily_hishab/models/transaction.dart';
import 'package:daily_hishab/providers/add_transaction_provider.dart';
import 'package:daily_hishab/widgets/connectivity_banner.dart';
import 'package:daily_hishab/widgets/spending_earning_segment.dart';
import 'package:daily_hishab/widgets/total_balance_hero_card.dart';
import 'package:daily_hishab/widgets/tranasction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import '../core/formatters/formatters.dart';
import '../providers/transaction_provider.dart';
import '../widgets/add_transaction_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  DashboardMode _mode = DashboardMode.spending;


  bool _hideBalance = false;
  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final provider = context.read<TransactionProvider>();
    final transactions = transactionProvider.transactions;
    final categoryMap = transactionProvider.expenseByCategory;
    final scheme = Theme.of(context).colorScheme;
    final balanceText =
    AppFormattrers.formatCurrency(transactionProvider.balance);

    final filteredTransaction = transactions.where((t){
      switch(_mode){
        case DashboardMode.spending:
        return t.type == TransactionType.expense;

        case DashboardMode.earnings:
        return t.type == TransactionType.income;
      }
    }).toList();


    const spinkit = SpinKitRotatingCircle(color: Colors.blue, size: 50.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Daily Hishab'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.keyboard_arrow_down_outlined),
            label: Text('March 2026'),
          ),
        ],
      ),
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
                      SliverToBoxAdapter(child: const ConnectivityBanner()),
                      const SliverToBoxAdapter(child: SizedBox(height: 16)),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: TotalBalanceHeroCard(
                            amountText: balanceText,
                            isHidden: _hideBalance,
                            onToggleHidden: () => setState(()=> _hideBalance = !_hideBalance),
                          ),
                        ),
                      ),
                      SliverPadding(
                          padding:EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(child: SpendingEarningsSegmented(
                            value: _mode,
                            onChanged: (next) => setState(() => _mode = next),
                        ),),
                      ),
                      SliverPadding(
                        padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
                        sliver: TransactionList(transactions: filteredTransaction),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
