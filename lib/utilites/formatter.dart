import 'package:intl/intl.dart';

class PeachFormatter {
  static String formatPrice(double price) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return 'Ksh ${formatter.format(price.toInt())}';
  }

  static String formatMileage(int km) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return '${formatter.format(km)} km';
  }

  static String formatEngineCC(int cc) => '${cc}cc';

  static String formatDate(DateTime dt) {
    return DateFormat('dd MMM yyyy').format(dt);
  }

  static String formatDateTime(DateTime dt) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dt);
  }

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 30) return DateFormat('dd MMM yyyy').format(dt);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
