import 'package:daily_hishab/core/formatters/formatters.dart';
import 'package:daily_hishab/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DashboardMode { spending, earnings }

class SpendingEarningsSegmented extends StatelessWidget {
  const SpendingEarningsSegmented({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DashboardMode value;
  final ValueChanged<DashboardMode> onChanged;
  DashboardMode get selectedMode => value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(999);
    TransactionProvider provider = context.watch<TransactionProvider>();

    Widget segment({required DashboardMode mode, required String label}) {
      final selected = value == mode;
      return Expanded(
        child: Material(
          color: selected ? scheme.primary : Colors.transparent,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onChanged(mode),
            splashColor: scheme.primary.withValues(alpha: 0.10),
            highlightColor: scheme.primary.withValues(alpha: 0.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 22,
              ),
              child: Center(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    color: selected
                        ? scheme.surface
                        : scheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.black26,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Row(
              children: [
                segment(mode: DashboardMode.spending, label: 'Spending'),
                const SizedBox(width: 6),
                segment(mode: DashboardMode.earnings, label: 'Earnings'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedMode == DashboardMode.spending
                    ? 'Total Expenditure'
                    : 'Total Earnings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              ),
              Text(
                selectedMode == DashboardMode.spending
                    ? AppFormattrers.formatCurrency(context.watch<TransactionProvider>().totalExpense)
                    : AppFormattrers.formatCurrency(context.watch<TransactionProvider>().totalIncome),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
