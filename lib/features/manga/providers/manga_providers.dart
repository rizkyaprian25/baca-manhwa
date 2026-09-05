import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/network/komiku_api.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/network_provider.dart';
import '../../settings/presentation/settings_provider.dart';
import '../data/datasources/komiku_remote_datasource.dart';
import '../data/datasources/mangadex_remote_datasource.dart';
import '../data/mappers/manga_mapper.dart';
import '../data/repositories/komiku_repository_impl.dart';
import '../data/repositories/manga_repository_impl.dart';
import '../domain/entities/manga.dart' as entity;
import '../domain/repositories/manga_repository.dart';

/// Provider repository (remote MangaDex + cache Drift).
/// `lib/features/manga/providers/manga_providers.dart`.
final mangaRemoteDataSourceProvider = Provider<MangadexRemoteDataSource>(
  (ref) => MangadexRemoteDataSource(ref.watch(mangadexApiProvider)),
);

final komikuApiProvider = Provider<KomikuApi>(
  (ref) => KomikuApi(DioClient.createBrowser()),
);

final komikuRemoteDataSourceProvider = Provider<KomikuRemoteDataSource>(
  (ref) => KomikuRemoteDataSource(ref.watch(komikuApiProvider)),
);

/// Repository aktif mengikuti pengaturan sumber
/// ('komiku' default Indonesia | 'mangadex').
final mangaRepositoryProvider = Provider<MangaRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final source = ref.watch(sourceProvider);
  if (source == 'mangadex') {
    return MangaRepositoryImpl(
      remote: ref.watch(mangaRemoteDataSourceProvider),
      db: db,
    );
  }
  return KomikuRepositoryImpl(
    remote: ref.watch(komikuRemoteDataSourceProvider),
    db: db,
  );
});

/// Remote-first dengan fallback cache lokal saat offline.
/// Bila cache juga kosong, error asli dilempar (UI tampil ErrorView).
Future<List<entity.Manga>> _withOfflineCache(
  Ref ref,
  Future<List<entity.Manga>> Function() remote, {
  int limit = 10,
}) async {
  try {
    return await remote();
  } on MangaDexException catch (e) {
    if (!e.isOffline) rethrow;
    final db = ref.read(databaseProvider);
    final cached = await db.recentCachedMangas(limit: limit);
    if (cached.isEmpty) rethrow;
    return cached.map(mangaRowToEntity).toList();
  }
}

/// Beranda: trending (+ cache offline).
final trendingProvider = FutureProvider<List<entity.Manga>>((ref) {
  return _withOfflineCache(
    ref,
    () => ref.watch(mangaRepositoryProvider).trending(limit: 10),
    limit: 10,
  );
});

/// Ukuran halaman feed update Beranda.
const updatesPageSize = 10;

/// Gabung halaman baru ke daftar lama: buang duplikat per id; bila tak ada
/// item BARU, hentikan pagination (jaring pengaman semua sumber).
({List<entity.Manga> items, bool hasMore}) mergeSearchPage(
  List<entity.Manga> existing,
  entity.MangaPage page,
) {
  final known = existing.map((m) => m.id).toSet();
  final fresh = page.items.where((m) => !known.contains(m.id)).toList();
  return (
    items: [...existing, ...fresh],
    hasMore: page.hasMore && fresh.isNotEmpty,
  );
}

/// State feed update Beranda (infinite scroll).
class UpdatesState {
  const UpdatesState({
    this.items = const [],
    this.hasMore = true,
    this.loading = false,
    this.loadingMore = false,
    this.error,
  });

  final List<entity.Manga> items;
  final bool hasMore;
  final bool loading;
  final bool loadingMore;
  final Object? error;

  UpdatesState copyWith({
    List<entity.Manga>? items,
    bool? hasMore,
    bool? loading,
    bool? loadingMore,
    Object? error,
  }) =>
      UpdatesState(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        loading: loading ?? this.loading,
        loadingMore: loadingMore ?? this.loadingMore,
        error: error,
      );
}

/// Feed update Beranda per halaman (terbaru dulu), fallback cache offline
/// saat load awal gagal total.
class UpdatesNotifier extends Notifier<UpdatesState> {
  @override
  UpdatesState build() => const UpdatesState();

  Future<entity.MangaPage> _page(int offset) {
    return ref.read(mangaRepositoryProvider).search(
          const MangaFilter(order: {'latestUploadedChapter': 'desc'}),
          limit: updatesPageSize,
          offset: offset,
        );
  }

  Future<entity.MangaPage> _pageOrCache(int offset) async {
    try {
      return await _page(offset);
    } on MangaDexException catch (e) {
      if (!e.isOffline || offset > 0) rethrow;
      final cached = await ref
          .read(databaseProvider)
          .recentCachedMangas(limit: updatesPageSize * 2);
      if (cached.isEmpty) rethrow;
      final items = cached.map(mangaRowToEntity).toList();
      return entity.MangaPage(items: items, total: items.length, hasMore: false);
    }
  }

  Future<void> loadInitial() async {
    state = const UpdatesState(loading: true);
    try {
      final page = await _pageOrCache(0);
      final merged = mergeSearchPage(const [], page);
      state = UpdatesState(
        items: merged.items,
        hasMore: merged.hasMore,
      );
    } catch (e) {
      state = UpdatesState(error: e);
    }
  }

  Future<void> loadMore() async {
    final s = state;
    if (s.loading || s.loadingMore || !s.hasMore || s.error != null) return;
    state = s.copyWith(loadingMore: true);
    try {
      final page = await _page(s.items.length);
      final merged = mergeSearchPage(s.items, page);
      state = s.copyWith(
        items: merged.items,
        hasMore: merged.hasMore,
        loadingMore: false,
      );
    } catch (_) {
      state = s.copyWith(loadingMore: false);
    }
  }
}

final updatesProvider =
    NotifierProvider<UpdatesNotifier, UpdatesState>(
  UpdatesNotifier.new,
);

/// Daftar genre untuk filter (GET /manga/tag).
final tagsProvider = FutureProvider<List<entity.MangaTag>>((ref) {
  return ref.watch(mangaRepositoryProvider).tags();
});

/// Rekomendasi: 3 tag teratas dari library + riwayat.
/// Kosong -> fallback trending. Offline -> cache lokal.
final recommendedProvider = FutureProvider<List<entity.Manga>>((ref) async {
  final db = ref.watch(databaseProvider);
  final repo = ref.watch(mangaRepositoryProvider);
  try {
    final ids = {
      ...await db.libraryMangaIds(),
      ...await db.historyMangaIds(),
    };
    if (ids.isEmpty) return repo.trending(limit: 10);
    final rows = await db.getMangasByIds(ids.toList());
    final count = <String, int>{};
    for (final r in rows) {
      for (final t in mangaRowTagIds(r)) {
        count[t] = (count[t] ?? 0) + 1;
      }
    }
    if (count.isEmpty) return repo.trending(limit: 10);
    final top = count.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return repo.recommended(
      top.take(3).map((e) => e.key).toList(),
      limit: 10,
    );
  } on MangaDexException catch (e) {
    if (!e.isOffline) rethrow;
    final cached = await db.recentCachedMangas(limit: 10);
    if (cached.isEmpty) rethrow;
    return cached.map(mangaRowToEntity).toList();
  }
});
