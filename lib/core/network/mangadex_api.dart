import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

/// Wrapper endpoint MangaDex yang dipakai aplikasi.
/// `lib/core/network/mangadex_api.dart`.
/// Selalu kembalikan JSON mentah (`Map`) — parsing ada di layer model.
class MangadexApi {
  MangadexApi(this._dio);
  final Dio _dio;

  static const List<String> defaultIncludes = [
    'cover_art',
    'author',
    'artist',
  ];

  /// GET /manga — daftar & pencarian.
  Future<Map<String, dynamic>> getMangaList({
    String? title,
    List<String>? includedTags,
    List<String>? excludedTags,
    List<String>? status,
    List<String>? contentRating,
    int? year,
    Map<String, String>? order,
    int limit = AppConstants.apiPageSize,
    int offset = 0,
    List<String> includes = defaultIncludes,
    List<String>? translatedLanguage,
  }) async {
    final params = <String, dynamic>{
      'limit': limit,
      'offset': offset,
      'includes[]': includes,
    };
    if (title != null && title.isNotEmpty) params['title'] = title;
    if (includedTags != null && includedTags.isNotEmpty) {
      params['includedTags[]'] = includedTags;
    }
    if (excludedTags != null && excludedTags.isNotEmpty) {
      params['excludedTags[]'] = excludedTags;
    }
    if (status != null && status.isNotEmpty) params['status[]'] = status;
    if (contentRating != null && contentRating.isNotEmpty) {
      params['contentRating[]'] = contentRating;
    }
    if (year != null) params['year'] = year;
    if (order != null) {
      for (final e in order.entries) {
        params['order[${e.key}]'] = e.value;
      }
    }
    if (translatedLanguage != null && translatedLanguage.isNotEmpty) {
      params['availableTranslatedLanguage[]'] = translatedLanguage;
    }
    final res = await _dio.get<Map<String, dynamic>>(
      '/manga',
      queryParameters: params,
    );
    return res.data ?? const {};
  }

  /// GET /manga/{id} — detail satu judul.
  Future<Map<String, dynamic>> getManga(String id) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/manga/$id',
      queryParameters: {'includes[]': defaultIncludes},
    );
    return (res.data?['data'] as Map<String, dynamic>?) ?? const {};
  }

  /// GET /manga/{id}/feed — daftar chapter (filter bahasa di server).
  Future<Map<String, dynamic>> getFeed(
    String mangaId, {
    List<String> languages = const ['id', 'en'],
    String order = 'asc',
    int limit = 100,
    int offset = 0,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/manga/$mangaId/feed',
      queryParameters: {
        'translatedLanguage[]': languages,
        'order[volume]': order,
        'order[chapter]': order,
        'limit': limit,
        'offset': offset,
        'includeEmptyPages': 0,
      },
    );
    return res.data ?? const {};
  }

  /// GET /at-home/server/{chapterId} — base URL + daftar file gambar.
  /// WAJIB dipanggil fresh tiap buka chapter (URL sementara).
  Future<Map<String, dynamic>> getAtHome(String chapterId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/at-home/server/$chapterId',
    );
    return res.data ?? const {};
  }

  /// GET /manga/tag — daftar semua tag (untuk filter genre).
  Future<Map<String, dynamic>> getTags() async {
    final res = await _dio.get<Map<String, dynamic>>('/manga/tag');
    return res.data ?? const {};
  }

  /// Resolve URL cover dari id manga + nama file cover_art.
  static String coverUrl(String mangaId, String fileName, {int size = 512}) =>
      '${AppConstants.coverBaseUrl}/covers/$mangaId/$fileName.$size.jpg';

  /// URL satu halaman chapter dari payload at-home.
  static String pageUrl({
    required String baseUrl,
    required String hash,
    required String fileName,
    required bool dataSaver,
  }) =>
      '$baseUrl/${dataSaver ? 'data-saver' : 'data'}/$hash/$fileName';
}
