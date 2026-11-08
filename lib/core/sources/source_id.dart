/// Identifier & registry sumber komik — `lib/core/sources/source_id.dart`.
/// Single Source of Truth (SSOT) agar tidak ada magic strings 'komiku'/'mangadex' yang bertebaran.
class SourceId {
  SourceId._();

  static const String komiku = 'komiku';
  static const String mangadex = 'mangadex';

  /// Sumber default aplikasi.
  static const String defaultSource = komiku;

  /// Daftar sumber bawaan yang terdaftar resmi.
  static const List<String> allBuiltIn = [komiku, mangadex];

  /// Nama tampil ramah pengguna.
  static String displayName(String sourceId) => switch (sourceId) {
        komiku => 'Komiku (Indonesia)',
        mangadex => 'MangaDex (Global)',
        _ => sourceId.toUpperCase(),
      };

  /// Mendeteksi sourceId dari format ID manga global.
  /// Contoh:
  /// - `k:solo-leveling` -> 'komiku'
  /// - `mdx:a1b2c3d4` -> 'mangadex'
  /// - `custom:slug-manga` -> 'custom'
  /// - `a1b2c3d4-e5f6...` (UUID tanpa prefiks) -> 'mangadex' (kompatibilitas mundur v1.0)
  static String fromMangaId(String mangaId) {
    final trimmed = mangaId.trim();
    if (trimmed.startsWith('k:')) return komiku;
    if (trimmed.contains(':')) {
      final prefix = trimmed.substring(0, trimmed.indexOf(':'));
      if (prefix == 'mdx') return mangadex;
      if (prefix.isNotEmpty) return prefix;
    }
    return mangadex;
  }

  /// Membuat ID manga berprefiks standar.
  static String buildMangaId(String source, String slug) {
    if (source == komiku) {
      return slug.startsWith('k:') ? slug : 'k:$slug';
    }
    return '$source:$slug';
  }

  /// Mengekstrak slug murni tanpa prefiks sumber.
  static String extractSlug(String mangaId) {
    final trimmed = mangaId.trim();
    if (trimmed.startsWith('k:')) return trimmed.substring(2);
    final colonIdx = trimmed.indexOf(':');
    if (colonIdx != -1) return trimmed.substring(colonIdx + 1);
    return trimmed;
  }
}
