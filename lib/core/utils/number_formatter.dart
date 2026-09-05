/// Format angka ringkas gaya Indonesia: 1.6jt, 502rb, 999.
/// `lib/core/utils/number_formatter.dart`.
String formatCompactId(int n) {
  if (n >= 1000000) return '${_one(n / 1000000)}jt';
  if (n >= 1000) return '${_one(n / 1000)}rb';
  return '$n';
}

String _one(double v) {
  final r = (v * 10).round() / 10;
  return r == r.roundToDouble() ? '${r.round()}' : '$r';
}
