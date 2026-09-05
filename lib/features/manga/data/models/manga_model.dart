import '../../domain/entities/manga.dart';
import '../../../../core/network/mangadex_api.dart';

/// Parsing JSON MangaDex -> entity.
/// `lib/features/manga/data/models/manga_model.dart`.

String _locale(Map? m) {
  if (m == null || m.isEmpty) return '';
  for (final k in const ['id', 'en', 'ko-ro', 'ja-ro', 'ko', 'ja']) {
    final v = m[k];
    if (v is String && v.isNotEmpty) return v;
  }
  for (final v in m.values) {
    if (v is String && v.isNotEmpty) return v;
  }
  return '';
}

String? _relFileName(List rels, String type) {
  for (final r in rels) {
    final m = Map<String, dynamic>.from(r as Map);
    if (m['type'] == type) {
      final attrs = m['attributes'] as Map?;
      final fn = attrs?['fileName'];
      if (fn is String && fn.isNotEmpty) return fn;
    }
  }
  return null;
}

String? _relName(List rels, String type) {
  for (final r in rels) {
    final m = Map<String, dynamic>.from(r as Map);
    if (m['type'] == type) {
      final attrs = m['attributes'] as Map?;
      final name = attrs?['name'];
      if (name is String && name.isNotEmpty) return name;
    }
  }
  return null;
}

MangaTag _parseTag(Map<String, dynamic> j) {
  final attrs = (j['attributes'] as Map?) ?? {};
  final name = _locale(attrs['name'] as Map?);
  return MangaTag(id: (j['id'] ?? '').toString(), name: name);
}

Manga mangaFromJson(Map<String, dynamic> j) {
  final attrs = Map<String, dynamic>.from((j['attributes'] as Map?) ?? {});
  final rels = List.from((j['relationships'] as List?) ?? []);
  final id = (j['id'] ?? '').toString();
  final fileName = _relFileName(rels, 'cover_art');
  final stats = j['stats'] as Map?;

  final altRaw = (attrs['altTitles'] as List?) ?? [];
  final alts = <String>[];
  for (final a in altRaw) {
    final s = _locale(a as Map?);
    if (s.isNotEmpty) alts.add(s);
  }

  final tagsRaw = (attrs['tags'] as List?) ?? [];
  final tags = tagsRaw
      .map((t) => _parseTag(Map<String, dynamic>.from(t as Map)))
      .where((t) => t.name.isNotEmpty)
      .toList();

  final desc = _locale(attrs['description'] as Map?);
  final statsRating = stats?['rating'];
  final bayesian = statsRating is Map ? statsRating['bayesian'] : null;

  return Manga(
    id: id,
    title: _locale(attrs['title'] as Map?),
    altTitles: alts,
    description: desc.isEmpty ? null : desc,
    status: attrs['status']?.toString(),
    contentRating: attrs['contentRating']?.toString(),
    year: (attrs['year'] is int) ? attrs['year'] as int : null,
    coverUrl: fileName == null ? null : MangadexApi.coverUrl(id, fileName),
    tags: tags,
    author: _relName(rels, 'author'),
    artist: _relName(rels, 'artist'),
    followedCount: (j['followedCount'] is int)
        ? j['followedCount'] as int
        : (stats?['follows'] is int ? stats!['follows'] as int : null),
    rating: (bayesian is num) ? bayesian.toDouble() : null,
  );
}

ChapterInfo chapterFromJson(Map<String, dynamic> j, String mangaId) {
  final attrs = Map<String, dynamic>.from((j['attributes'] as Map?) ?? {});
  DateTime? published;
  final pa = attrs['publishAt']?.toString() ?? attrs['readableAt']?.toString();
  if (pa != null && pa.isNotEmpty) published = DateTime.tryParse(pa);
  return ChapterInfo(
    id: (j['id'] ?? '').toString(),
    mangaId: mangaId,
    title: attrs['title']?.toString(),
    chapterNo: attrs['chapter']?.toString(),
    volume: attrs['volume']?.toString(),
    language: attrs['translatedLanguage']?.toString() ?? 'en',
    pages: (attrs['pages'] is int) ? attrs['pages'] as int : 0,
    publishAt: published,
  );
}

AtHome atHomeFromJson(Map<String, dynamic> j) {
  final ch = Map<String, dynamic>.from((j['chapter'] as Map?) ?? {});
  return AtHome(
    baseUrl: (j['baseUrl'] ?? '').toString(),
    hash: (ch['hash'] ?? '').toString(),
    pages: List<String>.from((ch['data'] as List?) ?? []),
    pagesSaver: List<String>.from((ch['dataSaver'] as List?) ?? []),
  );
}

/// Parse GET /manga/tag -> daftar tag (opsional filter group: genre/theme/format/content).
List<MangaTag> tagListFromJson(Map<String, dynamic> j, {String? group}) {
  final data = (j['data'] as List?) ?? [];
  final out = <MangaTag>[];
  for (final e in data) {
    final m = Map<String, dynamic>.from(e as Map);
    final attrs = Map<String, dynamic>.from((m['attributes'] as Map?) ?? {});
    if (group != null && attrs['group']?.toString() != group) continue;
    final name = _locale(attrs['name'] as Map?);
    if (name.isEmpty) continue;
    out.add(MangaTag(id: (m['id'] ?? '').toString(), name: name));
  }
  out.sort((a, b) => a.name.compareTo(b.name));
  return out;
}

List<Manga> mangaListFromJson(Map<String, dynamic> j) {
  final data = (j['data'] as List?) ?? [];
  return data
      .map((e) => mangaFromJson(Map<String, dynamic>.from(e as Map)))
      .where((m) => m.id.isNotEmpty && m.title.isNotEmpty)
      .toList();
}
