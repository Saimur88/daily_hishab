import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/transaction_provider.dart';

class BalanceSummaryCard extends StatelessWidget {
  final double balance; final double totalExpense;
    const BalanceSummaryCard({
      super.key,
      required this.balance,
      required this.totalExpense,
    });

    @override
    Widget build(BuildContext context) {

      return Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Balance :",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(balance.toStringAsFixed(2)),
                  Text("BDT"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Expense :",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    totalExpense.toStringAsFixed(2),
                  ),
                  Text("BDT"),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
