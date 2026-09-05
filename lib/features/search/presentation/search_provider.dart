import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../manga/domain/entities/manga.dart';
import '../../manga/domain/repositories/manga_repository.dart';
import '../../manga/providers/manga_providers.dart';
import '../../settings/presentation/settings_provider.dart';
import '../../../core/utils/content_rating_filter.dart';

/// Opsi urutan: (key, direction, label). Rating = default (skor tertinggi).
const searchOrderOptions = [
  ('rating', 'desc', 'Rating'),
  ('followedCount', 'desc', 'Populer'),
  ('latestUploadedChapter', 'desc', 'Terbaru'),
  ('title', 'asc', 'A-Z'),
];

/// Opsi per sumber (Komiku hanya dukung Peringkat + Terbaru).
List<(String, String, String)> searchOrdersFor(String source) =>
    source == 'komiku'
        ? const [
            ('rating', 'desc', 'Rating'),
            ('latestUploadedChapter', 'desc', 'Terbaru'),
          ]
        : searchOrderOptions;

/// Opsi status: (value, label). '' = semua.
const searchStatusOptions = [
  ('', 'Semua'),
  ('ongoing', 'Ongoing'),
  ('completed', 'Tamat'),
  ('hiatus', 'Hiatus'),
];

/// State filter pencarian — `lib/features/search/presentation/search_provider.dart`.
class MangaFilterNotifier extends Notifier<MangaFilter> {
  @override
  MangaFilter build() {
    final adultOn = ref.watch(adultFilterProvider);
    return MangaFilter(
      contentRating: ContentRatingFilter.forQuery(adultFilterOn: adultOn),
    );
  }

  void setTitle(String v) {
    if (state.title == v) return;
    state = state.copyWith(title: v);
  }

  void setOrder(String key, String dir) {
    state = state.copyWith(order: {key: dir});
  }

  void setStatus(String v) {
    state = state.copyWith(status: v.isEmpty ? [] : [v]);
  }

  void setYear(int? y) {
    if (y == null) {
      state = state.copyWith(clearYear: true);
    } else {
      state = state.copyWith(year: y);
    }
  }

  void toggleTag(String id) {
    final l = [...state.includedTags];
    if (l.contains(id)) {
      l.remove(id);
    } else {
      l.add(id);
    }
    state = state.copyWith(includedTags: l);
  }

  void clearTags() => state = state.copyWith(includedTags: []);

  int get activeCount =>
      state.includedTags.length +
      (state.status.isEmpty ? 0 : 1) +
      (state.year == null ? 0 : 1);

  void resetFilters() {
    final adultOn = ref.read(adultFilterProvider);
    state = MangaFilter(
      title: state.title,
      contentRating: ContentRatingFilter.forQuery(adultFilterOn: adultOn),
    );
  }
}

final searchFilterProvider =
    NotifierProvider<MangaFilterNotifier, MangaFilter>(
  MangaFilterNotifier.new,
);

/// State hasil ber-halaman.
class SearchState {
  const SearchState({
    this.items = const [],
    this.total = 0,
    this.hasMore = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
  });

  final List<Manga> items;
  final int total;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final Object? error;

  SearchState copyWith({
    List<Manga>? items,
    int? total,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    Object? error,
  }) =>
      SearchState(
        items: items ?? this.items,
        total: total ?? this.total,
        hasMore: hasMore ?? this.hasMore,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        error: error,
      );
}

/// Hasil pencarian + infinite scroll (limit 20).
/// Gabung halaman via `mergeSearchPage` bersama (manga_providers).
class SearchResultsNotifier extends Notifier<SearchState> {
  @override
  SearchState build() => const SearchState();

  Future<void> search() async {
    final filter = ref.read(searchFilterProvider);
    state = const SearchState(isLoading: true);
    try {
      final page = await ref
          .read(mangaRepositoryProvider)
          .search(filter, limit: 20);
      state = SearchState(
        items: page.items,
        total: page.total,
        hasMore: page.hasMore,
      );
    } catch (e) {
      state = SearchState(error: e);
    }
  }

  Future<void> loadMore() async {
    final s = state;
    if (s.isLoading || s.isLoadingMore || !s.hasMore || s.error != null) {
      return;
    }
    state = s.copyWith(isLoadingMore: true);
    try {
      final page = await ref.read(mangaRepositoryProvider).search(
            ref.read(searchFilterProvider),
            limit: 20,
            offset: s.items.length,
          );
      final merged = mergeSearchPage(s.items, page);
      state = s.copyWith(
        items: merged.items,
        total: page.total,
        hasMore: merged.hasMore,
        isLoadingMore: false,
      );
    } catch (_) {
      // List lama dipertahankan; scroll berikutnya bisa retry.
      state = s.copyWith(isLoadingMore: false);
    }
  }
}

final searchResultsProvider =
    NotifierProvider<SearchResultsNotifier, SearchState>(
  SearchResultsNotifier.new,
);
