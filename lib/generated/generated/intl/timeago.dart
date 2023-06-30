import 'package:intl/intl.dart';

String formatTimeAgo(String timestamp) {
  final DateTime? dateTime = DateTime.tryParse(timestamp);
  if (dateTime == null) {
    return '';
  }
  final DateTime now = DateTime.now();

  final int daysDifference = now.difference(dateTime).inDays;
  final int monthsDifference =
      now.month - dateTime.month + (now.year - dateTime.year) * 12;

  if (daysDifference < 30) {
    return '$daysDifference days ago';
  } else if (monthsDifference < 12) {
    return '$monthsDifference months ago';
  } else {
    return DateFormat.yMMMd().format(dateTime);
  }
}
