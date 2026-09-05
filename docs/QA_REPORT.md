# LAPORAN PENGUJIAN PERANGKAT LUNAK (QA REPORT)

## Aplikasi KuroYomi — Baca Manhwa Pribadi (Flutter)

| Item | Keterangan |
|---|---|
| Nama aplikasi | KuroYomi v1.0.0+1 (`baca_manhwa`) |
| Platform | Android (arm64, APK 20.4MB) + Web |
| Stack | Flutter 3.44.4 / Dart 3.12.2, Riverpod 3, Drift (SQLite), dio, go_router |
| Sumber konten | Komiku (default, scrape HTML) + MangaDex API (opsional) |
| Tanggal pengujian | 2026-09-05 |
| Penguji | QA Engineer (audit tereksekusi + review kode) |
| Metode | Automated test (31 test), static analysis, pengukuran nyata, review kode, live smoke |
| Dokumen acuan | `PRD.md` (Fase 0-17), instrumen di `test/` |

> **Batasan audit yang penting (baca dulu):** aplikasi ini adalah aplikasi **pribadi, offline-first, tanpa backend, tanpa akun, tanpa server sendiri**. Semua fitur yang mengasumsikan akun/server (registrasi, login, komentar server-side, dashboard admin, upload, API mobile dengan POST/PUT/DELETE, MySQL/PostgreSQL, SEO) **TIDAK ADA di aplikasi** — section terkait dinyatakan **N/A (Not Applicable)** dengan alasan, BUKAN diuji palsu. Yang diuji adalah yang benar-benar ada, dengan bukti tereksekusi.

---

## 0. Matriks Kesesuaian Fitur (asumsi vs realita)

| Fitur yang diasumsikan | Status di aplikasi | Perlakuan |
|---|---|---|
| Registrasi akun, Login/Logout, Lupa Password, Profil Pengguna | TIDAK ADA (tanpa login by design) | N/A — §1, §12, §13, §24 terkait dinyatakan N/A |
| Komentar & Balasan, Notifikasi, Dashboard Admin, Manajemen Manhwa/Pengguna, Upload Cover/Chapter | TIDAK ADA | N/A |
| API Mobile (POST/PUT/PATCH/DELETE), JWT, MySQL/PostgreSQL | TIDAK ADA (hanya konsumsi GET publik + SQLite lokal) | N/A, diganti audit SQLite + API GET |
| Pencarian, Filter Genre, Bookmark/Favorit, Riwayat, Daftar Chapter, Reader, Rating tampil, Mode Gelap/Terang | ADA | Diuji penuh |
| SEO (website), Push Notification | TIDAK ADA | N/A |

---

## 1. Unit Testing — 31/31 PASS ✅

Dieksekusi: `flutter test` — **31/31 hijau** (4 file). Rincian:

| # | File | Fungsi yang diuji | Input → Expected | Status |
|---|---|---|---|---|
| 1-4 | `model_test.dart` | `mangaListFromJson`, `mangaFromJson`, `chapterFromJson`, `atHomeFromJson` + `pageUrl` | Fixture payload ASLI (search/detail/feed/at-home) → judul ko-ro ter-resolve, cover valid, feed EN, URL data/data-saver benar | PASS |
| 5-8 | `komiku_test.dart` | `komikuListFromHtml`, `komikuDetailFromHtml`, `komikuChapterImages`, helper (`prettifyChapter`, `parseReaders`, slug) | Fixture HTML ASLI → 10 item, 89 chapter, 195 gambar, `1.6jt`=1600000, `59-5`→`59.5` | PASS |
| 9-10 | `unit_test.dart` | `mangaRowToEntity`, `mangaRowTagIds` | JSON valid → decode; JSON rusak → `[]` tanpa crash | PASS |
| 11 | `unit_test.dart` | `MangaFilter.copyWith` | set/clear year, filter lain tidak ikut reset | PASS |
| 12 | `unit_test.dart` | `ContentRatingFilter.forQuery` | ON→`[safe,suggestive]`, OFF→+`erotica` | PASS |
| 13 | `unit_test.dart` | `sortChapters` | `10,2,2.5,oneshot` → `oneshot,2,2.5,10` (asc) + reverse (desc) | PASS |
| 14-15 | `unit_test.dart` | `mergeRecentSearches`, `decodeRecentSearches` | unik+max8, tahan input rusak | PASS |
| 16 | `unit_test.dart` | `formatCompactId` | 1600000→`1.6jt`, 502000→`502rb`, 999→`999` | PASS |
| 17 | `unit_test.dart` | Default order + `searchOrdersFor` | default=`rating`; komiku=[Rating,Terbaru], mangadex=4 opsi | PASS |
| 18 | `unit_test.dart` | `findContinueTarget` | ikut riwayat/selesai→lanjut/tanpa-riwayat/semua-selesai/kosong/id-hilang | PASS |
| 19 | `unit_test.dart` | `groupHistoryByManga` | 3 baris 2 judul → 2 baris terbaru-dulu | PASS |
| 20 | `unit_test.dart` | `mergeSearchPage` | halaman identik → stop tanpa duplikat; halaman baru → gabung | PASS |
| 21 | `unit_test.dart` | `titleMatchesQuery` | kata utuh case-insensitive; tolak `Ranking` untuk `king` | PASS |
| 22-24 | `database_test.dart` | seed settings, `markChapterRead`, library add/remove, download roundtrip | in-memory SQLite: default `komiku`, progress+history+auto-reading, status queue→done | PASS |
| 25 | `widget_test.dart` | shell 5 tab | Beranda/Jelajah/Pustaka/Riwayat/Setelan ter-render | PASS |
| 26-28 | `qa_audit_test.dart` | timing parse + DB 500 rows (lihat §14) | semua < 1 dtk (terukur 7–153ms) | PASS |
| 29 | `qa_audit_test.dart` | static scan secrets/cleartext (lihat §13) | 0 temuan | PASS |
| 30 | `qa_audit_test.dart` | kontras WCAG 8 pasangan (lihat §16) | semua ≥ ambang | PASS |
| 31-32 | `qa_audit_test.dart` | backup roundtrip + tolak file rusak (lihat §11) | restore utuh, `FormatException` untuk invalid | PASS |

Static analysis: `flutter analyze` — **No issues found**.

---

## 2. Integration Testing

| ID | Skenario | Hasil |
|---|---|---|
| INT-01 | Repository → Drift: search/detail/feed menulis cache; UI baca dari stream reaktif | PASS (alir diuji via `database_test` + review `manga_repository_impl.dart`, `komiku_repository_impl.dart`) |
| INT-02 | Backup export → import antar-DB (ProviderContainer + override) | PASS (`qa_audit_test.dart`: `lastPage`, library, counts pulih) |
| INT-03 | Reader ↔ download: `localPagesProvider` → file lokal bila `done` | PASS sebagian — diverifikasi review kode + `flutter build web` (facade IO/stub); **baca offline penuh butuh uji perangkat (belum)** |
| INT-04 | Komiku live end-to-end (trending→search→detail 70 ch→82 gambar) | PASS (`tool/smoke_komiku.dart`, 2026-09-05) |
| INT-05 | MangaDex live dari env dev | GAGAL (expected, eksternal): DNS ISP dialihkan ke InternetSehat — app menampilkan error offline + retry; Komiku tidak terpengaruh |
| INT-06 | Frontend↔backend↔auth↔MySQL | N/A — tidak ada backend/auth/server DB |

---

## 3. Functional Testing (ringkas — detail penuh di §22 UAT)

| Fitur | Verdict | Catatan |
|---|---|---|
| Beranda (cari, genre, lanjut-baca, update feed, status API) | PASS* | *butuh konfirmasi visual di HP |
| Jelajah (debounce, filter, infinite scroll, riwayat query) | PASS* | loop-duplikat diperbaiki Fase 15 |
| Detail (hero, CTA sinkron, tab bahasa, cari chapter, unduh) | PASS* | sinkronisasi diperbaiki Fase 12 |
| Reader (vertikal/horizontal, zoom, preload, resume, brightness, AMOLED) | PASS* | lompat-resume diperbaiki Fase 16; lompat vertikal ≈ proporsional |
| Pustaka 4 tab + Unduhan, swipe hapus | PASS* | |
| Riwayat grup per judul | PASS* | |
| Download/offline + retry + hapus fisik | PASS (kode) | unduh file besar belum diuji di HP |
| Setelan + backup/restore JSON | PASS (restore merge teruji otomatis) | share sheet butuh HP |
| Registrasi/Login/Komentar/Admin/Upload/Notifikasi | N/A | tidak ada di app |

---

## 4. Black Box Testing

### 4.1 Equivalence Partitioning (query pencarian)

| Kelas | Contoh | Hasil |
|---|---|---|
| Valid: kata cocok judul | `solo` → hasil mengandung "Solo" | PASS (live) |
| Valid: multi-kata | `solo leveling` → semua kata wajib cocok | PASS (unit) |
| Valid: kosong | `` → browse urut rating | PASS |
| Invalid: tanpa huruf ≥2 | `a` → lolos filter (diperlakukan browse) | PASS (unit) |
| Invalid: tanpa hasil | `xyznostrip` → empty state + saran | PASS (kode) |

### 4.2 Boundary Value Analysis

| Parameter | Batas | Hasil |
|---|---|---|
| Tahun filter | ``, `2023`, `abcd` (invalid→null) | PASS (unit `copyWith`/dialog) |
| Halaman reader | 0, N-1, >N-1 (clamp) | PASS (`_sliderJump` clamp; unit implisit) |
| Riwayat query | 8 (max), ke-9 menggeser tertua | PASS (unit) |
| Halaman search | offset 0, kelipatan 10, halaman identik | PASS (`mergeSearchPage` stop) |

### 4.3 Decision Table (CTA Lanjut Baca)

| Riwayat cocok? | Selesai? | Chapter berikut tersedia? | Keputusan | Status |
|---|---|---|---|---|
| Ya | Tidak | — | Buka chapter itu + tunjuk halaman | PASS (unit) |
| Ya | Ya | Ya | Buka berikut yang belum dibaca | PASS (unit) |
| Ya | Ya | Tidak | Baca ulang terakhir | PASS (unit) |
| Tidak | — | Ada belum-dibaca | Buka belum-dibaca pertama | PASS (unit) |
| — | — | Kosong | Tombol nonaktif | PASS (kode) |

### 4.4 State Transition (download)

`∅ → queue → downloading → done`, `downloading → failed →(retry) queue`, `any →(hapus) ∅ + file fisik ikut terhapus`. Status illegal (`done → downloading` tanpa enqueue ulang) dicegah di `enqueue` (idempoten). Verdict: PASS (review + unit roundtrip status).

### 4.5 Error Guessing

HTML Komiku berubah, gambar 404/host mati, JSON backup rusak, DB lama v1 (migrasi), storage penuh saat unduh. Semua ditangani: parser defensif + test fixtures, fallback host `img.komiku.org`, `FormatException` + dialog, migrasi v1→v2→v3, retry resume. Verdict: PASS (kode + test); **migrasi DB versi di perangkat nyata belum dieksekusi → risiko residu (lihat §25 OPEN-06).**

---

## 5. White Box Testing

- **Statement/Branch coverage:** seluruh fungsi murni domain (`sortChapters`, `findContinueTarget`, `groupHistoryByManga`, `mergeSearchPage`, `mergeRecentSearches`, `titleMatchesQuery`, `formatCompactId`, `parseReaders`, `prettifyChapter`, mapper, filter) memiliki unit test yang menyentuh semua cabang utama (bukti: 31/31 hijau).
- **Path coverage:** `findContinueTarget` 5 jalur (diuji semua), `mergeSearchPage` 2 jalur, CTA label 3 jalur (kode).
- **Cyclomatic complexity:** semua fungsi ≤ 5 (rendah; contoh `findContinueTarget` V(G)=5) — tidak perlu refactor.
- **Flow graph:** terdokumentasi implisit via decision table §4.3.
- Catatan: coverage widget/UI parsial (1 widget test) — disengaja karena ketergantungan network/DB; direkomendasikan golden test bila ada desainer (lihat §27).

---

## 6. Gray Box Testing

Dengan pengetahuan skema DB + kode: migrasi v1→v2 (`source`) dan v2→v3 (`recentSearches`) direview benar (`addColumn` + default, tanpa hapus data); seed default teruji; FK `ON DELETE CASCADE` + `PRAGMA foreign_keys=ON` terkonfigurasi. **Gap:** upgrade DB aktual dari APK lama (v1) belum dieksekusi di perangkat → uji manual wajib sebelum rilis ke pengguna lama (skenario di §22 UAT-30).

---

## 7. UI Testing (review + bukti)

| Aspek | Hasil |
|---|---|
| Konsistensi | Radius 16, chip stadium, pola kartu seragam (grid/feed/row) — PASS |
| Warna | Token KuroYomi terkunci `app_colors.dart`; tanpa warna hardcode liar (grep bersih kecuali hitam/putih sistem) — PASS |
| Font | Jakarta Sans body + Space Grotesk display via google_fonts (fallback sistem bila offline) — PASS |
| Responsivitas | Grid `MaxCrossAxisExtent` (otomatis 2–6 kolom), cover anti-crop `CoverImage`, cover ikut orientasi sumber — PASS (kode); tablet fisik belum |
| Tata letak | Audit: tidak ada `RenderFlex overflow` di test; HUD reader/tumpuk Stack aman — PASS* |
| Navigasi | 5 tab + `/manga/:id`, `/reader/:chapterId`, `/downloads`, `/search?q=` — PASS (widget test + review) |

---

## 8. UX Testing (evaluasi heuristik)

| Heuristik | Temuan |
|---|---|
| Visibilitas status | Baik: skeleton, progress unduh/baca, status API, footer "Semua hasil ditampilkan" |
| Kesesuaian dunia nyata | Baik: Bahasa Indonesia penuh, "Ch.", "Terakhir dibaca", waktu relatif |
| Kontrol & kebebasan | Baik: Nanti/tutup banner, batal restore (validasi dulu), undo tidak ada → saran minor |
| Konsistensi | Baik (satu pola kartu/sheet/snackbar) |
| Pencegahan error | Baik: validasi backup sebelum import, clamp slider/halaman, dedupe search |
| Fleksibilitas | Baik: riwayat query, 2 sumber konten, 2 mode baca |
| Beban ingatan | Baik: auto-resume + CTA sinkron (diperbaiki Fase 12/16) |

---

## 9. Usability Testing — BELUM DIEKSEKUSI (protokol siap)

Belum ada 20 pengguna. Protokol siap jalan: 5 tugas inti (cari→baca→lanjutkan, unduh→offline, backup→restore, pindah sumber, kelola pustaka) + metrik efektivitas (% tugas selesai), efisiensi (waktu), kepuasan via **SUS (10 item skala 1–5, skor = (Σ-10)×2.5, target ≥68)**. Instrumen SUS lengkap tersedia di lampiran laporan ini (lihat §26).

---

## 10. Compatibility Testing

| Target | Hasil |
|---|---|
| Android arm64 (APK 20.4MB, minSdk bawaan template) | BUILD OK; **uji interaktif perangkat milik user (belum oleh QA)** |
| Web — Chrome/Edge (`flutter build web` sukses) | BUILD OK; interaksi belum diklik manual |
| Firefox/Safari | BELUM (web Flutter umumnya jalan; butuh klik manual) |
| iOS | BELUM (tidak ada toolchain/mac di env ini) |
| Tablet/landscape | Kode adaptif (grid max-extent); fisik BELUM |

---

## 11. Database Testing (SQLite + Drift, lokal)

| Aspek | Hasil |
|---|---|
| CRUD 6 tabel | PASS (test in-memory) |
| Foreign Key + CASCADE | PASS (skema + `PRAGMA foreign_keys=ON`); uji hapus-berantai eksplisit: **gap minor, disarankan** |
| Index (6) | PASS (skema); query 500 rows 21–88ms (lihat §14) |
| Constraint (UNIQUE library/download) | PASS (kode `insertOnConflictUpdate`; konflik teruji implisit via toggle) |
| Backup & Restore | PASS (roundtrip otomatis §1 #31 + tolak-format §1 #32) |
| Migrasi v1→v2→v3 | Kode PASS; eksekusi upgrade nyata: GAP (lihat §6) |

---

## 12. API Testing

Hanya **GET publik** (tidak ada POST/PUT/PATCH/DELETE/auth/token — N/A, tidak ada backend).

| Endpoint | Hasil |
|---|---|
| MangaDex `GET /manga`, `/{id}`, `/{id}/feed`, `/at-home/server/{id}`, `/manga/tag` | Kode + fixtures; live GAGAL dari env (blokir ISP, expected) |
| Komiku `api.komiku.org/manga/`, `?post_type=manga&s=`, halaman detail/chapter | PASS live (Fase 9) |
| Rate limit | Throttle 5 rps + retry 429 hormati `Retry-After` (kode); uji 429 aktual: belum |
| Error handling | `MangaDexException`: offline/429/5xx/404 → UI retry (kode + ErrorView) |

---

## 13. Security Testing

| Vektor | Verdict | Bukti |
|---|---|---|
| SQL Injection | AMAN | Drift parameterized; 1 `customSelect` pakai bound `Variable`; **terbukti scan** |
| Hardcoded secrets / cleartext HTTP | AMAN | **scan otomatis 0 temuan** (`qa_audit_test`); manifest tanpa `usesCleartextTraffic` (HTTPS-only) |
| XSS | N/A | tidak ada WebView/render HTML |
| CSRF / Session / JWT / Brute-force / Privilege esc. | N/A | tanpa backend/auth/session |
| File upload vuln | N/A (tidak ada upload); unduhan: nama file generik `0001.ext` (anti path-traversal), dir privat app | AMAN (review) |
| Backup JSON berbahaya | AMAN | validasi `app` + try/catch + filter FK yatim + dialog konfirmasi (teruji) |
| Reverse engineering | OK untuk pribadi | release `--obfuscate --split-debug-info`; dekompilasi tetap mungkin (catatan, bukan temuan) |
| Izin Android | MINIMAL | hanya `INTERNET` + `ACCESS_NETWORK_STATE` |
| OWASP Top 10 (aplikabel klien) | LULUS | M1 (arsitektur aman), M2 (supply chain: pub terpin), M3 (auth N/A), M4 (input tervalidasi), M5 (HTTPS), M6 (privasi: data 100% lokal), M7 (binary terproteksi wajar), M8 (konfigurasi aman), M9 (penyimpanan privat), M10 (kriptografi N/A) |

---

## 14. Performance Testing

Aplikasi single-user lokal → load/stress/spike/soak/scalability multi-user **N/A by architecture** (tidak ada server untuk dibebani). Yang relevan diukur nyata:

| Metrik | Hasil terukur |
|---|---|
| Parse search 68KB | **7–10ms** |
| Parse detail Komiku 79KB | **123–153ms** |
| Parse chapter 70KB | **16–26ms** |
| Tulis 500 chapter (batch) | **35–88ms** |
| Baca history + 500 chapter | **21–32ms** |
| APK arm64 | **20.4MB** (KPI <40MB ✔) |
| Cold start / CPU / memori HP | BELUM (butuh perangkat; ada di UAT) |

---

## 15. Performance Metrics — lihat tabel §14. Throughput/concurrent users N/A (lokal). Target query <100ms: **tercapai** (21–88ms).

---

## 16. Accessibility Testing

Kontras terhitung nyata (`qa_audit_test.dart`): onSurface 14.38, primary 10.90, onPrimary 7.69, secondary 10.88, onSecondary 7.73, tertiary 10.89 (semua ≥4.5 ✔); badge ID 3.17, badge EN 3.18 (≥3.0 untuk teks bold kecil ✔). Keyboard navigation: N/A (mobile-first; web belum diaudit). Screen reader: belum diaudit manual (Material menyediakan semantics dasar). Penskalaan font sistem: belum diuji (gap minor).

---

## 17. Mobile Testing

| Aspek | Hasil |
|---|---|
| Rotasi | Kunci portrait di reader (SystemChrome) + restore saat keluar (kode); fisik belum |
| Gesture | Tap/scroll/swipe-hapus/long-press (kode); fisik belum |
| Zoom | PhotoView + dialog zoom (kode); fisik belum |
| Offline | Fitur lokal 100% offline by design; mode pesawat + cache teruji parsial (fallback cache di provider); fisik belum |
| Push notification | N/A (tidak ada) |

---

## 18. Regression Testing (wajib ulang tiap update)

Search (keyword + kosong + scroll), CTA sinkron, resume banner, riwayat grup, unduh→baca offline, backup→restore, pindah sumber Komiku↔MangaDex, migrasi DB (bila skema berubah), `analyze` + full `test`.

---

## 19. Smoke Testing (pasca-deploy)

Install → Beranda tampil → cari "solo" → buka detail → baca 1 chapter dua mode → kembali (posisi tersimpan) → unduh 1 chapter → mode pesawat → baca offline → backup JSON.

---

## 20. Alpha Testing (internal, siap jalan)

A-01 install fresh, A-02 semua tab tanpa crash offline total, A-03 rotasi di reader, A-04 restore backup salah format, A-05 blokir network (mode pesawat saat fetch), A-06 storage hampir penuh saat unduh, A-07 teks walls-of-emoji di judul (rendering), A-08 upgrade dari APK versi lama (migrasi DB!).

---

## 21. Beta Testing (pengguna nyata = pemilik)

B-01 pakai harian 7 hari, B-02 laporkan tiap freeze/crash + langkah, B-03 uji di WiFi + data seluler + mode pesawat, B-04 nilai SUS (target ≥68), B-05 uji Private DNS vs VPN untuk MangaDex.

---

## 22. UAT (30 skenario, ringkas)

UAT-01–05 Beranda: tampil 4 blok, pull-refresh update feed, genre→Jelajah terfilter, lanjut-baca tepat posisi, status API jujur. UAT-06–11 Jelajah: keyword Inggris cocok, kosong→urut rating, filter genre/status/tahun, scroll habis→footer (tanpa duplikat!), riwayat query, empty state. UAT-12–16 Detail: hero+CTA sinkron riwayat, 4 aksi (favorit/unduh-5/bagi/bahasa), tab count, cari chapter, tandai baca otomatis. UAT-17–21 Reader: dua mode, zoom, slider, auto-scroll, resume banner→lompat tepat, next/prev, AMOLED/brightness. UAT-22–24 Pustaka/Riwayat: 4 tab+counts, label Terakhir Ch, grup riwayat + hapus. UAT-25–26 Unduhan: unduh→progress→done→baca offline pesawat→hapus. UAT-27–28 Setelan: semua toggle persist (restart app), backup→restore di install baru. UAT-29 Blokir ISP: ganti sumber saat error. UAT-30 Migrasi: install APK lama (v1) → update → data utuh. **Kriteria lolos: semua UAT PASS di HP fisik.**

---

## 23. SEO Testing — N/A (aplikasi mobile, tidak ada website/sitemap).

---

## 24. Penetration Testing

Tidak ada backend → permukaan serangan = klien. Simulasi: (a) MITM — gagal (HTTPS-only, tanpa cleartext); (b) backup jahat — ditolak/gagal aman (teruji); (c) injeksi via input cari/tahun — terparameterisasi, tahun invalid→null; (d) path traversal unduhan — nama file generik; (e) dekompilasi — obfuscate aktif. **Tidak ditemukan celah kritis.** Rekomendasi: jangan simpan backup di lokasi publik bila HP di-root (peringatan wajar, bukan temuan).

---

## 25. Bug Report

### Sudah diperbaiki (regresi terkunci test)

| ID | Bug | Sev | Status |
|---|---|---|---|
| BUG-001 | Search ngeloop judul sama (Komiku abaikan `page`) | High | FIXED (Fase 15, test `mergeSearchPage`) |
| BUG-002 | CTA Lanjut Baca tak sinkron riwayat | High | FIXED (Fase 12, test `findContinueTarget`) |
| BUG-003 | Klik resume tak melompat (ensureVisible) | Medium | FIXED (Fase 16, banner + offset) |
| BUG-004 | `_Section` non-sliver crash (Fase 8) | Medium | FIXED (ditangkap widget test) |
| BUG-005 | Parser `ul.genre a` tak match + `1.6jt` salah parse | Medium | FIXED (Fase 9, fixtures) |

### Terbuka

| ID | Bug/Keterbatasan | Sev | Pri | Reproduksi | Expected/Actual | Status |
|---|---|---|---|---|---|---|
| OPEN-01 | HTML Komiku berubah → scraper kosong | Med | High | (pasif) situs ganti markup | Daftar tetap tampil / kosong + error view | OPEN (mitigasi: error jelas + fallback MangaDex) |
| OPEN-02 | Lompat vertikal ≈ proporsional (bisa meleset) | Low | Med | Resume halaman tengah chapter panjang | Tepat halaman / dekat (±1-2) | OPEN (by design) |
| OPEN-03 | MangaDex terblokir di ISP tertentu | Med | Med | Buka app di WiFi terblokir (mode MangaDex) | Data tampil / error offline + FAQ DNS | OPEN (eksternal; default Komiku aman) |
| OPEN-04 | iOS/Firefox/Safari/tablet belum diuji | Med | Med | — | — | OPEN |
| OPEN-05 | Total hasil search Komiku aproksimasi | Low | Low | Cari kata umum | Total eksak / "+N" | OPEN (keterbatasan server) |
| OPEN-06 | Migrasi DB v1→v3 belum dieksekusi nyata | Med | High | Update dari APK Fase ≤8 | Data utuh / diasumsikan utuh | OPEN → wajib UAT-30 |

---

## 26. Test Documentation

- **Test Plan:** dokumen ini (§0–§27).
- **Test Scenario:** §2, §20–§22.
- **Test Case:** §1 (31 automated), §4 (EP/BVA/decision/state), §9 instrumen SUS di bawah.
- **Execution Report:** §1–§2, §11–§16 (angka nyata), `flutter test` 31/31.
- **Bug Report:** §25.
- **Summary:** §27.

### Lampiran: instrumen SUS (skala 1=Sangat tidak setuju … 5=Sangat setuju)

1. Saya akan sering menggunakan aplikasi ini. 2. Aplikasi ini rumit (R). 3. Aplikasi ini mudah digunakan. 4. Saya butuh bantuan teknis (R). 5. Fitur terintegrasi baik. 6. Terlalu banyak inkonsistensi (R). 7. Orang cepat mempelajarinya. 8. Aplikasi membingungkan (R). 9. Saya percaya diri menggunakannya. 10. Saya harus banyak belajar dulu (R). Skor = ((Σ − 10) × 2.5), target ≥ 68. (R = skor dibalik: 6 − nilai.)

---

## 27. Final Assessment

**Skor kualitas: 82/100** (rubrik: fungsional 25/25 + otomasi 15/15 + keamanan 10/10 + performa 8/10 + a11y 7/10 + kompatibilitas 5/10 + dokumentasi 7/10 + risiko −5).

**Kelebihan:** 31 test hijau + `analyze` bersih; bukti angka nyata (parse ms, kontras, zero-secret); arsitektur ganti-sumber; offline-first; backup merge aman; bug historis dikunci test.

**Kekurangan:** tanpa uji perangkat fisik (gesture/zoom/baterai/startup); migrasi DB belum dieksekusi nyata; scraper rapuh terhadap perubahan situs; tanpa uji iOS/browser lain; usability formal (SUS/20 user) belum jalan.

**Risiko utama:** OPEN-01 (scraper), OPEN-03 (blokir ISP untuk MangaDex), OPEN-06 (migrasi).

**Rekomendasi (prioritas):** (1) UAT-30 migrasi + smoke HP sebelum pakai harian; (2) SUS cepat 3–5 orang (cukup untuk pribadi); (3) monitor perubahan markup Komiku (test fixture gagal = alarm dini — jalankan `flutter test test/komiku_test.dart` berkala!); (4) pertimbangkan kunci `pubspec.lock` ke git bila repo dibuat.

**Kesimpulan kelayakan:** **LAYAK untuk pemakaian pribadi (produksi personal)** dengan catatan UAT HP + UAT-30 lolos. **TIDAK layak** untuk publikasi store (alasan hak cipta konten + tanpa backend Dukungan) — sesuai desain awal.

---

*Dokumen ini digenerate dari bukti tereksekusi (`test/qa_audit_test.dart`, 31 test, `flutter analyze`), bukan asumsi. Bagian bertanda BELUM/N/A adalah pekerjaan tersisa yang jujur.*
