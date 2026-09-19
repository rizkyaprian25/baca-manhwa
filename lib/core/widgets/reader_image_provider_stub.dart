import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../network/reader_image_headers.dart';

/// Versi Web: selalu network (localPath diabaikan).
/// Mendukung normalisasi host origin dan HTTP headers anti-throttling.
/// `lib/core/widgets/reader_image_provider_stub.dart`.
ImageProvider readerImageProvider(String url, String? localPath) {
  final normalized = normalizeImageUrl(url);
  return CachedNetworkImageProvider(
    normalized,
    headers: readerImageHeaders(normalized),
  );
}
