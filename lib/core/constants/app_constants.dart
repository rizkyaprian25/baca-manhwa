/// Konstanta global aplikasi — `lib/core/constants/app_constants.dart`.
class AppConstants {
  AppConstants._();

  static const String appName = 'Baca Manhwa';
  static const String appVersion = '1.0.0+1';
  static const String locale = 'id_ID';

  /// Versi skema Drift — naikkan tiap ada perubahan tabel + tulis migrasi.
  static const int dbVersion = 5;
  static const String dbName = 'baca_manhwa.db';

  // --- MangaDex ---
  static const String apiBaseUrl = 'https://api.mangadex.org';
  static const String coverBaseUrl = 'https://uploads.mangadex.org';
  static const String userAgent = 'BacaManhwa/1.0 (personal-use)';

  /// Batas request global ke MangaDex (patuhi rate limit: 5 req/detik).
  static const int maxRequestsPerSecond = 5;

  /// TTL cache metadata (judul/cover/tag) sebelum dianggap basi.
  static const Duration metadataCacheTtl = Duration(hours: 24);

  /// Debounce input pencarian (ms).
  static const int searchDebounceMs = 500;

  /// Jumlah halaman reader yang di-preload ke depan (dijaga 2 agar hemat bandwidth & tidak rebutan socket).
  static const int readerPreloadPages = 2;

  /// Ukuran halaman pagination API.
  static const int apiPageSize = 20;
}
