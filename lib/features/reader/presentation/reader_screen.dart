import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/network/reader_image_headers.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/widgets/apple_loading.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/reader_buffering_placeholder.dart';
import '../../../core/widgets/reader_image_provider.dart';
import '../../../core/widgets/reader_page_image.dart';
import '../../download/presentation/download_provider.dart';
import '../../manhwa_detail/presentation/detail_provider.dart'
    show sortChapters;
import '../../manga/domain/entities/manga.dart' show AtHome;
import '../../settings/presentation/settings_provider.dart';
import 'reader_provider.dart';

/// Reader: vertical webtoon + horizontal page-by-page + auto-resume.
/// `lib/features/reader/presentation/reader_screen.dart`.
class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key, required this.chapterId});
  final String chapterId;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen>
    with SingleTickerProviderStateMixin {
  late String _mode;
  bool _amoled = false;
  bool _showChrome = true;
  bool _tapNav = true;
  bool _missing = false;
  bool _resumeAsked = false;
  bool _showResumeBanner = false;
  int _resumePage = 0;
  bool _finishedMarked = false;
  bool _autoScrolling = false;
  bool _orientationLocked = false;
  int _total = 0;
  int _lastPrecachePage = -1;
  Timer? _precacheTimer;
  Ticker? _autoScrollTicker;
  Duration _lastAutoScrollTick = Duration.zero;
  Timer? _clockTimer;
  String _clock = '';

  Chapter? _chapter;
  String? _mangaTitle;
  List<Chapter> _siblings = const [];

  final _page = ValueNotifier<int>(0);
  final _progress = ValueNotifier<double>(0);
  final _vCtrl = ScrollController();
  PageController? _hCtrl;
  final _keys = <int, GlobalKey>{};
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _mode = ref.read(readDirectionProvider);
    _tickClock();
    _clockTimer =
        Timer.periodic(const Duration(seconds: 30), (_) => _tickClock());
    _init();
  }

  void _tickClock() {
    final now = DateTime.now();
    final t =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    if (mounted) setState(() => _clock = t);
  }

  /// Tandai posisi saat ini secara manual.
  Future<void> _bookmarkPage() async {
    if (_chapter == null || _total <= 0) return;
    await ref
        .read(databaseProvider)
        .saveReadingPage(_chapter!.id, _page.value);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Posisi tersimpan (Hal. ${_page.value + 1})'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _clockTimer?.cancel();
    // Simpan posisi terakhir (best-effort) agar keluar di tengah
    // chapter pun tetap tersimpan.
    if (_chapter != null && _total > 0) {
      ref.read(databaseProvider).saveReadingPage(_chapter!.id, _page.value);
    }
    // Kembalikan rotasi bebas.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _saveTimer?.cancel();
    _precacheTimer?.cancel();
    _vCtrl.dispose();
    _hCtrl?.dispose();
    _page.dispose();
    _progress.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final db = ref.read(databaseProvider);
    final ch = await db.getChapter(widget.chapterId);
    if (!mounted) return;
    if (ch == null) {
      setState(() => _missing = true);
      return;
    }
    final manga = await db.getManga(ch.mangaId);
    final sibs = sortChapters(await db.getChapters(ch.mangaId));
    if (!mounted) return;
    final start = ch.lastPage < 0 ? 0 : ch.lastPage;
    setState(() {
      _chapter = ch;
      _mangaTitle = manga?.title;
      _siblings = sibs;
      _page.value = start;
      _hCtrl = PageController(initialPage: start);
    });
    _vCtrl.addListener(_onVScroll);
    // Log buka chapter (riwayat + Sedang Dibaca) sekali.
    await db.markChapterRead(
      mangaId: ch.mangaId,
      chapterId: ch.id,
      page: start,
    );
  }

  // ---------- progress & simpan posisi ----------

  void _onVScroll() {
    if (!_vCtrl.hasClients) return;
    final max = _vCtrl.position.maxScrollExtent;
    _progress.value = max <= 0 ? 0 : (_vCtrl.offset / max).clamp(0.0, 1.0);
  }

  void _scheduleVSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      _savePage(_firstVisible());
    });
  }

  int _firstVisible() {
    if (_total <= 0) return _page.value;
    final padTop = MediaQuery.of(context).padding.top;
    final chromeTop = _showChrome ? kToolbarHeight + 8 : 0.0;
    final limit = padTop + chromeTop;
    for (var i = 0; i < _total; i++) {
      final ctx = _keys[i]?.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.attached || !box.hasSize) continue;
      final top = box.localToGlobal(Offset.zero).dy;
      if (top + box.size.height > limit + 1) return i;
    }
    return _page.value;
  }

  Future<void> _savePage(int i, {bool? finished}) async {
    if (_chapter == null || _total <= 0) return;
    final idx = i.clamp(0, _total - 1);
    _page.value = idx;
    final done = finished ?? (idx >= _total - 1);
    if (done && !_finishedMarked) {
      _finishedMarked = true;
      await ref.read(databaseProvider).markChapterRead(
            mangaId: _chapter!.mangaId,
            chapterId: _chapter!.id,
            page: idx,
            finished: true,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chapter selesai dibaca 🎉')),
        );
      }
    } else {
      await ref.read(databaseProvider).saveReadingPage(_chapter!.id, idx);
    }
    _precacheFrom(idx);
  }

  // ---------- preload & refresh ----------

  void _precacheFrom(int idx) {
    if (idx == _lastPrecachePage) return;
    _lastPrecachePage = idx;
    _precacheTimer?.cancel();
    // Debounce 350ms agar scrolling cepat tidak membombardir socket request
    _precacheTimer = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      final at = ref.read(atHomeProvider(widget.chapterId)).value;
      if (at == null) return;
      final local = ref.read(localPagesProvider(widget.chapterId)).value;
      final saver = ref.read(dataSaverProvider);
      final count = AppConstants.readerPreloadPages;
      for (var i = idx + 1; i <= idx + count && i < at.pageCount; i++) {
        if (local != null && i < local.length) continue; // sudah lokal
        final raw = at.pageUrl(i, dataSaver: saver);
        final u = normalizeImageUrl(raw);
        precacheImage(
          CachedNetworkImageProvider(
            u,
            headers: readerImageHeaders(u),
          ),
          context,
        ).catchError((_) {});
      }
    });
  }

  /// Segarkan chapter: bersihkan cache gambar yang menggantung,
  /// invalidate provider, dan muat ulang halaman.
  Future<void> _refreshChapter() async {
    final at = ref.read(atHomeProvider(widget.chapterId)).value;
    final saver = ref.read(dataSaverProvider);
    if (at != null) {
      final cur = _page.value;
      final start = (cur - 2).clamp(0, at.pageCount - 1);
      final end = (cur + 3).clamp(0, at.pageCount - 1);
      for (var i = start; i <= end; i++) {
        final raw = at.pageUrl(i, dataSaver: saver);
        await CachedNetworkImage.evictFromCache(raw);
        await CachedNetworkImage.evictFromCache(normalizeImageUrl(raw));
      }
    }
    _lastPrecachePage = -1;
    ref.invalidate(atHomeProvider(widget.chapterId));
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menyegarkan chapter & memuat ulang gambar...'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {});
    }
  }

  /// Path lokal halaman ke-[i] bila chapter sudah terunduh.
  String? _localPathFor(List<String>? paths, int i) {
    if (paths == null || i >= paths.length) return null;
    return paths[i];
  }

  // ---------- navigasi chapter ----------

  int get _sibIndex => _siblings.indexWhere((c) => c.id == widget.chapterId);
  Chapter? get _prevChapter =>
      _sibIndex > 0 ? _siblings[_sibIndex - 1] : null;
  Chapter? get _nextChapter => _sibIndex >= 0 && _sibIndex < _siblings.length - 1
      ? _siblings[_sibIndex + 1]
      : null;

  String _chapterLabel(Chapter c) =>
      (c.chapterNo == null || c.chapterNo!.isEmpty)
          ? 'Oneshot'
          : 'Ch. ${c.chapterNo}';

  void _goChapter(String id) => context.pushReplacement('/reader/$id');

  void _maybeResume(int total) {
    if (_resumeAsked || _chapter == null) return;
    _resumeAsked = true;
    final last = _chapter!.lastPage;
    if (last <= 0 || last >= total - 1) return;
    // Banner persisten (bukan snackbar sekilas): tetap tampil sampai
    // dipilih / ditutup.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _resumePage = last;
        _showResumeBanner = true;
      });
    });
  }

  void _dismissResume() {
    if (mounted) setState(() => _showResumeBanner = false);
  }

  void _jumpTo(int idx) {
    _dismissResume();
    if (_total <= 0) return;
    final i = idx.clamp(0, _total - 1);
    if (_mode == 'vertical') {
      // Lompat proporsional offset (andal untuk halaman jauh yang widget-nya
      // belum dibangun — ensureVisible gagal dalam kasus itu).
      if (_vCtrl.hasClients && _total > 1) {
        final max = _vCtrl.position.maxScrollExtent;
        _vCtrl.jumpTo((max * i / (_total - 1)).clamp(0.0, max));
      }
      _savePage(i);
    } else {
      _hCtrl?.jumpToPage(i);
    }
  }

  /// Banner "Lanjutkan halaman X?" — besar, jelas, tidak hilang sendiri.
  Widget _resumeBanner() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: _showChrome ? 200 : 90,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Lanjutkan bacaan?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Halaman ${_resumePage + 1} dari $_total',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _dismissResume,
                child: const Text('Nanti'),
              ),
              FilledButton(
                onPressed: () => _jumpTo(_resumePage),
                child: const Text('Lanjutkan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- kontrol HUD ----------

  void _toggleAutoScroll() {
    if (_mode != 'vertical') return;
    if (_autoScrolling) {
      _stopAutoScroll();
    } else {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    if (_mode != 'vertical' || _autoScrolling) return;
    setState(() => _autoScrolling = true);
    _lastAutoScrollTick = Duration.zero;
    _autoScrollTicker?.dispose();
    _autoScrollTicker = createTicker(_onAutoScrollTick);
    _autoScrollTicker?.start();
  }

  void _onAutoScrollTick(Duration elapsed) {
    if (!mounted || !_vCtrl.hasClients) {
      _stopAutoScroll();
      return;
    }

    if (_lastAutoScrollTick == Duration.zero) {
      _lastAutoScrollTick = elapsed;
      return;
    }

    final dtMicroseconds = (elapsed - _lastAutoScrollTick).inMicroseconds;
    _lastAutoScrollTick = elapsed;

    // Proteksi delta time (clamp antara 1ms sampai 50ms jika frame drop)
    final dt = (dtMicroseconds / 1000000.0).clamp(0.001, 0.05);

    final speedLevel = ref.read(autoScrollSpeedProvider);
    final pxPerSec = autoScrollPixelsPerSecond(speedLevel);
    final delta = pxPerSec * dt;

    final max = _vCtrl.position.maxScrollExtent;
    final next = _vCtrl.offset + delta;
    if (next >= max) {
      _vCtrl.jumpTo(max);
      _stopAutoScroll();
      return;
    }
    _vCtrl.jumpTo(next);
  }

  void _stopAutoScroll() {
    _autoScrollTicker?.stop();
    _autoScrollTicker?.dispose();
    _autoScrollTicker = null;
    _lastAutoScrollTick = Duration.zero;
    if (_autoScrolling && mounted) {
      setState(() => _autoScrolling = false);
    } else {
      _autoScrolling = false;
    }
  }

  void _toggleOrientationLock() {
    setState(() => _orientationLocked = !_orientationLocked);
    if (_orientationLocked) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void _sliderJump(int idx) {
    if (_total <= 0) return;
    final i = idx.clamp(0, _total - 1);
    if (_mode == 'vertical') {
      if (_vCtrl.hasClients) {
        final max = _vCtrl.position.maxScrollExtent;
        _vCtrl.jumpTo(_total <= 1 ? 0 : max * i / (_total - 1));
      }
      _savePage(i);
    } else {
      _hCtrl?.jumpToPage(i);
    }
  }

  // ---------- build ----------

  @override
  Widget build(BuildContext context) {
    if (_missing) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          error: Exception('Chapter tidak ditemukan di cache.'),
          onRetry: () => context.pop(),
        ),
      );
    }
    if (_chapter == null) {
      return const Scaffold(
        body: AppleLoadingView(message: 'Menyiapkan bab...'),
      );
    }
    final atHome = ref.watch(atHomeProvider(widget.chapterId));
    final brightness = ref.watch(readerBrightnessProvider);
    final dim = brightness == null
        ? 0.0
        : ((1.0 - brightness) * 0.75).clamp(0.0, 0.7);
    final bg = _amoled ? Colors.black : null;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          switch (atHome) {
            AsyncData(:final value) => _readerBody(
                atHome: value,
                onReady: () => _maybeResume(value.pageCount),
              ),
            AsyncError(:final error) => ErrorView(
                error: error,
                onRetry: () =>
                    ref.invalidate(atHomeProvider(widget.chapterId)),
              ),
            _ => const AppleLoadingView(message: 'Memuat halaman chapter...'),
          },
          if (dim > 0)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(color: Colors.black.withValues(alpha: dim)),
              ),
            ),
          if (_showResumeBanner) _resumeBanner(),
          if (_autoScrolling) _floatingAutoScrollHud(),
          if (_showChrome) ...[
            _topHud(),
            _pagePill(),
            _bottomController(),
          ] else ...[
            _pagePill(),
          ],
        ],
      ),
    );
  }

  /// HUD atas mengambang: kembali + judul + pengaturan.
  Widget _topHud() {
    final scheme = Theme.of(context).colorScheme;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                color: scheme.surfaceContainerHigh.withValues(alpha: 0.9),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.wifi,
                                size: 12,
                                color: scheme.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Baca Manhwa',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _clock,
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Kembali',
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _mangaTitle ?? 'Membaca...',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              ValueListenableBuilder<int>(
                                valueListenable: _page,
                                builder: (_, p, _) => Text(
                                  _total <= 0
                                      ? _chapterLabel(_chapter!)
                                      : '${_chapterLabel(_chapter!)} • Hal. ${p + 1}/$_total',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Segarkan chapter',
                          icon: const Icon(Icons.refresh_rounded),
                          onPressed: _refreshChapter,
                        ),
                        IconButton(
                          tooltip: 'Tandai posisi',
                          icon: const Icon(Icons.bookmark_add_outlined),
                          onPressed: _bookmarkPage,
                        ),
                        IconButton(
                          tooltip: 'Pengaturan baca',
                          icon: const Icon(Icons.tune),
                          onPressed: _openReaderSettings,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ValueListenableBuilder<int>(
                      valueListenable: _page,
                      builder: (_, p, _) => ValueListenableBuilder<double>(
                        valueListenable: _progress,
                        builder: (_, v, _) => LinearProgressIndicator(
                          value: _mode == 'vertical'
                              ? (v == 0 ? null : v)
                              : (_total <= 0 ? null : (p + 1) / _total),
                          minHeight: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Pil penghitung halaman (selalu terlihat).
  Widget _pagePill() {
    final scheme = Theme.of(context).colorScheme;
    final pillBottom = _showChrome ? 316.0 : (_autoScrolling ? 88.0 : 24.0);
    return Positioned(
      right: 16,
      bottom: pillBottom,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: scheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              ValueListenableBuilder<int>(
                valueListenable: _page,
                builder: (_, p, _) => Text(
                  _total <= 0 ? '...' : '${p + 1} / $_total',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Controller bawah: slider + navigasi + tile cepat + badge.
  Widget _bottomController() {
    final scheme = Theme.of(context).colorScheme;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              color: scheme.surfaceContainerHigh.withValues(alpha: 0.95),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Kemajuan Membaca',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                      ValueListenableBuilder<int>(
                        valueListenable: _page,
                        builder: (_, p, _) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _total <= 0
                                ? '...'
                                : '${(((p + 1) / _total) * 100).round()}%',
                            style: TextStyle(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ValueListenableBuilder<int>(
                    valueListenable: _page,
                    builder: (_, p, _) => Slider(
                      min: 1,
                      max: _total <= 0 ? 1 : _total.toDouble(),
                      divisions: _total <= 1 ? 1 : _total - 1,
                      value: _total <= 0
                          ? 1
                          : (p + 1).clamp(1, _total).toDouble(),
                      onChanged: (v) => _sliderJump(v.round() - 1),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          icon: const Icon(Icons.fast_rewind),
                          label: Text(
                            _prevChapter == null
                                ? 'Awal'
                                : _chapterLabel(_prevChapter!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onPressed: _prevChapter == null
                              ? null
                              : () => _goChapter(_prevChapter!.id),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        icon: Icon(
                          _autoScrolling ? Icons.pause : Icons.play_arrow,
                        ),
                        label: Text(
                          _autoScrolling ? 'Jeda' : 'Scroll Otomatis',
                        ),
                        onPressed: _mode == 'vertical'
                            ? _toggleAutoScroll
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          icon: const Icon(Icons.fast_forward),
                          label: Text(
                            _nextChapter == null
                                ? 'Akhir'
                                : _chapterLabel(_nextChapter!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onPressed: _nextChapter == null
                              ? null
                              : () => _goChapter(_nextChapter!.id),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// HUD mini mengambang saat auto-scroll aktif (Apple Liquid Glass pill).
  Widget _floatingAutoScrollHud() {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentSpeed = ref.watch(autoScrollSpeedProvider).clamp(1.0, 10.0);

    return Positioned(
      bottom: _showChrome ? 170 : 28,
      left: 20,
      right: 20,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xCC1C1C1E)
                    : const Color(0xE6FFFFFF),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: isDark
                      ? const Color(0x33FFFFFF)
                      : const Color(0x1F000000),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Hentikan Scroll',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.pause, color: scheme.primary),
                    onPressed: _stopAutoScroll,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Perlambat',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.remove, size: 18),
                    onPressed: currentSpeed > 1.0
                        ? () => ref
                            .read(settingsActionsProvider)
                            .setAutoScrollSpeed(currentSpeed - 1.0)
                        : null,
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 105),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      autoScrollSpeedLabel(currentSpeed),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Percepat',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: currentSpeed < 10.0
                        ? () => ref
                            .read(settingsActionsProvider)
                            .setAutoScrollSpeed(currentSpeed + 1.0)
                        : null,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Tutup',
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: scheme.onSurfaceVariant,
                    ),
                    onPressed: _stopAutoScroll,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _readerBody({required AtHome atHome, required VoidCallback onReady}) {
    if (_total != atHome.pageCount) _total = atHome.pageCount;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        onReady();
        _precacheFrom(_page.value);
      }
    });
    return _mode == 'vertical'
        ? _verticalList(atHome)
        : _horizontalPager(atHome);
  }

  // ----- vertical -----

  /// Geser vertikal sejauh fraksi layar (dipakai tap-zone).
  void _scrollByScreen(double factor) {
    if (!_vCtrl.hasClients) return;
    _stopAutoScroll();
    final h = MediaQuery.of(context).size.height;
    final max = _vCtrl.position.maxScrollExtent;
    final target = (_vCtrl.offset + h * factor).clamp(0.0, max);
    _vCtrl.animateTo(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Widget _verticalList(AtHome atHome) {
    final saver = ref.watch(dataSaverProvider);
    final localPaths =
        ref.watch(localPagesProvider(widget.chapterId)).value;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      // Zona ketuk vertikal: atas = naik, tengah = tampil/sembunyi UI,
      // bawah = turun satu layar.
      onTapUp: (d) {
        if (!_tapNav) {
          setState(() => _showChrome = !_showChrome);
          return;
        }
        final h = MediaQuery.of(context).size.height;
        final y = d.globalPosition.dy / h;
        if (y < 0.33) {
          _scrollByScreen(-0.85);
        } else if (y > 0.67) {
          _scrollByScreen(0.85);
        } else {
          setState(() => _showChrome = !_showChrome);
        }
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n is UserScrollNotification &&
              n.direction != ScrollDirection.idle) {
            if (_autoScrolling) {
              _stopAutoScroll();
            }
          }
          if (n is ScrollEndNotification) _scheduleVSave();
          return false;
        },
        child: ListView.builder(
          controller: _vCtrl,
          scrollCacheExtent: const ScrollCacheExtent.pixels(2000.0),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemCount: atHome.pageCount + 1,
          itemBuilder: (ctx, i) {
            if (i == atHome.pageCount) return _footer();
            final url = normalizeImageUrl(atHome.pageUrl(i, dataSaver: saver));
            final local = _localPathFor(localPaths, i);
            final key = _keys.putIfAbsent(i, () => GlobalKey());
            return GestureDetector(
              key: key,
              onDoubleTap: () => _openZoom(url, local),
              child: ReaderPageImage(
                url: url,
                localPath: local,
                pageIndex: i,
                onRetry: () => setState(() {}),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _footer() {
    final next = _nextChapter;
    final scheme = Theme.of(context).colorScheme;
    var nextDesc = '';
    if (next != null) {
      nextDesc = 'Lanjut ke ${_chapterLabel(next)}';
      if (next.title != null && next.title!.isNotEmpty) {
        nextDesc += ": '${next.title}'";
      }
    }
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_circle_outline, color: scheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            'AKHIR DARI ${_chapterLabel(_chapter!).toUpperCase()}',
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (next != null) ...[
            Text(
              nextDesc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: Text('Chapter Berikutnya (${_chapterLabel(next)})'),
              onPressed: () => _goChapter(next.id),
            ),
          ] else ...[
            const SizedBox(height: 4),
            const Text('Kamu sudah sampai chapter terakhir yang tersimpan.'),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Kembali'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openZoom(String url, String? localPath) {
    return showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (_) => Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            PhotoView(
              imageProvider: readerImageProvider(url, localPath),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----- horizontal -----

  Widget _horizontalPager(AtHome atHome) {
    final saver = ref.watch(dataSaverProvider);
    final localPaths =
        ref.watch(localPagesProvider(widget.chapterId)).value;
    final ctrl = _hCtrl;
    if (ctrl == null) return const Center(child: CircularProgressIndicator());
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (d) {
        final w = MediaQuery.of(context).size.width;
        final x = d.globalPosition.dx / w;
        if (!_tapNav || (x >= 0.33 && x <= 0.67)) {
          setState(() => _showChrome = !_showChrome);
          return;
        }
        final p = _page.value;
        if (x < 0.33) {
          if (p > 0) {
            ctrl.previousPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          } else if (_prevChapter != null) {
            _goChapter(_prevChapter!.id);
          }
        } else {
          if (p < _total - 1) {
            ctrl.nextPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          } else if (_nextChapter != null) {
            _goChapter(_nextChapter!.id);
          } else {
            setState(() => _showChrome = true);
          }
        }
      },
      child: PageView.builder(
        controller: ctrl,
        itemCount: atHome.pageCount,
        onPageChanged: (i) => _savePage(i),
        itemBuilder: (ctx, i) {
          final url = normalizeImageUrl(atHome.pageUrl(i, dataSaver: saver));
          return _HorizontalPageKeepAlive(
            child: PhotoView(
              imageProvider:
                  readerImageProvider(url, _localPathFor(localPaths, i)),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              loadingBuilder: (c, ev) => ReaderBufferingPlaceholder(
                pageLabel: 'Hal. ${i + 1}',
                onRefresh: () async {
                  await CachedNetworkImage.evictFromCache(url);
                  if (mounted) setState(() {});
                },
              ),
              errorBuilder: (_, _, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.broken_image_outlined, size: 48),
                    const SizedBox(height: 8),
                    Text('Hal. ${i + 1}: Gagal memuat halaman'),
                    const SizedBox(height: 8),
                    FilledButton.tonalIcon(
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Coba Lagi'),
                      onPressed: () async {
                        await CachedNetworkImage.evictFromCache(url);
                        if (mounted) setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ----- sheet pengaturan -----

  Future<void> _openReaderSettings() {
    return showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pengaturan Baca',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
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
                selected: {_mode},
                onSelectionChanged: (s) {
                  Navigator.pop(ctx);
                  final cur = _page.value;
                  setState(() {
                    _mode = s.first;
                    if (_mode == 'horizontal') {
                      _hCtrl?.dispose();
                      _hCtrl = PageController(initialPage: cur);
                    }
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Hitam pekat (AMOLED)'),
                value: _amoled,
                onChanged: (v) => setState(() {
                  _amoled = v;
                  Navigator.pop(ctx);
                }),
              ),
              SwitchListTile(
                title: const Text('Ketuk untuk navigasi'),
                subtitle: const Text('Atas naik • tengah UI • bawah turun'),
                value: _tapNav,
                onChanged: (v) => setState(() {
                  _tapNav = v;
                  Navigator.pop(ctx);
                }),
              ),
              SwitchListTile(
                title: const Text('Scroll otomatis'),
                subtitle: const Text('Mode vertikal • Ticker VSync mulus'),
                value: _autoScrolling,
                onChanged: _mode == 'vertical'
                    ? (_) {
                        _toggleAutoScroll();
                        Navigator.pop(ctx);
                      }
                    : null,
              ),
              Consumer(
                builder: (_, ref2, _) {
                  final s =
                      ref2.watch(autoScrollSpeedProvider).clamp(1.0, 10.0);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Kecepatan scroll otomatis'),
                          ),
                          Text(
                            autoScrollSpeedLabel(s),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Slider(
                        value: s,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: autoScrollSpeedLabel(s),
                        onChanged: (v) => ref2
                            .read(settingsActionsProvider)
                            .setAutoScrollSpeed(v),
                      ),
                    ],
                  );
                },
              ),
              SwitchListTile(
                title: const Text('Kunci portrait'),
                value: _orientationLocked,
                onChanged: (_) {
                  _toggleOrientationLock();
                  Navigator.pop(ctx);
                },
              ),
              Consumer(
                builder: (_, ref2, _) {
                  final b = ref2.watch(readerBrightnessProvider) ?? 1.0;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Text('Kecerahan reader')),
                          TextButton(
                            onPressed: () {
                              ref2
                                  .read(settingsActionsProvider)
                                  .setBrightness(null);
                              Navigator.pop(ctx);
                            },
                            child: const Text('Ikut Sistem'),
                          ),
                        ],
                      ),
                      Slider(
                        value: b.clamp(0.3, 1.0),
                        min: 0.3,
                        max: 1.0,
                        divisions: 7,
                        label: '${(b * 100).round()}%',
                        onChanged: (v) => ref2
                            .read(settingsActionsProvider)
                            .setBrightness(v),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pembungkus KeepAlive untuk halaman horizontal agar tidak re-render saat swipe mundur.
class _HorizontalPageKeepAlive extends StatefulWidget {
  const _HorizontalPageKeepAlive({required this.child});
  final Widget child;

  @override
  State<_HorizontalPageKeepAlive> createState() =>
      _HorizontalPageKeepAliveState();
}

class _HorizontalPageKeepAliveState extends State<_HorizontalPageKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}


/// Satu halaman vertikal full-width (+ retry) — pindah ke
/// `lib/core/widgets/reader_page_image.dart` (varian IO/Web) — Fase 5.


