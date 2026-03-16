import 'package:flutter/material.dart';

class TotalBalanceHeroCard extends StatelessWidget {
  const TotalBalanceHeroCard({
    super.key,
    required this.amountText,
    required this.isHidden,
    required this.onToggleHidden,
    this.backgroundColor,
  });

  final String amountText;
  final bool isHidden;
  final VoidCallback onToggleHidden;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 150,
      child: Card(
        color: backgroundColor ?? scheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
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
                      //color: scheme.surface,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    isHidden ? '••••' : amountText,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      //color: scheme.surface,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: onToggleHidden,
                icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
                //color: scheme.surface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}