import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/database_provider.dart';
import '../../manga/domain/entities/manga.dart';
import '../../manga/providers/manga_providers.dart';

/// Provider reader — `lib/features/reader/presentation/reader_provider.dart`.

/// Server gambar chapter (WAJIB resolve fresh tiap buka chapter).
final atHomeProvider = FutureProvider.family<AtHome, String>(
  (ref, chapterId) =>
      ref.watch(mangaRepositoryProvider).atHome(chapterId),
);

/// Baris chapter lokal (mangaId, nomor, posisi tersimpan).
final readerChapterProvider = FutureProvider.family<Chapter?, String>(
  (ref, chapterId) => ref.watch(databaseProvider).getChapter(chapterId),
);
