// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:typed_data';

/// Generate ikon launcher "Baca Manhwa": kotak biru + buku putih.
/// Murni Dart (tanpa package) — dijalankan sekali via `dart run tool/make_logo.dart`.
/// Target: android mipmap-* + web/icons + favicon.

// CRC32 (IEEE) untuk chunk PNG.
final List<int> _crcTable = List<int>.generate(256, (n) {
  var c = n;
  for (var k = 0; k < 8; k++) {
    c = (c & 1) != 0 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1;
  }
  return c;
});

int _crc32(List<int> bytes) {
  var c = 0xFFFFFFFF;
  for (final b in bytes) {
    c = _crcTable[(c ^ b) & 0xFF] ^ (c >>> 8);
  }
  return c ^ 0xFFFFFFFF;
}

void _chunk(BytesBuilder out, String type, List<int> data) {
  final len = ByteData(4)..setUint32(0, data.length);
  final td = type.codeUnits;
  out.add(len.buffer.asUint8List());
  out.add(td);
  out.add(data);
  final crc = ByteData(4)..setUint32(0, _crc32([...td, ...data]));
  out.add(crc.buffer.asUint8List());
}

Uint8List _png(int size, {bool fullBleed = false}) {
  const bg = [47, 128, 214, 255]; // #2F80D6
  const fg = [255, 255, 255, 255];
  final px = Uint8List(size * size * 4);
  final r = fullBleed ? 0.0 : size * 0.24;

  bool inRoundRect(double x, double y) {
    if (fullBleed) return true;
    if (x >= r && x < size - r) return true;
    if (y >= r && y < size - r) return true;
    final cx = x < r ? r : size - r;
    final cy = y < r ? r : size - r;
    final dx = x - cx, dy = y - cy;
    return dx * dx + dy * dy <= r * r;
  }

  // Glyph buku terbuka: dua halaman + garis teks.
  bool inBook(double x, double y) {
    final nx = x / size, ny = y / size;
    // Badan halaman kiri/kanan.
    final inLeft = nx >= 0.30 && nx < 0.485 && ny >= 0.32 && ny < 0.68;
    final inRight = nx >= 0.515 && nx < 0.70 && ny >= 0.32 && ny < 0.68;
    if (!inLeft && !inRight) return false;
    // Garis teks (lubang sewarna bg).
    for (final ly in [0.42, 0.50, 0.58]) {
      if ((ny - ly).abs() < 0.012 && nx > 0.335 && nx < 0.665) return false;
    }
    return true;
  }

  for (var y = 0; y < size; y++) {
    for (var x = 0; x < size; x++) {
      final o = (y * size + x) * 4;
      if (!inRoundRect(x + 0.5, y + 0.5)) {
        px[o + 3] = 0; // transparan di luar sudut
        continue;
      }
      var c = bg;
      if (inBook(x + 0.5, y + 0.5)) c = fg;
      px[o] = c[0];
      px[o + 1] = c[1];
      px[o + 2] = c[2];
      px[o + 3] = c[3];
    }
  }

  final raw = BytesBuilder();
  for (var y = 0; y < size; y++) {
    raw.addByte(0); // filter: none
    raw.add(px.sublist(y * size * 4, (y + 1) * size * 4));
  }
  final out = BytesBuilder();
  out.add([137, 80, 78, 71, 13, 10, 26, 10]);
  final ihdr = ByteData(13)
    ..setUint32(0, size)
    ..setUint32(4, size)
    ..setUint8(8, 8)
    ..setUint8(9, 6);
  _chunk(out, 'IHDR', ihdr.buffer.asUint8List());
  _chunk(out, 'IDAT', ZLibEncoder().convert(raw.toBytes()));
  _chunk(out, 'IEND', []);
  return out.toBytes();
}

void main() {
  final targets = <String, int>{
    'android/app/src/main/res/mipmap-mdpi/ic_launcher.png': 48,
    'android/app/src/main/res/mipmap-hdpi/ic_launcher.png': 72,
    'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png': 96,
    'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png': 144,
    'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png': 192,
    'web/icons/Icon-192.png': 192,
    'web/icons/Icon-512.png': 512,
    'web/favicon.png': 32,
  };
  for (final e in targets.entries) {
    File(e.key).writeAsBytesSync(_png(e.value));
    print('logo ${e.key} (${e.value}px)');
  }
  // Maskable: full-bleed (tanpa sudut transparan).
  for (final e in {
    'web/icons/Icon-maskable-192.png': 192,
    'web/icons/Icon-maskable-512.png': 512,
  }.entries) {
    File(e.key).writeAsBytesSync(_png(e.value, fullBleed: true));
    print('logo ${e.key} (${e.value}px, maskable)');
  }
  print('LOGO OK');
}
