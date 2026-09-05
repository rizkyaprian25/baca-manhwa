import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/database/tables/library_entries.dart';
import 'core/theme/app_theme.dart';
import 'features/download/presentation/downloads_screen.dart';
import 'features/history/presentation/history_screen.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/library/presentation/library_provider.dart';
import 'features/library/presentation/library_screen.dart';
import 'features/manhwa_detail/presentation/detail_screen.dart';
import 'features/reader/presentation/reader_screen.dart';
import 'features/search/presentation/search_screen.dart';
import 'features/settings/presentation/settings_provider.dart';
import 'features/settings/presentation/settings_screen.dart';

/// Router + shell 5 tab KuroYomi — `lib/app.dart`.
final _router = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          _ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (_, state) => SearchScreen(
                initialQuery:
                    state.uri.queryParameters['q'] ?? '',
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (_, _) => const LibraryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/history',
              builder: (_, _) => const HistoryScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (_, _) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/manga/:id',
      builder: (_, state) =>
          DetailScreen(mangaId: state.pathParameters['id'] ?? ''),
    ),
    GoRoute(
      path: '/reader/:chapterId',
      builder: (_, state) =>
          ReaderScreen(chapterId: state.pathParameters['chapterId'] ?? ''),
    ),
    GoRoute(
      path: '/downloads',
      builder: (_, _) => const DownloadsScreen(),
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  const _ScaffoldWithNavBar({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.cottage_outlined),
            selectedIcon: Icon(Icons.cottage),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Jelajah',
          ),
          NavigationDestination(
            icon: _PustakaBadge(selected: false),
            selectedIcon: _PustakaBadge(selected: true),
            label: 'Pustaka',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            selectedIcon: Icon(Icons.tune),
            label: 'Setelan',
          ),
        ],
      ),
    );
  }
}

/// Ikon Pustaka + badge jumlah isi semua rak.
class _PustakaBadge extends ConsumerWidget {
  const _PustakaBadge({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var total = 0;
    for (final t in LibraryList.all) {
      total += ref.watch(libraryTabProvider(t)).value?.length ?? 0;
    }
    final icon = Icon(
      selected ? Icons.auto_stories : Icons.auto_stories_outlined,
    );
    if (total == 0) return icon;
    return Badge(label: Text('$total'), child: icon);
  }
}

class BacaManhwaApp extends ConsumerWidget {
  const BacaManhwaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Baca Manhwa',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
