import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stub Web: unduhan file tidak didukung (API sama agar kode pemanggil
/// tidak perlu branching platform).
/// `lib/features/download/data/download_manager_stub.dart`.
class DownloadManager {
  DownloadManager(Ref _);

  Future<void> enqueue(String mangaId, String chapterId) async {}
  Future<void> retry(String chapterId) async {}
  Future<void> remove(String chapterId) async {}
  Future<void> removeManga(String mangaId) async {}
  Future<List<String>?> localPages(String chapterId) async => null;
}
