import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/library_entries.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/storage_helper.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/cover_image.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../download/presentation/download_provider.dart';
import '../../history/presentation/history_provider.dart';
import '../../manga/data/mappers/manga_mapper.dart';
import 'library_actions.dart';
import 'library_provider.dart';

/// Perpustakaan KuroYomi: pill tab + storage + sort/view + kartu progres.
/// `lib/features/library/presentation/library_screen.dart`.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _sortByTitle = false;
  bool _grid = true;

  static const _tabs = [
    LibraryList.reading,
    LibraryList.favorite,
    LibraryList.completed,
    LibraryList.plan,
  ];

  void _refresh() {
    for (final t in LibraryList.all) {
      ref.invalidate(libraryTabProvider(t));
    }
    ref.invalidate(libraryProgressProvider);
    ref.invalidate(downloadsStreamProvider);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pustaka diperbarui')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length + 1,
      child: Scaffold(
        appBar: AppBar(
          title: const AppLogo(),
          actions: [
            IconButton(
              tooltip: 'Unduhan offline',
              icon: const Icon(Icons.download_done_outlined),
              onPressed: () => context.push('/downloads'),
            ),
          ],
        ),
        body: Column(
          children: [
            _PillTabs(tabs: _tabs),
            _StorageCard(),
            _Toolbar(
              sortByTitle: _sortByTitle,
              grid: _grid,
              onSort: () =>
                  setState(() => _sortByTitle = !_sortByTitle),
              onView: () => setState(() => _grid = !_grid),
            ),
            const _HintPill(),
            Expanded(
              child: TabBarView(
                children: [
                  for (final t in _tabs)
                    _LibraryTab(
                      listType: t,
                      sortByTitle: _sortByTitle,
                      grid: _grid,
                    ),
                  const _DownloadsTab(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(Icons.autorenew),
          label: const Text('Perbarui Semua'),
          onPressed: _refresh,
        ),
      ),
    );
  }
}

/// Pill tab tersegmentasi + jumlah isi.
class _PillTabs extends ConsumerWidget {
  const _PillTabs({required this.tabs});
  final List<String> tabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final ctrl = DefaultTabController.of(context);
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: tabs.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isDl = i == tabs.length;
          final type = isDl ? '' : tabs[i];
          final count = isDl
              ? ref.watch(downloadsStreamProvider).value?.length ?? 0
              : ref.watch(libraryTabProvider(type)).value?.length ?? 0;
          final label = isDl ? 'Offline' : LibraryList.label(type);
          return AnimatedBuilder(
            animation: ctrl,
            builder: (_, _) {
              final selected = ctrl.index == i;
              return ActionChip(
                avatar: isDl
                    ? const Icon(Icons.offline_pin_outlined, size: 16)
                    : (type == LibraryList.favorite && selected
                        ? const Icon(Icons.favorite, size: 16)
                        : null),
                label: Text('$label • $count'),
                backgroundColor:
                    selected ? scheme.primary : scheme.surfaceContainerHigh,
                labelStyle: TextStyle(
                  color: selected
                      ? scheme.onPrimary
                      : scheme.onSurfaceVariant,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                ),
                onPressed: () => ctrl.animateTo(i),
              );
            },
          );
        },
      ),
    );
  }
}

/// Kartu telemetri penyimpanan offline.
class _StorageCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final total = ref.watch(totalDownloadBytesProvider).value ?? 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.sd_storage_outlined,
                      size: 18,
                      color: scheme.secondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PENYIMPANAN OFFLINE',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        Text(
                          StorageHelper.formatBytes(total),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.chevron_right, size: 16),
                    label: const Text('Kelola'),
                    onPressed: () => context.push('/downloads'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: total <= 0 ? 0 : 0.08,
                minHeight: 6,
                borderRadius: BorderRadius.circular(999),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.sortByTitle,
    required this.grid,
    required this.onSort,
    required this.onView,
  });
  final bool sortByTitle;
  final bool grid;
  final VoidCallback onSort;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          FilledButton.tonalIcon(
            icon: const Icon(Icons.sort, size: 16),
            label: Text(sortByTitle ? 'Judul A-Z' : 'Terakhir Dibaca'),
            onPressed: onSort,
          ),
          const Spacer(),
          IconButton(
            tooltip: grid ? 'Mode daftar' : 'Mode grid',
            icon: Icon(grid ? Icons.view_list_outlined : Icons.view_module_outlined),
            onPressed: onView,
          ),
        ],
      ),
    );
  }
}

class _HintPill extends StatelessWidget {
  const _HintPill();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.touch_app_outlined,
                size: 14, color: scheme.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Tahan lama cover untuk aksi cepat atau pindah rak.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryTab extends ConsumerWidget {
  const _LibraryTab({
    required this.listType,
    required this.sortByTitle,
    required this.grid,
  });
  final String listType;
  final bool sortByTitle;
  final bool grid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(libraryTabProvider(listType));
    return switch (async) {
      AsyncData(:final value) when value.isEmpty => EmptyView(
          icon: Icons.library_books_outlined,
          title: _emptyTitle(),
          subtitle: _emptySubtitle(),
        ),
      AsyncData(:final value) => _content(context, ref, _sorted(value)),
      AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(libraryTabProvider(listType)),
        ),
      _ => const SkeletonCoverGrid(),
    };
  }

  List<LibraryWithManga> _sorted(List<LibraryWithManga> list) {
    if (!sortByTitle) return list;
    final sorted = [...list]
      ..sort((a, b) => a.manga.title.compareTo(b.manga.title));
    return sorted;
  }

  Widget _content(
    BuildContext context,
    WidgetRef ref,
    List<LibraryWithManga> items,
  ) {
    // Riwayat terakhir per judul (untuk label "Terakhir baca").
    final history = ref.watch(historyStreamProvider).value ?? const [];
    final lastRead = <String, HistoryWithData>{};
    for (final h in history) {
      lastRead.putIfAbsent(h.manga.id, () => h);
    }
    if (grid) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.62,
        ),
        itemCount: items.length,
        itemBuilder: (_, i) => _LibraryCard(
          entry: items[i],
          lastRead: lastRead[items[i].entry.mangaId],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _LibraryRow(
        entry: items[i],
        lastRead: lastRead[items[i].entry.mangaId],
      ),
    );
  }

  String _emptyTitle() => switch (listType) {
        LibraryList.reading => 'Belum ada bacaan',
        LibraryList.favorite => 'Belum ada manhwa favorit',
        LibraryList.completed => 'Belum ada yang selesai',
        _ => 'Belum ada rencana baca',
      };

  String? _emptySubtitle() => switch (listType) {
        LibraryList.reading => 'Mulai baca chapter, otomatis masuk sini.',
        LibraryList.favorite => 'Ketuk ikon hati di halaman detail.',
        LibraryList.completed => 'Tandai judul yang sudah tamat dibaca.',
        _ => 'Simpan judul yang ingin dibaca nanti.',
      };
}

/// Kartu grid: cover + badge unread + ikon offline + progres.
class _LibraryCard extends ConsumerWidget {
  const _LibraryCard({required this.entry, this.lastRead});
  final LibraryWithManga entry;
  final HistoryWithData? lastRead;

  /// "Terakhir Ch. X • Hal. p/q" bila ada, else "Ch. read/total".
  String _progressLabel(int total, int read) {
    final lr = lastRead;
    if (lr != null) {
      final c = lr.chapter;
      final no = (c.chapterNo == null || c.chapterNo!.isEmpty)
          ? 'Oneshot'
          : 'Ch. ${c.chapterNo}';
      final pages =
          c.pages > 0 ? ' • Hal. ${lr.history.page + 1}/${c.pages}' : '';
      return 'Terakhir $no$pages';
    }
    return total > 0 ? 'Ch. $read / $total' : 'Belum ada cache';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final manga = mangaRowToEntity(entry.manga);
    final prog = ref.watch(libraryProgressProvider).value?[entry.manga.id];
    final total = prog?.total ?? 0;
    final read = prog?.read ?? 0;
    final unread = (total - read).clamp(0, 1 << 30);
    final pct = total <= 0 ? 0.0 : read / total;
    final offline = (ref.watch(downloadsStreamProvider).value ?? const [])
        .any((d) => d.manga.id == entry.manga.id);

    return Dismissible(
      key: ValueKey(entry.entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: scheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) async {
        await ref
            .read(databaseProvider)
            .removeFromLibrary(entry.entry.mangaId, entry.entry.listType);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Dihapus dari ${LibraryList.label(entry.entry.listType)}',
              ),
            ),
          );
        }
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/manga/${entry.manga.id}'),
        onLongPress: () => showMangaQuickActions(context, ref, manga),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CoverImage(url: manga.coverUrl, borderRadius: 16),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  if (unread > 0 && total > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '+$unread',
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (offline)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.download_done,
                          size: 14,
                          color: scheme.secondary,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            manga.statusLabel(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (entry.entry.lastOpened != null &&
                            entry.entry.listType == LibraryList.reading)
                          Text(
                            DateFormatter.relative(entry.entry.lastOpened!),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
              child: Text(
                manga.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _progressLabel(total, read),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Text(
                    '${(pct * 100).round()}%',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Baris mode daftar: thumb + progres.
class _LibraryRow extends ConsumerWidget {
  const _LibraryRow({required this.entry, this.lastRead});
  final LibraryWithManga entry;
  final HistoryWithData? lastRead;

  String _rowLabel(int total, int read) {
    final lr = lastRead;
    if (lr != null) {
      final c = lr.chapter;
      final no = (c.chapterNo == null || c.chapterNo!.isEmpty)
          ? 'Oneshot'
          : 'Ch. ${c.chapterNo}';
      final pages =
          c.pages > 0 ? ' • Hal. ${lr.history.page + 1}/${c.pages}' : '';
      return 'Terakhir $no$pages';
    }
    return total > 0 ? 'Ch. $read / $total' : 'Belum ada cache';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final manga = mangaRowToEntity(entry.manga);
    final prog = ref.watch(libraryProgressProvider).value?[entry.manga.id];
    final total = prog?.total ?? 0;
    final read = prog?.read ?? 0;
    final pct = total <= 0 ? 0.0 : read / total;
    return Dismissible(
      key: ValueKey(entry.entry.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: scheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => ref
          .read(databaseProvider)
          .removeFromLibrary(entry.entry.mangaId, entry.entry.listType),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/manga/${entry.manga.id}'),
        onLongPress: () => showMangaQuickActions(context, ref, manga),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: manga.coverUrl == null
                    ? Container(
                        width: 48,
                        height: 72,
                        color: scheme.surfaceContainerHighest,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 20,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: manga.coverUrl!,
                        width: 48,
                        height: 72,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Container(
                          width: 48,
                          height: 72,
                          color: scheme.surfaceContainerHighest,
                          child: const Icon(Icons.broken_image_outlined,
                              size: 20),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manga.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _rowLabel(total, read),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: pct,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('${(pct * 100).round()}%'),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tab unduhan ringkas.
class _DownloadsTab extends ConsumerWidget {
  const _DownloadsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(downloadsStreamProvider).value ?? const [];
    final total = ref.watch(totalDownloadBytesProvider).value ?? 0;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.offline_pin_outlined, size: 40),
                const SizedBox(height: 8),
                Text(
                  '${list.length} chapter • ${StorageHelper.formatBytes(total)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.folder_open_outlined),
                  label: const Text('Kelola Unduhan'),
                  onPressed: () => context.push('/downloads'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
