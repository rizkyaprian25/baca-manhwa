import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/database_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/apple_loading.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import 'history_provider.dart';

/// Riwayat baca: 1 baris per judul (bacaan terakhir) + hapus per judul.
/// `lib/features/history/presentation/history_screen.dart`.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(groupedHistoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        actions: [
          IconButton(
            tooltip: 'Hapus semua',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: () => _confirmClear(context, ref),
          ),
        ],
      ),
      body: switch (async) {
        AsyncData(:final value) when value.isEmpty => const EmptyView(
            icon: Icons.history_outlined,
            title: 'Riwayat kosong',
            subtitle: 'Chapter yang kamu buka akan tercatat di sini.',
          ),
        AsyncData(:final value) => ListView.builder(
            padding: const EdgeInsets.only(bottom: 96),
            itemCount: value.length,
            itemBuilder: (_, i) {
              final h = value[i];
              final c = h.chapter;
              final num = (c.chapterNo == null || c.chapterNo!.isEmpty)
                  ? 'Oneshot'
                  : 'Ch. ${c.chapterNo}';
              final label = (c.title == null || c.title!.isEmpty)
                  ? num
                  : '$num - ${c.title}';
              return Dismissible(
                key: ValueKey(h.manga.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  color: Theme.of(context).colorScheme.error,
                  child:
                      const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await ref
                      .read(databaseProvider)
                      .deleteHistoryForManga(h.manga.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Riwayat "${h.manga.title}" dihapus'),
                      ),
                    );
                  }
                },
                child: ListTile(
                  leading: h.manga.coverUrl == null
                      ? const Icon(Icons.image_not_supported_outlined)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            imageUrl: h.manga.coverUrl!,
                            width: 44,
                            height: 66,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) =>
                                const Icon(Icons.broken_image_outlined),
                          ),
                        ),
                  title: Text(
                    h.manga.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '$label • ${DateFormatter.relative(h.history.readAt)}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      context.push('/reader/${h.history.chapterId}'),
                ),
              );
            },
          ),
        AsyncError(:final error) => ErrorView(
            error: error,
            onRetry: () => ref.invalidate(groupedHistoryProvider),
          ),
        _ => const AppleLoadingView(message: 'Memuat riwayat bacaan...'),
      },
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus semua riwayat?'),
        content: const Text('Tindakan ini tidak bisa dibatalkan.'),
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
    if (ok == true) {
      await ref.read(databaseProvider).clearHistory();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Riwayat dihapus')),
        );
      }
    }
  }
}
