import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../network/reader_image_headers.dart';

/// ImageProvider halaman: file lokal bila ada, network bila tidak.
/// Mendukung normalisasi host origin dan HTTP headers anti-throttling.
/// `lib/core/widgets/reader_image_provider_io.dart`.
ImageProvider readerImageProvider(String url, String? localPath) {
  final lp = localPath;
  if (lp != null && File(lp).existsSync()) return FileImage(File(lp));
  final normalized = normalizeImageUrl(url);
  return CachedNetworkImageProvider(
    normalized,
    headers: readerImageHeaders(normalized),
  );
}
