import 'package:flutter/material.dart';

enum DashboardMode { spending, earnings }

class SpendingEarningsSegmented extends StatelessWidget {
  const SpendingEarningsSegmented({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final DashboardMode value;
  final ValueChanged<DashboardMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(999);

    Widget segment({
      required DashboardMode mode,
      required String label,
    }) {
      final selected = value == mode;
      return Expanded(
        child: Material(
          color: selected ? scheme.primaryContainer : Colors.transparent,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onChanged(mode),
            splashColor: scheme.primary.withValues(alpha: 0.10),
            highlightColor: scheme.primary.withValues(alpha: 0.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 22),
              child: Center(
                child: Text(label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? scheme.onSurface : scheme.onSurface.withValues(alpha: 0.5),
                ),),
              ),
            ),
          ),
        ),
      );
    }

    return Material(
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
    );


  }
}
