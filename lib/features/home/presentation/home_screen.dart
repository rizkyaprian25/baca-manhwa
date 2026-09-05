import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/number_formatter.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/cover_image.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/skeleton.dart';
import '../../history/presentation/history_provider.dart';
import '../../library/presentation/library_actions.dart';
import '../../library/presentation/library_provider.dart';
import '../../manga/domain/entities/manga.dart';
import '../../manga/providers/manga_providers.dart';
import '../../settings/presentation/settings_provider.dart';
import '../../search/presentation/search_provider.dart';
import '../../../core/database/tables/library_entries.dart';

/// Beranda setia panduan KuroYomi: search + pill genre + spotlight +
/// lanjut baca + grid update + status. Fitur tetap semua.
/// `lib/features/home/presentation/home_screen.dart`.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  int _popularIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(updatesProvider.notifier).loadInitial();
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 600) {
      ref.read(updatesProvider.notifier).loadMore();
    }
  }

  Future<void> _refresh() async {
    ref
      ..invalidate(trendingProvider)
      ..invalidate(historyStreamProvider);
    await ref.read(updatesProvider.notifier).loadInitial();
  }

  void _submitSearch(String v) {
    final q = v.trim();
    if (q.isEmpty) {
      context.push('/search');
    } else {
      context.push('/search?q=${Uri.encodeComponent(q)}');
    }
  }

  void _pickGenre(String? tagId) {
    final notifier = ref.read(searchFilterProvider.notifier);
    notifier.clearTags();
    if (tagId != null) notifier.toggleTag(tagId);
    context.push('/search');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const AppLogo(),
        actions: [
          Stack(
            children: [
              IconButton(
                tooltip: 'Unduhan offline',
                icon: const Icon(Icons.download_done_outlined),
                onPressed: () => context.push('/downloads'),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: scheme.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            tooltip: 'Setelan',
            icon: const Icon(Icons.tune_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollCtrl,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: InputDecoration(
                          hintText: 'Cari judul, genre, atau author...',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: scheme.surfaceContainerHigh,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: _submitSearch,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(48, 48),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.push('/search'),
                      child: const Icon(Icons.tune),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(child: _GenrePills(onPick: _pickGenre)),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(
              child: _Spotlight(
                index: _popularIndex,
                onPage: (i) => setState(() => _popularIndex = i),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _ContinueReading()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: _LatestGrid()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            const SliverToBoxAdapter(child: _ApiStatus()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

/// Pil genre single-select ala panduan.
class _GenrePills extends ConsumerWidget {
  const _GenrePills({required this.onPick});
  final ValueChanged<String?> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagsProvider).value?.take(7).toList() ??
        const [];
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tags.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          if (i == 0) {
            return ActionChip(
              label: const Text('Semua'),
              backgroundColor: scheme.primaryContainer,
              labelStyle: TextStyle(
                color: scheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              onPressed: () => onPick(null),
            );
          }
          final t = tags[i - 1];
          return ActionChip(
            label: Text(t.name),
            onPressed: () => onPick(t.id),
          );
        },
      ),
    );
  }
}

/// Spotlight hero: trending #1 + gradien + rating + CTA + bookmark.
class _Spotlight extends ConsumerWidget {
  const _Spotlight({required this.index, required this.onPage});
  final int index;
  final ValueChanged<int> onPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(trendingProvider);
    final scheme = Theme.of(context).colorScheme;
    return switch (async) {
      AsyncData(:final value) when value.isEmpty => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Belum ada data.'),
        ),
      AsyncData(:final value) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: PageView.builder(
                    onPageChanged: onPage,
                    itemCount: value.length.clamp(0, 5),
                    itemBuilder: (_, i) =>
                        _SpotlightCard(manga: value[i]),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var d = 0;
                      d < value.length.clamp(0, 5);
                      d++)
                    Container(
                      width: d == index % 5 ? 20 : 6,
                      height: 6,
                      margin:
                          const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: d == index % 5
                            ? scheme.primary
                            : scheme.outline.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      AsyncError(:final error) => ErrorView(
          compact: true,
          error: error,
          onRetry: () => ref.invalidate(trendingProvider),
        ),
      _ => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SkeletonCoverRow(),
        ),
    };
  }
}

class _SpotlightCard extends ConsumerWidget {
  const _SpotlightCard({required this.manga});
  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final fav = ref
            .watch(libraryTabProvider(LibraryList.favorite))
            .value
            ?.any((e) => e.manga.id == manga.id) ??
        false;
    final score = manga.rating != null
        ? manga.rating!.toStringAsFixed(1)
        : (manga.followedCount != null
            ? formatCompactId(manga.followedCount!)
            : null);
    return InkWell(
      onTap: () => context.push('/manga/${manga.id}'),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CoverImage(
            url: manga.coverUrl,
            aspectRatio: 16 / 10,
            borderRadius: 0,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                  Colors.black.withValues(alpha: 0.92),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color:
                            scheme.primary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'SPOTLIGHT #1',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const Spacer(),
                    if (score != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              score,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  manga.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (manga.tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      manga.tags.take(3).map((t) => t.name).join(' • '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white70),
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.menu_book),
                        label: Text(
                          manga.latestChapter != null
                              ? 'Mulai Baca Ch. ${manga.latestChapter}'
                              : 'Mulai Baca',
                        ),
                        onPressed: () =>
                            context.push('/manga/${manga.id}'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'Favorit',
                      icon: Icon(
                        fav ? Icons.bookmark : Icons.bookmark_add_outlined,
                      ),
                      onPressed: () => ref
                          .read(libraryActionsProvider)
                          .toggle(context, manga, LibraryList.favorite),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lanjut Baca: kartu progres guide (cover + Bab/Hal + bar + play).
class _ContinueReading extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyStreamProvider).value;
    final items =
        history == null ? const [] : groupHistoryByManga(history);
    if (items.isEmpty) return const SizedBox.shrink();
    final h = items.first;
    final c = h.chapter;
    final total = c.pages <= 0 ? 1 : c.pages;
    final pct =
        (h.history.page / (total - 1).clamp(1, 1 << 30)).clamp(0.0, 1.0);
    final num = (c.chapterNo == null || c.chapterNo!.isEmpty)
        ? 'Oneshot'
        : 'Bab ${c.chapterNo}';
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.history_toggle_off, color: scheme.secondary),
              const SizedBox(width: 8),
              Text(
                'Lanjut Baca',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.push('/history'),
                child: const Text('Semua Riwayat'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: h.manga.coverUrl == null
                        ? Container(
                            width: 56,
                            height: 80,
                            color: scheme.surfaceContainerHighest,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: h.manga.coverUrl!,
                            width: 56,
                            height: 80,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Container(
                              width: 56,
                              height: 80,
                              color: scheme.surfaceContainerHighest,
                              child: const Icon(
                                Icons.broken_image_outlined,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            h.manga.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '$num • Hal. ${h.history.page + 1} / $total',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: scheme.secondary),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Progress Baca',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                        Text(
                                          '${(pct * 100).round()}%',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: scheme.secondary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    LinearProgressIndicator(value: pct),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Lanjutkan',
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () =>
                        context.push('/reader/${h.history.chapterId}'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Update Terbaru: grid 2 kolom ala panduan (badge + Ch + waktu + unduh info).
class _LatestGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(updatesProvider);
    final scheme = Theme.of(context).colorScheme;
    final sourceName =
        ref.watch(sourceProvider) == 'komiku' ? 'Komiku' : 'MangaDex';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.bolt_outlined, color: scheme.primary),
              const SizedBox(width: 8),
              Text(
                'Update Terbaru',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: scheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(sourceName),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (st.loading)
            const SkeletonCoverRow()
          else if (st.error != null && st.items.isEmpty)
            ErrorView(
              compact: true,
              error: st.error!,
              onRetry: () =>
                  ref.read(updatesProvider.notifier).loadInitial(),
            )
          else if (st.items.isEmpty)
            const Text('Belum ada data.')
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              itemCount: st.items.length,
              itemBuilder: (_, i) => _UpdateCard(manga: st.items[i]),
            ),
          if (st.loadingMore)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (!st.hasMore && st.items.isNotEmpty && !st.loadingMore)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Semua update ditampilkan',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.sync),
            label: const Text('Muat Chapter Lainnya'),
            onPressed: () => context.push('/search'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UpdateCard extends ConsumerWidget {
  const _UpdateCard({required this.manga});
  final Manga manga;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final ago = manga.updateAgo ?? 'Baru diupdate';
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/manga/${manga.id}'),
      onLongPress: () => showMangaQuickActions(context, ref, manga),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CoverImage(url: manga.coverUrl),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                  if (manga.id.startsWith('k:'))
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.secondary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ID',
                          style: TextStyle(
                            color: scheme.onSecondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (manga.latestChapter != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Ch. ${manga.latestChapter}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Row(
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: 13,
                          color: scheme.secondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            ago,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: scheme.secondary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _statLine(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statLine() {
    if (manga.rating != null) {
      return '★ ${manga.rating!.toStringAsFixed(1)}';
    }
    if (manga.followedCount != null) {
      return '${formatCompactId(manga.followedCount!)} pembaca';
    }
    return manga.statusLabel();
  }
}

/// Indikator status koneksi API (ringkas).
class _ApiStatus extends ConsumerWidget {
  const _ApiStatus();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(updatesProvider);
    final online = st.error == null;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: online ? scheme.secondary : scheme.error, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            online ? 'Terhubung • Mode online' : 'Offline • Mode cache',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
