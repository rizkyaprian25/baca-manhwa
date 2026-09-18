import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';

/// Entry point — `lib/main.dart`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Batasi cache gambar agar performa ringan, hemat RAM, dan anti-lag
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 << 20; // 100 MB
  PaintingBinding.instance.imageCache.maximumSize = 300; // max 300 gambar
  await initializeDateFormatting(AppConstants.locale);
  runApp(const ProviderScope(child: BacaManhwaApp()));
}
