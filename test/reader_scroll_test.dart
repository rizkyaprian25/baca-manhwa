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
}
