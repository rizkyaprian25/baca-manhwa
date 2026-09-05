import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:baca_manhwa/features/manga/data/models/manga_model.dart';

/// Parsing payload ASLI MangaDex (fixtures di test/fixtures, diambil
/// 2026-09-05). Tidak butuh network — validasi mapping model.
Future<Map<String, dynamic>> _fixture(String name) async {
  final f = File('test/fixtures/$name');
  return jsonDecode(await f.readAsString()) as Map<String, dynamic>;
}

void main() {
  test('search: 3 item, judul ko-ro ter-resolve, cover valid', () async {
    final json = await _fixture('search.json');
    final items = mangaListFromJson(json);
    expect(items.length, 3);
    // Item pertama hanya punya judul ko-ro (tanpa en).
    expect(items.first.title.isNotEmpty, true);
    for (final m in items) {
      expect(m.id.isNotEmpty, true);
      if (m.coverUrl != null) {
        expect(
          m.coverUrl!,
          startsWith('https://uploads.mangadex.org/covers/${m.id}/'),
        );
      }
    }
  });

  test('detail entity: author/artist/tag/deskripsi terisi', () async {
    final wrap = await _fixture('detail_wrap.json');
    final manga = mangaFromJson(
      Map<String, dynamic>.from(wrap['data'] as Map),
    );
    expect(manga.title.isNotEmpty, true);
    expect(manga.author, isNotNull);
    expect(manga.artist, isNotNull);
    expect(manga.tags.isNotEmpty, true);
    expect(manga.description, isNotNull);
    expect(manga.coverUrl, startsWith('https://uploads.mangadex.org/covers/'));
  });

  test('feed: chapter EN ter-parse + displayTitle', () async {
    final json = await _fixture('feed.json');
    final data = (json['data'] as List).cast<Map<String, dynamic>>();
    final list = data.map((e) => chapterFromJson(e, 'manga-id')).toList();
    expect(list.isNotEmpty, true);
    expect(list.every((c) => c.language == 'en'), true);
    expect(list.first.displayTitle(), startsWith('Ch. '));
  });

  test('at-home: pageUrl data & data-saver terbentuk benar', () async {
    final json = await _fixture('athome.json');
    final at = atHomeFromJson(json);
    expect(at.baseUrl.startsWith('https://'), true);
    expect(at.pageCount, greaterThan(0));
    final hi = at.pageUrl(0, dataSaver: false);
    final lo = at.pageUrl(0, dataSaver: true);
    expect(hi, contains('/data/${at.hash}/'));
    expect(lo, contains('/data-saver/${at.hash}/'));
    expect(hi, startsWith(at.baseUrl));
  });
}
