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

  /// Daftar pustaka: orderby modified (terbaru) | date (rilis) |
  /// meta_value_num (peringkat). Paginasi server Komiku menggunakan path
  /// `/manga/page/{n}/` (sesuai HTMX pagination asli komiku.org).
  Future<String> listPage({
    String orderby = 'modified',
    String? sorttime,
    String? genre,
    String? genre2,
    String? status,
    int page = 1,
  }) async {
    final params = <String, dynamic>{
      'tipe': 'manhwa',
      'orderby': orderby,
    };
    if (sorttime != null) params['sorttime'] = sorttime;
    if (genre != null && genre.isNotEmpty) params['genre'] = genre;
    if (genre2 != null && genre2.isNotEmpty) params['genre2'] = genre2;
    if (status != null && status.isNotEmpty) params['status'] = status;
    final path = page > 1 ? '$api/manga/page/$page/' : '$api/manga/';
    final res = await _dio.get<String>(
      path,
      queryParameters: params,
    );
    return res.data ?? '';
  }

  /// Search judul: mendukung paginasi server via parameter `paged`.
  Future<String> searchPage(String query, {int page = 1}) async {
    final params = <String, dynamic>{
      'post_type': 'manga',
      's': query,
      'tipe': 'manhwa',
    };
    if (page > 1) {
      params['paged'] = page;
    }
    final res = await _dio.get<String>(
      '$api/',
      queryParameters: params,
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
