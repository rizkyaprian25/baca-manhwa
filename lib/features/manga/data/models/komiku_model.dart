import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

import '../../domain/entities/manga.dart';

/// Parsing HTML Komiku -> entity.
/// `lib/features/manga/data/models/komiku_model.dart`.
/// ID: manga `k:{slug}`, chapter `k:{mangaSlug}:{chapterSlug}`.

String mangaSlugOf(String href) {
  final m = RegExp(r'/manga/([a-z0-9-]+)/?').firstMatch(href);
  return m?.group(1) ?? '';
}

String chapterSlugOf(String href) {
  var s = href.trim();
  if (s.startsWith('http')) s = Uri.parse(s).path;
  return s.replaceAll(RegExp(r'^/+|/+$'), '');
}

/// Judul cocok keyword: semua kata (≥2 huruf) harus muncul UTUH di judul
/// (case-insensitive). "king" cocok "Demon King", tapi BUKAN "Ranking".
bool titleMatchesQuery(String title, String query) {
  final words = query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((w) => w.length >= 2)
      .toList();
  if (words.isEmpty) return true;
  final lower = title.toLowerCase();
  return words.every(
    (w) => RegExp('\\b${RegExp.escape(w)}\\b').hasMatch(lower),
  );
}

/// Status detail cocok dengan filter? `wanted`: 'ongoing' | 'end'.
/// Server mengabaikan param status, jadi verifikasi dilakukan dari
/// halaman detail (satu-satunya sumber benar).
bool komikuStatusMatches(String? actual, String wanted) {
  final s = (actual ?? '').toLowerCase();
  if (wanted == 'ongoing') return s.contains('ongoing');
  if (wanted == 'end') {
    return s.contains('tamat') ||
        s.contains('complet') ||
        s == 'end' ||
        s.contains('finish');
  }
  return false;
}

/// "59-5" -> "59.5", selainnya apa adanya.
String prettifyChapter(String raw) {
  final s = raw.trim();
  if (RegExp(r'^\d+-\d+$').hasMatch(s)) return s.replaceFirst('-', '.');
  return s;
}

/// "18 menit lalu" -> menit sejak update (untuk urut Terbaru sejati).
/// Format tak dikenal -> null (diurut paling belakang). Jujur: hanya
/// menafsirkan pola relatif Indonesia yang umum di `.judul2` Komiku.
int? parseUpdateAgoMinutes(String? ago) {
  final s = (ago ?? '').toLowerCase().trim();
  if (s.isEmpty) return null;
  if (s.contains('baru') ||
      s.contains('sekarang') ||
      s.contains('detik')) {
    return 0;
  }
  if (s.contains('kemarin')) return 1440;
  final m = RegExp(r'(\d+)\s*(menit|jam|hari|minggu|bulan|tahun)')
      .firstMatch(s);
  if (m == null) return null;
  final n = int.tryParse(m.group(1)!) ?? 0;
  return switch (m.group(2)) {
    'menit' => n,
    'jam' => n * 60,
    'hari' => n * 1440,
    'minggu' => n * 10080,
    'bulan' => n * 43200,
    'tahun' => n * 525600,
    _ => null,
  };
}

int? parseReaders(String meta) {
  final m =
      RegExp(r'([\d.,]+)\s*(jt|rb|k)?\s*pembaca').firstMatch(meta);
  if (m == null) return null;
  // ID: ',' desimal, '.' ribuan. Tanpa koma, '.' = desimal.
  final raw = m.group(1)!;
  final num = raw.contains(',')
      ? double.tryParse(raw.replaceAll('.', '').replaceAll(',', '.'))
      : double.tryParse(raw);
  if (num == null) return null;
  return switch (m.group(2)) {
    'jt' => (num * 1000000).round(),
    'rb' || 'k' => (num * 1000).round(),
    _ => num.round(),
  };
}

Manga _listItem(Element el) {
  final link = el.querySelector('.bgei a[href]');
  final href = link?.attributes['href'] ?? '';
  final slug = mangaSlugOf(href);
  final img = el.querySelector('.bgei img');
  final title = el.querySelector('h3')?.text.trim() ?? '';
  final desc = el.querySelector('.kan > p')?.text.trim() ?? '';
  final meta = el.querySelector('.judul2')?.text ?? '';
  String? latest;
  String? ago;
  final news = el.querySelectorAll('.new1 a');
  if (news.isNotEmpty) {
    final t = news.last.text;
    final m = RegExp(r'Chapter\s+([\d.\-]+)', caseSensitive: false)
        .firstMatch(t);
    if (m != null) latest = prettifyChapter(m.group(1)!);
  }
  // Meta: "1.6jt pembaca | 18 menit lalu | Berwarna".
  final metaParts = meta.split('|').map((s) => s.trim()).toList();
  if (metaParts.length >= 2 && metaParts[1].isNotEmpty) {
    ago = metaParts[1];
  }
  return Manga(
    id: 'k:$slug',
    title: title,
    description: desc.isEmpty ? null : desc,
    coverUrl: img?.attributes['src'],
    followedCount: parseReaders(meta),
    latestChapter: latest,
    updateAgo: ago,
  );
}

/// Daftar `.bge` dari halaman list/search API.
List<Manga> komikuListFromHtml(String html) {
  if (html.isEmpty) return [];
  final doc = html_parser.parse(html);
  return doc
      .querySelectorAll('.bge')
      .map(_listItem)
      .where((m) => m.id != 'k:' && m.title.isNotEmpty)
      .toList();
}

String? _tableValue(Element root, String label) {
  for (final tr in root.querySelectorAll('table.inftable tr')) {
    final cells = tr.querySelectorAll('td');
    if (cells.length >= 2 &&
        cells.first.text.trim().startsWith(label)) {
      return cells[1].text.trim();
    }
  }
  return null;
}

String _mapStatus(String? raw) {
  final s = (raw ?? '').toLowerCase();
  if (s.contains('ongoing')) return 'ongoing';
  if (s.contains('tamat') || s.contains('completed') || s.contains('end')) {
    return 'completed';
  }
  return s.isEmpty ? 'ongoing' : s;
}

DateTime? _parseIdDate(String raw) {
  final m = RegExp(r'(\d{1,2})/(\d{1,2})/(\d{4})').firstMatch(raw);
  if (m == null) return null;
  return DateTime(
    int.parse(m.group(3)!),
    int.parse(m.group(2)!),
    int.parse(m.group(1)!),
  );
}

/// Detail + feed sekaligus (satu request).
({Manga manga, List<ChapterInfo> feed}) komikuDetailFromHtml(
  String html,
  String slug,
) {
  final doc = html_parser.parse(html);
  final root = doc.documentElement!;
  final name = root
          .querySelector('h1 span[itemprop="name"]')
          ?.text
          .trim() ??
      root
          .querySelector('h1')
          ?.text
          .trim()
          .replaceFirst(RegExp(r'^Komik\s+'), '') ??
      slug;
  final desc = root.querySelector('p.desc')?.text.trim();
  final alt = _tableValue(root, 'Judul Alternatif:');
  final author = _tableValue(root, 'Author:');
  final status = _mapStatus(_tableValue(root, 'Status:'));
  final cover = root.querySelector('.ims img')?.attributes['src'];
  final tags = <MangaTag>[];
  // NOTE: selector 'ul.genre a' tidak match di package:html —
  // pakai path eksplisit lewat li.
  for (final a in root.querySelectorAll('ul.genre li a[href]')) {
    final href = a.attributes['href'] ?? '';
    final m = RegExp(r'/genre/([a-z0-9-]+)/').firstMatch(href);
    final label = a.text.trim();
    if (m != null && label.isNotEmpty) {
      tags.add(MangaTag(id: m.group(1)!, name: label));
    }
  }
  final feed = <ChapterInfo>[];
  for (final tr in root.querySelectorAll('#daftarChapter tr[itemprop]')) {
    final a = tr.querySelector('td.judulseries a[href]');
    if (a == null) continue;
    final chSlug = chapterSlugOf(a.attributes['href'] ?? '');
    if (chSlug.isEmpty) continue;
    final label = a.text.trim();
    final m = RegExp(r'Chapter\s+([\d.\-]+)', caseSensitive: false)
        .firstMatch(label);
    final no = m == null ? null : prettifyChapter(m.group(1)!);
    final date =
        _parseIdDate(tr.querySelector('td.tanggalseries')?.text ?? '');
    feed.add(
      ChapterInfo(
        id: 'k:$slug:$chSlug',
        mangaId: 'k:$slug',
        chapterNo: no,
        language: 'id',
        publishAt: date,
      ),
    );
  }
  final manga = Manga(
    id: 'k:$slug',
    title: name,
    altTitles: (alt == null || alt.isEmpty || alt == name) ? const [] : [alt],
    description: (desc == null || desc.isEmpty) ? null : desc,
    status: status,
    coverUrl: cover,
    tags: tags,
    author: (author == null || author.isEmpty) ? null : author,
  );
  return (manga: manga, feed: feed);
}

/// URL gambar halaman chapter (urut tampil).
List<String> komikuChapterImages(String html) {
  if (html.isEmpty) return [];
  final doc = html_parser.parse(html);
  final out = <String>[];
  for (final img in doc.querySelectorAll('#Baca_Komik img')) {
    var src = img.attributes['src'] ?? '';
    if (src.isEmpty) src = img.attributes['data-src'] ?? '';
    // Host gambar: image2.komiku.to/.../uploads...|uploads2...|upload5...
    if (src.contains('/upload') &&
        (src.endsWith('.jpg') ||
            src.endsWith('.jpeg') ||
            src.endsWith('.png') ||
            src.endsWith('.webp'))) {
      if (src.startsWith('//')) src = 'https:$src';
      out.add(src);
    }
  }
  return out;
}
