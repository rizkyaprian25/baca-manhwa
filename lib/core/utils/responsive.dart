import 'package:flutter/widgets.dart';

/// Jumlah kolom grid cover yang adaptif terhadap lebar layar.
/// HP kecil: 2 • HP normal: 2-3 • tablet/landscape: 4-6.
/// `lib/core/utils/responsive.dart`.
int coverColumns(
  BuildContext context, {
  double maxItemWidth = 170,
  int maxCount = 6,
}) {
  final w = MediaQuery.widthOf(context);
  return (w / maxItemWidth).floor().clamp(2, maxCount);
}

/// Lebar layar tergolong lebar (tablet/landscape) — untuk penyesuaian.
bool isWideScreen(BuildContext context) =>
    MediaQuery.widthOf(context) >= 600;
