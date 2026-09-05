# AGENTS.md — Aturan Project Baca Manhwa Pribadi

> Dokumen ini otomatis dibaca AI (Muse Spark / opencode) tiap sesi. Jangan hapus.

## 1. Konteks Wajib Baca

- **Single source of truth:** `PRD.md` — baca sebelum mulai fase apapun.
- **Lokasi proyek:** `E:\Mobile\baca manhwa`
- **Versi app:** `pubspec.yaml:19` (`1.0.0+1`), SDK `^3.12.2` (Flutter 3.44.4 / Dart 3.12.2)
- **Stack terkunci:** Flutter Material 3 + Riverpod + dio (MangaDex API) + Drift 6 tabel + cached_network_image + photo_view + go_router 5 tab — lihat `PRD.md` §4
- **DB:** `lib/core/database/app_database.dart:14-26` (`baca_manhwa.db`, FK ON)
- **Bahasa & locale:** Indonesia, locale `id_ID` — `lib/main.dart:8`; bahasa konten chapter default ID fallback EN
- **Urutan build terkunci:** API service layer → Home → Search → Detail → Reader → Library → Settings — `PRD.md` §16
- **Legal:** pemakaian pribadi saja, patuhi ToS & rate limit MangaDex, tanpa credential hardcode — `PRD.md` §17

## 2. ATURAN MUTLAK: Wajib Update PRD.md Tiap Selesai Fase

> **PERINTAH MUTLAK UNTUK AI:** Setiap selesai SATU FASE (Fase 0-25 di `PRD.md` §16 Roadmap), AI **WAJIB** update `PRD.md` sebelum menyatakan fase selesai. **Dilarang skip.**

### Trigger
- Selesai Fase N (sesuai Roadmap §16)
- User bilang: "fase selesai", "lanjut fase", "done", "selesai pase", atau AI sendiri menilai deliverable fase tercapai

### Checklist Wajib (kerjakan berurutan, jangan klaim selesai sebelum ini tuntas)
1. **§14 Kriteria Penerimaan** — centang `[x]` item yang selesai, tambah `[ ]` baru jika ada scope baru
2. **§16 Roadmap** — tandai `Fase N — SELESAI (YYYY-MM-DD)` + 1-2 kalimat perubahan utama
3. **Bagian terkait** — sesuaikan `§5 Arsitektur`, `§7 Database`, `§8 Fitur Rinci`, `§13 Struktur Folder` jika ada perubahan file/tabel/provider/UI
4. **Header** — bump `Tanggal: YYYY-MM-DD` dan `Versi app` jika ubah `pubspec.yaml:4`
5. **Build check** — `flutter analyze` harus clean (jika ubah kode Dart)
6. **Commit message** — `docs(prd): update PRD Fase N — <ringkasan 3-5 kata>`

### Definisi "Fase Selesai"
Fase dianggap selesai **hanya jika** `PRD.md` sudah di-edit + checklist di atas tuntas + user konfirmasi. Tanpa update PRD, fase belum selesai.

### Jika AI Lupa
User cukup ketik `/finish-phase N` atau `/update-prd` atau ingatkan "update PRD" — AI harus langsung eksekusi checklist di atas. Lihat juga `PRD.md` §19.

## 3. Perintah Build Acuan

```bash
flutter pub get
dart run build_runner build
flutter analyze
flutter test
flutter run
flutter build apk --release
```

## 4. Gaya Kerja

- Bahasa: Indonesia
- Online-first + cache agresif (hormati rate limit MangaDex: throttle 5 rps, debounce search 500ms, TTL cache 24 jam), fitur lokal 100% offline
- Material 3, `google_fonts` Inter, warna di `lib/core/theme/app_colors.dart:5-58`, grid cover 2:3
- Selalu rujuk file dengan format `path:line_number` saat menyebut kode
- Verifikasi via eksekusi, bukan asumsi; error view informatif (offline / 429 / 5xx + retry)
- Gambar chapter selalu via `GET /at-home/server/{id}` — jangan hardcode URL halaman
