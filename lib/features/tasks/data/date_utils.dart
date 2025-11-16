import 'package:intl/intl.dart';

class DateUtils {
  /// تحويل التاريخ من 'dd/MM/yyyy' إلى 'd MMMM yyyy'
  static String formatDate(String dateString) {
    final parts = dateString.split('/'); // ['30', '12', '2022']
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    final date = DateTime(year, month, day);

    return DateFormat('d MMMM yyyy').format(date); // 30 December2022
  }
}
