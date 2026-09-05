import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';

/// Tab perpustakaan per tipe list.
/// `lib/features/library/presentation/library_provider.dart`.
final libraryTabProvider =
    StreamProvider.family<List<LibraryWithManga>, String>(
  (ref, listType) => ref.watch(databaseProvider).watchLibrary(listType),
);

/// Progres baca per manga dari chapter cache: total & sudah dibaca.
final libraryProgressProvider =
    StreamProvider<Map<String, ({int total, int read})>>((ref) {
  return ref.watch(databaseProvider).watchAllChapters().map((rows) {
    final map = <String, ({int total, int read})>{};
    for (final c in rows) {
      final cur = map[c.mangaId] ?? (total: 0, read: 0);
      map[c.mangaId] = (
        total: cur.total + 1,
        read: cur.read + (c.isRead ? 1 : 0),
      );
    }
    return map;
  });
});
