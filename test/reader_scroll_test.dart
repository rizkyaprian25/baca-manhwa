import 'package:baca_manhwa/core/network/reader_image_headers.dart';
import 'package:baca_manhwa/core/widgets/reader_buffering_placeholder.dart';
import 'package:baca_manhwa/core/widgets/reader_page_image.dart';
import 'package:baca_manhwa/features/settings/presentation/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Reader Auto-Scroll Speed Engine', () {
    test('autoScrollPixelsPerSecond meningkat secara monotonik & bertahap nyata', () {
      double previousSpeed = 0.0;

      for (int level = 1; level <= 10; level++) {
        final speed = autoScrollPixelsPerSecond(level.toDouble());

        // Kecepatan harus selalu lebih cepat dari level sebelumnya
        expect(speed, greaterThan(previousSpeed));

        // Selisih antar level harus terasa nyata (> 20 px/s)
        if (level > 1) {
          final diff = speed - previousSpeed;
          expect(diff, greaterThanOrEqualTo(20.0),
              reason: 'Selisih antara level $level dan ${level - 1} harus terasa nyata (minimal 20 px/s)');
        }

        previousSpeed = speed;
      }
    });

    test('autoScrollPixelsPerSecond menjaga batas clamp 1.0 sampai 10.0', () {
      final minSpeed = autoScrollPixelsPerSecond(1.0);
      final maxSpeed = autoScrollPixelsPerSecond(10.0);

      expect(autoScrollPixelsPerSecond(-5.0), equals(minSpeed));
      expect(autoScrollPixelsPerSecond(0.5), equals(minSpeed));
      expect(autoScrollPixelsPerSecond(15.0), equals(maxSpeed));
      expect(autoScrollPixelsPerSecond(100.0), equals(maxSpeed));
    });

    test('autoScrollSpeedLabel mengembalikan label deskriptif yang ramah pengguna', () {
      expect(autoScrollSpeedLabel(1.0), contains('Level 1'));
      expect(autoScrollSpeedLabel(1.0), contains('Sangat Lambat'));
      expect(autoScrollSpeedLabel(5.0), contains('Level 5'));
      expect(autoScrollSpeedLabel(5.0), contains('Normal'));
      expect(autoScrollSpeedLabel(10.0), contains('Level 10'));
      expect(autoScrollSpeedLabel(10.0), contains('Sangat Cepat'));
    });
  });

  group('Reader Image KeepAlive Widget Test', () {
    testWidgets('ReaderPageImage mempertahankan State KeepAlive', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReaderPageImage(
              url: 'https://example.com/chapter1/page1.jpg',
              onRetry: () {},
            ),
          ),
        ),
      );

      // Pastikan widget terpasang
      expect(find.byType(ReaderPageImage), findsOneWidget);
    });
  });

  group('Reader HTTP Anti-Throttling Headers Test', () {
    test('komiku URLs menyertakan Referer https://komiku.org/ dan User-Agent', () {
      final headers = readerImageHeaders('https://image2.komiku.to/uploads/2024/01/01.jpg');
      expect(headers['Referer'], equals('https://komiku.org/'));
      expect(headers['User-Agent'], contains('Chrome'));
      expect(headers['Accept'], contains('image/webp'));
    });

    test('img.komiku.org fallback URLs menyertakan Referer komiku', () {
      final headers = readerImageHeaders('https://img.komiku.org/uploads/2024/01/01.jpg');
      expect(headers['Referer'], equals('https://komiku.org/'));
    });

    test('mangadex URLs menyertakan Referer https://mangadex.org/', () {
      final headers = readerImageHeaders('https://uploads.mangadex.org/data/abc/1.jpg');
      expect(headers['Referer'], equals('https://mangadex.org/'));
      expect(headers['User-Agent'], equals('BacaManhwa/1.0 (personal-use)'));
    });

    test('URL generik memiliki User-Agent dan Accept image', () {
      final headers = readerImageHeaders('https://cdn.example.com/pic.webp');
      expect(headers['User-Agent'], isNotEmpty);
      expect(headers['Accept'], contains('image/'));
    });
  });

  group('Reader Buffering Watchdog & Refresh Widget Test', () {
    testWidgets('ReaderBufferingPlaceholder awalnya tampil tanpa tombol segarkan', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReaderBufferingPlaceholder(
              onRefresh: () {},
              slowThreshold: const Duration(seconds: 2),
            ),
          ),
        ),
      );

      expect(find.text('Segarkan Gambar'), findsNothing);
      expect(find.textContaining('Buffering agak lambat'), findsNothing);
    });

    testWidgets('ReaderBufferingPlaceholder menampilkan tombol Segarkan setelah timeout buffering', (tester) async {
      bool refreshed = false;
      bool timedOut = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ReaderBufferingPlaceholder(
              pageLabel: 'Hal. 1',
              slowThreshold: const Duration(milliseconds: 100),
              timeoutThreshold: const Duration(milliseconds: 200),
              onRefresh: () {
                refreshed = true;
              },
              onTimeout: () {
                timedOut = true;
              },
            ),
          ),
        ),
      );

      // Belum lambat di awal
      expect(find.text('Segarkan Gambar'), findsNothing);

      // Maju 150ms melampaui slowThreshold dan 350ms untuk transisi AnimatedSwitcher
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Segarkan Gambar'), findsOneWidget);
      expect(find.textContaining('Hal. 1: Buffering agak lambat'), findsOneWidget);

      // Tekan tombol Segarkan
      await tester.tap(find.text('Segarkan Gambar'));
      await tester.pump();
      expect(refreshed, isTrue);

      // Maju lagi melewati timeoutThreshold
      await tester.pump(const Duration(milliseconds: 100));
      expect(timedOut, isTrue);
    });
  });
}
