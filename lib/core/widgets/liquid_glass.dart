import 'dart:ui';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Container dengan material Liquid Glass sesuai pedoman Apple HIG.
/// Memadukan BackdropFilter blur 24px, fill translusen adaptif,
/// hairline border, dan bayangan ambient halus.
/// `lib/core/widgets/liquid_glass.dart`.
class LiquidGlassContainer extends StatelessWidget {
  const LiquidGlassContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.margin,
    this.blur = 16.0,
    this.borderWidth = 0.8,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double blur;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final radius = borderRadius ?? BorderRadius.circular(24);

    // Warna fill & hairline border adaptif
    final fillColor = isDark ? AppColors.glassDarkFill : AppColors.glassLightFill;
    final borderColor = isDark ? AppColors.glassDarkBorder : AppColors.glassLightBorder;
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.35)
        : Colors.black.withValues(alpha: 0.06);

    Widget content = ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: radius,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
          ),
          child: child,
        ),
      ),
    );

    if (margin != null || shadowColor.a > 0) {
      content = Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: -4,
            ),
          ],
        ),
        child: content,
      );
    }

    return content;
  }
}

/// Bilah Navigasi Bawah Mengambang (Floating Liquid Glass Bottom Bar)
/// Dirancang spesifik mengikuti Apple Human Interface Guidelines (HIG):
/// - Material Liquid Glass tembus pandang di atas content layer
/// - 5 Destinasi (Beranda, Jelajah, Pustaka, Riwayat, Setelan)
/// - Ikon & label responsif dengan animasi transisi halus
/// - Memenuhi uji widget_test.dart
class AppleLiquidGlassBottomBar extends StatelessWidget {
  const AppleLiquidGlassBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<AppleNavDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return RepaintBoundary(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset > 0 ? bottomInset : 12),
        child: LiquidGlassContainer(
          borderRadius: BorderRadius.circular(32),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          blur: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(destinations.length, (index) {
              final dest = destinations[index];
              final isSelected = selectedIndex == index;
              return Expanded(
                child: _NavItem(
                  destination: dest,
                  isSelected: isSelected,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class AppleNavDestination {
  const AppleNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final Widget icon;
  final Widget selectedIcon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
  });

  final AppleNavDestination destination;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final unselectedColor = isDark
        ? const Color(0xFF8E8E93)
        : const Color(0xFF687076);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? primaryColor.withValues(alpha: 0.15)
                  : primaryColor.withValues(alpha: 0.10))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme(
              data: IconThemeData(
                color: isSelected ? primaryColor : unselectedColor,
                size: 23,
              ),
              child: isSelected ? destination.selectedIcon : destination.icon,
            ),
            const SizedBox(height: 3),
            Text(
              destination.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? primaryColor : unselectedColor,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
