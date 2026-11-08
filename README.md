# 📱 KuroYomi (Baca Manhwa & Manga) - v1.1.0

Aplikasi personal manga, manhwa, dan manhua berbahasa Indonesia berbasis **Flutter** dengan tampilan modern bertema **Obsidian Liquid Glass** (KuroYomi Dark Glass). Dirancang untuk pengalaman membaca komik yang bersih, mulus, dan imersif tanpa gangguan iklan.

---

## ✨ Fitur Utama (v1.1.0)

1. **🎨 Desain KuroYomi Liquid Glass (iPhone Inspired):**
   - Palet warna gelap elegan (*Obsidian Graphite*, *Surface Container*, *iOS Blue*, dan *Amber Accent*).
   - Bilah navigasi kapsul melayang dengan efek kaca frosted blur (*BackdropFilter*).
   - Mikro-interaksi sentuhan `AppleBounceTap` dengan umpan balik haptik lembut (*haptic feedback*).
   - Animasi transisi halaman mulus berbasis `CupertinoPageTransitionsBuilder` dengan gesture *swipe-to-back*.

2. **📖 Reader HUD Terpadu & Mode Imersif 100% Bersih:**
   - **Mode Baca Bersih (Default):** Layar penuh 100% tanpa tombol melayang yang menutupi gambar bab komik.
   - **Integrated Bottom HUD Capsule:** Cukup ketuk layar untuk menampilkan slider penunjuk halaman (`14 / 28`) dan tombol bab terpadu (`◀ Ch. Sebelumnya`, `≡ Daftar Bab`, `⬇ Unduh`, `Ch. Berikutnya ▶`).
   - Dukungan mode baca Vertikal (Webtoon) dan Horizontal (Manga) dengan auto-scroll dan keep-alive rendering.

3. **🌏 Multi-Source Berbahasa Indonesia (Manga, Manhwa, Manhua):**
   - Integrasi **Komiku API** dinamis untuk Manhwa Korea 🇰🇷, Manga Jepang 🇯🇵, dan Manhua China 🇨🇳 berbahasa Indonesia.
   - Integrasi **MangaDex API** dengan filter terjemahan Bahasa Indonesia (`translatedLanguage: id`) dan filter bahasa asal.
   - Sistem badge bendera asal akurat (🇯🇵 JP / 🇰🇷 KR / 🇨🇳 CN) pada setiap kartu komik.

4. **🔍 Pencarian Cerdas & Anti-Mentok:**
   - Kursor server independen untuk paginasi tak terbatas tanpa macet saat deduplikasi data.
   - Quick Filter Chips: **Semua**, **🇰🇷 Manhwa**, **🇯🇵 Manga**, dan **🇨🇳 Manhua**.

5. **✨ Rekomendasi Pintar Lokal:**
   - Bagian *"Rekomendasi Untukmu"* di Beranda yang menganalisis riwayat bacaan dan genre favorit pengguna.

6. **💾 Cadangan Data Resilient (v3):**
   - Format cadangan JSON v3 yang aman dan kompatibel antar versi serta sumber komik heterogen.
   - Ekspor & impor riwayat baca serta komik tersimpan secara instan.

7. **📥 Unduhan & Pembacaan Offline:**
   - Antrean unduhan bab komik untuk dibaca tanpa koneksi internet.

---

## 🚀 Cara Menjalankan & Membangun

### Prasyarat
- [Flutter SDK](https://flutter.dev/) (>= 3.12.2 / Flutter 3.24+)
- Android SDK & Java 17

### Instalasi Dependensi
```bash
flutter pub get
```

### Menjalankan dalam Mode Debug
```bash
flutter run
```

### Menjalankan Pengujian (Unit & Widget Tests)
```bash
flutter test
```

### Membangun File APK Release
Untuk menghasilkan file APK siap instal (*universal APK*):
```bash
flutter build apk --release
```
File APK akan berada di:
`build/app/outputs/flutter-apk/app-release.apk`

Untuk menghasilkan file APK terpisah per arsitektur (*split APKs* - ukuran lebih hemat):
```bash
flutter build apk --release --split-per-abi
```

---

## 🔒 Lisensi & Privasi

Aplikasi ini bersifat *client-only* dan *offline-first*. Tidak ada data pribadi atau riwayat bacaan yang dikirimkan ke server pihak ketiga mana pun. Semua bookmark, riwayat baca, dan pengaturan disimpan secara lokal di perangkat menggunakan SQLite (Drift).
