import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'liquid_glass.dart';

/// Apple-style Loading Screen, Launch Overlay, dan Loading Indicators.
/// Dirancang sesuai Apple Human Interface Guidelines (HIG):
/// - Tampilan halus (*smooth transitions*), tanpa kedipan/pop kasar.
/// - Desain minimalis dan elegan dengan squircle monogram & hairline highlight.
/// - Indikator segmented spinner khas iOS (`CupertinoActivityIndicator`).
/// - Mendukung tema Terang (Apple System Grouped) dan Gelap (Apple OLED-friendly).
/// `lib/core/widgets/apple_loading.dart`.

/// Overlay peluncuran aplikasi bergaya Apple.
/// Menampilkan splash screen dengan animasi spring & fade yang halus,
/// lalu memudarkan dirinya secara mulus (*crossfade*) saat aplikasi siap.
class AppleLaunchOverlay extends StatefulWidget {
  const AppleLaunchOverlay({
    super.key,
    required this.child,
    this.displayDuration = const Duration(milliseconds: 1100),
    this.fadeDuration = const Duration(milliseconds: 350),
  });

  final Widget child;
  final Duration displayDuration;
  final Duration fadeDuration;

  @override
  State<AppleLaunchOverlay> createState() => _AppleLaunchOverlayState();
}

class _AppleLaunchOverlayState extends State<AppleLaunchOverlay> {
  bool _visible = true;
  bool _removed = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.displayDuration, () {
      if (!mounted) return;
      setState(() => _visible = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (!_removed)
          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: widget.fadeDuration,
            curve: Curves.easeInOutCubic,
            onEnd: () {
              if (!_visible && mounted) {
                setState(() => _removed = true);
              }
            },
            child: const IgnorePointer(
              ignoring: false,
              child: AppleSplashScreen(),
            ),
          ),
      ],
    );
  }
}

/// Layar Splash / Launch screen mandiri bergaya Apple.
class AppleSplashScreen extends StatefulWidget {
  const AppleSplashScreen({super.key});

  @override
  State<AppleSplashScreen> createState() => _AppleSplashScreenState();
}

class _AppleSplashScreenState extends State<AppleSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F131C) : const Color(0xFFF4F6F9);

    return Material(
      color: bg,
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Apple squircle emblem card dengan spring scale
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0071E3), // Apple System Blue
                        Color(0xFF0056B3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0071E3).withValues(
                          alpha: isDark ? 0.45 : 0.25,
                        ),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 46,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Judul aplikasi
              Text(
                'Baca Manhwa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  color: isDark ? Colors.white : const Color(0xFF1D1D1F),
                ),
              ),
              const SizedBox(height: 6),
              // Subtitle elegan
              Text(
                'Koleksi & Bacaan Pribadi',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : const Color(0xFF86868B),
                ),
              ),
              const Spacer(flex: 2),
              // Apple Cupertino Activity Indicator
              CupertinoActivityIndicator(
                radius: 12,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.7)
                    : const Color(0xFF86868B),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

/// Loading state untuk konten di dalam halaman (misal Detail, Reader, Search).
/// Menggunakan segmented spinner khas iOS yang halus dengan opsi pesan teks.
class AppleLoadingView extends StatelessWidget {
  const AppleLoadingView({
    super.key,
    this.message,
    this.indicatorRadius = 13.0,
    this.useGlassCard = false,
  });

  final String? message;
  final double indicatorRadius;
  final bool useGlassCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0xFF86868B);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoActivityIndicator(
          radius: indicatorRadius,
          color: isDark
              ? Colors.white.withValues(alpha: 0.75)
              : const Color(0xFF86868B),
        ),
        if (message != null) ...[
          const SizedBox(height: 12),
          Text(
            message!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              color: textColor,
            ),
          ),
        ],
      ],
    );

    if (useGlassCard) {
      return Center(
        child: LiquidGlassContainer(
          borderRadius: BorderRadius.circular(20),
          blur: 16,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: content,
        ),
      );
    }

    return Center(child: content);
  }
}

/// Indikator loading kecil segmented untuk tombol / widget kompak.
class AppleLoadingIndicator extends StatelessWidget {
  const AppleLoadingIndicator({
    super.key,
    this.radius = 10.0,
    this.color,
  });

  final double radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: radius,
      color: color,
    );
  }
}
