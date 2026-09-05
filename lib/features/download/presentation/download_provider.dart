import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../data/download_backend.dart';

/// Provider download — `lib/features/download/presentation/download_provider.dart`.
final downloadManagerProvider =
    Provider<DownloadManager>((ref) => DownloadManager(ref));

final downloadsStreamProvider =
    StreamProvider<List<DownloadWithData>>((ref) {
  return ref.watch(databaseProvider).watchDownloadsWithManga();
});

/// Status 1 chapter (untuk tombol unduh di detail & reader offline).
final downloadOfProvider =
    StreamProvider.family<Download?, String>((ref, chapterId) {
  return ref.watch(databaseProvider).watchDownload(chapterId);
});

/// Total byte (refresh otomatis saat daftar berubah).
final totalDownloadBytesProvider = FutureProvider<int>((ref) async {
  ref.watch(downloadsStreamProvider);
  return ref.watch(databaseProvider).totalDownloadBytes();
});

/// Path halaman lokal (refresh saat status unduhan berubah).
final localPagesProvider =
    FutureProvider.family<List<String>?, String>((ref, chapterId) {
  ref.watch(downloadOfProvider(chapterId));
  return ref.watch(downloadManagerProvider).localPages(chapterId);
});
