import 'package:flutter/material.dart';

import '../network/dio_client.dart';

/// Tampilan error informatif + tombol retry.
/// `lib/core/widgets/error_view.dart`.
class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.error,
    required this.onRetry,
    this.compact = false,
  });

  final Object error;
  final VoidCallback onRetry;
  final bool compact;

  bool get _offline =>
      error is MangaDexException && (error as MangaDexException).isOffline;

  @override
  Widget build(BuildContext context) {
    final title = _offline ? 'Tidak ada koneksi' : 'Gagal memuat data';
    final subtitle = _offline
        ? 'Periksa koneksi internet, lalu coba lagi.'
        : error.toString();
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _offline ? Icons.wifi_off_outlined : Icons.error_outline,
          size: compact ? 36 : 56,
          color: Theme.of(context).colorScheme.outline,
        ),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.tonal(
          onPressed: onRetry,
          child: const Text('Coba Lagi'),
        ),
      ],
    );
    if (compact) return Padding(padding: const EdgeInsets.all(24), child: body);
    return Center(
      child: SingleChildScrollView(child: body),
    );
  }
}
