import 'package:intl/intl.dart';

class AppFormattrers{
  const AppFormattrers._();

  static final NumberFormat _currency =
  NumberFormat.simpleCurrency(locale: 'en_BD', name: '৳\t',decimalDigits: 2);

  static final DateFormat _date =
  DateFormat('dd MMM, yyyy');

  static final DateFormat _dateTime =
  DateFormat('dd MMM, yyyy • hh:mm a');

  static String formatCurrency(double amount) =>
      _currency.format(amount);

  static String formatDate(DateTime date) =>
      _date.format(date);
  static String formatDateTime(DateTime date) =>
      _dateTime.format(date);
  
}