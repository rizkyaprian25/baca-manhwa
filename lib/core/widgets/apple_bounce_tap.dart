import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Widget pembungkus mikro-interaksi sentuhan Apple Bounce (iOS HIG).
/// Memberikan efek pegas (scale 0.96) saat ditekan dan haptic feedback ringan.
/// `lib/core/widgets/apple_bounce_tap.dart`.
class AppleBounceTap extends StatefulWidget {
  const AppleBounceTap({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.96,
    this.enableHaptic = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scaleDown;
  final bool enableHaptic;

  @override
  State<AppleBounceTap> createState() => _AppleBounceTapState();
}

class _AppleBounceTapState extends State<AppleBounceTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 220),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onTap == null) return;
    _controller.forward();
    if (widget.enableHaptic) {
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onTap == null) return;
    _controller.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    if (widget.onTap == null) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
