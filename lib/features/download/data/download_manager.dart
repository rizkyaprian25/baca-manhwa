import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/downloads.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/network_provider.dart';
import '../../manga/providers/manga_providers.dart';

/// Unduh chapter ke penyimpanan lokal untuk baca offline.
/// Antre FIFO, maks 2 konkuren, retry melanjutkan file yang sudah ada.
/// `lib/features/download/data/download_manager.dart`.
class DownloadManager {
  DownloadManager(this._ref);
  final Ref _ref;

  bool _pumping = false;
  int _active = 0;
  static const int maxConcurrent = 2;

  AppDatabase get _db => _ref.read(databaseProvider);

  Future<Directory> _chapterDir(String mangaId, String chapterId) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/downloads/$mangaId/$chapterId');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// Masuk antrean (idempoten; yang done/downloading/queue diabaikan).
  Future<void> enqueue(String mangaId, String chapterId) async {
    final existing = await _db.getDownload(chapterId);
    if (existing != null &&
        existing.status != DownloadStatus.failed) {
      return;
    }
    final ch = await _db.getChapter(chapterId);
    await _db.upsertDownload(
      DownloadsCompanion(
        mangaId: Value(mangaId),
        chapterId: Value(chapterId),
        status: const Value(DownloadStatus.queue),
        totalPages: Value(ch?.pages ?? 0),
        donePages: const Value(0),
      ),
    );
    _pump();
  }

  Future<void> retry(String chapterId) async {
    await _db.updateDownload(
      chapterId,
      const DownloadsCompanion(status: Value(DownloadStatus.queue)),
    );
    _pump();
  }

  /// Hapus 1 chapter (row + file fisik).
  Future<void> remove(String chapterId) async {
    final dl = await _db.getDownload(chapterId);
    if (dl?.localPath != null) {
      try {
        final d = Directory(dl!.localPath!);
        if (await d.exists()) await d.delete(recursive: true);
      } catch (_) {}
    }
    await _db.deleteDownload(chapterId);
  }

  /// Hapus semua download 1 judul (row + file fisik).
  Future<void> removeManga(String mangaId) async {
    final list = await _db.downloadsForManga(mangaId);
    for (final dl in list) {
      await remove(dl.chapterId);
    }
    // Bersihkan folder judul bila kosong.
    try {
      final docs = await getApplicationDocumentsDirectory();
      final dir = Directory('${docs.path}/downloads/$mangaId');
      if (await dir.exists()) {
        final rest = await dir.list().toList();
        if (rest.isEmpty) await dir.delete();
      }
    } catch (_) {}
  }

  Future<void> _pump() async {
    if (_pumping) return;
    _pumping = true;
    try {
      while (true) {
        final slots = maxConcurrent - _active;
        if (slots > 0) {
          final pend = await _db.pendingDownloads(limit: slots);
          for (final p in pend) {
            _active++;
            _run(p).whenComplete(() => _active--);
          }
        }
        if (_active == 0) {
          final more = await _db.pendingDownloads(limit: 1);
          if (more.isEmpty) break;
        }
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } finally {
      _pumping = false;
    }
  }

  Future<void> _run(Download dl) async {
    try {
      await _db.updateDownload(
        dl.chapterId,
        const DownloadsCompanion(
          status: Value(DownloadStatus.downloading),
        ),
      );
      // Offline = kualitas penuh (abaikan data-saver).
      final at = await _ref.read(mangaRepositoryProvider).atHome(dl.chapterId);
      if (at.pageCount == 0) throw Exception('Chapter kosong');
      final dir = await _chapterDir(dl.mangaId, dl.chapterId);
      await _db.updateDownload(
        dl.chapterId,
        DownloadsCompanion(
          totalPages: Value(at.pageCount),
          localPath: Value(dir.path),
        ),
      );
      var done = 0;
      var bytes = 0;
      final dio = _ref.read(dioProvider);
      for (var i = 0; i < at.pageCount; i++) {
        final src = at.pages[i];
        final ext = src.contains('.') ? src.split('.').last : 'jpg';
        final file =
            File('${dir.path}/${i.toString().padLeft(4, '0')}.$ext');
        if (await file.exists() && await file.length() > 0) {
          done++;
          bytes += await file.length();
          continue; // resume: lewati file yang sudah ada
        }
        final url = at.pageUrl(i, dataSaver: false);
        final res = await dio.get<List<int>>(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        final data = res.data ?? [];
        await file.writeAsBytes(data, flush: true);
        done++;
        bytes += data.length;
        await _db.updateDownload(
          dl.chapterId,
          DownloadsCompanion(
            donePages: Value(done),
            sizeBytes: Value(bytes),
          ),
        );
      }
      await _db.updateDownload(
        dl.chapterId,
        DownloadsCompanion(
          status: const Value(DownloadStatus.done),
          donePages: Value(done),
          totalPages: Value(at.pageCount),
          sizeBytes: Value(bytes),
        ),
      );
    } catch (_) {
      await _db.updateDownload(
        dl.chapterId,
        const DownloadsCompanion(status: Value(DownloadStatus.failed)),
      );
    }
  }

  /// Path file lokal berurut bila status done (String agar aman-Web).
  Future<List<String>?> localPages(String chapterId) async {
    final dl = await _db.getDownload(chapterId);
    if (dl == null ||
        dl.status != DownloadStatus.done ||
        dl.localPath == null) {
      return null;
    }
    final dir = Directory(dl.localPath!);
    if (!await dir.exists()) return null;
    final files = await dir
        .list()
        .where((e) => e is File)
        .cast<File>()
        .toList();
    files.sort((a, b) => a.path.compareTo(b.path));
    return files.isEmpty ? null : files.map((f) => f.path).toList();
  }
}
