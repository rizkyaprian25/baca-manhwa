import 'package:drift/drift.dart';

import 'chapters.dart';
import 'mangas.dart';

/// Log chapter yang pernah dibuka — `lib/core/database/tables/reading_history.dart`.
class ReadingHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mangaId =>
      text().references(Mangas, #id, onDelete: KeyAction.cascade)();
  TextColumn get chapterId =>
      text().references(Chapters, #id, onDelete: KeyAction.cascade)();
  IntColumn get page => integer().withDefault(const Constant(0))();
  DateTimeColumn get readAt => dateTime().withDefault(currentDateAndTime)();
}
