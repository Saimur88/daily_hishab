import 'package:daily_hishab/models/transaction.dart';
import 'package:daily_hishab/widgets/connectivity_banner.dart';
import 'package:daily_hishab/widgets/spending_earning_segment.dart';
import 'package:daily_hishab/widgets/total_balance_hero_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../core/formatters/formatters.dart';
import '../providers/transaction_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {

  DashboardMode _mode = DashboardMode.spending;


  bool _hideBalance = false;
  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final provider = context.read<TransactionProvider>();
    final transactions = transactionProvider.transactions;
    final categoryMap =
        _mode == DashboardMode.spending ?
        transactionProvider.expenseByCategory
    : transactionProvider.incomeByCategory
    ;
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

    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
    ];

    final barGroups = categoryMap.entries.toList().asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: category.value,       // amount
            color: colors[index % colors.length],
            width: 20,
          ),
        ],
      );
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
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            height: 300,
                            child: BarChart(
                              BarChartData(
                                barGroups: barGroups,
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta){
                                          final index = value.toInt();
                                          if (index >= categoryMap.keys.length) return Text('');
                                          final category = categoryMap.keys.toList()[index];
                                          return Text(category);
                                      }
                                    )
                                  )
                                )
                              )
                            ),
                          ),
                        ),
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
