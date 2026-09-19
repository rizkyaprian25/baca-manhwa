import 'dart:async';
import 'package:flutter/material.dart';

import 'apple_loading.dart';

/// Widget placeholder loading untuk gambar reader dengan deteksi buffering lambat
/// dan tombol interaktif "Segarkan Gambar".
/// `lib/core/widgets/reader_buffering_placeholder.dart`.
class ReaderBufferingPlaceholder extends StatefulWidget {
  const ReaderBufferingPlaceholder({
    super.key,
    required this.onRefresh,
    this.onTimeout,
    this.height = 320,
    this.backgroundColor,
    this.pageLabel,
    this.slowThreshold = const Duration(seconds: 5),
    this.timeoutThreshold = const Duration(seconds: 8),
  });

  /// Dipanggil saat pengguna menekan tombol "Segarkan Gambar".
  final VoidCallback onRefresh;

  /// Dipanggil otomatis jika buffering melampaui batas waktu (misal untuk fallback CDN).
  final VoidCallback? onTimeout;

  final double height;
  final Color? backgroundColor;
  final String? pageLabel;
  final Duration slowThreshold;
  final Duration timeoutThreshold;

  @override
  State<ReaderBufferingPlaceholder> createState() =>
      _ReaderBufferingPlaceholderState();
}

class _ReaderBufferingPlaceholderState
    extends State<ReaderBufferingPlaceholder> {
  bool _isSlow = false;
  Timer? _slowTimer;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _startTimers();
  }

  void _startTimers() {
    _slowTimer?.cancel();
    _timeoutTimer?.cancel();

    _slowTimer = Timer(widget.slowThreshold, () {
      if (mounted) {
        setState(() => _isSlow = true);
      }
    });

    _timeoutTimer = Timer(widget.timeoutThreshold, () {
      if (mounted) {
        widget.onTimeout?.call();
      }
    });
  }

  @override
  void dispose() {
    _slowTimer?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = widget.backgroundColor ??
        (isDark
            ? scheme.surfaceContainerLowest
            : scheme.surfaceContainerHighest.withValues(alpha: 0.3));

    return Container(
      height: widget.height,
      width: double.infinity,
      color: bg,
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: !_isSlow
              ? const AppleLoadingIndicator(radius: 12)
              : Padding(
                  key: const ValueKey('buffering_slow_view'),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppleLoadingIndicator(radius: 12),
                      const SizedBox(height: 12),
                      Text(
                        widget.pageLabel != null
                            ? '${widget.pageLabel}: Buffering agak lambat...'
                            : 'Buffering agak lambat...',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      FilledButton.tonalIcon(
                        onPressed: widget.onRefresh,
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: const Text('Segarkan Gambar'),
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
