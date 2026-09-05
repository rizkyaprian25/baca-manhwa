import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

/// HTTP client MangaDex: throttle max 5 rps + retry 429 (hormati
/// header `Retry-After`, backoff eksponensial, max 3x).
/// `lib/core/network/dio_client.dart`.
class DioClient {
  DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'User-Agent': AppConstants.userAgent},
      ),
    );
    dio.interceptors.add(_ThrottleInterceptor());
    dio.interceptors.add(_RetryOnRateLimitInterceptor(dio));
    return dio;
  }

  /// Client untuk sumber HTML (Komiku): UA browser + plain text.
  static Dio createBrowser() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 25),
        responseType: ResponseType.plain,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
                  '(KHTML, like Gecko) Chrome/120.0 Mobile Safari/537.36',
          'Accept-Language': 'id-ID,id;q=0.9,en;q=0.8',
        },
      ),
    );
    dio.interceptors.add(_ThrottleInterceptor());
    return dio;
  }
}

/// Token-bucket sederhana: maksimal [AppConstants.maxRequestsPerSecond]
/// request per detik (global, semua endpoint).
class _ThrottleInterceptor extends Interceptor {
  final List<DateTime> _hits = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final now = DateTime.now();
    _hits.removeWhere((t) => now.difference(t).inMilliseconds >= 1000);
    if (_hits.length >= AppConstants.maxRequestsPerSecond) {
      final oldest = _hits.first;
      final wait =
          const Duration(milliseconds: 1000) - now.difference(oldest);
      if (!wait.isNegative) await Future.delayed(wait);
    }
    _hits.add(DateTime.now());
    handler.next(options);
  }
}

class _RetryOnRateLimitInterceptor extends Interceptor {
  _RetryOnRateLimitInterceptor(this._dio);
  final Dio _dio;
  static const int _maxRetries = 3;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final status = err.response?.statusCode;
    final retries = (err.requestOptions.extra['retries'] as int?) ?? 0;
    if (status == 429 && retries < _maxRetries) {
      final retryAfter = _secondsFromRetryAfter(
        err.response?.headers.value('retry-after'),
      );
      // Backoff eksponensial bila server tidak memberi Retry-After.
      final wait = retryAfter ?? Duration(seconds: 1 << retries);
      await Future.delayed(wait);
      try {
        final opts = err.requestOptions..extra['retries'] = retries + 1;
        final res = await _dio.fetch(opts);
        return handler.resolve(res);
      } catch (_) {
        // Gagal lagi — teruskan error asli ke UI.
      }
    }
    handler.next(err);
  }

  Duration? _secondsFromRetryAfter(String? value) {
    if (value == null) return null;
    final secs = int.tryParse(value.trim());
    return secs == null ? null : Duration(seconds: secs);
  }
}

/// Error API yang ramah UI (dipetakan dari [DioException]).
class MangaDexException implements Exception {
  MangaDexException(this.message, {this.retryAfter});
  final String message;
  final Duration? retryAfter;

  bool get isRateLimited => retryAfter != null;
  bool get isOffline => message == _offline;

  static const _offline = 'offline';

  factory MangaDexException.fromDio(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.unknown &&
            e.message?.contains('SocketException') == true) {
      return MangaDexException(_offline);
    }
    final status = e.response?.statusCode;
    if (status == 429) {
      final ra = e.response?.headers.value('retry-after');
      final secs = int.tryParse((ra ?? '').trim());
      return MangaDexException(
        'Terlalu sering meminta ke MangaDex. Coba lagi'
        '${secs != null ? ' dalam $secs detik' : ''}.',
        retryAfter: Duration(seconds: secs ?? 5),
      );
    }
    if (status != null && status >= 500) {
      return MangaDexException('Server MangaDex bermasalah ($status). Coba lagi.');
    }
    if (status == 404) {
      return MangaDexException('Data tidak ditemukan di MangaDex.');
    }
    return MangaDexException('Gagal memuat data. Periksa koneksi lalu coba lagi.');
  }

  @override
  String toString() => message;
}
