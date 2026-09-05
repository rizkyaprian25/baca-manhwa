import '../../../../core/database/app_database.dart'
    hide Chapter, Manga;
import '../../../../core/network/komiku_api.dart';
import '../../domain/entities/manga.dart';
import '../../domain/repositories/manga_repository.dart';
import '../datasources/komiku_remote_datasource.dart';
import '../mappers/manga_mapper.dart';
import '../models/komiku_model.dart' as k;

/// Repository Komiku (Bahasa Indonesia) — implementasi [MangaRepository].
/// ID: manga `k:{slug}`, chapter `k:{mangaSlug}:{chapterSlug}`.
/// `lib/features/manga/data/repositories/komiku_repository_impl.dart`.
class KomikuRepositoryImpl implements MangaRepository {
  KomikuRepositoryImpl({required this.remote, required this.db});
  final KomikuRemoteDataSource remote;
  final AppDatabase db;

  static String mangaSlug(String id) =>
      id.startsWith('k:') ? id.substring(2) : id;

  static (String, String) splitChapter(String id) {
    final parts = id.split(':');
    if (parts.length >= 3) {
      return (parts[1], parts.sublist(2).join(':'));
    }
    return ('', id);
  }

  String _order(Map<String, String> order) {
    final key = order.keys.isEmpty ? '' : order.keys.first;
    return switch (key) {
      'followedCount' || 'rating' => 'meta_value_num',
      _ => 'modified',
    };
  }

  String? _status(List<String> status) {
    for (final s in status) {
      if (s == 'ongoing') return 'ongoing';
      if (s == 'completed') return 'end';
    }
    return null;
  }

  Future<List<Manga>> _pages(
    Future<List<Manga>> Function(int page) fetch, {
    int limit = 10,
  }) async {
    final out = <Manga>[];
    var page = 1;
    while (out.length < limit && page <= 5) {
      final items = await fetch(page);
      if (items.isEmpty) break;
      out.addAll(items);
      if (items.length < KomikuApi.pageSize) break;
      page++;
    }
    return out.take(limit).toList();
  }

  @override
  Future<MangaPage> search(
    MangaFilter filter, {
    int limit = 20,
    int offset = 0,
  }) async {
    final page = offset ~/ KomikuApi.pageSize + 1;
    final isTitleSearch = filter.title.trim().isNotEmpty;
    if (isTitleSearch) {
      // Search: kumpulkan SEMUA yang cocok (maks 3 halaman mentah, ~30
      // hasil) karena server mencampur hasil tak-relevan (cocok sinopsis).
      // hasMore=false — semua sudah ditampilkan sekaligus.
      final q = filter.title.trim();
      final seen = <String>{};
      final all = <Manga>[];
      for (var p = 1; p <= 3; p++) {
        final raw = await remote.searchPage(q, page: p);
        if (raw.isEmpty) break;
        for (final m in raw) {
          if (seen.add(m.id) && k.titleMatchesQuery(m.title, q)) {
            all.add(m);
          }
        }
        if (raw.length < KomikuApi.pageSize) break;
      }
      await db.upsertMangas(all.map(mangaToCompanion).toList());
      return MangaPage(items: all, total: all.length, hasMore: false);
    }
    final List<Manga> items = await remote.listPage(
      orderby: _order(filter.order),
      genre: filter.includedTags.isEmpty ? null : filter.includedTags.first,
      status: _status(filter.status),
      page: page,
    );
    await db.upsertMangas(items.map(mangaToCompanion).toList());
    final hasMore = items.length >= KomikuApi.pageSize;
    return MangaPage(
      items: items,
      total: offset + items.length + (hasMore ? KomikuApi.pageSize : 0),
      hasMore: hasMore,
    );
  }

  @override
  Future<List<Manga>> trending({int limit = 10}) => _pages(
        (p) => remote.listPage(orderby: 'meta_value_num', page: p),
        limit: limit,
      );

  @override
  Future<List<Manga>> latestUpdates({int limit = 10}) => _pages(
        (p) => remote.listPage(orderby: 'modified', page: p),
        limit: limit,
      );

  @override
  Future<List<Manga>> recommended(List<String> tagIds, {int limit = 10}) {
    if (tagIds.isEmpty) return trending(limit: limit);
    return _pages(
      (p) => remote.listPage(
        orderby: 'meta_value_num',
        genre: tagIds.first,
        page: p,
      ),
      limit: limit,
    );
  }

  /// Genre populer Komiku (tanpa network).
  @override
  Future<List<MangaTag>> tags() async => [
        MangaTag(id: 'action', name: 'Action'),
        MangaTag(id: 'adventure', name: 'Adventure'),
        MangaTag(id: 'comedy', name: 'Comedy'),
        MangaTag(id: 'drama', name: 'Drama'),
        MangaTag(id: 'fantasy', name: 'Fantasy'),
        MangaTag(id: 'isekai', name: 'Isekai'),
        MangaTag(id: 'martial-arts', name: 'Martial Arts'),
        MangaTag(id: 'murim', name: 'Murim'),
        MangaTag(id: 'reincarnation', name: 'Reincarnation'),
        MangaTag(id: 'revenge', name: 'Revenge'),
        MangaTag(id: 'romance', name: 'Romance'),
        MangaTag(id: 'school-life', name: 'School Life'),
        MangaTag(id: 'shounen', name: 'Shounen'),
        MangaTag(id: 'supernatural', name: 'Supernatural'),
      ];

  @override
  Future<Manga> detail(String mangaId) async {
    final res = await remote.detail(mangaSlug(mangaId));
    await db.upsertManga(mangaToCompanion(res.manga));
    await db.upsertChapters(res.feed.map(chapterToCompanion).toList());
    return res.manga;
  }

  @override
  Future<List<ChapterInfo>> feed(
    String mangaId, {
    List<String> languages = const ['id', 'en'],
    String order = 'asc',
  }) async {
    final res = await remote.detail(mangaSlug(mangaId));
    await db.upsertChapters(res.feed.map(chapterToCompanion).toList());
    return res.feed;
  }

  @override
  Future<AtHome> atHome(String chapterId) async {
    final (_, chSlug) = splitChapter(chapterId);
    final urls = await remote.chapterImages(chSlug);
    return AtHome(baseUrl: '', hash: '', pages: urls, pagesSaver: urls);
  }
}
