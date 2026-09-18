import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/manga/domain/entities/manga.dart';
import '../../features/library/presentation/library_actions.dart';
import '../utils/number_formatter.dart';
import 'cover_image.dart';

/// Kartu hasil Jelajah ala contoh: cover portrait + badge (UP/16+/flag)
/// + judul + rating/views + baris chapter.
/// Tap -> detail, long-press -> quick actions.
/// `lib/core/widgets/manga_grid_card.dart`.
class MangaGridCard extends ConsumerWidget {
  const MangaGridCard({super.key, required this.manga});
  final Manga manga;

  bool get _isKomiku => manga.id.startsWith('k:');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/manga/${manga.id}'),
      onLongPress: () => showMangaQuickActions(context, ref, manga),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CoverImage(url: manga.coverUrl, borderRadius: 0),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (manga.updateAgo != null)
                          _pill(
                            'UP',
                            scheme.secondary,
                            scheme.onSecondary,
                          ),
                        if (_ageBadge != null) ...[
                          const SizedBox(width: 4),
                          _pill(
                            _ageBadge!,
                            const Color(0xFFF2994A),
                            Colors.white,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (_isKomiku)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: _FlagKr(),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    manga.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  _statRow(context),
                  if (manga.latestChapter != null) ...[
                    const SizedBox(height: 4),
                    _chapterRow(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Badge umur untuk konten sensitif (data MangaDex).
  String? get _ageBadge => switch (manga.contentRating) {
        'erotica' => '18+',
        'suggestive' => '16+',
        _ => null,
      };

  Widget _pill(String text, Color bg, Color fg) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      );

  Widget _statRow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final parts = <Widget>[];
    if (manga.rating != null) {
      parts.add(const Icon(Icons.star, size: 13, color: Colors.amber));
      parts.add(Text(
        ' ${manga.rating!.toStringAsFixed(1)}  ',
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }
    if (manga.followedCount != null) {
      parts.add(Icon(Icons.visibility_outlined,
          size: 13, color: scheme.outline));
      parts.add(Text(
        ' ${formatCompactId(manga.followedCount!)}',
        style: Theme.of(context).textTheme.bodySmall,
      ));
    }
    if (parts.isEmpty) {
      return Text(
        manga.statusLabel(),
        maxLines: 1,
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    return Row(children: parts);
  }

  Widget _chapterRow(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Ch. ${manga.latestChapter}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: scheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          if (manga.updateAgo != null)
            Expanded(
              child: Text(
                manga.updateAgo!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
        ],
      ),
    );
  }
}

/// Bendera Korea (konten Komiku = manhwa) — lingkaran belah merah/biru.
class _FlagKr extends StatelessWidget {
  const _FlagKr();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: ClipOval(
        child: Column(
          children: [
            Expanded(child: Container(color: const Color(0xFFCD2E3A))),
            Expanded(child: Container(color: const Color(0xFF0047A0))),
          ],
        ),
      ),
    );
  }
}
