// Entity domain dipakai lintas fitur (home/search/detail/reader/library/history).

import '../../../../core/sources/source_id.dart';

/// Asal negara komik beserta representasi visual & label tipe.
enum MangaOrigin {
  jp('jp', 'Jepang', 'Manga', '🇯🇵'),
  kr('kr', 'Korea', 'Manhwa', '🇰🇷'),
  cn('cn', 'China', 'Manhua', '🇨🇳'),
  other('other', 'Lainnya', 'Komik', '🌐');

  const MangaOrigin(this.code, this.countryName, this.typeLabel, this.flagEmoji);
  final String code;
  final String countryName;
  final String typeLabel;
  final String flagEmoji;

  static MangaOrigin fromCode(String? code) {
    if (code == null) return MangaOrigin.other;
    return switch (code.toLowerCase().trim()) {
      'jp' || 'manga' || 'japan' || 'japanese' => MangaOrigin.jp,
      'kr' || 'manhwa' || 'korea' || 'korean' => MangaOrigin.kr,
      'cn' || 'manhua' || 'china' || 'chinese' => MangaOrigin.cn,
      _ => MangaOrigin.other,
    };
  }

  /// Deteksi asal dari kumpulan tag genre atau tipe mentah.
  static MangaOrigin fromTagsOrType(List<String> tags, [String? typeString]) {
    if (typeString != null && typeString.isNotEmpty) {
      final parsed = fromCode(typeString);
      if (parsed != MangaOrigin.other) return parsed;
    }
    final lowerTags = tags.map((t) => t.toLowerCase().trim()).toSet();
    if (lowerTags.contains('manhwa') || lowerTags.contains('korean')) {
      return MangaOrigin.kr;
    }
    if (lowerTags.contains('manhua') || lowerTags.contains('chinese')) {
      return MangaOrigin.cn;
    }
    if (lowerTags.contains('manga') || lowerTags.contains('japanese')) {
      return MangaOrigin.jp;
    }
    return MangaOrigin.other;
  }
}

class MangaTag {
  MangaTag({required this.id, required this.name});
  final String id;
  final String name;
}

class Manga {
  Manga({
    required this.id,
    required this.title,
    String? sourceId,
    this.origin = MangaOrigin.other,
    this.altTitles = const [],
    this.description,
    this.status,
    this.contentRating,
    this.year,
    this.coverUrl,
    this.tags = const [],
    this.author,
    this.artist,
    this.followedCount,
    this.rating,
    this.latestChapter,
    this.updateAgo,
  }) : sourceId = sourceId ?? SourceId.fromMangaId(id);

  final String id;
  final String sourceId;
  final MangaOrigin origin;
  final String title;
  final List<String> altTitles;
  final String? description;
  final String? status;
  final String? contentRating;
  final int? year;
  final String? coverUrl;
  final List<MangaTag> tags;
  final String? author;
  final String? artist;
  final int? followedCount;
  final double? rating;

  /// Chapter terbaru yang diketahui (mis. "194") — display only, tidak di-cache.
  final String? latestChapter;

  /// Info waktu update mentah dari sumber (mis. "18 menit lalu") — Komiku.
  final String? updateAgo;

  String statusLabel() => switch (status) {
        'ongoing' => 'Ongoing',
        'completed' => 'Completed',
        'hiatus' => 'Hiatus',
        'cancelled' => 'Dibatalkan',
        _ => status ?? '-',
      };
}

class ChapterInfo {
  ChapterInfo({
    required this.id,
    required this.mangaId,
    this.title,
    this.chapterNo,
    this.volume,
    this.language = 'en',
    this.pages = 0,
    this.publishAt,
  });

  final String id;
  final String mangaId;
  final String? title;
  final String? chapterNo;
  final String? volume;
  final String language;
  final int pages;
  final DateTime? publishAt;

  /// Label tampil: "Ch. 12 - Judul" / "Oneshot" / "Ch. ?".
  String displayTitle() {
    final ch = (chapterNo == null || chapterNo!.isEmpty) ? 'Oneshot' : 'Ch. $chapterNo';
    if (title == null || title!.isEmpty) return ch;
    return '$ch - $title';
  }
}

/// Hasil resolve at-home/server — daftar file gambar chapter.
class AtHome {
  AtHome({
    required this.baseUrl,
    required this.hash,
    required this.pages,
    required this.pagesSaver,
  });

  final String baseUrl;
  final String hash;
  final List<String> pages;
  final List<String> pagesSaver;

  int get pageCount => pages.length;

  /// URL halaman ke-[index]. dataSaver = resolusi rendah.
  /// Bila baseUrl kosong (sumber direct-URL seperti Komiku),
  /// kembalikan URL apa adanya.
  String pageUrl(int index, {required bool dataSaver}) {
    final list = dataSaver ? pagesSaver : pages;
    final file = (index >= 0 && index < list.length) ? list[index] : pages[index];
    if (baseUrl.isEmpty) return file;
    return '$baseUrl/${dataSaver ? 'data-saver' : 'data'}/$hash/$file';
  }
}

/// Hasil pencarian/list ber-halaman.
class MangaPage {
  MangaPage({required this.items, required this.total, required this.hasMore});
  final List<Manga> items;
  final int total;
  final bool hasMore;
}
