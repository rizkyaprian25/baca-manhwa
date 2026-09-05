import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:baca_manhwa/features/manga/data/models/komiku_model.dart';

/// Parsing HTML ASLI Komiku (fixtures test/fixtures/komiku_*.html).
Future<String> _fixture(String name) =>
    File('test/fixtures/$name').readAsString();

void main() {
  test('list: 10 item + slug + cover + chapter terbaru', () async {
    final items = komikuListFromHtml(await _fixture('komiku_list.html'));
    expect(items.length, 10);
    final first = items.first;
    expect(first.id, 'k:baek-xx');
    expect(first.title, 'Baek XX');
    expect(first.coverUrl, contains('thumbnail.komiku.'));
    expect(first.latestChapter, '194');
    expect(first.followedCount, 1600000);
    expect(first.updateAgo, '18 menit lalu');
    expect(items.every((m) => m.title.isNotEmpty), true);
  });

  test('detail: meta + genre + feed 89 chapter', () async {
    final res = komikuDetailFromHtml(
      await _fixture('komiku_detail.html'),
      'song-baek',
    );
    expect(res.manga.id, 'k:song-baek');
    expect(res.manga.title, 'Song Baek');
    expect(res.manga.author, 'Wondong Lee');
    expect(res.manga.status, 'ongoing');
    expect(res.manga.coverUrl, contains('thumbnail.komiku.'));
    expect(
      res.manga.tags.map((t) => t.id),
      containsAll(['action', 'martial-arts']),
    );
    expect(res.manga.description, isNotNull);
    expect(res.feed.length, 89);
    final first = res.feed.first;
    expect(first.id, startsWith('k:song-baek:'));
    expect(first.mangaId, 'k:song-baek');
    expect(first.chapterNo, '89');
    expect(first.language, 'id');
    expect(first.publishAt, DateTime(2026, 9, 5));
  });

  test('chapter: 195 gambar direct-URL', () async {
    final urls =
        komikuChapterImages(await _fixture('komiku_chapter.html'));
    expect(urls.length, 195);
    expect(urls.every((u) => u.startsWith('https://')), true);
    expect(urls.first, contains('uploads2/'));
  });

  test('helper: prettify + readers + slug', () {
    expect(prettifyChapter('59-5'), '59.5');
    expect(prettifyChapter('01'), '01');
    expect(parseReaders('1.6jt pembaca'), 1600000);
    expect(parseReaders('502rb pembaca'), 502000);
    expect(parseReaders('3.1jt pembaca'), 3100000);
    expect(mangaSlugOf('https://komiku.org/manga/song-baek/'), 'song-baek');
    expect(
      chapterSlugOf('/song-baek-chapter-89/'),
      'song-baek-chapter-89',
    );
  });
}
