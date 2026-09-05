import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../core/database/app_database.dart';
import '../core/providers/database_provider.dart';

/// Backup & restore JSON — tanpa dart:io (aman Web).
/// Isi: settings, library, cache mangas, chapters (+progress baca), history.
/// TIDAK termasuk file unduhan (unduh ulang setelah restore).
/// Import bersifat upsert (tidak menghapus data lokal).
/// `lib/services/backup_service.dart`.
class BackupService {
  BackupService(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(databaseProvider);

  Future<Map<String, dynamic>> buildBackup() async {
    final s = await _db.getSettings();
    final library = await _db.select(_db.libraryEntries).get();
    final mangas = await _db.select(_db.mangas).get();
    final chapters = await _db.select(_db.chapters).get();
    final history = await _db.select(_db.readingHistory).get();
    return {
      'app': 'baca_manhwa',
      'backupVersion': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'settings': {
        'theme': s.theme,
        'chapterLang': s.chapterLang,
        'adultFilter': s.adultFilter,
        'dataSaver': s.dataSaver,
        'readDirection': s.readDirection,
        'brightness': s.brightness,
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

  static int _count(Map<String, dynamic> json, String key) =>
      ((json[key] as List?) ?? []).length;

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
  Future<String?> pickBackupString() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    return utf8.decode(bytes);
  }

  /// Import upsert dari String JSON. Melempar [FormatException] bila invalid.
  Future<BackupSummary> importJsonString(String text) async {
    final decoded = jsonDecode(text);
    if (decoded is! Map<String, dynamic> || decoded['app'] != 'baca_manhwa') {
      throw const FormatException('Bukan file backup Baca Manhwa');
    }
    final json = decoded;
    var lib = 0, man = 0, ch = 0, his = 0;

    final mangas = (json['mangas'] as List?) ?? [];
    if (mangas.isNotEmpty) {
      await _db.batch((b) {
        b.insertAllOnConflictUpdate(
          _db.mangas,
          mangas.whereType<Map>().map(
                (m) => MangasCompanion(
                  id: Value('${m['id']}'),
                  title: Value('${m['title']}'),
                  altTitles: Value(m['altTitles'] as String?),
                  description: Value(m['description'] as String?),
                  status: Value(m['status'] as String?),
                  contentRating: Value(m['contentRating'] as String?),
                  year: Value((m['year'] as num?)?.toInt()),
                  coverUrl: Value(m['coverUrl'] as String?),
                  tags: Value(m['tags'] as String?),
                  author: Value(m['author'] as String?),
                  artist: Value(m['artist'] as String?),
                  lastFetched: Value(DateTime.now()),
                ),
              ),
        );
      });
      man = mangas.length;
    }

    final chapters = (json['chapters'] as List?) ?? [];
    final mangaIds = mangas
        .whereType<Map>()
        .map((m) => '${m['id']}')
        .toSet();
    final validChapters = chapters
        .whereType<Map>()
        .where((c) => mangaIds.contains('${c['mangaId']}'))
        .toList();
    if (validChapters.isNotEmpty) {
      await _db.batch((b) {
        b.insertAllOnConflictUpdate(
          _db.chapters,
          validChapters.map(
                (c) => ChaptersCompanion(
                  id: Value('${c['id']}'),
                  mangaId: Value('${c['mangaId']}'),
                  title: Value(c['title'] as String?),
                  chapterNo: Value(c['chapterNo'] as String?),
                  volume: Value(c['volume'] as String?),
                  language: Value('${c['language'] ?? 'en'}'),
                  pages: Value((c['pages'] as num?)?.toInt() ?? 0),
                  readableAt: Value(
                    DateTime.tryParse('${c['readableAt']}'),
                  ),
                  isRead: Value(c['isRead'] == true),
                  lastPage: Value((c['lastPage'] as num?)?.toInt() ?? 0),
                ),
              ),
        );
      });
      ch = validChapters.length;
    }

    final library = (json['library'] as List?) ?? [];
    for (final e in library.whereType<Map>()) {
      final mangaId = '${e['mangaId']}';
      final listType = '${e['listType']}';
      if (mangaId.isEmpty) continue;
      await _db.addToLibrary(mangaId, listType);
      lib++;
    }

    final settings = json['settings'];
    if (settings is Map) {
      await _db.updateSettings(
        AppSettingsCompanion(
          theme: Value('${settings['theme'] ?? 'system'}'),
          chapterLang: Value('${settings['chapterLang'] ?? 'id'}'),
          adultFilter: Value(settings['adultFilter'] != false),
          dataSaver: Value(settings['dataSaver'] == true),
          readDirection: Value('${settings['readDirection'] ?? 'vertical'}'),
          brightness: Value((settings['brightness'] as num?)?.toDouble()),
        ),
      );
    }

    final history = (json['history'] as List?) ?? [];
    for (final h in history.whereType<Map>()) {
      try {
        await _db.into(_db.readingHistory).insert(
              ReadingHistoryCompanion.insert(
                mangaId: '${h['mangaId']}',
                chapterId: '${h['chapterId']}',
                page: Value((h['page'] as num?)?.toInt() ?? 0),
              ),
            );
        his++;
      } catch (_) {
        // Baris yatim (chapter tidak ada) dilewati.
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
