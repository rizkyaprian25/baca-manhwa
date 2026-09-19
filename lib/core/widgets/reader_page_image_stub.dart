import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'apple_loading.dart';

/// Versi Web: selalu network (localPath diabaikan).
/// Mendukung retensi render (KeepAlive) anti-blink saat scroll balik ke atas,
/// dan downsampling memCacheWidth hemat memori.
/// `lib/core/widgets/reader_page_image_stub.dart`.
class ReaderPageImage extends StatefulWidget {
  const ReaderPageImage({
    super.key,
    required this.url,
    this.localPath,
    required this.onRetry,
  });
  final String url;
  final String? localPath;
  final VoidCallback onRetry;

  @override
  State<ReaderPageImage> createState() => _ReaderPageImageState();
}

class _ReaderPageImageState extends State<ReaderPageImage>
    with AutomaticKeepAliveClientMixin {
  late String _url = widget.url;
  bool _fellBack = false;

  @override
  bool get wantKeepAlive => true;

  String? get _fallback {
    if (_fellBack || !_url.contains('image2.komiku.to')) return null;
    return _url.replaceFirst('image2.komiku.to', 'img.komiku.org');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final mq = MediaQuery.maybeSizeOf(context);
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 2.0;
    final cacheWidth = mq != null
        ? ((mq.width * dpr).round()).clamp(720, 1440)
        : 1080;

    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderBg = isDark
        ? scheme.surfaceContainerLowest
        : scheme.surfaceContainerHighest.withValues(alpha: 0.3);

    return CachedNetworkImage(
      key: ValueKey(_url),
      imageUrl: _url,
      width: double.infinity,
      fit: BoxFit.fitWidth,
      memCacheWidth: cacheWidth,
      fadeInDuration: const Duration(milliseconds: 100),
      fadeOutDuration: Duration.zero,
      placeholder: (_, _) => Container(
        height: 320,
        color: placeholderBg,
        child: const Center(
          child: AppleLoadingIndicator(radius: 12),
        ),
      ),
      errorWidget: (_, _, _) {
        final fb = _fallback;
        if (fb != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _url = fb;
                _fellBack = true;
              });
            }
          });
          return Container(
            height: 200,
            alignment: Alignment.center,
            color: placeholderBg,
            child: const AppleLoadingIndicator(radius: 12),
          );
        }
        return InkWell(
          onTap: () async {
            await CachedNetworkImage.evictFromCache(_url);
            widget.onRetry();
          },
          child: Container(
            height: 200,
            alignment: Alignment.center,
            color: placeholderBg,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image_outlined),
                SizedBox(height: 4),
                Text('Gagal — ketuk untuk coba lagi'),
              ],
            ),
          ),
        );
      },
    );
  }
}

