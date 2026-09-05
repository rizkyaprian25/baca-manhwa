import '../../../../core/database/app_database.dart'
    hide Chapter, Manga;
import '../../domain/entities/manga.dart';
import '../../domain/repositories/manga_repository.dart';
import '../datasources/mangadex_remote_datasource.dart';
import '../mappers/manga_mapper.dart';

/// Repository: remote-first + cache Drift untuk detail & feed.
/// `lib/features/manga/data/repositories/manga_repository_impl.dart`.
class MangaRepositoryImpl implements MangaRepository {
  MangaRepositoryImpl({required this.remote, required this.db});
  final MangadexRemoteDataSource remote;
  final AppDatabase db;

  @override
  Future<MangaPage> search(MangaFilter filter, {int limit = 20, int offset = 0}) async {
    final page = await remote.search(filter, limit: limit, offset: offset);
    // Cache ringan agar tombol library tetap bisa dipakai offline.
    await db.upsertMangas(page.items.map(mangaToCompanion).toList());
    return page;
  }

  @override
  Future<List<Manga>> trending({int limit = 10}) async {
    final list = await remote.trending(limit: limit);
    await db.upsertMangas(list.map(mangaToCompanion).toList());
    return list;
  }

  @override
  Future<List<Manga>> latestUpdates({int limit = 10}) async {
    final list = await remote.latestUpdates(limit: limit);
    await db.upsertMangas(list.map(mangaToCompanion).toList());
    return list;
  }

  @override
  Future<List<Manga>> recommended(List<String> tagIds, {int limit = 10}) {
    if (tagIds.isEmpty) return trending(limit: limit);
    return remote.recommended(tagIds, limit: limit);
  }

  @override
  Future<List<MangaTag>> tags() => remote.tags();

  @override
  Future<Manga> detail(String mangaId) async {
    final manga = await remote.detail(mangaId);
    await db.upsertManga(mangaToCompanion(manga));
    return manga;
  }

  @override
  Future<List<ChapterInfo>> feed(
    String mangaId, {
    List<String> languages = const ['id', 'en'],
    String order = 'asc',
  }) async {
    final list = await remote.feed(mangaId, languages: languages, order: order);
    await db.upsertChapters(list.map(chapterToCompanion).toList());
    return list;
  }

  @override
  Future<AtHome> atHome(String chapterId) => remote.atHome(chapterId);
}
