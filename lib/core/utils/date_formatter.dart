import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Format tanggal Indonesia — `lib/core/utils/date_formatter.dart`.
class DateFormatter {
  DateFormatter._();

  static String full(DateTime d) =>
      DateFormat('d MMMM yyyy', AppConstants.locale).format(d);

  static String short(DateTime d) =>
      DateFormat('d MMM yyyy', AppConstants.locale).format(d);

  /// "baru saja" / "5 mnt lalu" / "3 jam lalu" / tanggal singkat.
  static String relative(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mnt lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return short(d);
  }
}
