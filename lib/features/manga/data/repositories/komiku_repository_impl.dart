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

  /// Genre kurasi (sama dengan tags()) untuk pendalaman pool browse
  /// "semua" — satu-satunya sumber halaman-1 berbeda yang tersisa.
  static const _poolGenres = [
    'action',
    'adventure',
    'comedy',
    'drama',
    'fantasy',
    'isekai',
    'martial-arts',
    'murim',
    'reincarnation',
    'revenge',
    'romance',
    'school-life',
    'shounen',
    'supernatural',
  ];

  /// Cache pool browse per kombinasi filter (sesi).
  final Map<String, List<Manga>> _poolCache = {};

  static bool _isRankedOrder(String orderKey) =>
      orderKey == 'rating' || orderKey == 'followedCount';

  /// Satu view aman-gagal (view lain tetap dipakai bila satu gagal).
  static Future<List<Manga>> _safeView(Future<List<Manga>> f) async {
    try {
      return await f;
    } catch (_) {
      return const [];
    }
  }

  /// Jalankan pembuat view per batch kecil (maks 4 serentak): ramah
  /// throttle 5rps + hemat baterai + tak menumpuk timer. Factory dipakai
  /// agar request batch berikutnya BARU dibuat setelah batch kini selesai.
  static Future<List<List<Manga>>> _batchedViews(
    List<Future<List<Manga>> Function()> makers,
  ) async {
    const size = 4;
    final out = <List<Manga>>[];
    for (var i = 0; i < makers.length; i += size) {
      final end = (i + size).clamp(0, makers.length);
      final chunk = makers.sublist(i, end);
      out.addAll(await Future.wait(chunk.map((m) => _safeView(m()))));
    }
    return out;
  }

  /// Pool browse JUJUR: gabung semua view halaman-1 yang isinya terbukti
  /// berbeda (modified | date | meta_value_num [+ peringkat per genre bila
  /// tanpa genre]), dedupe per id, urut di klien. Pagination server mati
  /// (`page` mengulang, `paged` kosong, `status` diabaikan — Fase 28),
  /// jadi slice + infinite scroll bekerja dari pool ini.
  Future<List<Manga>> _browsePool({
    String? genre,
    String? genre2,
    required String orderKey,
  }) async {
    final key = 'pool|$genre|$genre2|$orderKey';
    final hit = _poolCache[key];
    if (hit != null) return hit;
    final ranked = _isRankedOrder(orderKey);
    final makers = <Future<List<Manga>> Function()>[
      () => remote.listPage(
          orderby: 'modified', genre: genre, genre2: genre2, page: 1),
      () => remote.listPage(
          orderby: 'date', genre: genre, genre2: genre2, page: 1),
      () => remote.listPage(
          orderby: 'meta_value_num',
          genre: genre,
          genre2: genre2,
          page: 1),
    ];
    if (genre == null) {
      for (final g in _poolGenres) {
        makers.add(() => remote.listPage(
              orderby: ranked ? 'meta_value_num' : 'modified',
              genre: g,
              page: 1,
            ));
      }
    }
    final views = await _batchedViews(makers);
    final ids = <String>{};
    final pool = <Manga>[];
    for (final v in views) {
      for (final m in v) {
        if (ids.add(m.id)) pool.add(m);
      }
    }
    final pos = {for (var i = 0; i < pool.length; i++) pool[i].id: i};
    if (ranked) {
      pool.sort((a, b) {
        final c = (b.followedCount ?? -1)
            .compareTo(a.followedCount ?? -1);
        return c != 0 ? c : pos[a.id]!.compareTo(pos[b.id]!);
      });
    } else {
      pool.sort((a, b) {
        final am = k.parseUpdateAgoMinutes(a.updateAgo);
        final bm = k.parseUpdateAgoMinutes(b.updateAgo);
        if (am == null && bm == null) {
          return pos[a.id]!.compareTo(pos[b.id]!);
        }
        if (am == null) return 1;
        if (bm == null) return -1;
        final c = am.compareTo(bm);
        return c != 0 ? c : pos[a.id]!.compareTo(pos[b.id]!);
      });
    }
    _poolCache[key] = pool;
    return pool;
  }

  @override
  Future<MangaPage> search(
    MangaFilter filter, {
    int limit = 20,
    int offset = 0,
  }) async {
    if (filter.title.trim().isNotEmpty) {
      // Search judul: server hanya punya SATU halaman (~8-10 hasil, tanpa
      // paginasi). Saring kata-utuh karena server mencampur hasil
      // tak-relevan (cocok sinopsis). hasMore=false yang jujur.
      final q = filter.title.trim();
      final raw = await remote.searchPage(q);
      final seen = <String>{};
      final all = <Manga>[];
      for (final m in raw) {
        if (seen.add(m.id) && k.titleMatchesQuery(m.title, q)) {
          all.add(m);
        }
      }
      await db.upsertMangas(all.map(mangaToCompanion).toList());
      return MangaPage(items: all, total: all.length, hasMore: false);
    }
    final orderKey =
        filter.order.keys.isEmpty ? '' : filter.order.keys.first;
    final tags = filter.includedTags;
    final genre = tags.isEmpty ? null : tags.first;
    final genre2 = tags.length > 1 ? tags[1] : null;
    final status = _status(filter.status);
    // Status: server MENGABAIKAN param status (terbukti) → verifikasi
    // via halaman detail (satu-satunya sumber benar), lazy per batch.
    if (status != null) {
      return _statusBrowse(
        genre: genre,
        genre2: genre2,
        wanted: status,
        orderKey: orderKey,
        limit: limit,
        offset: offset,
      );
    }
    final pool = await _browsePool(
      genre: genre,
      genre2: genre2,
      orderKey: orderKey,
    );
    final slice = pool.skip(offset).take(limit).toList();
    await db.upsertMangas(slice.map(mangaToCompanion).toList());
    return MangaPage(
      items: slice,
      total: pool.length,
      hasMore: offset + limit < pool.length,
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
    required String orderKey,
    required int limit,
    required int offset,
  }) async {
    final key = 'st|$genre|$genre2|$wanted|$orderKey';
    var job = _statusJobs[key];
    if (job == null) {
      // Pool kandidat = pool browse yang sama (sudah dalam): status hanya
      // menyaring, tak mengubah urutan.
      final pool = await _browsePool(
        genre: genre,
        genre2: genre2,
        orderKey: orderKey,
      );
      job = _StatusJob(pool);
      _statusJobs[key] = job;
    }
    // Verifikasi LAZY per batch 6 paralel sampai kebutuhan halaman
    // terpenuhi atau kandidat habis — halaman pertama tampil cepat,
    // scroll berikutnya melanjutkan. cursor dicadangkan sinkron sebelum
    // await sehingga panggilan tumpang-tindih tak memverifikasi ganda.
    final need = offset + limit;
    while (job.matched.length < need &&
        job.cursor < job.candidates.length) {
      final batch =
          job.candidates.skip(job.cursor).take(6).toList();
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
    return MangaPage(
      items: slice,
      // total = yang sudah terverifikasi sejauh ini (tumbuh saat scroll).
      total: job.matched.length,
      hasMore: offset + limit < job.matched.length ||
          job.cursor < job.candidates.length,
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

/// Pekerjaan verifikasi status lazy: kandidat diverifikasi bertahap
/// (batch paralel), yang cocok dikumpulkan di [matched].
class _StatusJob {
  _StatusJob(this.candidates);
  final List<Manga> candidates;
  final List<Manga> matched = [];
  final Set<String> matchedIds = {};
  int cursor = 0;
}
