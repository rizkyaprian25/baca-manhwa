import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Versi Web: selalu network.
/// `lib/core/widgets/reader_image_provider_stub.dart`.
ImageProvider readerImageProvider(String url, String? localPath) {
  return CachedNetworkImageProvider(url);
}
