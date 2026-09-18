import 'package:flutter_test/flutter_test.dart';

import 'package:baca_manhwa/core/database/app_database.dart';
import 'package:baca_manhwa/core/utils/content_rating_filter.dart';
import 'package:baca_manhwa/core/utils/number_formatter.dart';
import 'package:baca_manhwa/features/manga/data/mappers/manga_mapper.dart';
import 'package:baca_manhwa/features/manga/data/models/komiku_model.dart';
import 'package:baca_manhwa/features/history/presentation/history_provider.dart';
import 'package:baca_manhwa/features/manga/domain/entities/manga.dart' as entity;
import 'package:baca_manhwa/features/manga/providers/manga_providers.dart';
import 'package:baca_manhwa/features/search/presentation/search_provider.dart';
import 'package:baca_manhwa/features/manga/domain/repositories/manga_repository.dart';
import 'package:baca_manhwa/features/manhwa_detail/presentation/detail_provider.dart';
import 'package:baca_manhwa/features/settings/presentation/settings_provider.dart';

/// Unit murni Fase 2 (tanpa network).
void main() {
  test('mangaRowToEntity: decode tags & altTitles JSON', () {
    const row = Manga(
      id: 'abc',
      title: 'Judul',
      altTitles: '["Alt 1","Alt 2"]',
      tags: '[{"id":"t1","name":"Action"},{"id":"t2","name":"Fantasy"}]',
    );
    final e = mangaRowToEntity(row);
    expect(e.id, 'abc');
    expect(e.altTitles, ['Alt 1', 'Alt 2']);
    expect(e.tags.map((t) => t.name), ['Action', 'Fantasy']);
    expect(mangaRowTagIds(row), ['t1', 't2']);
  });

  test('mangaRowToEntity: JSON rusak tidak crash', () {
    const row = Manga(id: 'x', title: 'Y', tags: 'bukan-json');
    final e = mangaRowToEntity(row);
    expect(e.tags, isEmpty);
    expect(mangaRowTagIds(row), isEmpty);
  });

  test('MangaFilter.copyWith: set & clear year', () {
    const f = MangaFilter();
    expect(f.copyWith(year: 2023).year, 2023);
    expect(f.copyWith(year: 2023, clearYear: true).year, isNull);
    // Filter lain tidak ikut ke-reset saat set year.
    final g = f.copyWith(title: 'solo', year: 2020).copyWith(title: 'solo leveling');
    expect(g.year, 2020);
  });

  test('ContentRatingFilter: sensor ON/OFF', () {
    expect(
      ContentRatingFilter.forQuery(adultFilterOn: true),
      ['safe', 'suggestive'],
    );
    expect(
      ContentRatingFilter.forQuery(adultFilterOn: false),
      contains('erotica'),
    );
  });

  test('sortChapters: numeric-aware, oneshot di depan (asc)', () {
    const rows = [
      Chapter(
          id: 'a',
          mangaId: 'm',
          chapterNo: '10',
          language: 'en',
          pages: 0,
          isRead: false,
          lastPage: 0),
      Chapter(
          id: 'b',
          mangaId: 'm',
          chapterNo: '2',
          language: 'en',
          pages: 0,
          isRead: false,
          lastPage: 0),
      Chapter(
          id: 'c',
          mangaId: 'm',
          chapterNo: '2.5',
          language: 'en',
          pages: 0,
          isRead: false,
          lastPage: 0),
      Chapter(
          id: 'd',
          mangaId: 'm',
          language: 'en',
          pages: 0,
          isRead: false,
          lastPage: 0),
    ];
    final asc = sortChapters(rows).map((c) => c.id).toList();
    expect(asc, ['d', 'b', 'c', 'a']);
    final desc = sortChapters(rows, ascending: false).map((c) => c.id).toList();
    expect(desc, ['a', 'c', 'b', 'd']);
  });

  test('mergeRecentSearches: unik, terbaru dulu, max 8', () {
    expect(mergeRecentSearches([], 'solo'), ['solo']);
    expect(mergeRecentSearches(['a', 'b'], 'B'), ['B', 'a']);
    expect(mergeRecentSearches(['a'], '  '), ['a']);
    final many = List.generate(10, (i) => 'q$i');
    final merged = mergeRecentSearches(many, 'baru');
    expect(merged.first, 'baru');
    expect(merged.length, 8);
  });

  test('decodeRecentSearches: aman dari rusak', () {
    expect(decodeRecentSearches(null), isEmpty);
    expect(decodeRecentSearches('bukan-json'), isEmpty);
    expect(
      decodeRecentSearches('["a","b"]'),
      ['a', 'b'],
    );
  });

  test('formatCompactId: gaya Indonesia', () {
    expect(formatCompactId(1600000), '1.6jt');
    expect(formatCompactId(16000000), '16jt');
    expect(formatCompactId(502000), '502rb');
    expect(formatCompactId(3100), '3.1rb');
    expect(formatCompactId(1000), '1rb');
    expect(formatCompactId(999), '999');
  });

  test('MangaFilter default: urut rating + opsi per sumber', () {
    expect(const MangaFilter().order.keys.first, 'rating');
    expect(
      searchOrdersFor('komiku').map((o) => o.$3),
      ['Rating', 'Terbaru'],
    );
    expect(searchOrdersFor('mangadex').length, 4);
  });

  Chapter mkChapter(String id, {bool read = false}) => Chapter(
        id: id,
        mangaId: 'm',
        language: 'id',
        pages: 10,
        isRead: read,
        lastPage: 0,
      );

  test('findContinueTarget: ikut riwayat terakhir (sinkron Pustaka)', () {
    final asc = [
      mkChapter('c1', read: true),
      mkChapter('c2'),
      mkChapter('c3')
    ];
    // Belum selesai -> chapter itu persis.
    expect(
      findContinueTarget(asc: asc, lastChapterId: 'c2')?.id,
      'c2',
    );
    // Sudah selesai -> sesudahnya yang belum dibaca.
    expect(
      findContinueTarget(asc: asc, lastChapterId: 'c1')?.id,
      'c2',
    );
    // Tanpa riwayat -> belum-dibaca pertama.
    expect(findContinueTarget(asc: asc)?.id, 'c2');
    // Semua selesai -> terakhir (baca ulang).
    final done = [mkChapter('c1', read: true), mkChapter('c2', read: true)];
    expect(findContinueTarget(asc: done)?.id, 'c2');
    // Kosong -> null.
    expect(findContinueTarget(asc: []), isNull);
    // Riwayat chapter yang sudah tak ada -> fallback belum-dibaca.
    expect(findContinueTarget(asc: asc, lastChapterId: 'hilang')?.id, 'c2');
  });

  HistoryWithData mkHist(String mangaId, int id) => HistoryWithData(
        history: ReadingHistoryData(
          id: id,
          mangaId: mangaId,
          chapterId: 'c$id',
          page: 0,
          readAt: DateTime(2026, 1, id),
        ),
        manga: Manga(id: mangaId, title: 'T$mangaId'),
        chapter: mkChapter('c$id'),
      );

  test('groupHistoryByManga: 1 baris per judul (terbaru)', () {
    final rows = [mkHist('m1', 3), mkHist('m2', 2), mkHist('m1', 1)];
    final grouped = groupHistoryByManga(rows);
    expect(grouped.map((h) => h.manga.id), ['m1', 'm2']);
    expect(grouped.first.history.id, 3);
  });

  test('mergeSearchPage: buang duplikat + stop bila tak ada baru', () {
    entity.Manga mk(String id) => entity.Manga(id: id, title: id);
    // Halaman 2 identik (kasus search Komiku) -> stop, tanpa duplikat.
    final r1 = mergeSearchPage(
      [mk('a'), mk('b')],
      entity.MangaPage(items: [mk('a'), mk('b')], total: 4, hasMore: true),
    );
    expect(r1.items.map((m) => m.id), ['a', 'b']);
    expect(r1.hasMore, false);
    // Halaman baru valid -> tambah + lanjut.
    final r2 = mergeSearchPage(
      [mk('a')],
      entity.MangaPage(items: [mk('b'), mk('c')], total: 10, hasMore: true),
    );
    expect(r2.items.map((m) => m.id), ['a', 'b', 'c']);
    expect(r2.hasMore, true);

    // Scroll bertahap melampaui 40 item (contoh 60 item) berjalan lancar
    var accumulated = <entity.Manga>[];
    for (var page = 1; page <= 6; page++) {
      final pageItems = List.generate(
        10,
        (i) => mk('manga_${(page - 1) * 10 + i + 1}'),
      );
      final merged = mergeSearchPage(
        accumulated,
        entity.MangaPage(items: pageItems, total: 100, hasMore: page < 6),
      );
      accumulated = merged.items;
      expect(merged.hasMore, page < 6);
    }
    expect(accumulated.length, 60);
    expect(accumulated.first.id, 'manga_1');
    expect(accumulated.last.id, 'manga_60');
  });

  test('titleMatchesQuery: kata utuh di judul (case-insensitive)', () {
    expect(titleMatchesQuery('Solo Leveling', 'solo'), true);
    expect(titleMatchesQuery('Solo Leveling', 'SOLO LEVELING'), true);
    expect(titleMatchesQuery('18-Year-Old Demon King', 'king'), true);
    // Bukan kata utuh -> tolak.
    expect(titleMatchesQuery('Bloodhound', 'blood'), false);
    expect(titleMatchesQuery('Aku closing Ranking', 'king'), false);
    // Semua kata harus ada.
    expect(titleMatchesQuery('Solo Leveling', 'solo solo'), true);
    expect(titleMatchesQuery('Solo Leveling', 'solo naruto'), false);
    // Query kosong -> lolos (dipakai browse).
    expect(titleMatchesQuery('Apapun', ''), true);
    expect(titleMatchesQuery('Apapun', 'a'), true);
  });

  test('komikuStatusMatches: ongoing vs tamat', () {
    expect(komikuStatusMatches('Ongoing', 'ongoing'), true);
    expect(komikuStatusMatches('ongoing', 'end'), false);
    expect(komikuStatusMatches('Tamat', 'end'), true);
    expect(komikuStatusMatches('Completed', 'end'), true);
    expect(komikuStatusMatches(null, 'ongoing'), false);
    expect(komikuStatusMatches('', 'end'), false);
  });

  test('searchStatusesFor: komiku tanpa hiatus', () {
    expect(
      searchStatusesFor('komiku').map((o) => o.$1),
      ['', 'ongoing', 'completed'],
    );
    expect(searchStatusesFor('mangadex').length, 4);
  });
}
