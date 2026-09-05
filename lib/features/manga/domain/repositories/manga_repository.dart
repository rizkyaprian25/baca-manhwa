import '../entities/manga.dart';

/// Filter pencarian — `lib/features/manga/domain/repositories/manga_repository.dart`.
class MangaFilter {
  const MangaFilter({
    this.title = '',
    this.includedTags = const [],
    this.status = const [],
    this.contentRating = const ['safe', 'suggestive'],
    this.year,
    // Default: rating tertinggi (MangaDex skor / Komiku peringkat).
    this.order = const {'rating': 'desc'},
    this.languages = const ['id', 'en'],
  });

  final String title;
  final List<String> includedTags;
  final List<String> status;
  final List<String> contentRating;
  final int? year;
  final Map<String, String> order;
  final List<String> languages;

  MangaFilter copyWith({
    String? title,
    List<String>? includedTags,
    List<String>? status,
    List<String>? contentRating,
    int? year,
    bool clearYear = false,
    Map<String, String>? order,
    List<String>? languages,
  }) =>
      MangaFilter(
        title: title ?? this.title,
        includedTags: includedTags ?? this.includedTags,
        status: status ?? this.status,
        contentRating: contentRating ?? this.contentRating,
        year: clearYear ? null : (year ?? this.year),
        order: order ?? this.order,
        languages: languages ?? this.languages,
      );
}

/// Kontrak sumber data (MangaDex default; ganti source = implementasi baru).
abstract class MangaRepository {
  Future<MangaPage> search(MangaFilter filter, {int limit = 20, int offset = 0});
  Future<List<Manga>> trending({int limit = 10});
  Future<List<Manga>> latestUpdates({int limit = 10});
  Future<List<Manga>> recommended(List<String> tagIds, {int limit = 10});
  Future<List<MangaTag>> tags();
  Future<Manga> detail(String mangaId);
  Future<List<ChapterInfo>> feed(
    String mangaId, {
    List<String> languages = const ['id', 'en'],
    String order = 'asc',
  });
  Future<AtHome> atHome(String chapterId);
}
