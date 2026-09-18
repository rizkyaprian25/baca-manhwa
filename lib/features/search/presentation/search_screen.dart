import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/manga_grid_card.dart';
import '../../../core/widgets/skeleton.dart';
import '../../manga/providers/manga_providers.dart';
import '../../settings/presentation/settings_provider.dart';
import 'search_provider.dart';

/// Pencarian + filter + infinite scroll.
/// `lib/features/search/presentation/search_screen.dart`.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialQuery = ''});
  final String initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
    // Mode jelajah: tampilkan update terbaru, selalu mulai segar kecuali
    // dibuka dengan query awal (mis. dari Beranda).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(searchFilterProvider.notifier);
      if (widget.initialQuery.isNotEmpty) {
        _searchCtrl.text = widget.initialQuery;
        notifier.setTitle(widget.initialQuery);
      } else if (ref.read(searchFilterProvider).title.isNotEmpty) {
        _searchCtrl.clear();
        notifier.setTitle('');
        setState(() {});
      }
      ref.read(searchResultsProvider.notifier).search();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 400) {
      ref.read(searchResultsProvider.notifier).loadMore();
    }
  }

  void _onTitleChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(searchFilterProvider.notifier).setTitle(v.trim());
      ref.read(searchResultsProvider.notifier).search();
    });
  }

  void _research() => ref.read(searchResultsProvider.notifier).search();

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(searchFilterProvider);
    // Satu filter dipakai bersama (tab Jelajah + rute /search dari Beranda):
    // bila judul di provider berubah dari tempat lain (mis. layar Jelajah
    // lain me-reset), sinkronkan kotak teks agar tak "nempel" teks basi.
    // Aman di build: set programatik tak memicu onChanged, spasi akhir
    // saat mengetik diabaikan via trim.
    if (_searchCtrl.text.trim() != filter.title) {
      _searchCtrl.text = filter.title;
    }
    final results = ref.watch(searchResultsProvider);
    final filterCount = ref.watch(
      searchFilterProvider.select((f) => f.includedTags.length),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Jelajah')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Cari komik...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchCtrl.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchCtrl.clear();
                            ref
                                .read(searchFilterProvider.notifier)
                                .setTitle('');
                            _research();
                            setState(() {});
                          },
                        ),
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                ),
              textInputAction: TextInputAction.search,
              onChanged: (v) {
                setState(() {});
                _onTitleChanged(v);
              },
              onSubmitted: (_) {
                _debounce?.cancel();
                final q = _searchCtrl.text.trim();
                ref.read(searchFilterProvider.notifier).setTitle(q);
                if (q.isNotEmpty) {
                  ref.read(settingsActionsProvider).addRecentSearch(q);
                }
                _research();
              },
            ),
          ),
          _FilterBar(
            filter: filter,
            tagCount: filterCount,
            onChanged: _research,
          ),
          if (filter.title.isEmpty)
            _RecentRow(
              onPick: (q) {
                _searchCtrl.text = q;
                ref.read(searchFilterProvider.notifier).setTitle(q);
                setState(() {});
                _research();
              },
            ),
          if (!results.isLoading && results.error == null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  results.items.isEmpty
                      ? 'Tidak ada hasil'
                      : (results.hasMore
                          ? (results.total > results.items.length
                              ? '${results.items.length} dari ${results.total} hasil'
                              : '${results.items.length}+ hasil')
                          : '${results.items.length} hasil'),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          Expanded(
            child: _Results(
              results: results,
              onRetry: _research,
              controller: _scrollCtrl,
            ),
          ),
        ],
      ),
    );
  }
}

class _Results extends ConsumerWidget {
  const _Results({
    required this.results,
    required this.onRetry,
    required this.controller,
  });
  final SearchState results;
  final VoidCallback onRetry;
  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (results.isLoading) return const SkeletonCoverGrid();
    if (results.error != null) {
      return ErrorView(error: results.error!, onRetry: onRetry);
    }
    if (results.items.isEmpty) {
      final isKomiku = ref.watch(sourceProvider) == 'komiku';
      final empty = EmptyView(
        icon: Icons.search_off_outlined,
        title: 'Tidak ditemukan',
        subtitle: isKomiku
            ? 'Coba kata kunci lain / judul Indonesianya.'
            : 'Coba kata kunci atau filter lain.',
      );
      // Filter status diverifikasi bertahap: halaman pertama bisa kosong
      // padahal kandidat masih tersisa -> tetap tawarkan muat lanjutan.
      if (!results.hasMore) return empty;
      return Column(
        children: [
          Expanded(child: empty),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.expand_more),
              label: const Text('Muat lebih banyak'),
              onPressed: () => ref
                  .read(searchResultsProvider.notifier)
                  .loadMore(),
            ),
          ),
        ],
      );
    }
    // Kartu portrait 3 kolom ala contoh (cover anti-crop + badge + info).
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => MangaGridCard(
                manga: results.items[i],
              ),
              childCount: results.items.length,
            ),
            gridDelegate:
                const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 120,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.42,
            ),
          ),
        ),
        if (results.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        if (!results.isLoadingMore && results.hasMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.expand_more),
                label: const Text('Muat lebih banyak'),
                onPressed: () => ref
                    .read(searchResultsProvider.notifier)
                    .loadMore(),
              ),
            ),
          ),
        if (!results.isLoadingMore && !results.hasMore)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Center(
                child: Text(
                  'Semua hasil ditampilkan',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Riwayat pencarian terakhir (ketuk untuk pakai lagi).
class _RecentRow extends ConsumerWidget {
  const _RecentRow({required this.onPick});
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentSearchesProvider);
    if (recent.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: recent.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          if (i == recent.length) {
            return IconButton(
              tooltip: 'Hapus riwayat cari',
              icon: const Icon(Icons.delete_sweep_outlined, size: 20),
              onPressed: () => ref
                  .read(settingsActionsProvider)
                  .clearRecentSearches(),
            );
          }
          return ActionChip(
            avatar: const Icon(Icons.history, size: 16),
            label: Text(recent[i]),
            onPressed: () => onPick(recent[i]),
          );
        },
      ),
    );
  }
}

/// Bar filter: urutan + status + genre + tahun + reset.
class _FilterBar extends ConsumerWidget {
  const _FilterBar({
    required this.filter,
    required this.tagCount,
    required this.onChanged,
  });

  final dynamic filter;
  final int tagCount;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(searchFilterProvider.notifier);
    final orderKey = filter.order.keys.first as String;
    final statusVal = (filter.status as List).isEmpty
        ? ''
        : (filter.status as List).first as String;
    final year = filter.year as int?;
    // Komiku: hanya 2 urutan didukung, tanpa filter tahun.
    final isKomiku = ref.watch(sourceProvider) == 'komiku';
    final orders = searchOrdersFor(isKomiku ? 'komiku' : 'mangadex');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          for (final o in orders)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ChoiceChip(
                label: Text(o.$3),
                selected: orderKey == o.$1,
                onSelected: (_) {
                  notifier.setOrder(o.$1, o.$2);
                  onChanged();
                },
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text('•'),
          ),
          for (final s in searchStatusesFor(
            isKomiku ? 'komiku' : 'mangadex',
          ))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ChoiceChip(
                label: Text(s.$2),
                selected: statusVal == s.$1,
                onSelected: (_) {
                  notifier.setStatus(s.$1);
                  onChanged();
                },
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text('•'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: FilterChip(
              label: Text(
                tagCount == 0 ? 'Genre' : 'Genre ($tagCount)',
              ),
              selected: tagCount > 0,
              onSelected: (_) =>
                  _openGenreSheet(context, ref, onChanged),
            ),
          ),
          if (!isKomiku)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: FilterChip(
                label: Text(year == null ? 'Tahun' : '$year'),
                selected: year != null,
                onSelected: (_) => _openYearDialog(context, ref, onChanged),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> _openGenreSheet(
  BuildContext context,
  WidgetRef ref,
  VoidCallback onChanged,
) async {
  final tagsAsync = ref.read(tagsProvider);
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (_, ctrl) => tagsAsync.when(
        data: (tags) => ListView(
          controller: ctrl,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Pilih Genre',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            for (final t in tags)
              Consumer(
                builder: (_, ref2, _) {
                  final selected = ref2.watch(
                    searchFilterProvider.select(
                      (f) => f.includedTags.contains(t.id),
                    ),
                  );
                  return CheckboxListTile(
                    title: Text(t.name),
                    value: selected,
                    onChanged: (_) => ref2
                        .read(searchFilterProvider.notifier)
                        .toggleTag(t.id),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  onChanged();
                },
                child: const Text('Terapkan'),
              ),
            ),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(tagsProvider),
        ),
      ),
    ),
  );
}

Future<void> _openYearDialog(
  BuildContext context,
  WidgetRef ref,
  VoidCallback onChanged,
) async {
  final ctrl = TextEditingController();
  final year = await showDialog<int?>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Tahun Rilis'),
      content: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(hintText: 'mis. 2023'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, -1),
          child: const Text('Hapus'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(ctx, int.tryParse(ctrl.text.trim())),
          child: const Text('Terapkan'),
        ),
      ],
    ),
  );
  if (year == null) return;
  ref.read(searchFilterProvider.notifier).setYear(year == -1 ? null : year);
  onChanged();
}
