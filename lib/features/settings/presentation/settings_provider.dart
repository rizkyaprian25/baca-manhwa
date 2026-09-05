import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/storage_helper.dart';
import '../../../core/providers/database_provider.dart';

/// Settings: stream + turunan + aksi tulis.
/// `lib/features/settings/presentation/settings_provider.dart`.
final settingsStreamProvider = StreamProvider<AppSetting>((ref) {
  return ref.watch(databaseProvider).watchSettings();
});

ThemeMode _themeOf(String? v) => switch (v) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };

final themeModeProvider = Provider<ThemeMode>((ref) {
  final s = ref.watch(settingsStreamProvider).value;
  return _themeOf(s?.theme);
});

/// Bahasa chapter default: 'id' | 'en'.
final chapterLangProvider = Provider<String>((ref) {
  return ref.watch(settingsStreamProvider).value?.chapterLang ?? 'id';
});

/// true = sensor konten dewasa ON (default).
final adultFilterProvider = Provider<bool>((ref) {
  return ref.watch(settingsStreamProvider).value?.adultFilter ?? true;
});

final dataSaverProvider = Provider<bool>((ref) {
  return ref.watch(settingsStreamProvider).value?.dataSaver ?? false;
});

/// 'vertical' | 'horizontal'.
final readDirectionProvider = Provider<String>((ref) {
  return ref.watch(settingsStreamProvider).value?.readDirection ??
      'vertical';
});

final readerBrightnessProvider = Provider<double?>((ref) {
  return ref.watch(settingsStreamProvider).value?.brightness;
});

/// Sumber konten: 'komiku' (Indonesia, default) | 'mangadex'.
final sourceProvider = Provider<String>((ref) {
  return ref.watch(settingsStreamProvider).value?.source ?? 'komiku';
});

/// Aksi tulis settings (dipakai UI + reader).
class SettingsActions {
  SettingsActions(this._ref);
  final Ref _ref;

  AppDatabase get _db => _ref.read(databaseProvider);

  Future<void> setTheme(String v) =>
      _db.updateSettings(AppSettingsCompanion(theme: Value(v)));
  Future<void> setChapterLang(String v) =>
      _db.updateSettings(AppSettingsCompanion(chapterLang: Value(v)));
  Future<void> setAdultFilter(bool v) =>
      _db.updateSettings(AppSettingsCompanion(adultFilter: Value(v)));
  Future<void> setDataSaver(bool v) =>
      _db.updateSettings(AppSettingsCompanion(dataSaver: Value(v)));
  Future<void> setReadDirection(String v) =>
      _db.updateSettings(AppSettingsCompanion(readDirection: Value(v)));
  Future<void> setBrightness(double? v) =>
      _db.updateSettings(AppSettingsCompanion(brightness: Value(v)));
  Future<void> setSource(String v) =>
      _db.updateSettings(AppSettingsCompanion(source: Value(v)));
  Future<void> setAutoScrollSpeed(double v) => _db.updateSettings(
        AppSettingsCompanion(autoScrollSpeed: Value(v.clamp(1.0, 10.0))),
      );

  /// Simpan query ke riwayat pencarian (max 8, unik).
  Future<void> addRecentSearch(String query) async {
    final current = await _db.getSettings().then(
          (s) => decodeRecentSearches(s.recentSearches),
        );
    final merged = mergeRecentSearches(current, query);
    await _db.updateSettings(
      AppSettingsCompanion(recentSearches: Value(jsonEncode(merged))),
    );
  }

  Future<void> clearRecentSearches() => _db.updateSettings(
        const AppSettingsCompanion(recentSearches: Value('[]')),
      );
}

final settingsActionsProvider =
    Provider<SettingsActions>((ref) => SettingsActions(ref));

/// Ukuran cache gambar (refresh manual via invalidate).
final cacheBytesProvider = FutureProvider<int>((ref) {
  return StorageHelper.appCacheBytes();
});

/// Kecepatan scroll otomatis reader (px per 50ms, default 4).
final autoScrollSpeedProvider = Provider<double>((ref) {
  return ref.watch(settingsStreamProvider).value?.autoScrollSpeed ?? 4.0;
});

/// Riwayat query pencarian (persisten, max 8).
final recentSearchesProvider = Provider<List<String>>((ref) {
  final raw = ref.watch(settingsStreamProvider).value?.recentSearches;
  return decodeRecentSearches(raw);
});

/// Pure helpers (unit-testable).
List<String> decodeRecentSearches(String? raw) {
  if (raw == null || raw.isEmpty) return [];
  try {
    final d = jsonDecode(raw);
    if (d is List) return d.whereType<String>().toList();
  } catch (_) {}
  return [];
}

List<String> mergeRecentSearches(
  List<String> current,
  String query, {
  int max = 8,
}) {
  final q = query.trim();
  if (q.isEmpty) return current;
  final out = [q, ...current.where((e) => e.toLowerCase() != q.toLowerCase())];
  return out.take(max).toList();
}
