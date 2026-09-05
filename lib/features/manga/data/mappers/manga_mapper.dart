import 'dart:convert';

import 'package:baca_manhwa/features/manga/domain/entities/manga.dart' as e;
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

/// Mapping Drift row <-> entity.
/// `lib/features/manga/data/mappers/manga_mapper.dart`.
/// (Row Drift `Manga` vs entity `e.Manga` — entity selalu pakai prefix `e`.)

e.Manga mangaRowToEntity(Manga row) {
  List<String> alts = const [];
  try {
    final d = jsonDecode(row.altTitles ?? '[]');
    if (d is List) alts = d.whereType<String>().toList();
  } catch (_) {}
  var tags = <e.MangaTag>[];
  try {
    final d = jsonDecode(row.tags ?? '[]');
    if (d is List) {
      tags = d
          .whereType<Map>()
          .map((m) => e.MangaTag(
                id: '${m['id']}',
                name: '${m['name']}',
              ))
          .where((t) => t.name.isNotEmpty && t.name != 'null')
          .toList();
    }
  } catch (_) {}
  return e.Manga(
    id: row.id,
    title: row.title,
    altTitles: alts,
    description: row.description,
    status: row.status,
    contentRating: row.contentRating,
    year: row.year,
    coverUrl: row.coverUrl,
    tags: tags,
    author: row.author,
    artist: row.artist,
  );
}

/// Ambil id tag dari JSON tags baris cache (untuk rekomendasi).
List<String> mangaRowTagIds(Manga row) {
  try {
    final d = jsonDecode(row.tags ?? '[]');
    if (d is List) {
      return d
          .whereType<Map>()
          .map((m) => '${m['id']}')
          .where((id) => id.isNotEmpty)
          .toList();
    }
  } catch (_) {}
  return const [];
}

/// Entity -> Drift companion (dipakai semua repository).
MangasCompanion mangaToCompanion(e.Manga m) => MangasCompanion(
      id: Value(m.id),
      title: Value(m.title),
      altTitles: Value(jsonEncode(m.altTitles)),
      description: Value(m.description),
      status: Value(m.status),
      contentRating: Value(m.contentRating),
      year: Value(m.year),
      coverUrl: Value(m.coverUrl),
      tags: Value(
        jsonEncode(m.tags.map((t) => {'id': t.id, 'name': t.name}).toList()),
      ),
      author: Value(m.author),
      artist: Value(m.artist),
      lastFetched: Value(DateTime.now()),
    );

ChaptersCompanion chapterToCompanion(e.ChapterInfo c) => ChaptersCompanion(
      id: Value(c.id),
      mangaId: Value(c.mangaId),
      title: Value(c.title),
      chapterNo: Value(c.chapterNo),
      volume: Value(c.volume),
      language: Value(c.language),
      pages: Value(c.pages),
      readableAt: Value(c.publishAt),
    );
