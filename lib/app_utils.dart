import 'package:intl/intl.dart';

abstract class AppUtils {
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    }
    return DateFormat("dd-MM-yyyy-hh:mm:ss").format(dateTime);
  }
}
