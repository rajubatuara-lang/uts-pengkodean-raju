# Audit Trail Sistem Voucher Kas Keluar

## 1. Tujuan Audit Trail

Audit trail digunakan untuk mendukung penelusuran transaksi, mengetahui siapa yang membuat voucher, kapan voucher dibuat, dan bagaimana aktivitas transaksi dicatat.

## 2. Atribut Audit Trail

### created_by
Menyimpan identitas pengguna yang membuat voucher. Identitas ini sebaiknya berasal dari pengguna yang telah terautentikasi, bukan dari nilai bebas yang dikirimkan browser.

### created_at
Mencatat waktu pembuatan voucher. Kolom ini menggunakan tipe `TIMESTAMPTZ` dan nilai default waktu database.

### hash_checksum
Menyimpan nilai checksum dari representasi data voucher untuk membantu mendeteksi perubahan terhadap data yang diperiksa. Data yang digunakan untuk membuat checksum harus ditentukan secara konsisten.

Checksum biasa tidak otomatis mencegah perubahan data. Untuk kontrol yang lebih kuat, sistem perlu melindungi checksum, mengendalikan akses, dan mencatat perubahan dalam audit log yang tidak mudah dimanipulasi.

## 3. Perlindungan Voucher POSTED

Voucher yang telah berstatus POSTED tidak boleh diubah atau dihapus melalui alur transaksi normal. Jika ditemukan kesalahan, sistem menyediakan proses jurnal pembalik atau koreksi yang dapat ditelusuri.

Perlindungan harus diterapkan terhadap header dan detail jurnal, serta didukung oleh pembatasan hak akses database.

## 4. Data Audit yang Dicatat

Informasi audit yang dapat dicatat antara lain:
- Nomor voucher.
- Pengguna yang melakukan aktivitas.
- Waktu aktivitas.
- Jenis aktivitas, misalnya CREATE, POST, atau REVERSE.
- Referensi voucher asal untuk transaksi pembalik.
- Alasan koreksi apabila ada.

## 5. Kesimpulan

Audit trail membantu menjaga keterlacakan dan akuntabilitas transaksi. Implementasi yang baik memerlukan kombinasi pencatatan aktivitas, pembatasan hak akses, validasi database, dan prosedur koreksi yang terdokumentasi.
