import 'package:drift/drift.dart';

import 'mangas.dart';

/// Entri perpustakaan: reading | favorite | completed | plan.
/// `lib/core/database/tables/library_entries.dart`.
class LibraryEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get mangaId =>
      text().references(Mangas, #id, onDelete: KeyAction.cascade)();
  TextColumn get listType => text()();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastOpened => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {mangaId, listType},
      ];
}

/// Tipe list perpustakaan.
class LibraryList {
  LibraryList._();
  static const String reading = 'reading';
  static const String favorite = 'favorite';
  static const String completed = 'completed';
  static const String plan = 'plan';

  static const List<String> all = [reading, favorite, completed, plan];

  static String label(String type) => switch (type) {
        reading => 'Sedang Dibaca',
        favorite => 'Favorit',
        completed => 'Selesai Dibaca',
        plan => 'Ingin Dibaca',
        _ => type,
      };
}
