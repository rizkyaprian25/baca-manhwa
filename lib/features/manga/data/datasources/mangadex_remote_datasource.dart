import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/mangadex_api.dart';
import '../../domain/entities/manga.dart';
import '../../domain/repositories/manga_repository.dart';
import '../models/manga_model.dart';

/// Remote datasource MangaDex — `lib/features/manga/data/datasources/mangadex_remote_datasource.dart`.
/// Melempar [MangaDexException] (ramah UI) saat Dio gagal.
class MangadexRemoteDataSource {
  MangadexRemoteDataSource(this._api);
  final MangadexApi _api;

  Future<T> _guard<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw MangaDexException.fromDio(e);
    }
  }

  Future<MangaPage> search(
    MangaFilter filter, {
    int limit = 20,
    int offset = 0,
  }) =>
      _guard(() async {
        final json = await _api.getMangaList(
          title: filter.title,
          includedTags: filter.includedTags,
          status: filter.status,
          contentRating: filter.contentRating,
          year: filter.year,
          order: filter.order,
          limit: limit,
          offset: offset,
          translatedLanguage: filter.languages,
        );
        final items = mangaListFromJson(json);
        final total = (json['total'] as int?) ?? items.length;
        return MangaPage(
          items: items,
          total: total,
          hasMore: offset + items.length < total,
        );
      });

  Future<List<Manga>> trending({int limit = 10}) => _guard(() async {
        final json = await _api.getMangaList(
          order: const {'followedCount': 'desc'},
          contentRating: const ['safe', 'suggestive', 'erotica'],
          limit: limit,
        );
        return mangaListFromJson(json);
      });

  Future<List<Manga>> latestUpdates({int limit = 10}) => _guard(() async {
        final json = await _api.getMangaList(
          order: const {'latestUploadedChapter': 'desc'},
          contentRating: const ['safe', 'suggestive', 'erotica'],
          limit: limit,
        );
        return mangaListFromJson(json);
      });

  Future<List<Manga>> recommended(List<String> tagIds, {int limit = 10}) =>
      _guard(() async {
        final json = await _api.getMangaList(
          includedTags: tagIds,
          order: const {'followedCount': 'desc'},
          contentRating: const ['safe', 'suggestive'],
          limit: limit,
        );
        return mangaListFromJson(json);
      });

  Future<List<MangaTag>> tags({String group = 'genre'}) => _guard(() async {
        final json = await _api.getTags();
        return tagListFromJson(json, group: group);
      });

  Future<Manga> detail(String mangaId) => _guard(() async {
        final json = await _api.getManga(mangaId);
        return mangaFromJson(json);
      });

  /// Ambil SEMUA halaman feed (loop offset) — feed max 100/req.
  Future<List<ChapterInfo>> feed(
    String mangaId, {
    List<String> languages = const ['id', 'en'],
    String order = 'asc',
  }) =>
      _guard(() async {
        final all = <ChapterInfo>[];
        var offset = 0;
        const limit = 100;
        while (true) {
          final json = await _api.getFeed(
            mangaId,
            languages: languages,
            order: order,
            limit: limit,
            offset: offset,
          );
          final data = (json['data'] as List?) ?? [];
          for (final e in data) {
            all.add(
              chapterFromJson(Map<String, dynamic>.from(e as Map), mangaId),
            );
          }
          final total = (json['total'] as int?) ?? data.length;
          offset += data.length;
          if (data.isEmpty || offset >= total || offset >= 500) break;
        }
        return all;
      });

  Future<AtHome> atHome(String chapterId) => _guard(() async {
        final json = await _api.getAtHome(chapterId);
        return atHomeFromJson(json);
      });
}
