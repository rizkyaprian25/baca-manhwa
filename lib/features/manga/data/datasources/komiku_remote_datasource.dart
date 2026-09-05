import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/komiku_api.dart';
import '../../domain/entities/manga.dart';
import '../models/komiku_model.dart' as k;

/// Remote datasource Komiku (scrape HTML, Bahasa Indonesia).
/// `lib/features/manga/data/datasources/komiku_remote_datasource.dart`.
class KomikuRemoteDataSource {
  KomikuRemoteDataSource(this._api);
  final KomikuApi _api;

  Future<T> _guard<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw MangaDexException.fromDio(e);
    }
  }

  Future<List<Manga>> listPage({
    String orderby = 'modified',
    String? genre,
    String? status,
    int page = 1,
  }) =>
      _guard(() async {
        final html = await _api.listPage(
          orderby: orderby,
          genre: genre,
          status: status,
          page: page,
        );
        return k.komikuListFromHtml(html);
      });

  Future<List<Manga>> searchPage(String query, {int page = 1}) =>
      _guard(() async {
        final html = await _api.searchPage(query, page: page);
        return k.komikuListFromHtml(html);
      });

  Future<({Manga manga, List<ChapterInfo> feed})> detail(String slug) =>
      _guard(() async {
        final html = await _api.detailPage(slug);
        if (html.isEmpty) throw Exception('Halaman kosong');
        return k.komikuDetailFromHtml(html, slug);
      });

  Future<List<String>> chapterImages(String chapterSlug) => _guard(() async {
        final html = await _api.chapterPage(chapterSlug);
        return k.komikuChapterImages(html);
      });
}
