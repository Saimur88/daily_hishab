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
    return SegmentedButton<DashboardMode>(
      segments: const [
        ButtonSegment(value: DashboardMode.spending, label: Text('Spending')),
        ButtonSegment(value: DashboardMode.earnings, label: Text('Earnings')),
      ],
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      side: const WidgetStatePropertyAll(
        BorderSide(
          color: Colors.transparent
        )
      ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 18,vertical: 12)

      ),
        backgroundColor: WidgetStateColor.resolveWith(
            (state){
              final selected = state.contains(WidgetState.selected);
              return selected ? scheme.primaryContainer : scheme.surfaceContainerHighest.withValues(alpha: 0.35);
            }
        ),
        foregroundColor: WidgetStateColor.resolveWith(
            (state) {
              final selected = state.contains(WidgetState.selected);
              return selected ? scheme.onPrimaryContainer : scheme.onSurface;
            }
        ),
        textStyle: WidgetStateProperty.resolveWith((state){
          final selected = state.contains(WidgetState.selected);
          return Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500
          );
        }

        ),
        elevation: WidgetStatePropertyAll(0),
        overlayColor: WidgetStatePropertyAll(
          scheme.primary.withValues(alpha: 0.08)
        )

      ),
      selected: {value},
      onSelectionChanged: (set) => onChanged(set.first),
      showSelectedIcon: false,
    );
  }
}