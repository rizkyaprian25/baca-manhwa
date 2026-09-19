/// Header HTTP optimal untuk reader gambar manhwa (mencegah throttling/hotlink block).
/// Mengembalikan HTTP header yang sesuai berdasarkan URL gambar.
/// Memastikan server CDN komik (Komiku, MangaDex) menerima User-Agent browser
/// dan Referer yang sah agar bandwidth tidak di-throttle.
/// `lib/core/network/reader_image_headers.dart`.
Map<String, String> readerImageHeaders(String url) {
  final lower = url.toLowerCase();
  if (lower.contains('komiku')) {
    return const {
      'User-Agent':
          'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
          '(KHTML, like Gecko) Chrome/120.0 Mobile Safari/537.36',
      'Referer': 'https://komiku.org/',
      'Accept':
          'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
      'Accept-Language': 'id-ID,id;q=0.9,en;q=0.8',
    };
  }
  if (lower.contains('mangadex')) {
    return const {
      'User-Agent': 'BacaManhwa/1.0 (personal-use)',
      'Referer': 'https://mangadex.org/',
      'Accept':
          'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
    };
  }
  return const {
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/120.0 Mobile Safari/537.36',
    'Accept':
        'image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8',
  };
}

/// Normalisasi URL gambar agar selalu menggunakan host origin yang aktif dan andal.
/// Mengonversi subdomain Komiku yang mati/sering timeout (seperti image2..14.komiku.to)
/// menjadi origin server resmi 'img.komiku.org'.
String normalizeImageUrl(String url) {
  if (url.contains('.komiku.to') && url.contains('/upload')) {
    return url.replaceAll(
      RegExp(r'https?://image\d*\.komiku\.to'),
      'https://img.komiku.org',
    );
  }
  return url;
}
