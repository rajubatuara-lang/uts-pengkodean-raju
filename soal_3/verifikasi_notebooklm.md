Hasil verifikasi aturan bisnis untuk prototipe **Sistem Voucher Entri Transaksi Kas Keluar** berdasarkan sumber standar akuntansi dan literatur yang tersedia di notebook ini disajikan di bawah ini.

---

### **Tabel Verifikasi Aturan Bisnis Prototipe**

| Aturan Bisnis Prototipe | Hasil Verifikasi | Dasar Sumber (Judul & Bagian) | Klasifikasi Ketentuan | Tindakan Perbaikan Rancangan Aplikasi |
| :--- | :--- | :--- | :--- | :--- |
| **1. Ketersediaan Bukti & Keterangan Memadai**<br>*Setiap transaksi harus memiliki bukti dan keterangan yang memadai.* | **Didukung Penuh** | • *Laporan Riset: Standar Akuntansi & Verifikasi Voucher Kas Keluar* (Buku Teks & Modul Akuntansi)<br>• *Sistem Akuntansi (Mulyadi, Salemba Empat)* (Bab Sistem Pengeluaran Kas & Sistem Voucher)<br>• *Modul CAFB - Akuntansi Keuangan (IAI)* (Bab Bukti Transaksi) | **Kombinasi**:<br>• *Standar Akuntansi*: Prinsip keandalan & verifikabilitas bukti transaksi.<br>• *Kontrol Internal*: Prosedur otorisasi & verifikasi kelengkapan dokumen. | Wajibkan kolom **Keterangan/Deskripsi** serta input **Nomor Dokumen Pendukung** (faktur/kuitansi) sebagai *field mandatory* sebelum voucher dapat disimpan. |
| **2. Keseimbangan Debit & Kredit**<br>*Total debit harus sama dengan total kredit sebelum jurnal diposting.* | **Didukung Penuh** | • *Modul CAFB - Akuntansi Keuangan (IAI)* (Bab Persamaan Dasar Akuntansi & Aturan Debit-Kredit)<br>• *Laporan Riset* (Bagian Sistem Pencatatan Debit dan Kredit) | **Kombinasi**:<br>• *Standar Akuntansi*: Prinsip pembukuan berpasangan (*double-entry system*).<br>• *Kontrol Internal*: Validasi input *pre-posting* pada aplikasi. | Tambahkan **validasi otomatis (*hard check*)** yang mengunci tombol *posting* jika selisih `Total Debit - Total Kredit != 0`, dilengkapi indikator status *balance* secara *realtime*. |
| **3. Pencatatan Beban Listrik**<br>*Pembayaran beban listrik dicatat dengan mendebit Beban Listrik dan mengkredit Kas (jika beban telah terjadi).* | **Didukung Penuh** | • *PSAK 201: Penyajian Laporan Keuangan* (Paragraf Pengakuan Beban & Prinsip Akrual)<br>• *PSAK 207: Laporan Arus Kas* (Paragraf Definisi Kas & Setara Kas)<br>• *Modul CAFB* (Bab Aturan Debit-Kredit) | **Kombinasi**:<br>• *Standar Akuntansi*: Beban diakui saat terjadi penurunan manfaat ekonomi (PSAK 201) dan kas berkurang pada posisi Kredit (PSAK 207).<br>• *Kontrol Internal*: Pemetaan *Chart of Accounts* (CoA). | Sediakan **fitur *template* entri transaksi rutin** (prapemetaan Debit: Beban Listrik, Kredit: Kas/Bank) untuk meminimalkan risiko salah pilih akun oleh pengguna. |
| **4. Larangan Edit/Delete Transaksi Terposting**<br>*Transaksi yang sudah diposting tidak boleh diedit/dihapus langsung; koreksi via jurnal pembalik.* | **Tidak Dapat Dipastikan dari PSAK** *(Didukung Kontrol Internal IT & Prinsip Koreksi Retrospektif)* | • *PSAK 201: Penyajian Laporan Keuangan* (Paragraf 40A–40D / Penyajian Kembali Retrospektif)<br>• *Rincian teknis larangan edit/delete aplikasi tidak diatur dalam teks PSAK/Modul di notebook*. | **Kontrol Internal Aplikasi (IT Application Control)**:<br>Penguncian data terposting untuk menjaga integritas *General Ledger* dan keterlacakan audit (*audit trail*). | Terapkan **penguncian status (*status locking*)** pada jurnal `POSTED`. Sediakan modul khusus **Jurnal Pembalik / *Adjustment Voucher*** yang terhubung ke nomor voucher asli. |
| **5. Pemeliharaan Log Audit & Riwayat**<br>*Informasi pembuat, waktu pencatatan, dan riwayat aktivitas dipelihara untuk audit.* | **Tidak Dapat Dipastikan dari PSAK** *(Didukung Kontrol Internal & Otorisasi Sistem)* | • *Laporan Riset* (Sistem Akuntansi Mulyadi - Fungsi Otorisasi & Register Voucher)<br>• *Spesifikasi log audit IT tidak diatur dalam standar akuntansi PSAK yang tersedia*. | **Kontrol Internal IT (IT General Control / Audit Trail)**:<br>Mekanisme penjaminan akuntabilitas entri data dan transparansi operasional sistem. | Buat tabel **_Audit Log_ otomatis** di tingkat basis data yang mencatat `user_id`, `timestamp`, `action_type` (create/approve/reverse), dan `IP_address` pada setiap transaksi. |

---

### **Pembedaan Ketentuan Akuntansi vs. Kontrol Internal Aplikasi**

1. **Ketentuan Standar Akuntansi (PSAK / SAK)**
   * Berfokus pada **kriteria pengakuan, pengukuran, dan penyajian laporan keuangan** agar menghasilkan informasi keuangan yang relevan dan andal. Contohnya: pengakuan beban berdasarkan dasar akrual (PSAK 201), definisi kas/setara kas (PSAK 207), serta keseimbangan persamaan dasar akuntansi melalui sistem *double-entry*.
2. **Kontrol Internal Aplikasi (IT Application & General Controls)**
   * Berfokus pada **tata kelola teknis perangkat lunak dan pencegahan kesalahan operasional**. Contohnya: penguncian transaksi yang telah diposting (*status locking*), mekanisme *audit trail/timestamp*, validasi *pre-posting*, serta pemisahan otorisasi pengguna.

---

### **Rekomendasi Perbaikan Rancangan Prototipe**

1. **Alur Kerja Otorisasi & Verifikasi Berjenjang (*Approval Workflow*)**:
   * Terapkan pemisahan peran (*segregation of duties*) antara pembuat entri (*Maker*), verifikator dokumen (*Checker*), dan penyetujui pembayaran (*Approver*) sesuai dengan prinsip sistem voucher kas keluar.
2. **Penguncian Data Terisolasi (*Immutable Posting*)**:
   * Pastikan transaksi bertanda `POSTED` secara teknis tidak dapat diubah melalui query `UPDATE` atau `DELETE` biasa pada basis data, melainkan hanya dapat disesuaikan melalui modul *Reversal Journal* berdokumen.
3. **Penyimpanan Dokumen Digital (*Digital Attachment*)**:
   * Tambahkan modul *file attachment* agar bukti transaksi fisik (seperti pemindaian kuitansi atau faktur tagihan listrik) terhubung langsung dengan nomor voucher kas keluar terkait guna memudahkan proses audit.

---
