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
  print('LATEST: ${latest.length} — pertama: ${latest.first.title}');

  final found = await ds.searchPage('solo leveling');
  print('SEARCH: ${found.length}');
  for (final m in found.take(3)) {
    print(' - ${m.title} (${m.id})');
  }

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
