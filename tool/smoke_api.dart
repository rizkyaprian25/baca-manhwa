// ignore_for_file: avoid_print
import 'package:baca_manhwa/core/network/dio_client.dart';
import 'package:baca_manhwa/core/network/mangadex_api.dart';
import 'package:baca_manhwa/features/manga/data/datasources/mangadex_remote_datasource.dart';
import 'package:baca_manhwa/features/manga/domain/repositories/manga_repository.dart';

/// Smoke test live MangaDex (sementara, bukan bagian app).
Future<void> main() async {
  final ds = MangadexRemoteDataSource(MangadexApi(DioClient.create()));

  final trending = await ds.trending(limit: 5);
  print('TRENDING: ${trending.length}');
  for (final m in trending) {
    print(' - ${m.title} [${m.status}] cover=${m.coverUrl != null}');
  }

  final page = await ds.search(
    const MangaFilter(title: 'solo leveling'),
    limit: 3,
  );
  print('SEARCH solo leveling: ${page.items.length} (total ${page.total})');
  for (final m in page.items) {
    print(' - ${m.title} (${m.id}) by ${m.author}');
  }

  if (page.items.isNotEmpty) {
    final id = page.items.first.id;
    final detail = await ds.detail(id);
    print('DETAIL: ${detail.title} tags=${detail.tags.length} '
        'desc=${(detail.description ?? '').length} chars');
    final feed = await ds.feed(id, languages: const ['id', 'en']);
    print('FEED: ${feed.length} chapters');
    final idCh = feed.where((c) => c.language == 'id').length;
    print('FEED-ID: $idCh chapters bahasa Indonesia');
    if (feed.isNotEmpty) {
      final at = await ds.atHome(feed.first.id);
      print('ATHOME: baseUrl=${at.baseUrl} pages=${at.pageCount}');
      print('PAGE0: ${at.pageUrl(0, dataSaver: true)}');
    }
  }
  print('SMOKE OK');
}
