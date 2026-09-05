import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/downloads.dart';
import '../../../core/database/tables/library_entries.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/widgets/cover_image.dart';
import '../../download/presentation/download_provider.dart';
import '../../manga/domain/entities/manga.dart' as entity;
import '../../manga/providers/manga_providers.dart';

/// Aksi library + quick-action sheet (dipakai grid beranda/cari).
/// `lib/features/library/presentation/library_actions.dart`.
class LibraryActions {
  LibraryActions(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(databaseProvider);

  Future<bool> isIn(String mangaId, String listType) async =>
      (await _db.libraryEntry(mangaId, listType)) != null;

  Future<void> toggle(
    BuildContext context,
    entity.Manga manga,
    String listType,
  ) async {    // Pastikan metadata ter-cache agar FK library valid.
    await _db.upsertManga(
      MangasCompanion.insert(id: manga.id, title: manga.title),
    );
    final existing = await _db.libraryEntry(manga.id, listType);
    if (existing == null) {
      await _db.addToLibrary(manga.id, listType);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ditambahkan ke ${LibraryList.label(listType)}',
            ),
          ),
        );
      }
    } else {
      await _db.removeFromLibrary(manga.id, listType);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Dihapus dari ${LibraryList.label(listType)}',
            ),
          ),
        );
      }
    }
  }

  /// Hapus dari SEMUA rak (untuk sheet "Hapus dari Pustaka").
  Future<void> removeFromAll(BuildContext context, String mangaId) async {
    for (final t in LibraryList.all) {
      await _db.removeFromLibrary(mangaId, t);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dihapus dari Pustaka')),
      );
    }
  }
}

final libraryActionsProvider =
    Provider<LibraryActions>((ref) => LibraryActions(ref));

/// Long-press sheet ala panduan: Lanjutkan, Unduh 5, Favorit, Selesai, Hapus.
Future<void> showMangaQuickActions(
  BuildContext context,
  WidgetRef ref,
  entity.Manga manga,
) {
  final actions = ref.read(libraryActionsProvider);
  final scheme = Theme.of(context).colorScheme;
  return showModalBottomSheet(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: scheme.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 40,
                child: CoverImage(url: manga.coverUrl, borderRadius: 8),
              ),
            ),
            title: Text(
              manga.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(manga.statusLabel()),
          ),
          ListTile(
            leading: Icon(Icons.auto_stories, color: scheme.primary),
            title: const Text('Lanjutkan Membaca'),
            onTap: () {
              Navigator.pop(ctx);
              context.push('/manga/${manga.id}');
            },
          ),
          ListTile(
            leading: Icon(Icons.download_outlined, color: scheme.secondary),
            title: const Text('Unduh 5 Bab Terbaru'),
            onTap: () {
              Navigator.pop(ctx);
              _downloadLatest5(context, ref, manga);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_add_outlined),
            title: const Text('Favorit'),
            onTap: () {
              Navigator.pop(ctx);
              actions.toggle(context, manga, LibraryList.favorite);
            },
          ),
          ListTile(
            leading: const Icon(Icons.done_all_outlined),
            title: const Text('Tandai Sudah Selesai Dibaca'),
            onTap: () {
              Navigator.pop(ctx);
              actions.toggle(context, manga, LibraryList.completed);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_sweep_outlined, color: scheme.error),
            title: Text(
              'Hapus dari Pustaka',
              style: TextStyle(color: scheme.error),
            ),
            onTap: () {
              Navigator.pop(ctx);
              actions.removeFromAll(context, manga.id);
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// Unduh 5 chapter terbaru yang belum tersimpan.
Future<void> _downloadLatest5(
  BuildContext context,
  WidgetRef ref,
  entity.Manga manga,
) async {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Menyiapkan 5 bab terbaru...')),
  );
  try {
    final repo = ref.read(mangaRepositoryProvider);
    final feed = await repo.feed(manga.id);
    double num(String? s) =>
        s == null || s.isEmpty ? -1 : double.tryParse(s) ?? -1;
    final sorted = [...feed]..sort((a, b) => num(b.chapterNo).compareTo(
          num(a.chapterNo),
        ));
    final known = {
      for (final d in ref.read(downloadsStreamProvider).value ?? const [])
        d.download.chapterId: d.download.status,
    };
    final cands = sorted
        .where(
          (c) =>
              known[c.id] != DownloadStatus.done &&
              known[c.id] != DownloadStatus.queue &&
              known[c.id] != DownloadStatus.downloading,
        )
        .take(5)
        .toList();
    if (cands.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('5 bab terbaru sudah tersimpan')),
        );
      }
      return;
    }
    final mgr = ref.read(downloadManagerProvider);
    for (final c in cands) {
      await mgr.enqueue(manga.id, c.id);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mengunduh ${cands.length} bab terbaru')),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyiapkan unduhan')),
      );
    }
  }
}
