import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baca_manhwa/app.dart';
import 'package:baca_manhwa/features/manga/domain/entities/manga.dart';
import 'package:baca_manhwa/features/manga/domain/repositories/manga_repository.dart';
import 'package:baca_manhwa/features/manga/providers/manga_providers.dart';

/// Repositori palsu: tanpa HTTP (di widget test semua request nyata
/// digagalkan binding + throttle membuat timer gantung). Smoke test ini
/// hanya menguji kerangka navigasi, bukan data.
class _FakeMangaRepository implements MangaRepository {
  @override
  Future<MangaPage> search(
    MangaFilter filter, {
    int limit = 20,
    int offset = 0,
  }) async =>
      MangaPage(items: const [], total: 0, hasMore: false);

  @override
  Future<List<Manga>> trending({int limit = 10}) async => const [];

  @override
  Future<List<Manga>> latestUpdates({int limit = 10}) async => const [];

  @override
  Future<List<Manga>> recommended(
    List<String> tagIds, {
    int limit = 10,
  }) async =>
      const [];

  @override
  Future<List<MangaTag>> tags() async => const [];

  @override
  Future<Manga> detail(String mangaId) => throw UnimplementedError();

  @override
  Future<List<ChapterInfo>> feed(
    String mangaId, {
    List<String> languages = const ['id', 'en'],
    String order = 'asc',
  }) =>
      throw UnimplementedError();

  @override
  Future<AtHome> atHome(String chapterId) => throw UnimplementedError();
}

/// Smoke test: shell + floating nav 5 tujuan ter-render.
/// (Label hanya tampil di tab aktif ala MangaIndo.)
void main() {
  testWidgets('App menampilkan navigasi 5 tujuan', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          mangaRepositoryProvider.overrideWithValue(_FakeMangaRepository()),
        ],
        child: const BacaManhwaApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Tab aktif = Beranda (ikon + label).
    expect(find.text('Beranda'), findsOneWidget);
    // 5 ikon tujuan selalu ada (aktif = filled).
    expect(find.byIcon(Icons.cottage), findsWidgets);
    expect(find.byIcon(Icons.explore_outlined), findsOneWidget);
    expect(find.byIcon(Icons.auto_stories_outlined), findsOneWidget);
    expect(find.byIcon(Icons.history_outlined), findsOneWidget);
    expect(find.byIcon(Icons.tune_outlined), findsWidgets);

    // Pindah ke Jelajah: label ikut pindah (nav + judul layar).
    // (Semua label nav selalu tampil ala panduan.)
    await tester.tap(find.byIcon(Icons.explore_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Jelajah'), findsWidgets);
  });
}
