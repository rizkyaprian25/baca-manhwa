import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/manga/domain/entities/manga.dart';
import '../../features/library/presentation/library_actions.dart';
import '../utils/number_formatter.dart';

/// Kartu hasil cari: cover (proporsi ikut sumber) + judul.
/// Komiku = landscape 16:9 (asli situsnya), MangaDex = portrait 2:3.
/// Tap -> detail, long-press -> quick actions.
/// `lib/core/widgets/manga_grid_card.dart`.
class MangaGridCard extends ConsumerWidget {
  const MangaGridCard({
    super.key,
    required this.manga,
    this.aspectRatio = 2 / 3,
  });
  final Manga manga;
  final double aspectRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push('/manga/${manga.id}'),
      onLongPress: () => showMangaQuickActions(context, ref, manga),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: manga.coverUrl == null
                  ? Container(
                      color: scheme.surfaceContainerHighest,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: manga.coverUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                        color: scheme.surfaceContainerHighest,
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      errorWidget: (_, _, _) => Container(
                        color: scheme.surfaceContainerHighest,
                        child: const Icon(Icons.broken_image_outlined),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            manga.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            _subtitle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: scheme.outline,
                ),
          ),
        ],
      ),
    );
  }

  String _subtitle() {
    final parts = <String>[];
    // Rating sesuai data: skor MangaDex, atau jumlah pembaca Komiku.
    if (manga.rating != null) {
      parts.add('★ ${manga.rating!.toStringAsFixed(1)}');
    } else if (manga.followedCount != null) {
      parts.add('${formatCompactId(manga.followedCount!)} pembaca');
    }
    if (manga.status != null) parts.add(manga.statusLabel());
    if (manga.year != null) parts.add('${manga.year}');
    return parts.join(' • ');
  }
}
