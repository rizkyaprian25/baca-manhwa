import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../constants/app_constants.dart';
import 'tables/app_settings.dart';
import 'tables/chapters.dart';
import 'tables/downloads.dart';
import 'tables/library_entries.dart';
import 'tables/mangas.dart';
import 'tables/reading_history.dart';

part 'app_database.g.dart';

/// Database lokal — `lib/core/database/app_database.dart`.
@DriftDatabase(
  tables: [
    Mangas,
    Chapters,
    LibraryEntries,
    ReadingHistory,
    Downloads,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Konstruktor in-memory untuk test.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => AppConstants.dbVersion;

  static QueryExecutor _openConnection() =>
      driftDatabase(name: AppConstants.dbName);

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createIndexes();
          // Seed: satu baris settings default.
          await into(appSettings).insert(
            AppSettingsCompanion.insert(),
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(appSettings, appSettings.source);
          }
          if (from < 3) {
            await m.addColumn(appSettings, appSettings.recentSearches);
          }
          if (from < 4) {
            await m.addColumn(appSettings, appSettings.autoScrollSpeed);
          }
          if (from < 5) {
            // Fase 21: tema default kembali gelap (panduan KuroYomi).
            // Baris lama yang masih 'system' ikut digelapkan.
            await customStatement(
              "UPDATE app_settings SET theme = 'dark' WHERE theme = 'system'",
            );
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _createIndexes() async {
    for (final sql in const [
      'CREATE INDEX IF NOT EXISTS idx_chapters_mangaId ON chapters (manga_id)',
      'CREATE INDEX IF NOT EXISTS idx_chapters_lang ON chapters (language)',
      'CREATE INDEX IF NOT EXISTS idx_library_type ON library_entries (list_type)',
      'CREATE INDEX IF NOT EXISTS idx_library_opened ON library_entries (last_opened)',
      'CREATE INDEX IF NOT EXISTS idx_history_read ON reading_history (read_at)',
      'CREATE INDEX IF NOT EXISTS idx_downloads_status ON downloads (status)',
    ]) {
      await customStatement(sql);
    }
  }

  // ============ Settings ============

  Stream<AppSetting> watchSettings() {
    return (select(appSettings)..where((t) => t.id.equals(1))).watchSingle();
  }

  Future<AppSetting> getSettings() {
    return (select(appSettings)..where((t) => t.id.equals(1))).getSingle();
  }

  Future<void> updateSettings(AppSettingsCompanion c) {
    return (update(appSettings)..where((t) => t.id.equals(1))).write(c);
  }

  // ============ Manga cache ============

  Future<void> upsertManga(MangasCompanion c) {
    return into(mangas).insertOnConflictUpdate(c);
  }

  Future<void> upsertMangas(List<MangasCompanion> list) async {
    await batch((b) => b.insertAllOnConflictUpdate(mangas, list));
  }

  Future<Manga?> getManga(String id) {
    return (select(mangas)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Cache terbaru (fallback offline untuk seksi beranda).
  Future<List<Manga>> recentCachedMangas({int limit = 20}) {
    return (select(mangas)
          ..orderBy([(t) => OrderingTerm.desc(t.lastFetched)])
          ..limit(limit))
        .get();
  }

  Future<List<Manga>> getMangasByIds(List<String> ids) {
    if (ids.isEmpty) return Future.value([]);
    return (select(mangas)..where((t) => t.id.isIn(ids))).get();
  }

  Future<List<String>> libraryMangaIds() {
    return (selectOnly(libraryEntries, distinct: true)
          ..addColumns([libraryEntries.mangaId]))
        .map((r) => r.read(libraryEntries.mangaId) ?? '')
        .get()
        .then((l) => l.where((e) => e.isNotEmpty).toList());
  }

  Future<List<String>> historyMangaIds({int limit = 50}) {
    return (selectOnly(readingHistory, distinct: true)
          ..addColumns([readingHistory.mangaId])
          ..orderBy([OrderingTerm.desc(readingHistory.readAt)])
          ..limit(limit))
        .map((r) => r.read(readingHistory.mangaId) ?? '')
        .get()
        .then((l) => l.where((e) => e.isNotEmpty).toList());
  }

  // ============ Chapter cache ============

  Future<void> upsertChapters(List<ChaptersCompanion> list) async {
    await batch((b) => b.insertAllOnConflictUpdate(chapters, list));
  }

  /// Daftar chapter satu judul + filter bahasa (di memori DB, tanpa hit API).
  Stream<List<Chapter>> watchChapters(
    String mangaId, {
    String? language,
    bool ascending = true,
  }) {
    final q = select(chapters)..where((t) => t.mangaId.equals(mangaId));
    if (language != null && language != 'all') {
      q.where((t) => t.language.equals(language));
    }
    q.orderBy([
      (t) => OrderingTerm(
            expression: t.chapterNo,
            mode: ascending ? OrderingMode.asc : OrderingMode.desc,
          ),
    ]);
    return q.watch();
  }

  Future<List<Chapter>> getChapters(String mangaId) {
    return (select(chapters)..where((t) => t.mangaId.equals(mangaId))).get();
  }

  /// Semua chapter cache (untuk progres perpustakaan).
  Stream<List<Chapter>> watchAllChapters() => select(chapters).watch();

  Future<Chapter?> getChapter(String chapterId) {
    return (select(chapters)..where((t) => t.id.equals(chapterId)))
        .getSingleOrNull();
  }

  /// Simpan posisi halaman TANPA menambah riwayat (dipakai tiap pindah hal.).
  Future<void> saveReadingPage(String chapterId, int page) {
    return (update(chapters)..where((t) => t.id.equals(chapterId)))
        .write(ChaptersCompanion(lastPage: Value(page)));
  }

  // ============ Tandai dibaca (inti alur pribadi) ============
  //
  /// Update chapters.isRead/lastPage + tambah reading_history + sentuh
  /// library_entries.reading.lastOpened (auto-masuk "Sedang Dibaca").

  Future<void> markChapterRead({
    required String mangaId,
    required String chapterId,
    required int page,
    bool finished = false,
  }) async {
    await transaction(() async {
      await (update(chapters)..where((t) => t.id.equals(chapterId))).write(
        ChaptersCompanion(
          isRead: Value(finished),
          lastPage: Value(page),
        ),
      );
      await into(readingHistory).insert(
        ReadingHistoryCompanion.insert(
          mangaId: mangaId,
          chapterId: chapterId,
          page: Value(page),
        ),
      );
      final existing = await (select(libraryEntries)
            ..where((t) =>
                t.mangaId.equals(mangaId) &
                t.listType.equals(LibraryList.reading)))
          .getSingleOrNull();
      final now = DateTime.now();
      if (existing == null) {
        await into(libraryEntries).insert(
          LibraryEntriesCompanion.insert(
            mangaId: mangaId,
            listType: LibraryList.reading,
            lastOpened: Value(now),
          ),
        );
      } else {
        await (update(libraryEntries)
              ..where((t) => t.id.equals(existing.id)))
            .write(LibraryEntriesCompanion(lastOpened: Value(now)));
      }
    });
  }

  // ============ Library ============

  /// Library per tipe + join mangas, urut terakhir dibuka (reading) /
  /// terbaru ditambah (tipe lain).
  Stream<List<LibraryWithManga>> watchLibrary(String listType) {
    final q = select(libraryEntries).join([
      innerJoin(mangas, mangas.id.equalsExp(libraryEntries.mangaId)),
    ])
      ..where(libraryEntries.listType.equals(listType))
      ..orderBy([
        OrderingTerm(
          expression: listType == LibraryList.reading
              ? libraryEntries.lastOpened
              : libraryEntries.addedAt,
          mode: OrderingMode.desc,
        ),
      ]);
    return q.watch().map(
          (rows) => rows
              .map(
                (r) => LibraryWithManga(
                  entry: r.readTable(libraryEntries),
                  manga: r.readTable(mangas),
                ),
              )
              .toList(),
        );
  }

  Future<void> addToLibrary(String mangaId, String listType) {
    return into(libraryEntries).insertOnConflictUpdate(
      LibraryEntriesCompanion.insert(
        mangaId: mangaId,
        listType: listType,
        lastOpened:
            listType == LibraryList.reading ? Value(DateTime.now()) : const Value.absent(),
      ),
    );
  }

  Future<void> removeFromLibrary(String mangaId, String listType) {
    return (delete(libraryEntries)
          ..where((t) =>
              t.mangaId.equals(mangaId) & t.listType.equals(listType)))
        .go();
  }

  Future<LibraryEntry?> libraryEntry(String mangaId, String listType) {
    return (select(libraryEntries)
          ..where((t) =>
              t.mangaId.equals(mangaId) & t.listType.equals(listType)))
        .getSingleOrNull();
  }

  // ============ History ============

  Stream<List<HistoryWithData>> watchHistory({int limit = 100}) {
    final q = select(readingHistory).join([
      innerJoin(mangas, mangas.id.equalsExp(readingHistory.mangaId)),
      innerJoin(chapters, chapters.id.equalsExp(readingHistory.chapterId)),
    ])
      ..orderBy([OrderingTerm.desc(readingHistory.readAt)])
      ..limit(limit);
    return q.watch().map(
          (rows) => rows
              .map(
                (r) => HistoryWithData(
                  history: r.readTable(readingHistory),
                  manga: r.readTable(mangas),
                  chapter: r.readTable(chapters),
                ),
              )
              .toList(),
        );
  }

  Future<void> deleteHistory(int id) {
    return (delete(readingHistory)..where((t) => t.id.equals(id))).go();
  }

  /// Hapus seluruh riwayat 1 judul (untuk riwayat grup).
  Future<void> deleteHistoryForManga(String mangaId) {
    return (delete(readingHistory)
          ..where((t) => t.mangaId.equals(mangaId)))
        .go();
  }

  Future<void> clearHistory() => delete(readingHistory).go();

  // ============ Download ============

  Stream<List<Download>> watchDownloads() {
    return (select(downloads)
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .watch();
  }

  Future<Download?> getDownload(String chapterId) {
    return (select(downloads)..where((t) => t.chapterId.equals(chapterId)))
        .getSingleOrNull();
  }

  Future<void> upsertDownload(DownloadsCompanion c) {
    return into(downloads).insertOnConflictUpdate(c);
  }

  Future<void> updateDownload(String chapterId, DownloadsCompanion c) {
    return (update(downloads)..where((t) => t.chapterId.equals(chapterId)))
        .write(c);
  }

  Future<void> deleteDownload(String chapterId) {
    return (delete(downloads)..where((t) => t.chapterId.equals(chapterId)))
        .go();
  }

  Future<int> totalDownloadBytes() async {
    final row = await customSelect(
      'SELECT COALESCE(SUM(size_bytes), 0) AS s FROM downloads WHERE status = ?',
      variables: [Variable.withString('done')],
    ).getSingleOrNull();
    return (row?.data['s'] as int?) ?? 0;
  }

  /// Antrean worker (status queue), tertua dulu.
  Future<List<Download>> pendingDownloads({int limit = 2}) {
    return (select(downloads)
          ..where((t) => t.status.equals(DownloadStatus.queue))
          ..orderBy([(t) => OrderingTerm.asc(t.id)])
          ..limit(limit))
        .get();
  }

  Future<List<Download>> downloadsForManga(String mangaId) {
    return (select(downloads)..where((t) => t.mangaId.equals(mangaId))).get();
  }

  Stream<Download?> watchDownload(String chapterId) {
    return (select(downloads)..where((t) => t.chapterId.equals(chapterId)))
        .watchSingleOrNull();
  }

  Stream<List<DownloadWithData>> watchDownloadsWithManga() {
    final q = select(downloads).join([
      innerJoin(mangas, mangas.id.equalsExp(downloads.mangaId)),
      innerJoin(chapters, chapters.id.equalsExp(downloads.chapterId)),
    ])
      ..orderBy([OrderingTerm.desc(downloads.id)]);
    return q.watch().map(
          (rows) => rows
              .map(
                (r) => DownloadWithData(
                  download: r.readTable(downloads),
                  manga: r.readTable(mangas),
                  chapter: r.readTable(chapters),
                ),
              )
              .toList(),
        );
  }
}

/// Join library_entries + mangas.
class LibraryWithManga {
  LibraryWithManga({required this.entry, required this.manga});
  final LibraryEntry entry;
  final Manga manga;
}

/// Join reading_history + mangas + chapters.
class HistoryWithData {
  HistoryWithData({
    required this.history,
    required this.manga,
    required this.chapter,
  });
  final ReadingHistoryData history;
  final Manga manga;
  final Chapter chapter;
}

/// Join downloads + mangas + chapters.
class DownloadWithData {
  DownloadWithData({
    required this.download,
    required this.manga,
    required this.chapter,
  });
  final Download download;
  final Manga manga;
  final Chapter chapter;
}
