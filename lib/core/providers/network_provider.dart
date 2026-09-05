import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/dio_client.dart';
import '../network/mangadex_api.dart';

/// Dio + MangaDex API — `lib/core/providers/network_provider.dart`.
final dioProvider = Provider<Dio>((ref) => DioClient.create());

final mangadexApiProvider = Provider<MangadexApi>(
  (ref) => MangadexApi(ref.watch(dioProvider)),
);
