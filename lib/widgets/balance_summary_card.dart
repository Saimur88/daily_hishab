import 'package:daily_hishab/core/formatters/formatters.dart';
import 'package:flutter/material.dart';

class BalanceSummaryCard extends StatelessWidget {
  final double balance;
  final double totalExpense;
  late final String _balance = AppFormattrers.formatCurrency(balance);
  late final String _totalExpense = AppFormattrers.formatCurrency(totalExpense);
  late final bool isPositive = balance >= 0;
  late final IconData trendIcon =
    isPositive ? Icons.trending_up_outlined : Icons.trending_down_outlined;
   BalanceSummaryCard({
    super.key,
    required this.balance,
    required this.totalExpense,
  });
  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color color = isPositive ? Colors.green : scheme.error;
    return Card(
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance :',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Total Expense :',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              spacing: 20,
              children: [
                Row(
                  children: [
                    Icon(trendIcon,color: color,size: 20,),
                    Text('\t$_balance',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),),
                  ],
                ),
                Text('\t$_totalExpense',style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: scheme.error,
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
