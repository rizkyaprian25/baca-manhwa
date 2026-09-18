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

  /// Pekerjaan verifikasi status (lazy, per kombinasi filter).
  final Map<String, _StatusJob> _statusJobs = {};

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
    final seen = <String>{};
    var page = 1;
    while (out.length < limit && page <= 5) {
      final items = await fetch(page);
      if (items.isEmpty) break;
      var fresh = 0;
      for (final m in items) {
        if (seen.add(m.id)) {
          out.add(m);
          fresh++;
        }
      }
      // Server tanpa paginasi (hal. 2+ mengulang hal. 1): berhenti bila
      // halaman tak penuh atau tak membawa item baru — anti duplikat.
      if (items.length < KomikuApi.pageSize || fresh == 0) break;
      page++;
    }
    return out.take(limit).toList();
  }

  static String _orderParam(String orderKey) {
    if (orderKey == 'rating' || orderKey == 'followedCount') {
      return 'meta_value_num';
    }
    if (orderKey == 'date') {
      return 'date';
    }
    return 'modified';
  }

  /// Ambil rentang item melintasi beberapa halaman server jika diperlukan
  /// (Komiku menyajikan 10 item per halaman).
  Future<List<Manga>> _fetchRange({
    required Future<List<Manga>> Function(int page) fetchPage,
    required int offset,
    required int limit,
  }) async {
    final startPage = (offset ~/ KomikuApi.pageSize) + 1;
    final endPage = ((offset + limit - 1) ~/ KomikuApi.pageSize) + 1;
    final all = <Manga>[];
    for (var p = startPage; p <= endPage; p++) {
      final pageItems = await fetchPage(p);
      all.addAll(pageItems);
      if (pageItems.length < KomikuApi.pageSize) {
        break;
      }
    }
    final skip = offset % KomikuApi.pageSize;
    return all.skip(skip).take(limit).toList();
  }

  @override
  Future<MangaPage> search(
    MangaFilter filter, {
    int limit = 20,
    int offset = 0,
  }) async {
    // 1. Pencarian teks / judul komik
    if (filter.title.trim().isNotEmpty) {
      final q = filter.title.trim();
      final items = await _fetchRange(
        fetchPage: (p) => remote.searchPage(q, page: p),
        offset: offset,
        limit: limit,
      );
      await db.upsertMangas(items.map(mangaToCompanion).toList());
      final hasMore = items.length >= limit;
      return MangaPage(
        items: items,
        total: offset + items.length + (hasMore ? 10 : 0),
        hasMore: hasMore,
      );
    }

    // 2. Jelajah / Browse (urutan, genre, status)
    final orderKey =
        filter.order.keys.isEmpty ? '' : filter.order.keys.first;
    final orderby = _orderParam(orderKey);
    final tags = filter.includedTags;
    final genre = tags.isEmpty ? null : tags.first;
    final genre2 = tags.length > 1 ? tags[1] : null;
    final status = _status(filter.status);

    // Filter status khusus (ongoing/end) diverifikasi bertahap via detail
    if (status != null) {
      return _statusBrowse(
        genre: genre,
        genre2: genre2,
        wanted: status,
        orderby: orderby,
        limit: limit,
        offset: offset,
      );
    }

    // Mode Jelajah default: paginasi server /manga/page/{n}/ tanpa batas buatan
    final items = await _fetchRange(
      fetchPage: (p) => remote.listPage(
        orderby: orderby,
        genre: genre,
        genre2: genre2,
        page: p,
      ),
      offset: offset,
      limit: limit,
    );
    await db.upsertMangas(items.map(mangaToCompanion).toList());
    final hasMore = items.length >= limit;
    return MangaPage(
      items: items,
      total: offset + items.length + (hasMore ? 10 : 0),
      hasMore: hasMore,
    );
  }

  /// Status per manga (memory → db → detail). '' = tak diketahui/gagal.
  final Map<String, String> _statusCache = {};

  Future<String> _resolveStatus(Manga m) async {
    final hit = _statusCache[m.id];
    if (hit != null) return hit;
    final row = await db.getManga(m.id);
    final cached = (row?.status ?? '').toLowerCase();
    if (cached.isNotEmpty) {
      _statusCache[m.id] = cached;
      return cached;
    }
    try {
      final res = await remote.detail(mangaSlug(m.id));
      await db.upsertManga(mangaToCompanion(res.manga));
      await db.upsertChapters(res.feed.map(chapterToCompanion).toList());
      final st = (res.manga.status ?? '').toLowerCase();
      _statusCache[m.id] = st;
      return st;
    } catch (_) {
      _statusCache[m.id] = '';
      return '';
    }
  }

  Future<MangaPage> _statusBrowse({
    String? genre,
    String? genre2,
    required String wanted,
    required String orderby,
    required int limit,
    required int offset,
  }) async {
    final key = 'st|$genre|$genre2|$wanted|$orderby';
    var job = _statusJobs[key];
    if (job == null) {
      job = _StatusJob(
        genre: genre,
        genre2: genre2,
        orderby: orderby,
        wanted: wanted,
      );
      _statusJobs[key] = job;
    }

    final need = offset + limit;
    while (job.matched.length < need) {
      while (job.cursor >= job.candidates.length && !job.noMoreCandidates) {
        final pageItems = await remote.listPage(
          orderby: job.orderby,
          genre: job.genre,
          genre2: job.genre2,
          page: job.candidatePage++,
        );
        if (pageItems.isEmpty) {
          job.noMoreCandidates = true;
          break;
        }
        for (final m in pageItems) {
          if (job.candidateIds.add(m.id)) {
            job.candidates.add(m);
          }
        }
        if (pageItems.length < KomikuApi.pageSize) {
          job.noMoreCandidates = true;
          break;
        }
      }

      if (job.cursor >= job.candidates.length) {
        break;
      }

      final batch = job.candidates.skip(job.cursor).take(6).toList();
      job.cursor += batch.length;
      final statuses = await Future.wait(batch.map(_resolveStatus));
      for (var i = 0; i < batch.length; i++) {
        if (k.komikuStatusMatches(statuses[i], wanted) &&
            job.matchedIds.add(batch[i].id)) {
          job.matched.add(batch[i]);
        }
      }
    }

    final slice = job.matched.skip(offset).take(limit).toList();
    await db.upsertMangas(slice.map(mangaToCompanion).toList());
    final hasMore =
        offset + limit < job.matched.length || !job.noMoreCandidates;
    return MangaPage(
      items: slice,
      total: job.matched.length + (hasMore ? 10 : 0),
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

/// Pekerjaan verifikasi status lazy: kandidat diambil bertahap per halaman server
/// lalu diverifikasi per batch paralel.
class _StatusJob {
  _StatusJob({
    required this.genre,
    required this.genre2,
    required this.orderby,
    required this.wanted,
  });
  final String? genre;
  final String? genre2;
  final String orderby;
  final String wanted;

  final List<Manga> candidates = [];
  final Set<String> candidateIds = {};
  int candidatePage = 1;
  bool noMoreCandidates = false;

  final List<Manga> matched = [];
  final Set<String> matchedIds = {};
  int cursor = 0;
}
