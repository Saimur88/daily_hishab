import 'package:daily_hishab/core/formatters/formatters.dart';
import 'package:flutter/material.dart';

class TotalBalanceHeroCard extends StatefulWidget {
  const TotalBalanceHeroCard({
    super.key,
    required this.amount,
    this.backgroundColor,
  });

  final double amount;
  final Color? backgroundColor;

  @override
  State<TotalBalanceHeroCard> createState() => _TotalBalanceHeroCardState();
}

class _TotalBalanceHeroCardState extends State<TotalBalanceHeroCard> {
  bool isHidden = false;

  void _toggleHidden() => setState(() => isHidden = !isHidden);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final amountText = AppFormattrers.formatCurrency(widget.amount);

    return Card(
      color: widget.backgroundColor ?? scheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        child: Row(
          children: [
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total balance',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isHidden ? '••••' : amountText,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: _toggleHidden,
              icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}