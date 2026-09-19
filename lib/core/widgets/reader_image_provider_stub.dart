import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../network/reader_image_headers.dart';

/// Versi Web: selalu network (localPath diabaikan).
/// Mendukung HTTP headers anti-throttling untuk reader gambar manhwa.
/// `lib/core/widgets/reader_image_provider_stub.dart`.
ImageProvider readerImageProvider(String url, String? localPath) {
  return CachedNetworkImageProvider(
    url,
    headers: readerImageHeaders(url),
  );
}
