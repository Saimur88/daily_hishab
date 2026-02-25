import 'package:daily_hishab/core/formatters/formatters.dart';
import 'package:flutter/material.dart';

class BalanceSummaryCard extends StatelessWidget {
  final double balance;
  final double totalExpense;
  const BalanceSummaryCard({
    super.key,
    required this.balance,
    required this.totalExpense,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
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
              spacing: 20,
              children: [
                Text('\t${AppFormattrers.formatCurrency(balance)}',style: TextStyle(
                  fontSize: 15,
                ),),
                Text('\t${AppFormattrers.formatCurrency(totalExpense)}',style: TextStyle(
                  fontSize: 15,
                ),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
