import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baca_manhwa/core/database/app_database.dart';
import 'package:baca_manhwa/core/database/tables/library_entries.dart';

/// Test DB in-memory: seed, cache, alur baca, library, history.
void main() {
  AppDatabase open() =>
      AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));

  test('seed settings default', () async {
    final db = open();
    addTearDown(db.close);
    final s = await db.getSettings();
    expect(s.theme, 'system');
    expect(s.chapterLang, 'id');
    expect(s.adultFilter, true);
    expect(s.source, 'komiku');
    expect(s.autoScrollSpeed, 4.0);
  });

  test('markChapterRead: progress + history + auto-reading', () async {
    final db = open();
    addTearDown(db.close);
    await db.upsertManga(
      MangasCompanion.insert(id: 'm1', title: 'Judul'),
    );
    await db.upsertChapters([
      ChaptersCompanion.insert(id: 'c1', mangaId: 'm1'),
    ]);
    await db.markChapterRead(mangaId: 'm1', chapterId: 'c1', page: 3);

    final ch = await db.getChapter('c1');
    expect(ch?.lastPage, 3);
    expect(ch?.isRead, false);

    final lib = await db.libraryEntry('m1', LibraryList.reading);
    expect(lib, isNotNull);

    final hist = await db.watchHistory().first;
    expect(hist.length, 1);
    expect(hist.first.manga.title, 'Judul');

    await db.markChapterRead(
      mangaId: 'm1',
      chapterId: 'c1',
      page: 10,
      finished: true,
    );
    expect((await db.getChapter('c1'))?.isRead, true);
  });

  test('library add/remove + unduhan roundtrip', () async {
    final db = open();
    addTearDown(db.close);
    await db.upsertManga(
      MangasCompanion.insert(id: 'm2', title: 'Fav'),
    );
    await db.addToLibrary('m2', LibraryList.favorite);
    var tab = await db.watchLibrary(LibraryList.favorite).first;
    expect(tab.length, 1);
    await db.removeFromLibrary('m2', LibraryList.favorite);
    tab = await db.watchLibrary(LibraryList.favorite).first;
    expect(tab, isEmpty);

    await db.upsertChapters([
      ChaptersCompanion.insert(id: 'c9', mangaId: 'm2'),
    ]);
    await db.upsertDownload(
      DownloadsCompanion.insert(mangaId: 'm2', chapterId: 'c9'),
    );
    expect((await db.getDownload('c9'))?.status, 'queue');
    await db.updateDownload(
      'c9',
      const DownloadsCompanion(status: Value('done'), donePages: Value(5)),
    );
    expect((await db.watchDownload('c9').first)?.donePages, 5);
  });
}
