??# PRD — Baca Manhwa Pribadi v1.0.0+1

> **Dokumen sumber konteks** — Aplikasi mobile Flutter untuk membaca manhwa/manga **pemakaian pribadi** (bukan untuk publikasi store), sumber data **MangaDex API**, bahasa Indonesia, tanpa login & tanpa cloud/backend sendiri. Cache & data lokal via SQLite + Drift.

- **Lokasi proyek:** `E:\Mobile\baca manhwa`
- **Versi app:** `1.0.0+1` — `pubspec.yaml:4`
- **SDK:** `^3.12.2` — `pubspec.yaml:22` — Flutter 3.44.4 / Dart 3.12.2
- **Status baseline:** SEMUA FASE SELESAI (Fase 0-23). APK Baca Manhwa tersedia. Smoke test di HP fisik oleh user.
- **Tanggal:** 2026-09-05
- **Update terakhir Fase 23:** 2026-09-05 — Infinite scroll di Beranda (scroll mentok muat lagi via `updatesProvider`, dedupe + stop otomatis) — `analyze` 0 issues, `test` 31/31
- **Update terakhir Fase 22:** 2026-09-05 — Beranda tampil 20 update (fetch limit 20 + grid tanpa batas 4) — `analyze` 0 issues, `test` 31/31
- **Update terakhir Fase 21:** 2026-09-05 — Implementasi setia panduan KuroYomi dark (default gelap migrasi v5, nav fixed+label, Home search/pill/spotlight/lanjut/grid, CTA gradien, Reader jam/bookmark/milestone, sheet panduan) — `analyze` 0 issues, `test` 31/31
- **Update terakhir Fase 20:** 2026-09-05 — Tema MangaIndo (terang biru #2F80D6, AppBar biru, bottom-nav pil mengambang) + rebrand Baca Manhwa + logo baru (in-app + launcher PNG) + Home ala contoh (carousel Popular, Lanjut Baca, Update horizontal) — `analyze` 0 issues, `test` 31/31
- **Update terakhir Fase 19:** 2026-09-05 — Tap halaman scroll (zona atas/tengah/bawah) + kecepatan scroll-otomatis persisten (migrasi v4) — `analyze` 0 issues, `test` 31/31
- **Update terakhir Fase 18:** 2026-09-05 — Audit QA profesional (27 section): `test/qa_audit_test.dart` baru (timing nyata parse 7–173ms & DB 21–109ms, scan 0 secrets, kontras WCAG lolos, roundtrip backup) + `docs/QA_REPORT.md` (fitur tak-ada = N/A jujur, 5 bug fixed terkunci, 6 OPEN) — `analyze` 0 issues, `test` 31/31
- **Update terakhir Fase 17:** 2026-09-05 — Search relevan: pagination `paged` (bukan `page`), filter kata-utuh di judul, cover portrait/landscape ikut sumber — `analyze` 0 issues, `test` 25/25
- **Update terakhir Fase 16:** 2026-09-05 — Resume halaman diperbaiki (banner persisten + lompat proporsional yang andal) — `analyze` 0 issues, `test` 24/24
- **Update terakhir Fase 15:** 2026-09-05 — Bugfix search ngeloop (search Komiku abaikan `page` → `hasMore=false` + `mergeSearchPage` dedupe per id + footer "Semua hasil ditampilkan") — `analyze` 0 issues, `test` 24/24
- **Update terakhir Fase 14:** 2026-09-05 — Rating tampil sesuai data (skor MangaDex / pembaca Komiku) + search kosong default urut rating (Peringkat Komiku) — `analyze` 0 issues, `test` 23/23
- **Update terakhir Fase 13:** 2026-09-05 — Feed Chapter Terbaru di Beranda (baris thumb + Ch.X • waktu, dari `latestChapter`/`updateAgo` Komiku; refresh ikut pull-to-refresh, tanpa background) — `analyze` 0 issues, `test` 21/21
- **Update terakhir Fase 12:** 2026-09-05 — Bugfix sinkron: CTA Lanjut Baca ikut riwayat terakhir (`findContinueTarget`, sumber data sama dengan label Pustaka) + Riwayat grup per judul (`groupedHistoryProvider`, hapus per judul) — `analyze` 0 issues, `test` 21/21
- **Update terakhir Fase 11:** 2026-09-05 — Cover anti-crop (`CoverImage` blur-fill + contain) + grid max-extent responsif, riwayat pencarian persisten (migrasi v3), label "Terakhir Ch.X • Hal.p/q" di Pustaka + simpan posisi saat keluar reader, download di-deprioritaskan — `analyze` 0 issues, `test` 19/19, `build web` sukses, APK **20.4MB arm64**
- **Update terakhir Fase 10:** 2026-09-05 — UI simpel & responsif (Home tanpa spotlight/rekomendasi, Reader controller ringkas + sheet lengkap, grid adaptif `coverColumns`, hapus hint) — `analyze` 0 issues, `test` 17/17, `build web` sukses, APK **20.4MB arm64**
- **Update terakhir Fase 9:** 2026-09-05 — Scraper Komiku (list/search/detail/chapter ID via api.komiku.org + komiku.org, parser `html`, ID `k:`) + selektor sumber di Setelan + migrasi DB v2 (`app_settings.source`) + fallback host gambar + `AtHome` direct-URL — `analyze` 0 issues, `test` 17/17, smoke live OK
- **Update terakhir Fase 8:** 2026-09-05 — UI/UX KuroYomi (tema gelap #0F131C + Jakarta/Grotesk, nav Beranda/Jelajah/Pustaka+badge/Riwayat/Setelan, Home spotlight+lanjut-baca+grid, Detail hero-blur+CTA+tab count+cari, Reader HUD+slider+auto-scroll+orientation-lock, Library pill+storage+sort/view+progres) — `analyze` 0 issues, `test` 13/13, `build web` sukses, APK **20.0MB arm64**
- **Update terakhir Fase 7:** 2026-09-05 — QA (`analyze` 0 issues, `test` 13/13, `build web` sukses) + APK (`INTERNET` permission + label, `gradle.properties` kotlin.incremental=false + workers 2 + Xmx3G, `app-release.apk` 61.2MB universal / **19.9MB arm64** dengan shrink+obfuscate)
- **Update terakhir Fase 6:** 2026-09-05 — Settings full (tema/arah baca/bahasa/filter dewasa/data saver/cache + hapus/unduhan/backup-share/restore-merge/about+FAQ blokir ISP) + `BackupService` tanpa dart:io + `cacheBytesProvider` + test DB in-memory 3 — `analyze` 0 issues, `test` 13/13
- **Update terakhir Fase 5:** 2026-09-05 — Library 4 tab + swipe hapus, History (log/hapus/clear), DownloadManager (FIFO 2 konkuren + resume + retry + hapus file) + tombol unduh di detail + reader offline (file lokal) + layar Unduhan grup per judul + facade aman-Web — `analyze` 0 issues, `test` 10/10, `build web` sukses
- **Update terakhir Fase 4:** 2026-09-05 — Reader (`atHomeProvider` resolve fresh, ListView webtoon + PageView/PhotoView, preload 4, zoom dialog double-tap, progress bar, auto-resume snackbar, next/prev chapter, brightness overlay, AMOLED, tap-zone, `saveReadingPage`) — `analyze` 0 issues, `test` 10/10
- **Update terakhir Fase 3:** 2026-09-05 — Detail (cover/sinopsis/tag/author/rating + toggle Favorit & Sedang Dibaca + feed ID/EN/semua + sort numeric-aware + badge bahasa + dot dibaca reaktif via stream) + query `getChapter` — `analyze` 0 issues, `test` 10/10
- **Update terakhir Fase 2:** 2026-09-05 — Home (trending/latest/recommended + offline cache fallback + skeleton + quick actions) + Search (debounce 500ms, filter order/status/genre/tahun, infinite scroll 20, genre via GET /manga/tag) + `core/widgets` (error/empty/skeleton/card) + unit test mapper/filter — `analyze` 0 issues, `test` 9/9
- **Update terakhir Fase 1:** 2026-09-05 — fondasi (deps ter-resolve, `dio_client` throttle+retry, model parsing lolos 4 test fixtures payload asli, Drift 6 tabel + codegen, shell 5 tab + sub-route, `flutter analyze` 0 issues, `flutter test` 5/5, `flutter build web` sukses)
- **Update terakhir Fase 0:** 2026-09-05 — formalisasi PRD 19 section + AGENTS + opencode.json + commands (struktur anti-lupa §19 aktif)
- **Figma ref:** (tidak ada — referensi visual: Tachiyomi / Mihon, grid poster 2:3 rounded corner, skeleton loading, empty state jelas)

---

## 1. Ringkasan Eksekutif

Aplikasi **Baca Manhwa Pribadi** adalah aplikasi mobile Android (utama, opsional iOS) untuk mencari, membaca, dan mengoleksi manhwa/manga Korea via **MangaDex API** (`https://api.mangadex.org`). Semua state pribadi (favorit, sedang dibaca, riwayat, posisi baca, download offline) tersimpan lokal via **SQLite + Drift ORM**. Tanpa login, tanpa backend sendiri. Fokus: arsitektur ganti-sumber (MangaDex default, mudah tambah source lain), hemat rate-limit via cache, reader webtoon vertical + horizontal page-by-page yang mulus, dan download offline dengan manajemen storage.

**KPI v1:** query lokal <100ms, cold start <2s, APK <40MB, cache metadata hit-rate tinggi (tidak hit API berulang untuk judul yang sama), reader preload 3-5 halaman tanpa jank, 100% fitur lokal (library/history/offline) bekerja airplane mode.

---

## 2. Tujuan

- Beranda: Manhwa Populer (trending), Update Terbaru (chapter baru), Rekomendasi berbasis genre sering dibaca, search bar di atas.
- Pencarian & filter: judul, genre/tag, status (ongoing/completed), content rating (safe/suggestive/erotica + toggle sensor dewasa), tahun rilis, urutan (populer/terbaru/A-Z), infinite scroll/pagination.
- Detail manhwa: cover, judul + alternatif, sinopsis, genre/tag, status, author/artist, rating & pembaca (jika tersedia), tombol Favorit + Sedang Dibaca, daftar chapter (sort naik/turun, indikator sudah dibaca, filter bahasa ID/EN).
- Reader: mode vertical webtoon + horizontal page-by-page, pinch-to-zoom, preload, next/prev chapter di ujung, progress bar, auto-resume posisi, kontrol brightness, AMOLED black mode, tap-zone kiri/kanan/tengah yang bisa dikustom.
- Perpustakaan pribadi: 4 tab — Sedang Dibaca (auto, urut terakhir dibuka), Favorit (manual), Selesai Dibaca, Ingin Dibaca (plan to read); swipe hapus.
- Riwayat baca: log chapter + timestamp, hapus per item / clear all.
- Download offline: per chapter, status queue/downloading/selesai/gagal + retry, lihat total size, hapus per manhwa/chapter.
- Pengaturan: tema Light/Dark/Sistem, bahasa chapter default (ID/EN), filter dewasa, kualitas gambar (data saver), ukuran cache + clear cache, arah baca default, backup & restore JSON.
- Error handling informatif: no internet, API error, rate limit (429) dengan UI retry.

## 3. Non-Tujuan (v1)

- Tidak ada publikasi ke Play Store / App Store (isu hak cipta konten — pemakaian pribadi saja, lihat §17 legal).
- Tidak ada auth/login user, sync cloud, multi-user, atau backend sendiri.
- Tidak ada upload chapter / jadi uploader / ag simply scrape ilegal di luar ToS MangaDex.
- Tidak ada komentar, forum, atau sosial antar-user.
- Notifikasi chapter baru favorit (background fetch/WorkManager) bersifat **opsional nice-to-have** — masuk v1.1 jika semurah (lihat §8.9).
- Tidak ada hardcode API key/credential apapun ke repo publik.

---

## 4. Tech Stack (terkunci di `pubspec.yaml:9-45`)

| Lapisan | Lib | Versi | Catatan |
|---|---|---|---|
| UI | `flutter` + `google_fonts` | Flutter 3.44.4 / `8.2.1` | Plus Jakarta Sans + Space Grotesk, tema KuroYomi dark-first — `lib/core/theme/app_theme.dart:1-60` |
| State | `flutter_riverpod` (+ `riverpod_annotation` + `riverpod_generator` dev) | `3.4.3` / `4.0.7` / `4.0.9` | `ProviderScope` di `lib/main.dart:8`; Riverpod 3.x — `Provider/FutureProvider/StreamProvider/NotifierProvider`, `AsyncValue.value` |
| Network | `dio` | `5.11.1` | `DioClient` throttle + retry 429 + `createBrowser()` UA Chrome untuk Komiku — `lib/core/network/dio_client.dart:1-60` |
| Scrape | `html` | `0.15.7` | parser DOM Komiku (pure Dart, aman Web) |
| DB lokal | `drift` + `drift_flutter` + `sqlite3_flutter_libs` + `path_provider` + `path` | `2.34.4` / `0.3.1` / `0.6.0` / `2.1.6` / `1.9.1` | `AppDatabase` `driftDatabase(name: 'baca_manhwa.db')` — `lib/core/database/app_database.dart:23` |
| Gambar | `cached_network_image` | `4.0.0` | cover + halaman reader (memory+disk cache) |
| Reader | `photo_view` + `flutter_staggered_grid_view` | `0.15.0` / `0.7.0` | zoom per halaman + layout vertical webtoon |
| Nav | `go_router` | `18.0.1` | `StatefulShellRoute.indexedStack` 5 cabang — `lib/app.dart:19-33` |
| Format | `intl` | `0.20.2` | `initializeDateFormatting('id_ID')` — `lib/main.dart:8` |
| Storage mgmt | `path_provider` + (opsional `flutter_cache_manager`) | — | ukur cache + file download chapter |
| Backup | `file_picker` + `share_plus` | `12.2.0` / `13.3.0` | export/import JSON favorit+riwayat — `lib/services/backup_service.dart:1-120` (Fase 6) |
| Util | `uuid` | `4.6.0` | id lokal bila perlu |
| Notif (v1.1) | `flutter_local_notifications` + `workmanager` | — | hanya jika §8.9 dieksekusi |

> Versi exact dikunci Fase 1 via `flutter pub add` (lihat tabel). Dev deps: `build_runner 2.15.1`, `drift_dev 2.34.6`, `flutter_lints 6.0.0`.

---

## 5. Arsitektur

### 5.1 Struktur Target (Clean Architecture sederhana)

```
lib/
├── core/
│   ├── network/dio_client.dart:1-60        // baseUrl api.mangadex.org, throttle, retry 429
│   ├── network/mangadex_api.dart            // endpoint: /manga, /manga/{id}, /manga/{id}/feed, /at-home/server/{id}, /cover/{id}
│   ├── database/app_database.dart:14-26    // @DriftDatabase 6 tabel
│   ├── database/app_database.g.dart        // generated
│   ├── database/tables/{mangas,chapters,library_entries,reading_history,downloads,app_settings}.dart
│   ├── theme/{app_colors.dart:5-58, app_theme.dart:6-70}
│   └── utils/{date_formatter.dart, content_rating_filter.dart, storage_helper.dart}
├── features/
│   ├── home/data/{manga_repository_impl.dart, mangadex_remote_datasource.dart, manga_model.dart}
│   │       domain/{manga_entity.dart, manga_repository.dart, get_trending/get_latest/get_recommended.dart}
│   │       presentation/{home_screen.dart, widgets/manga_grid_card.dart, home_provider.dart}
│   ├── search/        // (struktur sama: data/domain/presentation)
│   ├── manhwa_detail/ // detail + feed chapter
│   ├── reader/        // at-home/server + viewer vertical/horizontal + progress
│   ├── library/       // 4 tab list lokal
│   ├── history/       // log baca
│   ├── download/      // queue + storage management
│   └── settings/      // tema, bahasa, filter, kualitas, backup
├── services/{backup_service.dart, notification_service.dart (v1.1)}
├── app.dart:12-66 + main.dart:6-10
```

Setiap fitur idealnya punya `data/` (API call & model) | `domain/` (entity & repository interface + usecase) | `presentation/` (screen, widget, provider). Arah dependensi: `presentation -> domain -> data -> core (network/database)`.

Abstraksi sumber: `MangaRemoteDataSource` interface — implementasi default `MangadexRemoteDataSource`. Ganti sumber lain nantinya = tambah implementasi baru tanpa ubah UI.

**Keputusan Fase 1:** layer manga yang dipakai lintas fitur (entity + model + datasource + repository + provider) dikonsolidasi di modul shared `lib/features/manga/` (bukan duplikat per fitur) — `home/search/detail/reader` hanya berisi `presentation` + memakai provider dari modul ini.

**Keputusan Fase 2:** widget lintas-fitur di `lib/core/widgets/` (`error_view`, `empty_view`, `skeleton`, `manga_grid_card`); aksi library awal (`toggle` + quick-action sheet) di `lib/features/library/presentation/library_actions.dart` agar grid Home/Search sudah bisa tambah Favorit (dipakai penuh di Fase 5).

**Keputusan Fase 9 (sumber Indonesia):** Komiku jadi sumber default (`source='komiku'`), MangaDex opsional via Setelan. Alasan: konten ID di MangaDex minim + sering terblokir ISP; Komiku berbahasa Indonesia + tidak diblokir. Implementasi: `KomikuApi` (dio HTML: `api.komiku.org/manga/` list 10/halaman + `komiku.org/manga/{slug}/` + `/{chapter}/`), parser `komiku_model.dart` (package `html`), `KomikuRepositoryImpl implements MangaRepository` (ID `k:{slug}` / `k:{manga}:{chapter}` agar unik lintas sumber), `mangaRepositoryProvider` switch ikut `sourceProvider`, `AtHome` dukung direct-URL (`baseUrl` kosong), fallback host gambar `image2→img`. Genre Komiku = daftar kurasi (tanpa network); tahun/rating diabaikan (UI sembunyikan chip tahun & urutan Rating/A-Z saat Komiku); tab bahasa detail disembunyikan bila 1 bahasa. Legal: scraper tidak resmi — bisa rusak bila situs berubah; throttle ringan + cache; pemakaian pribadi.

### 5.2 Dependensi

`presentation (home_provider.dart dkk) -> domain (usecase -> repository abstract -> entity) -> data (repository_impl + model + remote_datasource + local cache -> database)` + `core` shared. `databaseProvider` singleton Drift (`lib/core/providers/database_provider.dart:1-8`), di-inject ke repository lokal. Remote (dio) di-inject via `dioProvider` / `mangaRepositoryProvider`. Cache-first: baca `mangas`/`chapters` lokal dulu, refresh ke API bila stale, tulis balik ke DB.

---

## 6. Desain Sistem (Material 3 — Panduan KuroYomi dark, Fase 21)

**Tokens warna (dark-first)** — `lib/core/theme/app_colors.dart`: primary lavender `#D0BCFF`, secondary mint `#4EDEA3`, tertiary sky `#7BD0FF`, surface `#0F131C` + container `#1C2028/#262A33`, `onSurface #DFE2EE`. Tema terang biru `#2F80D6` tetap sebagai opsi. Font Jakarta + Grotesk, radius 16.

**Navigasi bawah fixed (5 label selalu):** `lib/app.dart` — cottage/explore/auto_stories(+badge)/history/tune.

**Layar setia panduan (Fase 21):** Home = search bar + tune + pill genre + spotlight 16:10 (rating+CTA+bookmark) + Lanjut Baca progres + grid Update 2 kolom (badge ID/Ch/waktu) + tombol muat + status; Detail = CTA gradien + 4 aksi; Reader = jam HUD + bookmark posisi + milestone tiap 10 halaman; Library sheet = Lanjutkan/Unduh-5/Favorit/Selesai/Hapus.

---

## 7. Database — Drift ORM

**File:** `lib/core/database/app_database.dart:14-40` `schemaVersion => 1`, `beforeOpen PRAGMA foreign_keys = ON`. File DB `baca_manhwa.db` via `driftDatabase(name: 'baca_manhwa.db')` — `app_database.dart:23`. Metadata API (judul, cover, tag) di-cache di `mangas` agar tidak selalu hit API (hemat rate limit).

### 7.1 Tabel (6)

#### `mangas` — `lib/core/database/tables/mangas.dart:3-20`
```dart
id TEXT PK                    // uuid MangaDex (bukan auto-increment)
title TEXT
altTitles TEXT NULL           // JSON array string
description TEXT NULL
status TEXT NULL              // ongoing | completed | hiatus | cancelled
contentRating TEXT NULL       // safe | suggestive | erotica | pornographic
year INTEGER NULL
coverUrl TEXT NULL            // URL cover ter-resolve (///uploads.mangadex.org/covers/...)
tags TEXT NULL                // JSON array tag id/nama
author TEXT NULL
artist TEXT NULL
lastFetched DATETIME NULL     // untuk staleness cache
```

#### `chapters` — `lib/core/database/tables/chapters.dart:3-15`
```dart
id TEXT PK                    // uuid chapter MangaDex
mangaId TEXT NOT NULL REFERENCES mangas(id) ON DELETE CASCADE
title TEXT NULL
chapterNo TEXT NULL           // string karena bisa "12.5", "Oneshot"
volume TEXT NULL
language TEXT                 // 'id' | 'en' | lain
pages INTEGER DEFAULT 0
readableAt DATETIME NULL
isRead BOOLEAN DEFAULT false
lastPage INTEGER DEFAULT 0    // auto-resume posisi
```

#### `library_entries` — `lib/core/database/tables/library_entries.dart:3-10`
```dart
id INTEGER AUTO_INCREMENT PK
mangaId TEXT NOT NULL REFERENCES mangas(id) ON DELETE CASCADE
listType TEXT                 // reading | favorite | completed | plan
addedAt DATETIME DEFAULT currentDateAndTime
lastOpened DATETIME NULL      // sortir "Sedang Dibaca"
UNIQUE(mangaId, listType)
```

#### `reading_history` — `lib/core/database/tables/reading_history.dart:3-10`
```dart
id INTEGER AUTO_INCREMENT PK
mangaId TEXT NOT NULL REFERENCES mangas(id) ON DELETE CASCADE
chapterId TEXT NOT NULL REFERENCES chapters(id) ON DELETE CASCADE
page INTEGER DEFAULT 0
readAt DATETIME DEFAULT currentDateAndTime
```

#### `downloads` — `lib/core/database/tables/downloads.dart:3-12`
```dart
id INTEGER AUTO_INCREMENT PK
mangaId TEXT NOT NULL REFERENCES mangas(id) ON DELETE CASCADE
chapterId TEXT NOT NULL REFERENCES chapters(id) ON DELETE CASCADE
status TEXT DEFAULT 'queue'   // queue | downloading | done | failed
totalPages INTEGER DEFAULT 0
donePages INTEGER DEFAULT 0
sizeBytes INTEGER DEFAULT 0
localPath TEXT NULL           // folder file gambar chapter
UNIQUE(chapterId)
```

#### `app_settings` — `lib/core/database/tables/app_settings.dart:3-12`
```dart
id INTEGER AUTO_INCREMENT PK
theme TEXT DEFAULT 'system'        // light | dark | system
chapterLang TEXT DEFAULT 'id'      // 'id' | 'en'
adultFilter BOOLEAN DEFAULT true   // true = sensor konten dewasa ON
dataSaver BOOLEAN DEFAULT false    // true = load resolusi rendah (data-saver at-home)
readDirection TEXT DEFAULT 'vertical' // vertical | horizontal
brightness DOUBLE NULL             // brightness khusus reader (null = sistem)
source TEXT DEFAULT 'komiku'       // v2 (Fase 9): 'komiku' | 'mangadex'
recentSearches TEXT DEFAULT '[]'   // v3 (Fase 11): JSON array query, max 8
```

### 7.2 Query Utama — `lib/core/database/app_database.dart:43-160`
- `watchLibraryByType(listType)` join `mangas` + `orderBy lastOpened desc` (tab Sedang Dibaca) / `addedAt desc` (tab lain) — pakai index `idx_library_listType`, `idx_library_lastOpened`
- `watchHistory()` join `mangas`+`chapters` + `orderBy readAt desc` + `limit/offset` — index `idx_history_readAt`
- `watchChapters(mangaId, {language, sortAsc})` + filter `isRead` — index `idx_chapters_mangaId`, `idx_chapters_lang`
- `upsertManga(manga)` / `upsertChapters(list)` — cache metadata API
- `markChapterRead(chapterId, page)` — update `chapters.isRead/lastPage` + insert `reading_history` + touch `library_entries.lastOpened` (auto-masuk Sedang Dibaca)
- `watchDownloads() / updateDownloadProgress() / retryDownload()` — index `idx_downloads_status`
- `getSettings / watchSettings / updateSettings` upsert single-row + migrasi v1→v2 (`source`) + v2→v3 (`recentSearches`)
- Index awal (v1): `idx_chapters_mangaId`, `idx_chapters_lang`, `idx_library_listType`, `idx_library_lastOpened`, `idx_history_readAt`, `idx_downloads_status` via `customStatement CREATE INDEX IF NOT EXISTS`

### 7.3 Seed Default — `lib/core/database/app_database.dart:200-230`

Hanya `app_settings` satu baris (`theme system, chapterLang id, adultFilter true, dataSaver false, readDirection vertical`). **Tidak seed manga/chapter contoh** — user mulai dari data API asli. Empty state tiap layar ditangani ("Belum ada…").

---

## 8. Fitur Rinci & Acceptance Criteria

### 8.1 Beranda — `lib/features/home/presentation/home_screen.dart:1-150`
- **Tampil:** search bar di atas (tap → `/search`); seksi "Manhwa Populer" (order rating/followedCount desc), "Update Terbaru" (order latestUploadedChapter desc), "Rekomendasi" (top tag dari `library_entries`+`reading_history` → query `GET /manga` dengan `includedTags[]`) — `home_provider.dart:10-60`.
- Cover grid horizontal scroll per seksi, rasio 2:3, `cached_network_image` + skeleton shimmer.
- Pull-to-refresh per seksi; cache DB dipakai dulu bila offline.
- **AC:** 3 seksi tampil <3s di koneksi normal; offline tampil data cache + banner "Mode offline".

### 8.2 Pencarian & Filter — `lib/features/search/presentation/search_screen.dart:1-200`
- Field: `title` (debounce 500ms), filter genre/tag (`includedTags[]`/`excludedTags[]`), `status[]` (ongoing/completed), content rating (`contentRating[]` mengikuti `adultFilter`), `year`, `order[rating|latestUploadedChapter|title]` — `search_provider.dart:10-80`.
- Pagination `limit 20 offset` + infinite scroll (`ScrollController` threshold 80%).
- **AC:** ketik judul tampil hasil; kombinasi filter via `copyWith`; scroll mentok load halaman berikut tanpa duplikat; state filter persist selama sesi.

### 8.3 Detail Manhwa — `lib/features/manhwa_detail/presentation/detail_screen.dart:1-250`
- Fetch `GET /manga/{id}?includes[]=cover_art&includes[]=author&includes[]=artist` → simpan ke `mangas`; feed `GET /manga/{id}/feed?translatedLanguage[]=id&translatedLanguage[]=en&order[chapter]=asc&limit=100` → simpan ke `chapters` — `detail_provider.dart:10-90`.
- **Tampil:** cover besar, judul + alternatif, sinopsis (expandable), tag chips, status, author/artist, rating & follows (jika ada), tombol Favorit + Sedang Dibaca (toggle `library_entries`), dropdown bahasa chapter (Semua/ID/EN), toggle urut naik/turun, tiap row chapter ada badge bahasa + dot "sudah dibaca".
- **AC:** buka detail <2s bila cache ada; toggle favorit langsung ubah icon + snackbar; filter bahasa bekerja tanpa refetch API (filter lokal bila data sudah ada).

### 8.4 Reader — `lib/features/reader/presentation/reader_screen.dart:1-350`
- Resolve `GET /at-home/server/{chapterId}` → `{baseUrl, chapter.hash, data[], dataSaver[]}`; pilih `data` vs `dataSaver` sesuai `dataSaver` setting — `reader_provider.dart:10-100`. URL halaman: `{baseUrl}/{quality}/{hash}/{filename}`.
- **Mode vertical (webtoon):** `ListView`/`CustomScrollView` gambar full-width, `cached_network_image` + preload 3-5 ke depan (`precacheImage`), progress bar atas (posisi scroll / total).
- **Mode horizontal:** `PageView` + `PhotoView` per halaman (pinch-to-zoom); vertical pun tiap gambar bisa tap → zoom overlay `PhotoView`.
- Kontrol: slider brightness (khusus reader, tidak ubah sistem), toggle AMOLED black, tap-zone kiri/kanan/tengah (default: kiri prev, kanan next, tengah toggle UI; bisa dikustom di Settings), tombol next/prev chapter di ujung (halaman terakhir → "Chapter Berikutnya").
- Auto-resume: simpan `lastPage` tiap ganti halaman (debounce), saat buka chapter tanya "Lanjutkan hal. N?" bila `lastPage > 0`; selesai chapter → `markChapterRead` + masuk history + auto favorit? tidak — hanya Sedang Dibaca.
- **AC:** gambar sementara/token-based tidak pernah di-hardcode — selalu via at-home; pindah halaman <300ms bila preload hit; rotasi tidak reset posisi; offline bisa baca bila chapter sudah di-download (baca dari `localPath`).

### 8.5 Perpustakaan — `lib/features/library/presentation/library_screen.dart:1-180`
- 4 tab (`TabBar`): Sedang Dibaca (`listType reading`, sort `lastOpened desc`), Favorit (`favorite`), Selesai (`completed`), Ingin Dibaca (`plan`) — `library_provider.dart:10-60`.
- Grid 2:3 + badge progress (chapter terbaca / total), long-press quick actions (pindah list, hapus), swipe (Dismissible) hapus dari list.
- Auto-masuk Sedang Dibaca saat mulai baca chapter (§7.2 `markChapterRead`).
- **AC:** tambah/hapus langsung refleksi tanpa restart; tiap tab punya empty state sendiri.

### 8.6 Riwayat — `lib/features/history/presentation/history_screen.dart:1-120`
- List `reading_history` join manga+chapter + timestamp relatif ("5 menit lalu", `date_formatter.dart`), tap → lanjut baca posisi tersimpan.
- Aksi: hapus per item (swipe), clear all (dialog konfirmasi).
- **AC:** buka chapter selalu nambah 1 row history; clear all butuh konfirmasi; kosong → empty state.

### 8.7 Download / Offline — `lib/features/download/data/download_manager.dart:1-150`
- Download per chapter: buat row `downloads` status `queue` → `downloading` (unduh tiap file halaman ke `documents/downloads/{mangaId}/{chapterId}/`) → `done` (catat `sizeBytes`) / `failed` (tombol retry). Antri FIFO, maksimal 2 concurrent.
- Layar manajemen: total size semua download (`storage_helper.dart`), list per manhwa → per chapter, hapus per chapter/manhwa, indikator progress `donePages/totalPages`.
- Reader prioritas file lokal bila `status done`.
- **AC:** download 1 chapter 20 halaman selesai tanpa corrupt; retry dari `failed` lanjut sisa (bukan dari 0 bila file sudah ada); hapus chapter hapus file fisiknya juga.

### 8.8 Pengaturan — `lib/features/settings/presentation/settings_screen.dart:1-200`
- Tema Light/Dark/Sistem (`themeProvider` → `ThemeMode` di `app.dart:40`); bahasa chapter default ID/EN (`chapterLangProvider`); toggle filter dewasa (`adultFilterProvider` → batasi `contentRating[]` query); data saver (`dataSaverProvider`); arah baca default (`readDirectionProvider`); brightness default reader; ukuran cache (`storage_helper.dart:cacheSize()`) + tombol clear cache (`cached_network_image` evict + hapus file sementara, jangan hapus download); backup & restore JSON (favorit, library, history, settings) via `backup_service.dart` + `file_picker`/`share_plus`.
- **AC:** tiap setting persist via `watchSettings` stream; ganti bahasa default langsung pengaruhi feed chapter berikutnya; clear cache tampilkan size terhapus.

### 8.9 Notifikasi chapter baru (opsional, v1.1) — `lib/services/notification_service.dart:1-80`
- `Workmanager` periodic 6-12 jam: cek feed tiap `favorite` → bandingkan `latestChapterId` cache → notif lokal bila ada baru. Toggle on/off di Settings. Tidak ada push remote.
- **AC (v1.1):** favorit ada chapter baru → notif <24 jam; tap notif → buka detail.

### 8.10 UI/UX & Navigasi
- Bottom nav 5 — `lib/app.dart:54-64`; detail & reader sebagai `GoRoute` push penuh; FAB hanya di mana relevan (misal download semua chapter terlihat di detail).
- Skeleton shimmer tiap grid/list loading; error view informatif (icon + pesan + tombol Coba Lagi) untuk: no internet (`DioException.connectionError`), 429 rate limit ("Terlalu sering, coba lagi dalam Xs" + auto backoff), 5xx/404 API.
- Rate-limit guard: debounce search, cache TTL metadata 24 jam (`lastFetched`), throttle feed/detail bila 429 (baca header `Retry-After`), maksimal 5 req/detik global via interceptor — `dio_client.dart:20-60`.

---

## 9. Riverpod Providers Graph

```
dioProvider (Dio + throttle/retry) — core/providers/network_provider.dart:1-15
databaseProvider (AppDatabase singleton) — core/providers/database_provider.dart:1-8
├── settingsStreamProvider / themeModeProvider / chapterLangProvider / adultFilterProvider
│   / dataSaverProvider / readDirectionProvider / sourceProvider + settingsActionsProvider — features/settings/presentation/settings_provider.dart:6-40 (+ recentSearchesProvider + merge/decode helpers, Fase 11)
├── komikuApiProvider (dio UA Chrome) + komikuRemoteDataSourceProvider + mangaRepositoryProvider (switch Komiku/MangaDex ikut sourceProvider)
│   │   — features/manga/providers/manga_providers.dart:8-30 + data/datasources/komiku_* + data/repositories/komiku_repository_impl + data/models/komiku_model (package html)
├── mangaRemoteDataSourceProvider + mangaRepositoryProvider (remote Mangadex + cache Drift)
│   │   — features/manga/providers/manga_providers.dart:8-30 + data/datasources + data/repositories
│   ├── trendingProvider / latestUpdatesProvider (offline fallback cache) + tagsProvider + recommendedProvider (top-3 tag library+riwayat) — manga_providers.dart
│   ├── searchFilterProvider (MangaFilterNotifier) + searchResultsProvider (limit 20 + loadMore) — search/search_provider.dart
│   ├── (Fase 3) mangaDetailProvider + feedLoaderProvider + chapterStreamProvider (cache reaktif + sort numeric) + libraryIdsProvider — manhwa_detail/detail_provider.dart
│   └── reader: atHomeProvider (resolve fresh) + readerChapterProvider — reader/reader_provider.dart
└── Local-only:
    ├── libraryTabProvider — library/library_provider.dart (+ aksi library_actions.dart)
    ├── historyStreamProvider — history/history_provider.dart
    └── downloadManagerProvider + downloadsStreamProvider + downloadOfProvider + localPagesProvider + totalDownloadBytesProvider — download/download_provider.dart (backend IO/stub via download_backend.dart agar `build web` lolos)
```

**Mappers:** `features/*/data/*_model.dart` (JSON MangaDex → entity: `Manga`, `Chapter`, `Cover`, `AtHome`) — contoh `manga_model.dart:1-120` parsing `data.attributes.title.en`, `relationships` cover_art/author.

Invalidasi: reaktif via stream Drift (`watchChapters` → dot baca update otomatis, `watchLibrary`/`watchHistory`/`watchDownloadsWithManga` tanpa invalidate manual).

---

## 10. Layanan & Util

- **DioClient** — `lib/core/network/dio_client.dart:1-60` `baseUrl https://api.mangadex.org`, header `User-Agent BacaManhwa/1.0`, interceptor throttle (max 5 rps) + retry 429 (baca `Retry-After`, backoff eksponensial max 3x).
- **MangadexApi** — `lib/core/network/mangadex_api.dart:1-150` wrapper `getManga()`, `getMangaDetail()`, `getFeed()`, `getAtHome()`, `getCoverUrl()` (resolve `cover_art` → `https://uploads.mangadex.org/covers/{mangaId}/{fileName}.256.jpg`).
- **KomikuApi** — `lib/core/network/komiku_api.dart:1-60` scrape HTML: `listPage()` (`api.komiku.org/manga/?tipe=manhwa&orderby=&genre=&status=&page=`, 10/halaman), `searchPage()` (`api.komiku.org/?post_type=manga&s=&tipe=manhwa`), `detailPage()` + `chapterPage()` (`komiku.org/...`). Parser `komiku_model.dart` (`.bge`, `table.inftable`, `ul.genre li a`, `#daftarChapter`, `#Baca_Komik img`).
- **AppConstants** — `lib/core/constants/app_constants.dart:1-15` `appName Baca Manhwa`, `locale id_ID`, `dbVersion 1`, `apiBaseUrl`, `coverBaseUrl https://uploads.mangadex.org`, `cacheTtlHours 24`, `searchDebounceMs 500`, `preloadPages 4`.
- **ContentRatingFilter** — `lib/core/utils/content_rating_filter.dart:1-30` mapping `adultFilter ON → contentRating=[safe,suggestive]`, `OFF → +erotica` (pornographic selalu exclude v1).
- **StorageHelper** — `lib/core/utils/storage_helper.dart:1-60` `cacheSize()`, `downloadsSize()`, `clearCache()`, format MB.
- **BackupService** — `lib/services/backup_service.dart:1-120` `exportJson()` (library+history+settings+`imagePath` bila ada) / `importJsonString()` dengan validasi format + dialog konfirmasi perbandingan isi (pelajaran insiden restore kosong — jangan wipe sebelum snapshot).
- **DateFormatter** — `lib/core/utils/date_formatter.dart:1-30` `formatRelative()` Indonesia ("baru saja", "5 mnt lalu", `DateFormat('d MMM yyyy', 'id_ID')`).

---

## 11. Bahasa & Locale

- **Bahasa UI:** Indonesia penuh. Label: Beranda, Cari, Perpustakaan, Riwayat, Pengaturan, Manhwa Populer, Update Terbaru, Rekomendasi, Sedang Dibaca, Favorit, Selesai Dibaca, Ingin Dibaca, Belum ada manhwa favorit, Coba Lagi, Mode offline, Chapter Berikutnya, dll.
- **Locale:** `id_ID` — `lib/main.dart:8` `initializeDateFormatting('id_ID')`, tanggal chapter `DateFormat('d MMM yyyy', 'id_ID')`.
- **Bahasa konten:** chapter default Indonesia (`translatedLanguage[]=id`), fallback English (`en`) bila ID kosong — diatur `chapterLangProvider`; tidak ada mata uang (aplikasi baca, bukan finansial).

---

## 12. Performa & Offline-First (Online-first + cache agresif)

- **API-first, cache kedua:** metadata (`mangas`+`chapters`) ditulis ke Drift tiap fetch; baca tampilkan cache dulu bila `lastFetched` <24 jam, refresh background. Daftar library/history/download 100% lokal (airplane mode tetap bisa dibuka).
- **Hemat rate limit:** debounce search 500ms, pagination `limit 20`, TTL 24 jam, throttle 5 rps, hormati `Retry-After` saat 429 — `dio_client.dart:20-60`.
- **Gambar:** `cached_network_image` (disk cache cover + halaman), preload 4 halaman depan di reader (`precacheImage`), data-saver pakai `dataSaver[]` dari at-home (resolusi rendah).
- **Pagination:** `PaginatedMangaNotifier` `_limit 20`, `_hasMore`, `loadInitial/loadMore` — `search_provider.dart:50-80`; UI infinite scroll + `RefreshIndicator`.
- **State optimasi:** `StateProvider` filter + `StreamProvider`/`FutureProvider` watch minimal rebuild; hindari `watch` berat di `build` reader (progress via `ValueNotifier`, bukan rebuild full list).

---

## 13. Struktur Folder Saat Ini vs Target

**Saat ini (Fase 19 — SELESAI 2026-09-05):** tap-zone vertikal (`_scrollByScreen` ±0.85 layar) + speed auto-scroll persisten (`autoScrollSpeed`, migrasi v4, slider 1–10 di sheet).
```
pubspec.yaml (name: baca_manhwa, v1.0.0+1, deps §4 ter-resolve)
lib/
├── main.dart + app.dart (5 tab StatefulShellRoute + /manga/:id + /reader/:chapterId)
├── core/{network/{dio_client,mangadex_api}, database/{app_database + tables×6},
│   theme/{app_colors,app_theme}, utils/{date_formatter,content_rating_filter,storage_helper},
│   constants/app_constants, providers/{database_provider,network_provider}}
├── features/manga/{domain/entities, domain/repositories, data/{models,datasources,repositories}, providers}
├── features/{home,search,manhwa_detail,reader,library,history,settings}/presentation/*_screen.dart (placeholder)
test/{widget_test.dart (shell 5 tab), model_test.dart (4 test fixtures payload asli), fixtures/{search,detail_wrap,feed,athome}.json}
tool/smoke_api.dart (skrip verifikasi live, butuh network tak-terblokir)
```

**Target (Fase 2-7):** ganti 7 placeholder screen dengan UI penuh (§8) + `features/download/` + `services/backup_service.dart`.

---

## 14. Kriteria Penerimaan v1 (Checklist Deliverables)

- [x] **Fase 0 — PRD — SELESAI (2026-09-05):** PRD 19 section + AGENTS + opencode.json + commands (dokumen ini)
- [x] **Fase 1 — Fondasi — SELESAI (2026-09-05):** project `baca_manhwa` + deps §4, Drift 6 tabel + FK ON + 6 index + seed settings, dio throttle/retry + 5 endpoint wrapper + parsing lolos 4 test fixtures payload asli, shell 5 tab + sub-route, `analyze` 0 issues, `test` 5/5, `build web` sukses
- [x] Flutter project `baca_manhwa` + `pubspec.yaml` dependensi §4 lengkap
- [x] Drift 6 tabel (§7.1) + FK ON + index + seed settings default
- [x] Dio client + MangadexApi wrapper (5 endpoint §5/§10) + throttle/retry 429 + model/entity Manga/Chapter/AtHome
- [x] **Fase 2 — Home + Search — SELESAI (2026-09-05):** 3 seksi + search bar, filter order/status/genre/tahun + debounce + infinite scroll, offline cache fallback, skeleton/error/empty state, quick actions long-press, `analyze` 0 issues, `test` 9/9
- [x] Beranda: 3 seksi + search bar + skeleton + offline cache
- [x] Search: title debounce + filter tag/status/rating/tahun/order + infinite scroll
- [x] **Fase 3 — Detail — SELESAI (2026-09-05):** detail + feed ID/EN/semua + sort numeric-aware + badge bahasa + dot dibaca reaktif + toggle Favorit/Sedang Dibaca, `analyze` 0 issues, `test` 10/10
- [x] Detail: cover/judul/sinopsis/tag/author/rating + favorit & sedang-dibaca toggle + feed chapter sort + badge bahasa + dot dibaca
- [x] **Fase 4 — Reader — SELESAI (2026-09-05):** vertikal + horizontal + zoom + preload + progress + auto-resume + brightness + AMOLED + tap-zone + next/prev, `analyze` 0 issues, `test` 10/10
- [x] Reader: vertical + horizontal + PhotoView zoom + preload 4 + next/prev chapter + progress + auto-resume + brightness + AMOLED black + tap-zone kustom
- [x] **Fase 5 — Library/History/Download — SELESAI (2026-09-05):** 4 tab + auto-masuk + swipe, history log + clear, download queue/retry/size + reader offline, `analyze` 0 issues, `test` 10/10, `build web` sukses
- [x] Library: 4 tab + auto-masuk + swipe hapus + empty state
- [x] History: log timestamp + hapus per item / clear all
- [x] Download: queue/downloading/done/failed + retry + total size + hapus file fisik
- [x] **Fase 6 — Settings/Backup — SELESAI (2026-09-05):** semua setting persist + cache + backup-share/restore-merge + about/FAQ, `analyze` 0 issues, `test` 13/13
- [x] Settings: tema/bahasa/filter dewasa/data saver/cache size + clear cache/arah baca/brightness/backup-restore JSON
- [x] **Fase 7 — QA/APK — SELESAI (2026-09-05):** `analyze` No issues found, `test` 13/13, `build web` sukses, `build apk --release` sukses (19.9MB arm64 / 61.2MB universal). Smoke test HP fisik → checklist manual user (install, cari, baca 1 chapter, unduh 1 chapter, backup)
- [x] **Fase 8 — UI/UX KuroYomi — SELESAI (2026-09-05):** tema gelap + font + nav badge + Home/Detail/Reader/Library sesuai `panduan ui ux.txt`, `analyze` 0 issues, `test` 13/13, `build web` sukses, APK 20.0MB arm64
- [x] **Fase 9 — Sumber Komiku ID — SELESAI (2026-09-05):** scraper list/search/detail/chapter ID + selektor sumber + migrasi v2 + fallback gambar, `analyze` 0 issues, `test` 17/17, smoke live OK
- [x] **Fase 18 — QA Audit + Laporan — SELESAI (2026-09-05):** 6 test bukti baru + `docs/QA_REPORT.md` 27 section (skor 82/100), `analyze` 0 issues, `test` 31/31
- [x] **Fase 19 — Tap Scroll + Speed — SELESAI (2026-09-05):** zona ketuk vertikal + slider kecepatan persisten, `analyze` 0 issues, `test` 31/31
- [x] **Fase 20 — Tema MangaIndo + Rebrand — SELESAI (2026-09-05):** tema biru terang + nav pil + Home contoh + logo + rename, `analyze` 0 issues, `test` 31/31, APK baru
- [x] **Fase 21 — Panduan KuroYomi Setia — SELESAI (2026-09-05):** dark default + nav fixed + Home/Detail/Reader/Library panduan, `analyze` 0 issues, `test` 31/31, `build web` + APK
- [x] **Fase 22 — 20 Update di Beranda — SELESAI (2026-09-05):** fetch 20 + tampil semua, `analyze` 0 issues, `test` 31/31
- [x] **Fase 23 — Infinite Scroll Beranda — SELESAI (2026-09-05):** scroll mentok muat lagi + stop otomatis, `analyze` 0 issues, `test` 31/31
- [x] Error view informatif (offline, 429, 5xx) + `flutter analyze` 0 error + `flutter test` hijau + `flutter build apk --release` sukses <40MB
- [x] Legal: catatan pribadi + patuh ToS & rate limit MangaDex, tanpa credential hardcode

---

## 15. Risiko & Mitigasi

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Rate limit 429 MangaDex | feed/search gagal massal | throttle 5 rps + debounce + TTL cache 24 jam + hormati `Retry-After` + retry max 3x — `dio_client.dart:20-60` |
| URL at-home sementara/expired | gambar gagal load | selalu resolve fresh via `GET /at-home/server/{id}` tiap buka chapter; jangan cache URL halaman, cache filenya (download) |
| `uploads.mangadex.org` lambat / timeout | reader jank | `cached_network_image` + preload 4 + data-saver mode + retry per halaman + placeholder |
| Chapter bahasa ID kosong | feed kosong membingungkan | fallback otomatis ke EN + dropdown bahasa + empty state "Belum ada chapter bahasa Indonesia" |
| Download besar (100+ halaman) | OOM / storage penuh | batasi 2 concurrent, tulis file streaming per halaman, cek free space sebelum mulai, tampilkan size |
| `sqlite3_flutter_libs` Android 14 | crash native | lock versi §4 + test `AppDatabase.forTesting` in-memory |
| Isu hak cipta bila disebar | takedown / pelanggaran | tegaskan **pribadi saja** di README+Settings About; patuhi ToS MangaDex (attribution + rate limit); jangan publish store |
| Konten dewasa tak sengaja tampil | UX tidak nyaman | `adultFilter` default ON, `pornographic` selalu exclude, badge contentRating di detail |
| Struktur HTML Komiku berubah | scraper rusak (list/detail/chapter kosong) | parser defensif + test fixtures; error view + fallback cache; user bisa pindah ke MangaDex sementara |
| Blokir DNS ISP Indonesia (InternetSehat redirect api.mangadex.org) | API tak terjangkau di network tertentu (terbukti di dev 2026-09-05) | **Komiku default tidak terblokir**; MangaDex opsional + FAQ Private DNS/VPN; tampilkan error offline + retry yang jelas; JANGAN hardcode IP di kode |

---

## 16. Roadmap Eksekusi (setelah PRD)

**Fase 0 — PRD — SELESAI (2026-09-05):** PRD v1.0 19 section + `AGENTS.md` 4-5 section (aturan wajib update §2) + `opencode.json:1-4` instructions + command `.opencode/command/finish-phase.md` & `update-prd.md`. Struktur anti-lupa §19 aktif, siap Fase 1.
**Fase 1 — Fondasi API + DB + Shell — SELESAI (2026-09-05):** `flutter create` (android+web, org com.pribadi), deps §4 via `flutter pub add`, `dio_client.dart` (throttle 5rps + retry 429) + `mangadex_api.dart` (5 endpoint) + `manga_model.dart` (`_locale` prioritas id/en/ko-ro/ja-ro) + modul shared `features/manga/`, Drift 6 tabel + 6 index + seed settings (`app_database.dart` + `markChapterRead` + library/history/download DAO), `app.dart` shell 5 tab + `/manga/:id` + `/reader/:chapterId`, tema + settings providers. Verifikasi: parsing vs payload ASLI (fixtures `test/fixtures/`, temuan: judul bisa `ko-ro`-only, relationships tanpa includes tak ada attributes, feed butuh `translatedLanguage[]` encoded) — `flutter analyze` No issues found, `flutter test` 5/5, `flutter build web` sukses. Catatan: ISP dev memblokir DNS MangaDex (dialihkan ke internetsehat) — verifikasi live via IP real + `--resolve`; aplikasi tetap pakai hostname normal.
**Fase 2 — Home + Search — SELESAI (2026-09-05):** `home_screen.dart` (search bar → /search, seksi Populer/Update/Rekomendasi horizontal 2:3 + Lihat Semua + pull-to-refresh + fallback `recentCachedMangas` saat offline), `search_screen.dart` + `search_provider.dart` (TextField debounce 500ms, ChoiceChip order Terbaru/Populer/Rating/A-Z + status Semua/Ongoing/Tamat/Hiatus, bottom-sheet genre multi-select via `tagsProvider`, dialog tahun, GridView 3 kolom + `loadMore` threshold 400px + counter hasil), `manga_grid_card.dart` (tap → detail, long-press → quick actions favorit/plan/completed), `error_view/empty_view/skeleton` konsisten. Verifikasi: `flutter analyze` No issues found, `flutter test` 9/9 (baru: mapper JSON + `copyWith` year + content rating).
**Fase 3 — Detail + Feed Chapter — SELESAI (2026-09-05):** `detail_screen.dart` full (header cover 120x180 + judul/alt + chips status/tahun/rating + penulis/artist + tombol Sedang Dibaca + favorit di AppBar + sinopsis expandable + tags wrap + dropdown bahasa Semua/ID/EN default ikut `chapterLang` + sort asc/desc + ListTile chapter badge bahasa + tanggal + jml halaman + ikon dibaca) + `detail_provider.dart` (`mangaDetailProvider` remote-first fallback cache, `feedLoaderProvider` tulis cache, `chapterStreamProvider` reaktif + `sortChapters` numeric-aware "10 setelah 2", `libraryIdsProvider` status toggle). Verifikasi: `flutter analyze` No issues found, `flutter test` 10/10 (baru: sort asc/desc + oneshot).
**Fase 4 — Reader — SELESAI (2026-09-05):** `reader_screen.dart` full — resolve `atHomeProvider` fresh tiap buka; vertikal `ListView` full-width + `GestureDetector` toggle chrome + double-tap dialog `PhotoView` + estimasi halaman terlihat via `GlobalKey` (simpan debounce 600ms) + footer next-chapter; horizontal `PageView` + `PhotoView` per halaman (loading/error+retry) + tap-zone kiri/kanan/tengah + bottom bar prev/next + counter; `LinearProgressIndicator` (ValueNotifier, tanpa rebuild list); auto-resume via snackbar "Lanjutkan halaman N?"; log buka (`markChapterRead`) + `saveReadingPage` per pindah + `finished=true` di halaman akhir; sheet pengaturan (mode, AMOLED, tap-nav, slider brightness overlay, ikut-sistem); data-saver ikut setting global. Catatan: brightness = overlay dalam-aplikasi (tanpa plugin sistem). Verifikasi: `flutter analyze` No issues found, `flutter test` 10/10.
**Fase 5 — Library + History + Download — SELESAI (2026-09-05):** `library_screen` (4 tab `LibraryList`, grid 2:3 + `Dismissible` hapus + empty state per tab + tombol ke `/downloads`), `history_screen` (thumb cover + label chapter + waktu relatif + tap lanjut baca + swipe hapus + hapus-semua konfirmasi), `download_manager` (FIFO antre, 2 konkuren, `atHome` kualitas penuh, file `0001.ext` + lewati file ada = resume, progress `donePages/sizeBytes` per halaman, `failed` + retry, `remove/removeManga` hapus file fisik), `download_button` di tiap tile chapter detail (status reaktif), reader otomatis pakai file lokal bila `done` (vertikal `ReaderPageImage`, horizontal `PhotoView(FileImage)`, precache lewati lokal), `downloads_screen` (total size + grup per judul + hapus per chapter/judul). Web-safe: `download_backend.dart` + `reader_page_image.dart` + `reader_image_provider.dart` conditional export (IO vs stub; tombol unduh disabled di Web). Verifikasi: `flutter analyze` No issues found, `flutter test` 10/10, `flutter build web` sukses.
**Fase 6 — Settings + Backup — SELESAI (2026-09-05):** `settings_screen` (Segmented tema Terang/Gelap/Sistem + arah baca + bahasa ID/EN + Switch sensor dewasa & hemat data + cache size + Hapus + ke `/downloads` + backup share + restore merge + About legal + FAQ blokir ISP), `backup_service.dart` (build/share/pick/import upsert + validasi format + dialog perbandingan isi + filter FK yatim; tanpa dart:io), `test/database_test.dart` (seed, markChapterRead, library, download roundtrip — sqlite in-memory). Verifikasi: `flutter analyze` No issues found, `flutter test` 13/13.
**Fase 7 — QA — SELESAI (2026-09-05):** `flutter analyze` No issues found; `flutter test` 13/13 (model fixtures ×4, unit ×5, database ×3, widget ×1); `flutter build web` sukses (facade conditional IO/stub terbukti); `flutter build apk --release` sukses — 61.2MB universal, **19.9MB arm64** (`--shrink --obfuscate --split-debug-info --target-platform android-arm64`, KPI <40MB ✔). Perbaikan build: `AndroidManifest` label + INTERNET/ACCESS_NETWORK_STATE; `gradle.properties` `kotlin.incremental=false` (fix crash "different roots" beda drive E:/C:) + `workers.max=2` + Xmx3G (fix thread exhaustion sqlite3 hook di RAM 8GB). Sisa manual (user, butuh network tak-terblokir): install APK → buka Beranda → cari & buka detail → baca 1 chapter (coba dua mode) → unduh 1 chapter + baca offline (mode pesawat) → backup JSON.
**Fase 8 — UI/UX KuroYomi — SELESAI (2026-09-05):** adaptasi `panduan ui ux.txt` — rebrand KuroYomi; tema gelap + Jakarta/Grotesk; nav badge Pustaka + `/search?q=`; Home (pill genre → Jelajah, spotlight #1 + bookmark, Lanjut Baca progres, grid Update 2 kolom, status API); Detail (hero blur, CTA lanjut-baca, Favorit/Unduh-5-terbaru/Bagikan/Bahasa, tab ID/EN ber-count, cari chapter, kartu read/unread); Reader (HUD blur atas/bawah, slider lompat halaman, auto-scroll vertikal, kunci orientasi via SystemChrome, pill counter, badge kualitas/cache, buffer akhir bab); Library (pill ber-count + tab Unduhan, kartu storage, sort A-Z, grid/list, kartu progres + badge unread + ikon offline, FAB Perbarui). Bug ditemukan test: `_Section` non-sliver di CustomScrollView (fix: return SliverToBoxAdapter). Verifikasi: `analyze` 0 issues, `test` 13/13, `build web` sukses, APK **20.0MB arm64**. Deviasi jujur dari mock: tanpa avatar profil/baterai/latensi-ms/nama scanlator (butuh plugin/data yang tak ada); brightness tetap overlay; unduh-batch = 5 terbaru (aman rate-limit).
**Fase 9 — Sumber Komiku ID — SELESAI (2026-09-05):** riset struktur (`api.komiku.org/manga/` HTML `.bge` 10/halaman + `?page=`/`genre`/`status`/`orderby=meta_value_num` + search `?post_type=manga&s=&tipe=manhwa`, detail `table.inftable` + `ul.genre` + `#daftarChapter`, chapter `#Baca_Komik img` + pola `/upload*` + fallback host `img.komiku.org`) — implementasi `KomikuApi` + `komiku_model.dart` + `KomikuRemoteDataSource` + `KomikuRepositoryImpl` (ID `k:`), migrasi DB v1→v2 (`source`), selektor sumber di Setelan (default Komiku), UI adaptif (order/tahun/tab bahasa disesuaikan per sumber), `AtHome` direct-URL. Temuan parser: selector `ul.genre a` tak match di package:html (pakai `ul.genre li a`); angka ID `1.6jt` = desimal (bukan ribuan). Verifikasi: `analyze` 0 issues, `test` 17/17 (baru: 4 test fixtures HTML asli), smoke live OK (trending/search/detail 70 ch/gambar 82).
**Fase 10 — UI Simpel & Responsif — SELESAI (2026-09-05):** sederhanakan Home (hapus spotlight + seksi rekomendasi ganda → cari + genre + lanjut-baca + grid update + status ringkas), Reader (controller bawah hanya progress + slider + prev/play/next; tile cepat + badge pindah ke sheet pengaturan; tambah toggle scroll-otomatis + kunci-portrait di sheet), hapus hint "Geser Bahasa", grid kolom adaptif (`coverColumns`: HP 2-3, tablet/landscape 4-6) di Home/Jelajah/Pustaka/skeleton. Verifikasi: `analyze` 0 issues, `test` 17/17, `build web` sukses (72s), APK **20.4MB arm64**. Catatan build: thread exhaustion bila RAM mepet — build satu per satu, jangan gabung web+apk.
**Fase 11 — Cover/Search/Progres — SELESAI (2026-09-05):** (1) Cover anti-crop: widget `CoverImage` (contain di atas blur-fill, tanpa potong wajah) dipakai semua kartu grid + hero Detail — menggantikan `BoxFit.cover` paksa; grid hasil pakai `MaxCrossAxisExtent` (responsif otomatis, bukan hitung kolom manual). (2) Search: riwayat query persisten (kolom `recentSearches`, migrasi v3, chips + hapus, simpan saat submit) + empty state sesuai sumber. (3) Progres: kartu Pustaka tampil "Terakhir Ch.X • Hal.p/q" dari riwayat; reader simpan posisi saat keluar (`dispose` + existing debounce) sehingga berhenti tengah chapter tetap tersimpan. Download di-deprioritaskan (kode tetap, tanpa pengembangan baru). Verifikasi: `analyze` 0 issues, `test` 19/19 (baru: merge/decode recent), `build web` sukses, APK **20.4MB arm64**.
**Fase 12 — Sinkron Lanjut-Baca + Riwayat Grup — SELESAI (2026-09-05):** laporan user — CTA Detail tidak sinkron dengan label Pustaka + riwayat duplikat per chapter. Perbaikan: (1) CTA "Lanjut Baca" memakai riwayat terakhir judul itu (`findContinueTarget`: belum-selesai → chapter itu persis; sudah-selesai → berikutnya yang belum dibaca; tanpa riwayat → belum-dibaca pertama) — sumber data SAMA dengan label "Terakhir Ch.X" di Pustaka sehingga mustahil beda; (2) layar Riwayat dikelompokkan 1 baris/judul (`groupHistoryByManga`, terbaru dulu) + hapus per judul (`deleteHistoryForManga`) + snackbar nama judul. Verifikasi: `analyze` 0 issues, `test` 21/21 (baru: 2 test sinkron).
**Fase 13 — Feed Chapter Terbaru — SELESAI (2026-09-05):** permintaan user — "manhwa yang update chapter-nya muncul di beranda". Implementasi: field entity `Manga.updateAgo` (diisi parser Komiku dari `.judul2`, mis. "18 menit lalu"; MangaDex null → "Baru diupdate") + seksi Update Beranda diubah dari grid cover menjadi feed baris kompak (`_FeedRow`: thumb 44x66 + judul + "Ch.X • waktu", ketuk → detail, tahan → quick actions, max 8). Refresh mengikuti pull-to-refresh Beranda (tanpa background fetch — bukan real-time; small print ini dijelaskan ke user). Verifikasi: `analyze` 0 issues, `test` 21/21 (assert `updateAgo` di fixtures).
**Fase 14 — Rating + Search Urut Rating — SELESAI (2026-09-05):** permintaan user — tampilkan rating + search kosong urut rating. Implementasi: subtitle kartu tampil sesuai data yang ada (MangaDex: "★ 8.7" dari skor bayesian; Komiku: "1.6jt pembaca" dari `followedCount`, format `formatCompactId`) + chip pembaca di Detail ikut format ID; default `MangaFilter.order` = `rating desc` sehingga Jelajah kosong langsung menampilkan semua dari rating tertinggi (MangaDex: skor; Komiku: `orderby=meta_value_num`/Peringkat); opsi urut per sumber (`searchOrdersFor`: Komiku hanya Rating + Terbaru, MangaDex 4 opsi). Verifikasi: `analyze` 0 issues, `test` 23/23.
**Fase 15 — Fix Search Ngeloop — SELESAI (2026-09-05):** laporan user — ketik "blood" (seharusnya ~10 hasil), scroll malah menambah judul yang SAMA terus. Akar masalah: endpoint search Komiku mengabaikan parameter `page` (halaman 2 = 10 item identik, terbukti via curl), sehingga infinite scroll append duplikat selamanya. Perbaikan 3 lapis: (1) `KomikuRepositoryImpl.search` → `hasMore=false` untuk title-search (browse list pagination-nya normal, tetap jalan); (2) `mergeSearchPage` (pure + unit test): buang duplikat per id saat gabung + setop bila halaman tak membawa item baru — jaring pengaman semua sumber; (3) footer "Semua hasil ditampilkan" di dasar hasil. Verifikasi: `analyze` 0 issues, `test` 24/24.
**Fase 16 — Fix Resume Halaman — SELESAI (2026-09-05):** laporan user — (1) notif "Lanjutkan halaman N?" tak jelas/mudah terlewat, (2) klik tidak melompat ke halaman itu. Akar masalah: snackbar 4-detik + `ensureVisible` gagal untuk halaman jauh yang widget-nya belum dibangun ListView. Perbaikan: banner kartu persisten ("Lanjutkan bacaan? Halaman X dari N", tombol Lanjutkan + Nanti, tidak hilang sendiri) + `_jumpTo` lompat proporsional via offset (`maxScroll * i/(N-1)`, selalu bisa) + simpan posisi. Verifikasi: `analyze` 0 issues, `test` 24/24.
**Fase 17 — Search Relevan + Cover — SELESAI (2026-09-05):** klarifikasi user — (1) tampilkan SEMUA hasil (10→10, 30→30), (2) keyword harus cocok kata di judul, (3) search kosong = semua urut pembaca terbanyak, (4) cover portrait tapi tidak over-zoom. Temuan riset: search Komiku ternyata paginasi via `paged` (bukan `page` — koreksi Fase 15 yang mengira tanpa pagination; terbukti halaman 2 beda isi), tapi mencocokkan sinopsis juga ("king" → "AKUJO RANKING", "Looking for..."). Perbaikan: `KomikuApi.searchPage` pakai `paged` (Fase 15 `hasMore=false` + dedupe tetap sebagai jaring pengaman) + `titleMatchesQuery` (semua kata ≥2 huruf harus muncul UTUH di judul, case-insensitive) + cover `MangaGridCard.aspectRatio` ikut sumber (Komiku 16:9 landscape asli, MangaDex 2:3) + grid aspect adaptif. Verifikasi: `analyze` 0 issues, `test` 25/25.
**Fase 18 — QA Audit + Laporan — SELESAI (2026-09-05):** permintaan user — audit QA profesional 27 jenis. Prinsip: hanya yang terbukti di app ini; fitur tak-ada (akun, komentar, admin, upload, backend, SEO) dinyatakan N/A jujur, bukan diuji palsu. Bukti baru tereksekusi: `test/qa_audit_test.dart` (timing nyata parse 7–173ms, tulis/baca 500 rows 21–109ms, scan 0 secrets/cleartext, 8 kontras WCAG lolos 3.17–14.38, roundtrip backup export→import + tolak file rusak) + `docs/QA_REPORT.md` (unit 31 test, integrasi, fungsional, black/white/gray box, UI/UX, usability+SUS siap jalan, kompatibilitas, DB, API-GET, OWASP mobile, perf, a11y, mobile, regresi, smoke, alpha/beta, 30 UAT, pentest klien, 5 bug fixed + 6 OPEN, skor **82/100** — layak pribadi, bukan store). Verifikasi: `analyze` 0 issues, `test` 31/31.
**Fase 19 — Tap Scroll + Speed — SELESAI (2026-09-05):** permintaan user — (1) ketuk halaman untuk scroll, (2) pengaturan kecepatan scroll-otomatis. Implementasi: zona ketuk mode vertikal (sepertiga atas = naik 0.85 layar, tengah = tampil/sembunyi UI, bawah = turun 0.85 layar, animasi 250ms; nonaktif bila toggle navigasi-ketuk mati) + kolom `app_settings.autoScrollSpeed` (migrasi v4, default 4.0 px/50ms) + slider 1–10 (Lambat/Sedang/Cepat) di sheet reader + provider + persist. Verifikasi: `analyze` 0 issues, `test` 31/31 (assert default seed).
**Fase 20 — Tema MangaIndo + Rebrand — SELESAI (2026-09-05):** permintaan user (contoh screenshot) — (1) UI sejenis MangaIndo yang rapi/user-friendly, (2) logo baru, (3) nama kembali "Baca Manhwa". Implementasi: tema light biru `#2F80D6` + AppBar biru + kartu putih + bottom-nav pil mengambang (aktif = pil biru berlabel); Home = carousel Popular 16:9 + dots (5 trending) + Lanjut Baca horizontal max 4 + Update Terbaru horizontal + status; search bar Jelajah biru; header logo `AppLogo` (kotak + buku + nama); logo launcher PNG digenerate via `tool/make_logo.dart` (encoder PNG murni, mipmap 48–192 + web icons + favicon); rename display (constants/manifest/judul/header/reader). Dark mode KuroYomi dipertahankan sebagai opsi. Verifikasi: `analyze` 0 issues, `test` 31/31 (widget test ikut gaya nav baru), `build web` + APK.
**Fase 21 — Panduan KuroYomi Setia — SELESAI (2026-09-05):** permintaan user — terapkan SEMUA aspek panduan dark + fitur tetap. Implementasi: (1) tema gelap default — seed `theme dark` + migrasi v5 (`UPDATE ... WHERE theme='system'`), AppBar gelap; terang biru tetap opsi; (2) nav fixed 5 label + badge (ganti pil mengambang Fase 20); (3) Home: search bar + tune, pill genre single-select, spotlight 16:10 (badge SPOTLIGHT#1 + rating + tags + CTA gradien→detail + bookmark), Lanjut Baca kartu progres guide + Semua Riwayat, grid Update 2 kolom (badge ID + Ch + waktu + stat rating/pembaca) + tombol muat + status; (4) Detail CTA gradien; (5) Reader: jam live HUD, tombol bookmark simpan posisi, milestone tiap 10 halaman; (6) Library sheet = Lanjutkan/Unduh-5/Favorit/Selesai/Hapus + `removeFromAll`. Nama tetap "Baca Manhwa". Verifikasi: `analyze` 0 issues, `test` 31/31, `build web` + APK.
**Fase 22 — 20 Update di Beranda — SELESAI (2026-09-05):** laporan user — Beranda cuma tampil ~10 (aneh, di search banyak). Akar: fetch `latestUpdates` limit 12 + grid dibatasi `clamp(0, 4)`. Perbaikan: limit 20 (Komiku = 2 halaman × 10; MangaDex 1 request) + grid tampil semua. Verifikasi: `analyze` 0 issues, `test` 31/31.
**Fase 23 — Infinite Scroll Beranda — SELESAI (2026-09-05):** permintaan user — "scroll mentok muncul lebih banyak". Implementasi: `latestUpdatesProvider` (sekali fetch) diganti `updatesProvider` (`UpdatesNotifier`: halaman 10 via `search` order terbaru + `loadMore` saat scroll <600px dari dasar + pull-refresh muat ulang + fallback cache offline di awal) + `mergeSearchPage` pindah ke shared providers (dipakai search juga). Stop otomatis bila halaman tak penuh / tak ada item baru (dedupe per id). Verifikasi: `analyze` 0 issues, `test` 31/31.

---

## 17. Lampiran — MangaDex API + Tokens

```js
// Endpoint (base https://api.mangadex.org)
GET /manga?title=&includedTags[]=&excludedTags[]=&status[]=&contentRating[]=&year=&order[rating]=desc&limit=20&offset=0&includes[]=cover_art
GET /manga/{id}?includes[]=cover_art&includes[]=author&includes[]=artist
GET /manga/{id}/feed?translatedLanguage[]=id&translatedLanguage[]=en&order[chapter]=asc&limit=100&offset=0
GET /at-home/server/{chapterId} -> { baseUrl, chapter: { hash, data[], dataSaver[] } }
cover: https://uploads.mangadex.org/covers/{mangaId}/{fileName}.256.jpg
page:  {baseUrl}/{data|dataSaver}/{hash}/{fileName}
```

Tokens warna awal (final di `app_colors.dart` Fase 1): `primary #6750A4`, `surface #F8F9FA`, `readerBlack #000000`, font Inter, grid 2:3 radius 12.

**Legal & etika (wajib):** pemakaian pribadi saja, bukan untuk distribusi/dijual; konten adalah hak cipta pemiliknya; MangaDex hanya mengindeks scanlation — patuhi ToS & docs (`https://api.mangadex.org/docs/`) termasuk attribution & rate limit; jangan hardcode credential; cantumkan atribusi MangaDex di halaman About.

---

## 18. Cara Pakai Dokumen Ini di Sesi Berikutnya

- Jangan ulang konteks — cukup rujuk `PRD.md` ini.
- Setiap perubahan spec update bagian terkait + bump `Versi app` di `pubspec.yaml:4`.
- **Wajib baca `AGENTS.md` — aturan update PRD tiap fase otomatis dibaca AI tiap sesi.**
- Urutan build terkunci: API service layer → Home → Search → Detail → Reader → Library → Settings (§16).
- Build command acuan:
  ```bash
  flutter pub get
  dart run build_runner build --delete-conflicting-outputs
  flutter analyze
  flutter test
  flutter run
  flutter build apk --release
  ```

---

## 19. Aturan Wajib AI — Update PRD Tiap Selesai Fase

> **PERINTAH MUTLAK UNTUK AI (Muse Spark / opencode):** Setiap selesai **SATU FASE** (Fase 0-23 di §16 Roadmap), AI **WAJIB** update `PRD.md` sebelum menyatakan fase selesai. **Dilarang skip. Dilarang klaim "fase selesai" tanpa PRD ter-update.**

### Trigger
- AI menilai deliverable `Fase N` tercapai, ATAU
- User mengetik: `fase selesai`, `selesai pase`, `lanjut fase`, `done`, `/finish-phase N`, `/update-prd`, atau `update PRD`

### Checklist Wajib (kerjakan berurutan — jangan klaim selesai sebelum tuntas)
1. **§14 Kriteria Penerimaan** — centang `[x]` item yang selesai; tambah `[ ]` baru jika ada scope baru
2. **§16 Roadmap** — tandai `Fase N — SELESAI (YYYY-MM-DD)` + 1-2 kalimat perubahan utama (file/tabel/provider/UI yang diubah)
3. **Bagian terkait** — sesuaikan `§5 Arsitektur`, `§7 Database`, `§8 Fitur Rinci`, `§13 Struktur Folder` jika ada perubahan file/tabel/provider/UI
4. **Header** — bump `Tanggal: YYYY-MM-DD` dan `Versi app` jika ubah `pubspec.yaml:4`
5. **Build check** — jalankan `flutter analyze` (harus clean) jika ada perubahan kode Dart
6. **Commit** — pesan `docs(prd): update PRD Fase N — <ringkasan 3-5 kata>`

### Definisi "Fase Selesai"
Fase dianggap selesai **hanya jika**: `PRD.md` sudah di-edit + checklist 1-6 tuntas + user konfirmasi. Tanpa update PRD, fase **belum selesai** — AI harus lanjutkan update.

### Jika AI Lupa
User cukup ketik `/finish-phase N` atau `/update-prd` atau ingatkan "update PRD" — AI harus langsung eksekusi checklist di atas tanpa debat. Lihat juga `AGENTS.md` §2.

---

*© Baca Manhwa Pribadi — PRD v1.0. Dibuat untuk pemakaian pribadi. Bahasa Indonesia, sumber MangaDex API, patuhi ToS & rate limit.*