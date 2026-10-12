# Dokumentasi Gemini Canvas

## Tujuan
Gemini Canvas digunakan untuk membantu membuat prototipe antarmuka Voucher Entri Transaksi Kas Keluar.

## Prompt yang Digunakan
Buat purwarupa website Sistem Voucher Entri Transaksi Kas Keluar untuk perusahaan. Gunakan HTML, CSS, dan JavaScript dengan tampilan profesional, bersih, responsif, dan cocok untuk sistem akuntansi.
Fitur yang wajib tersedia:
1. Form nomor voucher, tanggal transaksi, dan keterangan.
2. Tabel jurnal dinamis dengan kolom akun, debit, dan kredit.
3. Tombol tambah baris dan hapus baris jurnal.
4. Kalkulasi total debit dan total kredit secara otomatis ketika pengguna mengubah nominal.
5. Indikator status Balanced jika total debit sama dengan total kredit, dan Unbalanced jika berbeda.
6. Tombol Submit hanya aktif jika data wajib terisi, nominal valid, terdapat baris jurnal, dan total debit sama dengan total kredit.
7. Pisahkan kode menjadi index.html, style.css, dan app.js.
8. Tambahkan contoh jurnal pembayaran kas keluar.
9. Berikan validasi yang jelas dan mudah dipahami pengguna.
Jangan mengklaim bahwa aplikasi sudah terhubung ke database jika integrasi backend belum dibuat. Tampilkan kode lengkap untuk ketiga file tersebut.

## Hasil yang Dihasilkan
Gemini menghasilkan prototipe yang terdiri atas:
- Form informasi voucher.
- Tabel detail jurnal yang dinamis.
- Perhitungan total debit dan kredit.
- Indikator keseimbangan jurnal.
- Validasi tombol Submit.

## Pemeriksaan Hasil
Kode hasil AI diperiksa kembali untuk memastikan bahwa:
1. Total debit dan kredit dihitung dengan benar.
2. Tombol Submit tidak aktif ketika jurnal belum seimbang.
3. Pengguna memperoleh pesan kesalahan yang jelas.
4. Data yang belum disimpan ke database tidak ditampilkan sebagai transaksi yang berhasil disimpan.

## Catatan
Kode yang dihasilkan AI merupakan prototipe awal dan tetap perlu diuji serta disesuaikan sebelum digunakan bersama database.
