import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// ImageProvider halaman: file lokal bila ada, network bila tidak.
/// `lib/core/widgets/reader_image_provider_io.dart`.
ImageProvider readerImageProvider(String url, String? localPath) {
  final lp = localPath;
  if (lp != null && File(lp).existsSync()) return FileImage(File(lp));
  return CachedNetworkImageProvider(url);
}
