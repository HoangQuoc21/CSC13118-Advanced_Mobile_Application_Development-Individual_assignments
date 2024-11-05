import 'package:intl/intl.dart';

// Date and time format
final dateFormat = DateFormat('dd/MM/yyyy');
final timeFormat = DateFormat('HH:mm'); // 24-hour format

String formatDate(DateTime date) {
  return dateFormat.format(date);
}

String formatTime(DateTime date) {
  return timeFormat.format(date);
}
