import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baca_manhwa/core/database/app_database.dart';
import 'package:baca_manhwa/core/database/tables/library_entries.dart';
import 'package:baca_manhwa/core/providers/database_provider.dart';
import 'package:baca_manhwa/services/backup_service.dart';

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

  test('backup import tahan banting terhadap tipe heterogen & data yatim', () async {
    final db = open();
    addTearDown(db.close);
    final container = ProviderContainer(
      overrides: [databaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    final svc = container.read(backupServiceProvider);

    final malformedJson = '''
    {
      "app": "baca_manhwa",
      "backupVersion": 2,
      "settings": {
        "theme": "dark",
        "chapterLang": "en",
        "adultFilter": "true",
        "dataSaver": 1,
        "source": "mangadex",
        "autoScrollSpeed": "6.5",
        "recentSearches": ["solo", "leveling"]
      },
      "mangas": [
        {
          "id": "res_m1",
          "title": "Resilient Manhwa",
          "altTitles": ["Judul Alternatif 1", "Judul Alternatif 2"],
          "tags": [{"id": "t1", "name": "Action"}],
          "year": "2023"
        }
      ],
      "chapters": [
        {
          "id": "res_c1",
          "mangaId": "res_m1",
          "title": "Ch 1",
          "pages": "25",
          "lastPage": "12",
          "isRead": 1
        },
        {
          "id": "orphan_c",
          "mangaId": "non_existent_manga",
          "title": "Orphan Ch"
        }
      ],
      "library": [
        {
          "mangaId": "res_m1",
          "listType": "favorite"
        },
        {
          "mangaId": "non_existent_manga",
          "listType": "reading"
        }
      ],
      "history": [
        {
          "mangaId": "res_m1",
          "chapterId": "res_c1",
          "page": "12"
        },
        {
          "mangaId": "res_m1",
          "chapterId": "non_existent_chapter",
          "page": "5"
        }
      ]
    }
    ''';

    final summary = await svc.importJsonString(malformedJson);
    expect(summary.mangas, 1);
    expect(summary.chapters, 1);
    expect(summary.library, 1);
    expect(summary.history, 1);

    final m = await (db.select(db.mangas)..where((t) => t.id.equals('res_m1'))).getSingle();
    expect(m.year, 2023);
    expect(m.altTitles, contains('Judul Alternatif 1'));
    expect(m.tags, contains('Action'));

    final ch = await db.getChapter('res_c1');
    expect(ch?.pages, 25);
    expect(ch?.lastPage, 12);
    expect(ch?.isRead, true);

    final s = await db.getSettings();
    expect(s.theme, 'dark');
    expect(s.source, 'mangadex');
    expect(s.autoScrollSpeed, 6.5);
    expect(s.recentSearches, contains('solo'));
  });
}
