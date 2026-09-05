import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';

/// Entry point — `lib/main.dart`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(AppConstants.locale);
  runApp(const ProviderScope(child: BacaManhwaApp()));
}
