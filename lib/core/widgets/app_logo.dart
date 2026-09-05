import 'package:flutter/material.dart';

/// Logo aplikasi: kotak biru + ikon buku putih + nama.
/// `lib/core/widgets/app_logo.dart`.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.showName = true, this.size = 32});
  final bool showName;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: scheme.brightness == Brightness.light
                ? Colors.white
                : scheme.primary,
            borderRadius: BorderRadius.circular(size * 0.28),
          ),
          child: Icon(
            Icons.menu_book_rounded,
            size: size * 0.62,
            color: scheme.brightness == Brightness.light
                ? scheme.primary
                : scheme.onPrimary,
          ),
        ),
        if (showName) ...[
          const SizedBox(width: 8),
          const Text(
            'Baca Manhwa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}
