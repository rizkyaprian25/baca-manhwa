import 'package:drift/drift.dart';

/// Cache metadata judul — `lib/core/database/tables/mangas.dart`.
/// id = UUID MangaDex (TEXT PK, bukan auto-increment).
class Mangas extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get altTitles => text().nullable()(); // JSON array string
  TextColumn get description => text().nullable()();
  TextColumn get status => text().nullable()(); // ongoing|completed|hiatus|cancelled
  TextColumn get contentRating => text().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get coverUrl => text().nullable()();
  TextColumn get tags => text().nullable()(); // JSON array {id,name}
  TextColumn get author => text().nullable()();
  TextColumn get artist => text().nullable()();
  DateTimeColumn get lastFetched => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
