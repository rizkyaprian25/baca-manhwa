---
description: Tandai Fase N selesai dan wajib update PRD.md (§14, §16, header) sesuai AGENTS.md & PRD §19
agent: build
---

Kamu baru menyelesaikan **Fase $ARGUMENTS** (Roadmap `PRD.md` §16, Fase 0-7).

**PERINTAH MUTLAK — jangan klaim fase selesai sebelum ini tuntas:**

1. Baca `PRD.md` §14 Kriteria Penerimaan, §16 Roadmap, dan `AGENTS.md` §2 + `PRD.md` §19.
2. Update `PRD.md` berurutan:
   - §14: centang `[x]` item yang selesai, tambah `[ ]` baru jika ada scope baru
   - §16: tandai `Fase $ARGUMENTS — SELESAI (YYYY-MM-DD)` + 1-2 kalimat perubahan utama (file/tabel/provider/UI)
   - §5/§7/§8/§13: sesuaikan jika ada perubahan arsitektur/DB/fitur/folder
   - Header: bump `Tanggal: YYYY-MM-DD` dan `Versi app` jika ubah `pubspec.yaml:4`
3. Jika ubah kode Dart: jalankan `flutter analyze` (harus clean).
4. Buat ringkasan 3-5 kata untuk commit `docs(prd): update PRD Fase $ARGUMENTS — <ringkasan>` dan minta konfirmasi user.
5. Ingatkan: tanpa update PRD.md, fase BELUM selesai.

Argumen: $ARGUMENTS. Jika kosong, tanyakan Fase berapa (0-7) lalu lanjutkan.
