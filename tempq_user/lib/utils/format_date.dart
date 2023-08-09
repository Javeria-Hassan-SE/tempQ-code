import 'package:intl/intl.dart';

class FormatDate{

  static String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    // Format the date
    String formattedDate = DateFormat('d MMMM, y').format(dateTime);
    // Format the time
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    // Get the day with proper suffix (e.g., 1st, 2nd, 3rd, 4th, etc.)
    String dayWithSuffix = DateFormat('d').format(dateTime);
    String suffix = _getDaySuffix(int.parse(dayWithSuffix));

    return ' $formattedDate at $formattedTime';
  }

  static String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }


}