import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../network/reader_image_headers.dart';

/// Cover manhwa yang ringan, cepat, dan proporsional.
/// Menggunakan single-pass CachedNetworkImage dengan downsampling (memCacheWidth/Height)
/// dan perataan topCenter agar karakter/judul tidak terpotong atau over-zoom.
/// `lib/core/widgets/cover_image.dart`.
class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    required this.url,
    this.aspectRatio = 2 / 3,
    this.borderRadius = 12,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.topCenter,
    this.memCacheWidth = 320,
    this.memCacheHeight = 480,
  });

  final String? url;
  final double aspectRatio;
  final double borderRadius;
  final BoxFit fit;
  final Alignment alignment;
  final int? memCacheWidth;
  final int? memCacheHeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget imageWidget;
    if (url == null || url!.isEmpty) {
      imageWidget = Container(
        color: scheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: scheme.outline,
          size: 28,
        ),
      );
    } else {
      imageWidget = CachedNetworkImage(
        imageUrl: url!,
        httpHeaders: readerImageHeaders(url!),
        fit: fit,
        alignment: alignment,
        memCacheWidth: memCacheWidth,
        memCacheHeight: memCacheHeight,
        placeholder: (_, _) => Container(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (_, _, _) => Container(
          color: scheme.surfaceContainerHighest,
          child: Icon(
            Icons.broken_image_outlined,
            color: scheme.outline,
            size: 24,
          ),
        ),
      );
    }

    if (borderRadius > 0) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageWidget,
      );
    }

    if (aspectRatio > 0) {
      return AspectRatio(
        aspectRatio: aspectRatio,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
