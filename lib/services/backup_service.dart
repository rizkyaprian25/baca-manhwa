import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../core/database/app_database.dart';
import '../core/database/tables/library_entries.dart';
import '../core/providers/database_provider.dart';

/// Backup & restore JSON — tanpa dart:io (aman Web & Mobile).
/// Isi: settings (v1-v5), library, cache mangas, chapters (+progress baca), history.
/// TIDAK termasuk file unduhan (unduh ulang setelah restore).
/// Import bersifat upsert toleran dan tahan terhadap perubahan skema (resilient).
/// `lib/services/backup_service.dart`.
class BackupService {
  BackupService(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(databaseProvider);

  /// Ekspor seluruh data lokal ke Map JSON yang kompatibel maju dan mundur.
  Future<Map<String, dynamic>> buildBackup() async {
    final s = await _db.getSettings();
    final library = await _db.select(_db.libraryEntries).get();
    final mangas = await _db.select(_db.mangas).get();
    final chapters = await _db.select(_db.chapters).get();
    final history = await _db.select(_db.readingHistory).get();

    return {
      'app': 'baca_manhwa',
      'backupVersion': 2,
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': {
        'theme': s.theme,
        'chapterLang': s.chapterLang,
        'adultFilter': s.adultFilter,
        'dataSaver': s.dataSaver,
        'readDirection': s.readDirection,
        'brightness': s.brightness,
        'source': s.source,
        'recentSearches': s.recentSearches,
        'autoScrollSpeed': s.autoScrollSpeed,
      },
      'library': [
        for (final e in library)
          {
            'mangaId': e.mangaId,
            'listType': e.listType,
            'addedAt': e.addedAt.toIso8601String(),
            'lastOpened': e.lastOpened?.toIso8601String(),
          },
      ],
      'mangas': [
        for (final m in mangas)
          {
            'id': m.id,
            'title': m.title,
            'altTitles': m.altTitles,
            'description': m.description,
            'status': m.status,
            'contentRating': m.contentRating,
            'year': m.year,
            'coverUrl': m.coverUrl,
            'tags': m.tags,
            'author': m.author,
            'artist': m.artist,
          },
      ],
      'chapters': [
        for (final c in chapters)
          {
            'id': c.id,
            'mangaId': c.mangaId,
            'title': c.title,
            'chapterNo': c.chapterNo,
            'volume': c.volume,
            'language': c.language,
            'pages': c.pages,
            'readableAt': c.readableAt?.toIso8601String(),
            'isRead': c.isRead,
            'lastPage': c.lastPage,
          },
      ],
      'history': [
        for (final h in history)
          {
            'mangaId': h.mangaId,
            'chapterId': h.chapterId,
            'page': h.page,
            'readAt': h.readAt.toIso8601String(),
          },
      ],
    };
  }

  static int _count(Map<String, dynamic> json, String key) {
    final val = json[key];
    if (val is List) return val.length;
    return 0;
  }

  static String summaryOf(Map<String, dynamic> json) =>
      'Pustaka: ${_count(json, 'library')} • Judul: ${_count(json, 'mangas')}'
      ' • Chapter: ${_count(json, 'chapters')} • Riwayat: ${_count(json, 'history')}';

  Future<String> currentSummary() async =>
      summaryOf(await buildBackup());

  Future<String> exportJsonString() async =>
      const JsonEncoder.withIndent('  ').convert(await buildBackup());

  Future<void> shareBackup() async {
    final text = await exportJsonString();
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final file = XFile.fromData(
      utf8.encode(text),
      name: 'baca_manhwa_backup_$date.json',
      mimeType: 'application/json',
    );
    await SharePlus.instance.share(
      ShareParams(files: [file], text: 'Backup Baca Manhwa'),
    );
  }

  /// Pilih file .json backup → isi sebagai String (null bila batal).
  /// Mendukung pembacaan bytes langsung (Web/Desktop) dan XFile streaming (Mobile).
  Future<String?> pickBackupString() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (file == null) return null;
      final bytes = await file.readAsBytes();
      return utf8.decode(bytes);
    } catch (_) {
      return null;
    }
  }

  // Helper parsing defensif
  static int? _parseInt(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toInt();
    if (val is String) return int.tryParse(val.trim());
    return null;
  }

  static double? _parseDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val.trim());
    return null;
  }

  static bool _parseBool(dynamic val, {bool defaultValue = false}) {
    if (val == null) return defaultValue;
    if (val is bool) return val;
    if (val == 1 || val == '1' || val == 'true') return true;
    if (val == 0 || val == '0' || val == 'false') return false;
    return defaultValue;
  }

  static String? _parseStringOrJson(dynamic val) {
    if (val == null) return null;
    if (val is String) return val;
    if (val is List || val is Map) {
      try {
        return jsonEncode(val);
      } catch (_) {
        return val.toString();
      }
    }
    return val.toString();
  }

  static DateTime? _parseDateTime(dynamic val) {
    if (val == null) return null;
    if (val is DateTime) return val;
    final str = val.toString().trim();
    if (str.isEmpty || str == 'null') return null;
    return DateTime.tryParse(str);
  }

  /// Import upsert dari String JSON.
  /// Sangat defensif terhadap type casting, data yatim, dan foreign key constraints.
  Future<BackupSummary> importJsonString(String text) async {
    final dynamic decoded = jsonDecode(text);
    if (decoded is! Map) {
      throw const FormatException('Bukan file JSON yang valid');
    }
    if (decoded['app'] != 'baca_manhwa' &&
        decoded['backupVersion'] == null &&
        decoded['mangas'] == null) {
      throw const FormatException('Bukan file backup Baca Manhwa');
    }

    final json = Map<String, dynamic>.from(decoded);
    var lib = 0, man = 0, ch = 0, his = 0;

    // 1. Mangas
    final mangas = (json['mangas'] as List?) ?? [];
    final validMangas = mangas.whereType<Map>().where((m) {
      final id = m['id']?.toString().trim();
      return id != null && id.isNotEmpty;
    }).toList();

    if (validMangas.isNotEmpty) {
      await _db.batch((b) {
        b.insertAllOnConflictUpdate(
          _db.mangas,
          validMangas.map(
            (m) => MangasCompanion(
              id: Value(m['id'].toString().trim()),
              title: Value(m['title']?.toString() ?? 'Tanpa Judul'),
              altTitles: Value(_parseStringOrJson(m['altTitles'])),
              description: Value(m['description']?.toString()),
              status: Value(m['status']?.toString()),
              contentRating: Value(m['contentRating']?.toString()),
              year: Value(_parseInt(m['year'])),
              coverUrl: Value(m['coverUrl']?.toString()),
              tags: Value(_parseStringOrJson(m['tags'])),
              author: Value(m['author']?.toString()),
              artist: Value(m['artist']?.toString()),
              lastFetched: Value(DateTime.now()),
            ),
          ),
        );
      });
      man = validMangas.length;
    }

    // Ambil seluruh ID manga yang ada di DB (mencegah Foreign Key constraint crash)
    final allMangaIds = (await (_db.selectOnly(_db.mangas)..addColumns([_db.mangas.id])).get())
        .map((r) => r.read(_db.mangas.id)!)
        .toSet();

    // 2. Chapters (hanya yang memiliki parent mangaId valid)
    final chapters = (json['chapters'] as List?) ?? [];
    final validChapters = chapters.whereType<Map>().where((c) {
      final cid = c['id']?.toString().trim();
      final mid = c['mangaId']?.toString().trim();
      return cid != null && cid.isNotEmpty && mid != null && allMangaIds.contains(mid);
    }).toList();

    if (validChapters.isNotEmpty) {
      await _db.batch((b) {
        b.insertAllOnConflictUpdate(
          _db.chapters,
          validChapters.map(
            (c) => ChaptersCompanion(
              id: Value(c['id'].toString().trim()),
              mangaId: Value(c['mangaId'].toString().trim()),
              title: Value(c['title']?.toString()),
              chapterNo: Value(c['chapterNo']?.toString()),
              volume: Value(c['volume']?.toString()),
              language: Value(c['language']?.toString() ?? 'en'),
              pages: Value(_parseInt(c['pages']) ?? 0),
              readableAt: Value(_parseDateTime(c['readableAt'])),
              isRead: Value(_parseBool(c['isRead'])),
              lastPage: Value(_parseInt(c['lastPage']) ?? 0),
            ),
          ),
        );
      });
      ch = validChapters.length;
    }

    final allChapterIds = (await (_db.selectOnly(_db.chapters)..addColumns([_db.chapters.id])).get())
        .map((r) => r.read(_db.chapters.id)!)
        .toSet();

    // 3. Library (pertahankan addedAt dan lastOpened historis tanpa crash FK)
    final library = (json['library'] as List?) ?? [];
    for (final e in library.whereType<Map>()) {
      final mangaId = e['mangaId']?.toString().trim();
      final listType = e['listType']?.toString().trim();
      if (mangaId == null || mangaId.isEmpty || !allMangaIds.contains(mangaId)) {
        continue;
      }
      if (listType == null || !LibraryList.all.contains(listType)) {
        continue;
      }

      final addedAt = _parseDateTime(e['addedAt']) ?? DateTime.now();
      final lastOpened = _parseDateTime(e['lastOpened']);

      try {
        final existing = await (_db.select(_db.libraryEntries)
              ..where((t) => t.mangaId.equals(mangaId) & t.listType.equals(listType)))
            .getSingleOrNull();

        if (existing == null) {
          await _db.into(_db.libraryEntries).insert(
                LibraryEntriesCompanion.insert(
                  mangaId: mangaId,
                  listType: listType,
                  addedAt: Value(addedAt),
                  lastOpened: lastOpened != null ? Value(lastOpened) : const Value.absent(),
                ),
              );
        } else if (lastOpened != null) {
          await (_db.update(_db.libraryEntries)..where((t) => t.id.equals(existing.id))).write(
            LibraryEntriesCompanion(
              lastOpened: Value(lastOpened),
            ),
          );
        }
        lib++;
      } catch (_) {
        // Abaikan duplikasi atau constraint error terisolasi
      }
    }

    // 4. Settings (dukung semua pengaturan baru: theme, speed, source, recentSearches)
    final settings = json['settings'];
    if (settings is Map) {
      try {
        final themeVal = settings['theme']?.toString();
        final theme = (themeVal == 'light' || themeVal == 'dark' || themeVal == 'system')
            ? themeVal!
            : 'dark';
        final speed = _parseDouble(settings['autoScrollSpeed']) ?? 4.0;
        final recent = _parseStringOrJson(settings['recentSearches']) ?? '[]';
        final source = settings['source'] == 'mangadex' ? 'mangadex' : 'komiku';
        final lang = settings['chapterLang']?.toString() ?? 'id';
        final adult = _parseBool(settings['adultFilter'], defaultValue: true);
        final dataSaver = _parseBool(settings['dataSaver'], defaultValue: false);
        final readDir = settings['readDirection']?.toString() ?? 'vertical';
        final brightness = _parseDouble(settings['brightness']);

        await _db.updateSettings(
          AppSettingsCompanion(
            theme: Value(theme),
            chapterLang: Value(lang),
            adultFilter: Value(adult),
            dataSaver: Value(dataSaver),
            readDirection: Value(readDir),
            brightness: Value(brightness),
            source: Value(source),
            recentSearches: Value(recent),
            autoScrollSpeed: Value(speed),
          ),
        );
      } catch (_) {
        // Gagal parsial settings tidak menggagalkan seluruh import data buku
      }
    }

    // 5. History
    final history = (json['history'] as List?) ?? [];
    for (final h in history.whereType<Map>()) {
      final mangaId = h['mangaId']?.toString().trim();
      final chapterId = h['chapterId']?.toString().trim();
      if (mangaId == null || !allMangaIds.contains(mangaId)) continue;
      if (chapterId == null || !allChapterIds.contains(chapterId)) continue;

      final page = _parseInt(h['page']) ?? 0;
      final readAt = _parseDateTime(h['readAt']) ?? DateTime.now();

      try {
        await _db.into(_db.readingHistory).insert(
              ReadingHistoryCompanion.insert(
                mangaId: mangaId,
                chapterId: chapterId,
                page: Value(page),
                readAt: Value(readAt),
              ),
            );
        his++;
      } catch (_) {
        // Baris yatim / duplikat dilewati tanpa memutus proses
      }
    }

    return BackupSummary(
      library: lib,
      mangas: man,
      chapters: ch,
      history: his,
    );
  }
}

class BackupSummary {
  BackupSummary({
    required this.library,
    required this.mangas,
    required this.chapters,
    required this.history,
  });
  final int library;
  final int mangas;
  final int chapters;
  final int history;

  @override
  String toString() =>
      'Pustaka: $library • Judul: $mangas • Chapter: $chapters • Riwayat: $history';
}

final backupServiceProvider =
    Provider<BackupService>((ref) => BackupService(ref));
