import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../network/reader_image_headers.dart';
import 'reader_buffering_placeholder.dart';

/// Halaman reader: file lokal bila ada, network bila tidak.
/// Mendukung retensi render (KeepAlive) anti-blink saat scroll balik ke atas,
/// header HTTP anti-throttling, watchdog buffering lambat, serta fitur segarkan gambar.
/// `lib/core/widgets/reader_page_image_io.dart`.
class ReaderPageImage extends StatefulWidget {
  const ReaderPageImage({
    super.key,
    required this.url,
    this.localPath,
    required this.onRetry,
    this.pageIndex,
  });
  final String url;
  final String? localPath;
  final VoidCallback onRetry;
  final int? pageIndex;

  @override
  State<ReaderPageImage> createState() => _ReaderPageImageState();
}

class _ReaderPageImageState extends State<ReaderPageImage>
    with AutomaticKeepAliveClientMixin {
  late String _url = widget.url;
  bool _fellBack = false;
  int _refreshKey = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(covariant ReaderPageImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      _url = widget.url;
      _fellBack = false;
      _refreshKey = 0;
    }
  }

  /// Host cadangan Komiku (sama seperti onerror di situsnya).
  String? get _fallback {
    if (_fellBack || !_url.contains('image2.komiku.to')) return null;
    return _url.replaceFirst('image2.komiku.to', 'img.komiku.org');
  }

  Future<void> _refresh() async {
    await CachedNetworkImage.evictFromCache(_url);
    if (mounted) {
      setState(() {
        _refreshKey++;
      });
    }
  }

  void _triggerFallback() {
    final fb = _fallback;
    if (fb != null && mounted) {
      setState(() {
        _url = fb;
        _fellBack = true;
        _refreshKey++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final lp = widget.localPath;
    if (lp != null && File(lp).existsSync()) {
      return Image.file(
        File(lp),
        width: double.infinity,
        fit: BoxFit.fitWidth,
      );
    }

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

    final pageText =
        widget.pageIndex != null ? 'Hal. ${widget.pageIndex! + 1}' : null;

    return CachedNetworkImage(
      key: ValueKey('$_url-$_refreshKey'),
      imageUrl: _url,
      httpHeaders: readerImageHeaders(_url),
      width: double.infinity,
      fit: BoxFit.fitWidth,
      memCacheWidth: cacheWidth,
      fadeInDuration: const Duration(milliseconds: 100),
      fadeOutDuration: Duration.zero,
      placeholder: (_, _) => ReaderBufferingPlaceholder(
        height: 320,
        backgroundColor: placeholderBg,
        pageLabel: pageText,
        onRefresh: _refresh,
        onTimeout: _triggerFallback,
      ),
      errorWidget: (_, _, _) {
        final fb = _fallback;
        if (fb != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _url = fb;
                _fellBack = true;
                _refreshKey++;
              });
            }
          });
          return ReaderBufferingPlaceholder(
            height: 220,
            backgroundColor: placeholderBg,
            pageLabel: pageText,
            onRefresh: _refresh,
          );
        }
        return InkWell(
          onTap: () async {
            await CachedNetworkImage.evictFromCache(_url);
            if (mounted) {
              setState(() {
                _refreshKey++;
              });
            }
            widget.onRetry();
          },
          child: Container(
            height: 200,
            alignment: Alignment.center,
            color: placeholderBg,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.broken_image_outlined),
                const SizedBox(height: 4),
                Text(
                  pageText != null
                      ? '$pageText: Gagal — ketuk untuk coba lagi'
                      : 'Gagal — ketuk untuk coba lagi',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
