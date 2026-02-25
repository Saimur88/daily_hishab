import 'package:daily_hishab/core/formatters/formatters.dart';
import 'package:flutter/material.dart';

class ExpenseByCategoryCard extends StatelessWidget {
  const ExpenseByCategoryCard({super.key,required this.categoryMap});

  final Map<String, double> categoryMap;

  @override
  Widget build(BuildContext context) {
    return categoryMap.isEmpty
        ? Center(child: Text("No expenses yet.\nYour Categories will appear here",textAlign: TextAlign.center,))
        : Card(
      child: Column(
        children: categoryMap.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${entry.key} :",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                  ),
                ),
                Text(AppFormattrers.formatCurrency(entry.value),style: TextStyle(
                  fontSize: 15,
                ),),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
