import 'dart:math';

import 'package:flutter/material.dart';

import '../../../models/transaction.dart';
import '../domain/category_total.dart';
import '../domain/stats_model.dart';

class StatisticsProvider extends ChangeNotifier {
  StatsMode _mode = StatsMode.spending;
  StatsMode get mode => _mode;

  void setMode(StatsMode next) {
    if (next == _mode) return;
    _mode = next;
    notifyListeners();
  }

  List<CategoryTotal> totals({
    required List<TransactionModel> transactions,
    required ColorScheme scheme,
  }) {
    final map = <String, double>{};

    for (final t in transactions) {
      final include = switch (_mode) {
        StatsMode.spending => t.type == TransactionType.expense,
        StatsMode.earnings => t.type == TransactionType.income,
      };
      if (!include) continue;

      map.update(t.category, (v) => v + t.amount, ifAbsent: () => t.amount);
    }

    final entries = map.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return [
      for (final e in entries)
        CategoryTotal(
          category: e.key,
          amount: e.value,
          color: _colorForCategory(e.key, scheme),
        ),
    ];
  }

  double maxY(List<CategoryTotal> totals) {
    if (totals.isEmpty) return 100;
    final maxValue = totals.map((e) => e.amount).reduce(max);
    if (maxValue <= 0) return 100;

    final step = maxValue <= 200 ? 50.0 : 100.0;
    return (maxValue / step).ceil() * step;
  }

  Color _colorForCategory(String category, ColorScheme scheme) {
    // simple palette similar to your screenshot
    const palette = <Color>[
      Color(0xFFFF7A00), // orange
      Color(0xFFD65DB1), // pink/purple
      Color(0xFF00C853), // green
      Color(0xFFFFAB00), // amber
      Color(0xFF1A237E), // indigo
    ];
    return palette[category.hashCode.abs() % palette.length];
  }
}

class TransactionModel {
}