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
  /// meta_value_num (peringkat). Tiap kombinasi = MAKS 10 item halaman-1.
  /// TABEL KEBENARAN server (Fase 28, diverifikasi ulang via curl):
  /// - `page` DIABAIKAN di semua kombinasi (hal. 2 = hal. 1 identik).
  /// - `paged` mengembalikan KOSONG untuk endpoint list maupun search.
  /// - `status` DIABAIKAN total -> filter status wajib verifikasi detail.
  /// - `sorttime` (daily/weekly) MATI (isinya = list polos).
  /// - View berbeda yang MASIH jalan: modified | date | meta_value_num,
  ///   masing-masing bisa dikombinasikan dengan `genre` (+`genre2`).
  /// Strategi repo: gabung semua view halaman-1 yang relevan secara
  /// paralel, dedupe per id, urut di klien (pembaca desc / menit-lalu
  /// asc) -> pool jujur untuk slice + infinite scroll.
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
    if (page > 1) params['page'] = page;
    final res = await _dio.get<String>(
      '$api/manga/',
      queryParameters: params,
    );
    return res.data ?? '';
  }

  /// Search judul: SATU halaman (~8-10 hasil), tanpa paginasi.
  /// `page` mengulang hal. 1, `paged` mengembalikan kosong (Fase 28).
  Future<String> searchPage(String query, {int page = 1}) async {
    final res = await _dio.get<String>(
      '$api/',
      queryParameters: {
        'post_type': 'manga',
        's': query,
        'tipe': 'manhwa',
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
