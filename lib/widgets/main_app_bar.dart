import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
  });
  final DateTime selectedMonth;
  final Function(DateTime) onMonthChanged;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    String monthName(int month){
      const months =['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return months[month-1];
    }

    return AppBar(
      title: Text('Daily Hishab',style: TextStyle(
        fontWeight: FontWeight.w700
      ),),
      actions: [
        TextButton.icon(
          onPressed: () async {
            final picked = await showMonthPicker(
              context: context,

              initialDate: selectedMonth,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              onMonthChanged(picked);
            }
          },
          icon: Icon(Icons.keyboard_arrow_down_outlined,color: scheme.onTertiary,),
          label: Text('${monthName(selectedMonth.month)} ${selectedMonth.year}',style: TextStyle(
            color: scheme.onTertiary
          ),),
        ),
      ],
    );
  }


}
