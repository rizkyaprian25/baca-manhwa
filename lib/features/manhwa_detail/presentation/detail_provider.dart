import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart' hide Manga;
import '../../../core/network/dio_client.dart';
import '../../../core/providers/database_provider.dart';
import '../../manga/data/mappers/manga_mapper.dart';
import '../../manga/domain/entities/manga.dart';
import '../../manga/providers/manga_providers.dart';

/// Provider detail + feed — `lib/features/manhwa_detail/presentation/detail_provider.dart`.

/// Detail satu judul (remote-first, fallback cache offline).
final mangaDetailProvider =
    FutureProvider.family<Manga, String>((ref, mangaId) async {
  final repo = ref.watch(mangaRepositoryProvider);
  try {
    return await repo.detail(mangaId);
  } on MangaDexException catch (e) {
    if (!e.isOffline) rethrow;
    final row = await ref.read(databaseProvider).getManga(mangaId);
    if (row == null) rethrow;
    return mangaRowToEntity(row);
  }
});

/// Loader feed remote (menulis cache Drift; UI baca dari stream agar reaktif).
final feedLoaderProvider =
    FutureProvider.family<List<ChapterInfo>, String>((ref, mangaId) {
  return ref.watch(mangaRepositoryProvider).feed(mangaId);
});

/// Stream chapter dari cache.
/// Arg: (mangaId, language ['all'|'id'|'en'], ascending).
final chapterStreamProvider =
    StreamProvider.family<List<Chapter>, (String, String, bool)>(
  (ref, q) {
    final db = ref.watch(databaseProvider);
    final stream = db.watchChapters(
      q.$1,
      language: q.$2 == 'all' ? null : q.$2,
    );
    return stream.map((list) => sortChapters(list, ascending: q.$3));
  },
);

/// Id manga per tipe library (untuk status toggle favorit/dibaca).
final libraryIdsProvider =
    StreamProvider.family<Set<String>, String>((ref, listType) {
  final db = ref.watch(databaseProvider);
  return db
      .watchLibrary(listType)
      .map((l) => l.map((e) => e.manga.id).toSet());
});

/// Sort numeric-aware: "10" setelah "2"; null/oneshot paling depan (asc).
List<Chapter> sortChapters(List<Chapter> list, {bool ascending = true}) {
  final sorted = [...list]
    ..sort((a, b) {
      var c = _num(a.volume).compareTo(_num(b.volume));
      if (c != 0) return c;
      c = _num(a.chapterNo).compareTo(_num(b.chapterNo));
      if (c != 0) return c;
      return (a.title ?? '').compareTo(b.title ?? '');
    });
  return ascending ? sorted : sorted.reversed.toList();
}

/// Target "Lanjut Baca" — sinkron dengan label Pustaka (sumber data sama:
/// riwayat terakhir judul ini).
/// - Ada riwayat + chapter-nya belum selesai -> chapter itu persis.
/// - Riwayat sudah selesai -> chapter belum-dibaca pertama setelahnya.
/// - Tanpa riwayat cocok -> belum-dibaca pertama (atau terakhir bila semua
///   selesai, atau null bila kosong).
Chapter? findContinueTarget({
  required List<Chapter> asc,
  String? lastChapterId,
}) {
  if (asc.isEmpty) return null;
  if (lastChapterId != null) {
    final idx = asc.indexWhere((c) => c.id == lastChapterId);
    if (idx >= 0) {
      if (!asc[idx].isRead) return asc[idx];
      for (var i = idx + 1; i < asc.length; i++) {
        if (!asc[i].isRead) return asc[i];
      }
      return asc[idx];
    }
  }
  for (final c in asc) {
    if (!c.isRead) return c;
  }
  return asc.last;
}

double _num(String? s) {
  if (s == null || s.isEmpty) return -1;
  return double.tryParse(s) ?? -1;
}
