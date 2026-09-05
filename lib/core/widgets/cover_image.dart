import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Cover anti-crop: gambar penuh terlihat (contain) di atas latar blur
/// dari gambar yang sama — tidak ada wajah terpotong / melar.
/// `lib/core/widgets/cover_image.dart`.
class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    required this.url,
    this.aspectRatio = 2 / 3,
    this.borderRadius = 12,
  });
  final String? url;
  final double aspectRatio;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Latar: isi penuh + blur + gelap.
            if (url != null)
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: CachedNetworkImage(
                  imageUrl: url!,
                  fit: BoxFit.cover,
                  errorWidget: (_, _, _) => Container(
                    color: scheme.surfaceContainerHighest,
                  ),
                ),
              )
            else
              Container(color: scheme.surfaceContainerHighest),
            Container(color: Colors.black.withValues(alpha: 0.35)),
            // Depan: gambar utuh tanpa crop.
            if (url != null)
              CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.contain,
                placeholder: (_, _) => const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, _, _) => const Icon(
                  Icons.broken_image_outlined,
                ),
              )
            else
              const Icon(Icons.image_not_supported_outlined),
          ],
        ),
      ),
    );
  }
}
