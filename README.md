# UTS Pengkodean — Raju Batuara

Repository ini berisi jawaban UTS Mata Kuliah Pengkodean.

## 🚀 Jalankan Sistem

**[▶ Buka Sistem Voucher Kas Keluar](https://rajubatuara-lang.github.io/uts-pengkodean-raju/soal_3/)**

> Sistem terhubung ke Supabase. Data voucher yang diisi akan tersimpan ke database secara langsung.

---

## Struktur Repository

### Soal 1 — Desain Database General Ledger
- [`soal_1/schema.sql`](soal_1/schema.sql) — Skema tabel beserta constraint dan contoh data
- [`soal_1/analisis.md`](soal_1/analisis.md) — Analisis desain, normalisasi 3NF, dan audit trail

### Soal 2 — Inventory Trigger
- [`soal_2/inventory_trigger.sql`](soal_2/inventory_trigger.sql) — Trigger SQL untuk manajemen stok
- [`soal_2/hasil_pengujian.md`](soal_2/hasil_pengujian.md) — Hasil pengujian trigger

### Soal 3 — Voucher Entri Transaksi Kas Keluar
- [`soal_3/index.html`](soal_3/index.html) — Antarmuka sistem voucher (HTML + Tailwind + Supabase)
- [`soal_3/backend/voucher.sql`](soal_3/backend/voucher.sql) — Skema tabel Supabase
- [`soal_3/prompt_gemini.md`](soal_3/prompt_gemini.md) — Dokumentasi penggunaan Gemini Canvas
- [`soal_3/prompt_notebooklm.md`](soal_3/prompt_notebooklm.md) — Dokumentasi penggunaan NotebookLM
- [`soal_3/verifikasi_notebooklm.md`](soal_3/verifikasi_notebooklm.md) — Verifikasi hasil NotebookLM
- [`soal_3/audit_trail.md`](soal_3/audit_trail.md) — Analisis audit trail sistem

---

&copy; 2026 Raju Batuara — Universitas Diponegoro
