import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';

/// Stream riwayat baca.
/// `lib/features/history/presentation/history_provider.dart`.
final historyStreamProvider = StreamProvider<List<HistoryWithData>>(
  (ref) => ref.watch(databaseProvider).watchHistory(limit: 500),
);

/// Riwayat dikelompokkan per judul (1 baris per manhwa = bacaan terakhir).
/// Urutan: terakhir dibaca paling atas (ikut urutan stream).
final groupedHistoryProvider = StreamProvider<List<HistoryWithData>>(
  (ref) => ref
      .watch(databaseProvider)
      .watchHistory(limit: 500)
      .map(groupHistoryByManga),
);

/// Pure helper (unit-testable): ambil baris terbaru tiap mangaId.
/// Input harus sudah urut terbaru-dulu (seperti watchHistory).
List<HistoryWithData> groupHistoryByManga(List<HistoryWithData> rows) {
  final seen = <String>{};
  return rows.where((h) => seen.add(h.manga.id)).toList();
}
