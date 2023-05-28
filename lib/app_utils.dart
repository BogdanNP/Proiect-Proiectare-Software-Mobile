import 'package:intl/intl.dart';

abstract class AppUtils {
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }
    return DateFormat("dd-MM-yyyy-HH:mm:ss").format(dateTime.toUtc());
  }
}
