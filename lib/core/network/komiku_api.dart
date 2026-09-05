import 'package:dio/dio.dart';

/// Endpoint HTML Komiku (Bahasa Indonesia).
/// List/search lewat `api.komiku.org` (fragment HTML `.bge`),
/// detail & chapter lewat `komiku.org`.
/// `lib/core/network/komiku_api.dart`.
class KomikuApi {
  KomikuApi(this._dio);
  final Dio _dio;

  static const String site = 'https://komiku.org';
  static const String api = 'https://api.komiku.org';
  static const int pageSize = 10;

  /// Daftar pustaka: orderby modified (terbaru) | meta_value_num (peringkat).
  Future<String> listPage({
    String orderby = 'modified',
    String? sorttime,
    String? genre,
    String? status,
    int page = 1,
  }) async {
    final params = <String, dynamic>{
      'tipe': 'manhwa',
      'orderby': orderby,
    };
    if (sorttime != null) params['sorttime'] = sorttime;
    if (genre != null && genre.isNotEmpty) params['genre'] = genre;
    if (status != null && status.isNotEmpty) params['status'] = status;
    if (page > 1) params['page'] = page;
    final res = await _dio.get<String>(
      '$api/manga/',
      queryParameters: params,
    );
    return res.data ?? '';
  }

  /// NOTE: search pakai `paged` (bukan `page`) — `page` diabaikan server.
  Future<String> searchPage(String query, {int page = 1}) async {
    final res = await _dio.get<String>(
      '$api/',
      queryParameters: {
        'post_type': 'manga',
        's': query,
        'tipe': 'manhwa',
        if (page > 1) 'paged': page,
      },
    );
    return res.data ?? '';
  }

  Future<String> detailPage(String slug) async {
    final res = await _dio.get<String>('$site/manga/$slug/');
    return res.data ?? '';
  }

  Future<String> chapterPage(String chapterSlug) async {
    final res = await _dio.get<String>('$site/$chapterSlug/');
    return res.data ?? '';
  }
}
