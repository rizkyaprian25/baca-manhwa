import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/storage_helper.dart';
import '../../../services/backup_service.dart';
import 'settings_provider.dart';

/// Pengaturan: tema, bahasa, filter, kualitas, cache, backup, tentang.
/// `lib/features/settings/presentation/settings_screen.dart`.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStreamProvider).value;
    final actions = ref.read(settingsActionsProvider);
    final theme = settings?.theme ?? 'system';
    final lang = settings?.chapterLang ?? 'id';
    final direction = settings?.readDirection ?? 'vertical';
    final source = settings?.source ?? 'komiku';

    return Scaffold(
      appBar: AppBar(title: const Text('Setelan')),
      body: ListView(
        children: [
          _Header('Tampilan'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'light',
                  icon: Icon(Icons.light_mode_outlined),
                  label: Text('Terang'),
                ),
                ButtonSegment(
                  value: 'dark',
                  icon: Icon(Icons.dark_mode_outlined),
                  label: Text('Gelap'),
                ),
                ButtonSegment(
                  value: 'system',
                  icon: Icon(Icons.settings_outlined),
                  label: Text('Sistem'),
                ),
              ],
              selected: {theme},
              onSelectionChanged: (s) => actions.setTheme(s.first),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Expanded(child: Text('Arah baca default')),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'vertical',
                      icon: Icon(Icons.swap_vert),
                      label: Text('Vertikal'),
                    ),
                    ButtonSegment(
                      value: 'horizontal',
                      icon: Icon(Icons.swap_horiz),
                      label: Text('Halaman'),
                    ),
                  ],
                  selected: {direction},
                  onSelectionChanged: (s) =>
                      actions.setReadDirection(s.first),
                ),
              ],
            ),
          ),
          _Header('Konten'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Expanded(child: Text('Sumber konten')),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'komiku',
                      label: Text('Komiku ID'),
                    ),
                    ButtonSegment(
                      value: 'mangadex',
                      label: Text('MangaDex'),
                    ),
                  ],
                  selected: {source},
                  onSelectionChanged: (s) =>
                      actions.setSource(s.first),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              source == 'komiku'
                  ? 'Komiku: manhwa Bahasa Indonesia.'
                  : 'MangaDex: multi-bahasa (ID terbatas), butuh network tak-terblokir.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                const Expanded(child: Text('Bahasa chapter default')),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'id', label: Text('Indonesia')),
                    ButtonSegment(value: 'en', label: Text('English')),
                  ],
                  selected: {lang},
                  onSelectionChanged: (s) =>
                      actions.setChapterLang(s.first),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text('Sensor konten dewasa'),
            subtitle: const Text(
              'ON: hanya tampilkan Safe & Suggestive',
            ),
            value: settings?.adultFilter ?? true,
            onChanged: actions.setAdultFilter,
          ),
          SwitchListTile(
            title: const Text('Mode hemat data'),
            subtitle: const Text(
              'Muat gambar resolusi rendah di reader',
            ),
            value: settings?.dataSaver ?? false,
            onChanged: actions.setDataSaver,
          ),
          _Header('Penyimpanan'),
          Consumer(
            builder: (_, ref2, _) {
              final cache = ref2.watch(cacheBytesProvider);
              return ListTile(
                leading: const Icon(Icons.cleaning_services_outlined),
                title: const Text('Cache gambar'),
                subtitle: switch (cache) {
                  AsyncData(:final value) =>
                    Text(StorageHelper.formatBytes(value)),
                  AsyncError() => const Text('Gagal menghitung'),
                  _ => const Text('Menghitung...'),
                },
                trailing: TextButton(
                  onPressed: () async {
                    await StorageHelper.clearImageCache();
                    ref2.invalidate(cacheBytesProvider);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cache gambar dihapus'),
                        ),
                      );
                    }
                  },
                  child: const Text('Hapus'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('Kelola Unduhan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/downloads'),
          ),
          _Header('Data Pribadi'),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Backup ke file JSON'),
            subtitle: const Text('Favorit, progres baca, riwayat, pengaturan'),
            onTap: () => _backup(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: const Text('Restore dari JSON'),
            subtitle:
                const Text('Menggabungkan (tidak menghapus data lokal)'),
            onTap: () => _restore(context, ref),
          ),
          _Header('Tentang'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('${AppConstants.appName} ${AppConstants.appVersion}'),
            subtitle: const Text(
              'Pemakaian pribadi • Data: MangaDex API',
            ),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: AppConstants.appName,
              applicationVersion: AppConstants.appVersion,
              children: const [
                Text(
                  'Aplikasi baca pribadi (tidak dipublikasikan). '
                  'Seluruh konten manhwa adalah hak cipta pemiliknya; '
                  'aplikasi ini hanya mengakses indeks MangaDex '
                  'dan mengikuti ToS serta rate limit mereka. '
                  'Atribusi: MangaDex & grup scanlation terkait.',
                ),
              ],
            ),
          ),
          const ExpansionTile(
            leading: Icon(Icons.help_outline),
            title: Text('Tidak bisa memuat data?'),
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  'Sebagian provider internet Indonesia memblokir MangaDex '
                  'di level DNS. Solusi: aktifkan Private DNS '
                  '(mis. dns.google atau one.one.one.one) di Pengaturan '
                  'Android → Jaringan, gunakan data seluler lain, atau VPN. '
                  'Aplikasi tidak mem-bypass blokir secara diam-diam.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(backupServiceProvider).shareBackup();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Backup gagal: $e')),
        );
      }
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final svc = ref.read(backupServiceProvider);
    final text = await svc.pickBackupString();
    if (text == null) return; // batal
    if (!context.mounted) return;
    Map<String, dynamic>? json;
    try {
      final d = jsonDecode(text);
      if (d is Map<String, dynamic> && d['app'] == 'baca_manhwa') json = d;
    } catch (_) {}
    if (json == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File tidak valid / rusak')),
      );
      return;
    }
    final current = await svc.currentSummary();
    if (!context.mounted) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore backup?'),
        content: Text(
          'Isi file:\n${BackupService.summaryOf(json!)}\n\n'
          'Data saat ini:\n$current\n\n'
          'Restore MENGGABUNGKAN (tidak menghapus data lokal).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      final sum = await svc.importJsonString(text);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore selesai: $sum')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore gagal: $e')),
        );
      }
    }
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
