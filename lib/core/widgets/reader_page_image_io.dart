import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Halaman reader: file lokal bila ada, network bila tidak.
/// Sekali fallback host image2 -> img untuk Komiku.
/// `lib/core/widgets/reader_page_image_io.dart`.
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

class _ReaderPageImageState extends State<ReaderPageImage> {
  late String _url = widget.url;
  bool _fellBack = false;

  /// Host cadangan Komiku (sama seperti onerror di situsnya).
  String? get _fallback {
    if (_fellBack || !_url.contains('image2.komiku.to')) return null;
    return _url.replaceFirst('image2.komiku.to', 'img.komiku.org');
  }

  @override
  Widget build(BuildContext context) {
    final lp = widget.localPath;
    if (lp != null && File(lp).existsSync()) {
      return Image.file(
        File(lp),
        width: double.infinity,
        fit: BoxFit.fitWidth,
      );
    }
    return CachedNetworkImage(
      key: ValueKey(_url),
      imageUrl: _url,
      width: double.infinity,
      fit: BoxFit.fitWidth,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (_, _) => Container(
        height: 320,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: const Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
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
            child: const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
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
