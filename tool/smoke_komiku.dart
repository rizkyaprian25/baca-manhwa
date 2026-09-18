// ignore_for_file: avoid_print
import 'package:baca_manhwa/core/network/dio_client.dart';
import 'package:baca_manhwa/core/network/komiku_api.dart';
import 'package:baca_manhwa/features/manga/data/datasources/komiku_remote_datasource.dart';

/// Smoke test live Komiku (sementara, bukan bagian app).
Future<void> main() async {
  final ds = KomikuRemoteDataSource(KomikuApi(DioClient.createBrowser()));

  final trending = await ds.listPage(orderby: 'meta_value_num');
  print('TRENDING: ${trending.length} — pertama: ${trending.first.title}');

  final latest = await ds.listPage();
  print('LATEST P1: ${latest.length} — pertama: ${latest.first.title}');
  final latestP2 = await ds.listPage(page: 2);
  print('LATEST P2: ${latestP2.length} — pertama: ${latestP2.first.title}');

  final found = await ds.searchPage('the');
  print('SEARCH P1 "the": ${found.length} — pertama: ${found.first.title}');
  final foundP2 = await ds.searchPage('the', page: 2);
  print('SEARCH P2 "the": ${foundP2.length} — pertama: ${foundP2.first.title}');

  final slug = found.isNotEmpty
      ? found.first.id.substring(2)
      : 'song-baek';
  final detail = await ds.detail(slug);
  print('DETAIL: ${detail.manga.title} tags=${detail.manga.tags.length} '
      'feed=${detail.feed.length}');
  print('FIRST CH: ${detail.feed.first.id} no=${detail.feed.first.chapterNo}');

  final imgs = await ds.chapterImages(
    detail.feed.first.id.split(':').sublist(2).join(':'),
  );
  print('IMAGES: ${imgs.length} pertama=${imgs.first}');
  print('SMOKE KOMIKU OK');
}

