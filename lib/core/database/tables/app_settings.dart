import 'package:drift/drift.dart';

/// Pengaturan aplikasi (satu baris, id=1).
/// `lib/core/database/tables/app_settings.dart`.
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Default 'dark' (Fase 21): sesuai panduan KuroYomi.
  TextColumn get theme => text().withDefault(const Constant('dark'))();
  TextColumn get chapterLang => text().withDefault(const Constant('id'))();
  BoolColumn get adultFilter => boolean().withDefault(const Constant(true))();
  BoolColumn get dataSaver => boolean().withDefault(const Constant(false))();
  TextColumn get readDirection =>
      text().withDefault(const Constant('vertical'))();
  RealColumn get brightness => real().nullable()();
  // Sumber konten: 'komiku' (Indonesia, default) | 'mangadex'. (skema v2)
  TextColumn get source => text().withDefault(const Constant('komiku'))();
  // Riwayat query pencarian (JSON array, max 8). (skema v3)
  TextColumn get recentSearches =>
      text().withDefault(const Constant('[]'))();
  // Kecepatan scroll otomatis reader (px per 50ms, 1-10). (skema v4)
  RealColumn get autoScrollSpeed =>
      real().withDefault(const Constant(4.0))();
}
