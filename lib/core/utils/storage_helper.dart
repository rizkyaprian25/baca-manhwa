import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';

/// Helper ukuran cache & download — `lib/core/utils/storage_helper.dart`.
class StorageHelper {
  StorageHelper._();

  /// Total ukuran image cache (memory+disk via CachedNetworkImage evict tidak
  /// mengembalikan byte persis; ini estimasi direktori cache aplikasi).
  static Future<int> appCacheBytes() async {
    var total = 0;
    final tmp = await getTemporaryDirectory();
    total += await _dirBytes(tmp);
    return total;
  }

  static Future<int> downloadsBytes() async {
    final docs = await getApplicationDocumentsDirectory();
    return _dirBytes(
      // ignore: avoid_slow_async_io
      docs,
    );
  }

  static Future<int> _dirBytes(dynamic dir) async {
    var total = 0;
    try {
      await for (final f in dir.list(recursive: true, followLinks: false)) {
        try {
          // ignore: avoid_slow_async_io
          final st = await f.stat();
          final size = st.size;
          if (size is int) total += size;
        } catch (_) {}
      }
    } catch (_) {}
    return total;
  }

  /// Hapus image cache (JANGAN hapus file download chapter).
  static Future<void> clearImageCache() async {
    await CachedNetworkImage.evictFromCache('');
    final tmp = await getTemporaryDirectory();
    try {
      await for (final f in tmp.list(followLinks: false)) {
        try {
          await f.delete(recursive: true);
        } catch (_) {}
      }
    } catch (_) {}
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';
    return '${(mb / 1024).toStringAsFixed(2)} GB';
  }
}
