import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/tables/downloads.dart';
import 'download_provider.dart';

/// Tombol unduh per chapter (dipakai di daftar chapter detail).
/// `lib/features/download/presentation/download_button.dart`.
class DownloadButton extends ConsumerWidget {
  const DownloadButton({
    super.key,
    required this.mangaId,
    required this.chapterId,
  });
  final String mangaId;
  final String chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      return const IconButton(
        tooltip: 'Unduhan hanya tersedia di Android',
        icon: Icon(Icons.download_outlined),
        onPressed: null,
      );
    }
    final dl = ref.watch(downloadOfProvider(chapterId)).value;
    final mgr = ref.read(downloadManagerProvider);

    if (dl == null) {
      return IconButton(
        tooltip: 'Unduh untuk offline',
        icon: const Icon(Icons.download_outlined),
        onPressed: () {
          mgr.enqueue(mangaId, chapterId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ditambahkan ke antrean unduhan')),
          );
        },
      );
    }
    switch (dl.status) {
      case DownloadStatus.done:
        return IconButton(
          tooltip: 'Tersimpan offline',
          icon: const Icon(Icons.download_done, color: Colors.green),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Chapter sudah tersimpan, bisa dibaca offline'),
            ),
          ),
        );
      case DownloadStatus.failed:
        return IconButton(
          tooltip: 'Unduhan gagal — ketuk untuk ulangi',
          icon: const Icon(Icons.error_outline, color: Colors.red),
          onPressed: () {
            mgr.retry(chapterId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mengulang unduhan')),
            );
          },
        );
      default:
        final total = dl.totalPages;
        final v = total > 0 ? dl.donePages / total : null;
        return Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(strokeWidth: 2, value: v),
          ),
        );
    }
  }
}
