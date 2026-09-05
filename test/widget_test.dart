import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:baca_manhwa/app.dart';

/// Smoke test: shell + floating nav 5 tujuan ter-render.
/// (Label hanya tampil di tab aktif ala MangaIndo.)
void main() {
  testWidgets('App menampilkan navigasi 5 tujuan', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BacaManhwaApp()));
    await tester.pumpAndSettle();

    // Tab aktif = Beranda (ikon + label).
    expect(find.text('Beranda'), findsOneWidget);
    // 5 ikon tujuan selalu ada (aktif = filled).
    expect(find.byIcon(Icons.cottage), findsWidgets);
    expect(find.byIcon(Icons.explore_outlined), findsOneWidget);
    expect(find.byIcon(Icons.auto_stories_outlined), findsOneWidget);
    expect(find.byIcon(Icons.history_outlined), findsOneWidget);
    expect(find.byIcon(Icons.tune_outlined), findsWidgets);

    // Pindah ke Jelajah: label ikut pindah (nav + judul layar).
    // (Semua label nav selalu tampil ala panduan.)
    await tester.tap(find.byIcon(Icons.explore_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Jelajah'), findsWidgets);
  });
}
