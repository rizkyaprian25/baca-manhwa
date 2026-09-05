import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/tables/downloads.dart';
import '../../../core/database/tables/library_entries.dart';
import '../../../core/utils/content_rating_filter.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/widgets/cover_image.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/error_view.dart';
import '../../download/presentation/download_button.dart';
import '../../download/presentation/download_provider.dart';
import '../../history/presentation/history_provider.dart';
import '../../library/presentation/library_actions.dart';
import '../../settings/presentation/settings_provider.dart';
import 'detail_provider.dart';

/// Halaman detail KuroYomi: hero blur + CTA + 4 aksi + tab bahasa + cari.
/// `lib/features/manhwa_detail/presentation/detail_screen.dart`.
class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({super.key, required this.mangaId});
  final String mangaId;

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late String _lang;
  bool _asc = false; // panduan default: Terbaru dulu
  bool _expanded = false;
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    final def = ref.read(chapterLangProvider);
    _lang = (def == 'en') ? 'en' : 'id';
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(mangaDetailProvider(widget.mangaId));
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Detail Manhwa'),
        actions: [
          if (detail case AsyncData(:final value))
            IconButton(
              tooltip: 'Menu',
              icon: const Icon(Icons.more_vert),
              onPressed: () => showMangaQuickActions(
                context,
                ref,
                value,
              ),
            ),
        ],
      ),
      body: switch (detail) {
        AsyncData(:final value) => _DetailBody(
            manga: value,
            mangaId: widget.mangaId,
            lang: _lang,
            asc: _asc,
            expanded: _expanded,
            query: _query,
            searchCtrl: _searchCtrl,
            onLang: (v) => setState(() => _lang = v),
            onSort: () => setState(() => _asc = !_asc),
            onExpand: () => setState(() => _expanded = !_expanded),
            onQuery: (v) => setState(() => _query = v),
          ),
        AsyncError(:final error) => SafeArea(
            child: ErrorView(
              error: error,
              onRetry: () =>
                  ref.invalidate(mangaDetailProvider(widget.mangaId)),
            ),
          ),
        _ => const _DetailSkeleton(),
      },
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({
    required this.manga,
    required this.mangaId,
    required this.lang,
    required this.asc,
    required this.expanded,
    required this.query,
    required this.searchCtrl,
    required this.onLang,
    required this.onSort,
    required this.onExpand,
    required this.onQuery,
  });

  final dynamic manga;
  final String mangaId;
  final String lang;
  final bool asc;
  final bool expanded;
  final String query;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onLang;
  final VoidCallback onSort;
  final VoidCallback onExpand;
  final ValueChanged<String> onQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(feedLoaderProvider(mangaId));
    final all =
        ref.watch(chapterStreamProvider((mangaId, 'all', true))).value ??
            const [];
    final shown =
        ref.watch(chapterStreamProvider((mangaId, lang, asc))).value ??
            const [];
    final idCount = all.where((c) => c.language == 'id').length;
    final enCount = all.where((c) => c.language == 'en').length;
    final visible = query.trim().isEmpty
        ? shown
        : shown.where((c) {
            final q = query.trim().toLowerCase();
            final num = (c.chapterNo ?? '').toLowerCase();
            final title = (c.title ?? '').toLowerCase();
            return num.contains(q) || title.contains(q);
          }).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _Hero(manga: manga, mangaId: mangaId)),
        SliverToBoxAdapter(
          child: _Actions(manga: manga, mangaId: mangaId, onLangCycle: () {
            onLang(lang == 'id' ? 'en' : 'id');
          }),
        ),
        if (manga.description != null)
          SliverToBoxAdapter(
            child: _Synopsis(
              text: manga.description as String,
              tags: (manga.tags as List).map((t) => t.name as String).toList(),
              expanded: expanded,
              onExpand: onExpand,
            ),
          ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _ChapterHeaderDelegate(
            lang: lang,
            asc: asc,
            idCount: idCount,
            enCount: enCount,
            searchCtrl: searchCtrl,
            onLang: onLang,
            onSort: onSort,
            onQuery: onQuery,
          ),
        ),
        if (visible.isEmpty)
          const SliverToBoxAdapter(
            child: EmptyView(
              icon: Icons.search_off_outlined,
              title: 'Chapter tidak ditemukan',
              subtitle: 'Coba kata kunci lain atau periksa filter bahasa.',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _ChapterCard(
                    chapter: visible[i],
                    mangaId: mangaId,
                  ),
                ),
                childCount: visible.length,
              ),
            ),
          ),
      ],
    );
  }
}

/// Hero: backdrop blur + cover + meta.
class _Hero extends StatelessWidget {
  const _Hero({required this.manga, required this.mangaId});
  final dynamic manga;
  final String mangaId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final cover = manga.coverUrl as String?;
    return Stack(
      children: [
        if (cover != null)
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: CachedNetworkImage(
                imageUrl: cover,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) =>
                    Container(color: scheme.surfaceContainerLowest),
              ),
            ),
          )
        else
          Positioned.fill(
            child: Container(color: scheme.surfaceContainerLowest),
          ),
        // Blur + gradient (pakai backdrop seadanya: overlay gelap).
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.25),
                  scheme.surface.withValues(alpha: 0.85),
                  scheme.surface,
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: 128,
                      child: CoverImage(url: cover),
                    ),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: scheme.secondary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              manga.statusLabel() as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 14,
                            color: scheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'MANGADEX SOURCE',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(color: scheme.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        manga.title as String,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if ((manga.altTitles as List).isNotEmpty)
                        Text(
                          (manga.altTitles as List).first as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      const SizedBox(height: 8),
                      Text(
                        '✒️ ${manga.author ?? '-'} • 🎨 ${manga.artist ?? '-'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (manga.rating != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 14,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    ' ${(manga.rating as double).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (manga.followedCount != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${formatCompactId(manga.followedCount as int)} pembaca',
                              style:
                                  Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      _Chip(
                        ContentRatingFilter.label(manga.contentRating),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// CTA lanjut baca + 4 aksi.
class _Actions extends ConsumerWidget {
  const _Actions({
    required this.manga,
    required this.mangaId,
    required this.onLangCycle,
  });
  final dynamic manga;
  final String mangaId;
  final VoidCallback onLangCycle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ascAll =
        ref.watch(chapterStreamProvider((mangaId, 'all', true))).value ??
            const [];
    // Sumber yang SAMA dengan label Pustaka: riwayat terakhir judul ini.
    // Menjamin CTA "Lanjut Baca" sinkron dengan "Terakhir Ch. X".
    final history = ref.watch(historyStreamProvider).value ?? const [];
    String? lastChapterId;
    for (final h in history) {
      if (h.manga.id == mangaId) {
        lastChapterId = h.history.chapterId;
        break;
      }
    }
    final target =
        findContinueTarget(asc: ascAll, lastChapterId: lastChapterId);
    final fav = ref
            .watch(libraryIdsProvider(LibraryList.favorite))
            .value
            ?.contains(mangaId) ??
        false;

    String ctaLabel = 'Belum ada chapter';
    String? ctaSub;
    if (target != null) {
      final num = (target.chapterNo == null || target.chapterNo!.isEmpty)
          ? 'Oneshot'
          : 'Ch. ${target.chapterNo}';
      ctaLabel = target.isRead && target.lastPage <= 0
          ? 'Baca Ulang $num'
          : 'Lanjut Baca $num';
      if (target.lastPage > 0) ctaSub = '(Hal. ${target.lastPage + 1})';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: target == null
                    ? null
                    : () => context.push('/reader/${target.id}'),
                child: Ink(
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow,
                        color:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ctaSub == null ? ctaLabel : '$ctaLabel $ctaSub',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  icon: fav ? Icons.bookmark : Icons.bookmark_add_outlined,
                  label: 'Favorit',
                  active: fav,
                  onTap: () => ref
                      .read(libraryActionsProvider)
                      .toggle(context, manga, LibraryList.favorite),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  icon: Icons.download_for_offline_outlined,
                  label: 'Unduh',
                  onTap: () => _batchDownload(context, ref),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  icon: Icons.share_outlined,
                  label: 'Bagikan',
                  onTap: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text:
                            '${manga.title}\nhttps://mangadex.org/title/$mangaId',
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionTile(
                  icon: Icons.translate_outlined,
                  label: 'Bahasa',
                  onTap: onLangCycle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _batchDownload(BuildContext context, WidgetRef ref) async {
    final mgr = ref.read(downloadManagerProvider);
    final known = {
      for (final d
          in ref.read(downloadsStreamProvider).value ?? const [])
        d.download.chapterId: d.download.status,
    };
    final desc =
        ref.read(chapterStreamProvider((mangaId, 'all', false))).value ??
            const [];
    final cands = desc
        .where(
          (c) =>
              known[c.id] != DownloadStatus.done &&
              known[c.id] != DownloadStatus.queue &&
              known[c.id] != DownloadStatus.downloading,
        )
        .take(5)
        .toList();
    if (cands.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua chapter terbaru sudah diunduh')),
      );
      return;
    }
    for (final c in cands) {
      await mgr.enqueue(mangaId, c.id);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mengunduh ${cands.length} chapter terbaru')),
      );
    }
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    this.active = false,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: active
              ? scheme.surfaceContainerHigh
              : scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: active ? scheme.primary : scheme.onSurfaceVariant,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Sinopsis + chips genre.
class _Synopsis extends StatelessWidget {
  const _Synopsis({
    required this.text,
    required this.tags,
    required this.expanded,
    required this.onExpand,
  });
  final String text;
  final List<String> tags;
  final bool expanded;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tags.isNotEmpty)
            SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                separatorBuilder: (_, _) => const SizedBox(width: 6),
                itemBuilder: (_, i) => Chip(
                  label: Text(
                    tags[i],
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    maxLines: expanded ? null : 3,
                    overflow: expanded ? null : TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextButton.icon(
                    icon: Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    label: Text(
                      expanded ? 'Sembunyikan' : 'Baca Selengkapnya',
                    ),
                    onPressed: onExpand,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Header chapter sticky: tab bahasa + sort + cari.
class _ChapterHeaderDelegate extends SliverPersistentHeaderDelegate {
  _ChapterHeaderDelegate({
    required this.lang,
    required this.asc,
    required this.idCount,
    required this.enCount,
    required this.searchCtrl,
    required this.onLang,
    required this.onSort,
    required this.onQuery,
  });

  final String lang;
  final bool asc;
  final int idCount;
  final int enCount;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onLang;
  final VoidCallback onSort;
  final ValueChanged<String> onQuery;

  @override
  double get minExtent => 132;
  @override
  double get maxExtent => 132;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              if (idCount > 0 && enCount > 0)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _LangTab(
                            label: 'Indonesia (ID)',
                            count: idCount,
                            selected: lang == 'id',
                            onTap: () => onLang('id'),
                          ),
                        ),
                        Expanded(
                          child: _LangTab(
                            label: 'English (EN)',
                            count: enCount,
                            selected: lang == 'en',
                            onTap: () => onLang('en'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Text(
                  '${idCount + enCount} chapter • Indonesia',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              const SizedBox(width: 8),
              FilledButton.tonalIcon(
                icon: Icon(asc ? Icons.arrow_upward : Icons.arrow_downward),
                label: Text(asc ? 'Terlama' : 'Terbaru'),
                onPressed: onSort,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              hintText: 'Cari chapter...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: scheme.surfaceContainerHigh,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            onChanged: onQuery,
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _ChapterHeaderDelegate old) =>
      old.lang != lang ||
      old.asc != asc ||
      old.idCount != idCount ||
      old.enCount != enCount;
}

class _LangTab extends StatelessWidget {
  const _LangTab({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? scheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected
                      ? scheme.onPrimary
                      : scheme.onSurfaceVariant,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: TextStyle(
                color:
                    selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu chapter: read redup + check, unread + nomor + dot hijau.
class _ChapterCard extends StatelessWidget {
  const _ChapterCard({required this.chapter, required this.mangaId});
  final Chapter chapter;
  final String mangaId;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = chapter;
    final num = (c.chapterNo == null || c.chapterNo!.isEmpty)
        ? 'Oneshot'
        : 'Ch. ${c.chapterNo}';
    final title = (c.title == null || c.title!.isEmpty)
        ? num
        : '$num: ${c.title}';
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/reader/${c.id}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: c.isRead
              ? scheme.surfaceContainerLow
              : scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.isRead
                    ? scheme.surfaceContainerHigh
                    : scheme.primaryContainer.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: c.isRead
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: scheme.outline,
                    )
                  : Text(
                      c.chapterNo ?? '•',
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        color: scheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: c.isRead
                                ? scheme.outline
                                : scheme.onSurface,
                          ),
                        ),
                      ),
                      if (!c.isRead)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(
                            color: scheme.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (c.readableAt != null)
                        DateFormatter.relative(c.readableAt!),
                      '${c.pages} hlm',
                      c.language.toUpperCase(),
                    ].join(' • '),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                          color: c.isRead
                              ? scheme.outline
                              : scheme.secondary,
                        ),
                  ),
                ],
              ),
            ),
            DownloadButton(mangaId: mangaId, chapterId: c.id),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.surfaceContainerHighest;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: c,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),
            Container(height: 48, color: c),
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
