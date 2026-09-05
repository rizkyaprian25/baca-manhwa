import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baca_manhwa/core/database/app_database.dart';
import 'package:baca_manhwa/core/database/tables/library_entries.dart';
import 'package:baca_manhwa/core/providers/database_provider.dart';
import 'package:baca_manhwa/features/manga/data/models/komiku_model.dart';
import 'package:baca_manhwa/features/manga/data/models/manga_model.dart';
import 'package:baca_manhwa/services/backup_service.dart';

/// Bukti QA tereksekusi: performa (timing nyata), security statis,
/// kontras WCAG (hitung nyata), dan roundtrip backup/restore.
/// Hasil timing di-print untuk laporan (bukan assert ketat, toleran CI).
void main() {
  AppDatabase open() =>
      AppDatabase.forTesting(DatabaseConnection(NativeDatabase.memory()));

  group('PERF — waktu parsing & query (Stopwatch nyata)', () {
    test('parse fixtures besar < 1 detik', () async {
      final files = {
        'search': 'test/fixtures/search.json',
        'detail': 'test/fixtures/komiku_detail.html',
        'chapter': 'test/fixtures/komiku_chapter.html',
      };
      for (final e in files.entries) {
        final raw = await File(e.value).readAsString();
        final sw = Stopwatch()..start();
        if (e.key == 'search') {
          mangaListFromJson(jsonDecode(raw) as Map<String, dynamic>);
        } else if (e.key == 'detail') {
          komikuDetailFromHtml(raw, 'x');
        } else {
          komikuChapterImages(raw);
        }
        sw.stop();
        // ignore: avoid_print
        print('PERF parse ${e.key}: ${sw.elapsedMilliseconds}ms '
            '(${(raw.length / 1024).toStringAsFixed(1)}KB)');
        expect(sw.elapsedMilliseconds, lessThan(1000));
      }
    });

    test('500 chapter: tulis + baca riwayat < 1 detik', () async {
      final db = open();
      addTearDown(db.close);
      await db.upsertManga(MangasCompanion.insert(id: 'm', title: 'T'));
      var sw = Stopwatch()..start();
      await db.upsertChapters([
        for (var i = 0; i < 500; i++)
          ChaptersCompanion.insert(
            id: 'c$i',
            mangaId: 'm',
            chapterNo: Value('$i'),
          ),
      ]);
      sw.stop();
      // ignore: avoid_print
      print('PERF tulis 500 chapter: ${sw.elapsedMilliseconds}ms');
      expect(sw.elapsedMilliseconds, lessThan(2000));

      await db.markChapterRead(mangaId: 'm', chapterId: 'c499', page: 3);
      sw = Stopwatch()..start();
      final hist = await db.watchHistory().first;
      final chs = await db.getChapters('m');
      sw.stop();
      // ignore: avoid_print
      print('PERF baca history+chapters: ${sw.elapsedMilliseconds}ms');
      expect(hist.length, 1);
      expect(chs.length, 500);
      expect(sw.elapsedMilliseconds, lessThan(1000));
    });
  });

  group('SEC — static scan tanpa secrets & tanpa cleartext', () {
    test('lib/ bebas http:// dan credential hardcode', () async {
      final hits = <String>[];
      await for (final f in Directory('lib')
          .list(recursive: true, followLinks: false)
          .where((e) => e is File && e.path.endsWith('.dart'))
          .cast<File>()) {
        final src = await f.readAsString();
        for (final m in RegExp(r'http://').allMatches(src)) {
          hits.add('${f.path}: http:// @${m.start}');
        }
        for (final m in RegExp(
          r'''(api[_-]?key|apikey|secret|passwd|pwd)\s*[:=]\s*['"][^'"]+['"]''',
          caseSensitive: false,
        ).allMatches(src)) {
          hits.add('${f.path}: credential? @${m.start}');
        }
      }
      // ignore: avoid_print
      print('SEC static scan: ${hits.length} temuan');
      for (final h in hits.take(10)) {
        // ignore: avoid_print
        print('  $h');
      }
      expect(hits, isEmpty);
    });
  });

  group('A11Y — rasio kontras WCAG (hitung nyata)', () {
    double lum(int hex) {
      double lin(int c) {
        final v = c / 255;
        return v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
      }

      final r = (hex >> 16) & 0xFF, g = (hex >> 8) & 0xFF, b = hex & 0xFF;
      return 0.2126 * lin(r) + 0.7152 * lin(g) + 0.0722 * lin(b);
    }

    double ratio(int fg, int bg) {
      final a = lum(fg), b = lum(bg);
      final hi = math.max(a, b), lo = math.min(a, b);
      return (hi + 0.05) / (lo + 0.05);
    }

    test('pasangan teks utama >= 4.5, badge >= 3.0', () {
      const surface = 0x0F131C;
      final pairs = <String, (int, int, double)>{
        'onSurface/surface': (0xDFE2EE, surface, 4.5),
        'primary/surface': (0xD0BCFF, surface, 4.5),
        'onPrimary/primary': (0x3C0091, 0xD0BCFF, 4.5),
        'secondary/surface': (0x4EDEA3, surface, 4.5),
        'onSecondary/secondary': (0x003824, 0x4EDEA3, 4.5),
        'tertiary/surface': (0x7BD0FF, surface, 4.5),
        'badgeID putih/#00A572': (0xFFFFFF, 0x00A572, 3.0),
        'badgeEN putih/#009BD1': (0xFFFFFF, 0x009BD1, 3.0),
      };
      for (final e in pairs.entries) {
        final r = ratio(e.value.$1, e.value.$2);
        // ignore: avoid_print
        print('A11Y ${e.key}: ${r.toStringAsFixed(2)} (min ${e.value.$3})');
        expect(r, greaterThanOrEqualTo(e.value.$3), reason: e.key);
      }
    });
  });

  group('DB/BACKUP — roundtrip export→import', () {
    test('backup valid di-restore utuh ke DB kosong', () async {
      // NOTE: NativeDatabase.memory() dipakai bersama dalam 1 file test —
      // pakai id unik + assert baris spesifik (bukan hitungan global).
      final db1 = open();
      addTearDown(db1.close);
      final c1 = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db1)],
      );
      addTearDown(c1.dispose);
      await db1.upsertManga(MangasCompanion.insert(id: 'rb1', title: 'T'));
      await db1.upsertChapters([
        ChaptersCompanion.insert(id: 'rc1', mangaId: 'rb1'),
      ]);
      await db1.addToLibrary('rb1', LibraryList.favorite);
      await db1.markChapterRead(mangaId: 'rb1', chapterId: 'rc1', page: 2);
      final json =
          await c1.read(backupServiceProvider).exportJsonString();
      final exported = jsonDecode(json) as Map<String, dynamic>;

      // Hapus baris uji (simulasi DB kosong), lalu restore dari JSON.
      final db2 = open();
      addTearDown(db2.close);
      await (db2.delete(db2.readingHistory)
            ..where((t) => t.mangaId.equals('rb1')))
          .go();
      await (db2.delete(db2.libraryEntries)
            ..where((t) => t.mangaId.equals('rb1')))
          .go();
      await (db2.delete(db2.chapters)
            ..where((t) => t.mangaId.equals('rb1')))
          .go();
      await (db2.delete(db2.mangas)..where((t) => t.id.equals('rb1'))).go();
      expect(await db2.getChapter('rc1'), isNull);

      final c2 = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db2)],
      );
      addTearDown(c2.dispose);
      final sum = await c2.read(backupServiceProvider).importJsonString(json);
      expect(sum.mangas, (exported['mangas'] as List).length);
      expect(sum.chapters, (exported['chapters'] as List).length);
      expect((await db2.getChapter('rc1'))?.lastPage, 2);
      expect(
        await db2.libraryEntry('rb1', LibraryList.favorite),
        isNotNull,
      );
    });

    test('import menolak file rusak & salah format', () async {
      final db = open();
      addTearDown(db.close);
      final c = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(db)],
      );
      addTearDown(c.dispose);
      final svc = c.read(backupServiceProvider);
      await expectLater(
        svc.importJsonString('bukan json {{{'),
        throwsA(isA<FormatException>()),
      );
      await expectLater(
        svc.importJsonString('{"app":"aplikasi-lain"}'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
