import 'package:intl/intl.dart';

class DateUtils {
  /// تحويل التاريخ من DateTime إلى 'd MMMM yyyy'
  static String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy').format(date);
  }
}
