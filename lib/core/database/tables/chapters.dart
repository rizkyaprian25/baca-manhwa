import 'package:drift/drift.dart';

import 'mangas.dart';

/// Cache daftar chapter per judul — `lib/core/database/tables/chapters.dart`.
class Chapters extends Table {
  TextColumn get id => text()(); // UUID chapter MangaDex
  TextColumn get mangaId =>
      text().references(Mangas, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().nullable()();
  TextColumn get chapterNo => text().nullable()(); // string: "12.5", "Oneshot"
  TextColumn get volume => text().nullable()();
  TextColumn get language => text().withDefault(const Constant('en'))();
  IntColumn get pages => integer().withDefault(const Constant(0))();
  DateTimeColumn get readableAt => dateTime().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  IntColumn get lastPage => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
