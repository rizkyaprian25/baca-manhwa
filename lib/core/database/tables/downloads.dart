import 'package:drift/drift.dart';

import 'chapters.dart';
import 'mangas.dart';

/// Status download chapter — `lib/core/database/tables/downloads.dart`.
class Downloads extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mangaId =>
      text().references(Mangas, #id, onDelete: KeyAction.cascade)();
  TextColumn get chapterId =>
      text().references(Chapters, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text().withDefault(const Constant('queue'))();
  IntColumn get totalPages => integer().withDefault(const Constant(0))();
  IntColumn get donePages => integer().withDefault(const Constant(0))();
  IntColumn get sizeBytes => integer().withDefault(const Constant(0))();
  TextColumn get localPath => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {chapterId},
      ];
}

/// Status download.
class DownloadStatus {
  DownloadStatus._();
  static const String queue = 'queue';
  static const String downloading = 'downloading';
  static const String done = 'done';
  static const String failed = 'failed';

  static String label(String s) => switch (s) {
        queue => 'Antre',
        downloading => 'Mengunduh',
        done => 'Selesai',
        failed => 'Gagal',
        _ => s,
      };
}
