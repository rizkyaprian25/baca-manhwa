import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/downloads.dart';
import '../../../core/utils/storage_helper.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import 'download_provider.dart';

/// Manajemen unduhan: total size + hapus per chapter/judul.
/// `lib/features/download/presentation/downloads_screen.dart`.
class DownloadsScreen extends ConsumerWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(downloadsStreamProvider);
    final totalAsync = ref.watch(totalDownloadBytesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Unduhan')),
      body: switch (async) {
        AsyncData(:final value) when value.isEmpty => const EmptyView(
            icon: Icons.download_outlined,
            title: 'Belum ada unduhan',
            subtitle: 'Unduh chapter dari halaman detail untuk baca offline.',
          ),
        AsyncData(:final value) => _grouped(context, ref, value, totalAsync),
        AsyncError(:final error) => ErrorView(
            error: error,
            onRetry: () => ref.invalidate(downloadsStreamProvider),
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _grouped(
    BuildContext context,
    WidgetRef ref,
    List<DownloadWithData> all,
    AsyncValue<int> totalAsync,
  ) {
    final groups = <String, List<DownloadWithData>>{};
    for (final d in all) {
      groups.putIfAbsent(d.manga.id, () => []).add(d);
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.sd_storage_outlined),
            title: const Text('Total penyimpanan unduhan'),
            trailing: switch (totalAsync) {
              AsyncData(:final value) => Text(
                  StorageHelper.formatBytes(value),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              _ => const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            },
          ),
        ),
        const SizedBox(height: 8),
        for (final entry in groups.entries)
          _MangaGroup(
            mangaTitle: entry.value.first.manga.title,
            items: entry.value,
          ),
      ],
    );
  }
}

class _MangaGroup extends ConsumerWidget {
  const _MangaGroup({required this.mangaTitle, required this.items});
  final String mangaTitle;
  final List<DownloadWithData> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mgr = ref.read(downloadManagerProvider);
    final mangaId = items.first.manga.id;
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              mangaTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('${items.length} chapter'),
            trailing: IconButton(
              tooltip: 'Hapus semua chapter judul ini',
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirm(
                context,
                'Hapus ${items.length} unduhan "$mangaTitle"?',
                () => mgr.removeManga(mangaId),
              ),
            ),
          ),
          const Divider(height: 1),
          for (final d in items) _DownloadTile(item: d),
        ],
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context,
    String message,
    Future<void> Function() action,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus unduhan?'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true) await action();
  }
}

class _DownloadTile extends ConsumerWidget {
  const _DownloadTile({required this.item});
  final DownloadWithData item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mgr = ref.read(downloadManagerProvider);
    final dl = item.download;
    final c = item.chapter;
    final num = (c.chapterNo == null || c.chapterNo!.isEmpty)
        ? 'Oneshot'
        : 'Ch. ${c.chapterNo}';
    final label =
        (c.title == null || c.title!.isEmpty) ? num : '$num - ${c.title}';
    return ListTile(
      title: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: _statusLine(dl),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dl.status == DownloadStatus.failed)
            IconButton(
              tooltip: 'Ulangi',
              icon: const Icon(Icons.refresh),
              onPressed: () => mgr.retry(dl.chapterId),
            ),
          IconButton(
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => mgr.remove(dl.chapterId),
          ),
        ],
      ),
    );
  }

  Widget _statusLine(Download dl) {
    switch (dl.status) {
      case DownloadStatus.done:
        return Text(
          '${DownloadStatus.label(dl.status)} • ${dl.totalPages} hlm',
          style: const TextStyle(color: Colors.green),
        );
      case DownloadStatus.failed:
        return Text(
          DownloadStatus.label(dl.status),
          style: const TextStyle(color: Colors.red),
        );
      default:
        final v = dl.totalPages > 0 ? dl.donePages / dl.totalPages : null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DownloadStatus.label(dl.status)} ${dl.donePages}/${dl.totalPages}',
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: v),
          ],
        );
    }
  }
}
