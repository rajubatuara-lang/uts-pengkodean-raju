# Hasil Pengujian Trigger Persediaan

## 1. Tujuan Pengujian

Pengujian ini dilakukan untuk memastikan bahwa trigger PostgreSQL pada tabel `inventory_transactions` dapat memperbarui jumlah persediaan secara otomatis berdasarkan jenis transaksi yang dilakukan.

Trigger harus memenuhi ketentuan berikut:

1. Transaksi `PURCHASE` menambah jumlah persediaan.
2. Transaksi `SALE` mengurangi jumlah persediaan.
3. Transaksi `ADJUSTMENT` menyesuaikan jumlah persediaan berdasarkan kuantitas yang dimasukkan.
4. Transaksi penjualan ditolak apabila jumlah persediaan tidak mencukupi.
5. Transaksi yang tidak valid dibatalkan dan tidak menyebabkan jumlah persediaan menjadi negatif.
6. Penguncian baris menggunakan `SELECT ... FOR UPDATE` membantu mencegah dua transaksi penjualan menggunakan stok yang sama secara bersamaan.

## 2. Lingkungan Pengujian

Pengujian dirancang menggunakan PostgreSQL dengan dua tabel:

- `inventory_items`: menyimpan data barang dan jumlah persediaan.
- `inventory_transactions`: menyimpan riwayat transaksi persediaan.

Trigger menggunakan fungsi `trg_update_stock_and_journal()` yang dijalankan ketika terdapat transaksi baru pada tabel `inventory_transactions`.

**Catatan:** Fungsi pada implementasi ini memperbarui stok persediaan. Pembuatan jurnal akuntansi dan perhitungan harga pokok penjualan belum dilakukan oleh fungsi tersebut.

## 3. Persiapan Data Pengujian

Sebelum pengujian, masukkan satu data barang dengan stok awal 10 unit.

```sql
INSERT INTO inventory_items (
    item_id,
    item_name,
    stock_qty,
    unit_cost
)
VALUES (
    'BRG001',
    'Buku Tulis',
    10,
    5000.00
)
ON CONFLICT (item_id)
DO UPDATE SET
    item_name = EXCLUDED.item_name,
    stock_qty = EXCLUDED.stock_qty,
    unit_cost = EXCLUDED.unit_cost;
```

Untuk memeriksa stok awal, jalankan:

```sql
SELECT *
FROM inventory_items
WHERE item_id = 'BRG001';
```

Hasil yang diharapkan adalah barang `BRG001` memiliki stok awal sebanyak 10 unit.

**Perhatian:** Perintah persiapan di atas mengatur ulang stok menjadi 10 unit. Gunakan hanya pada lingkungan pengujian, bukan pada database produksi yang berisi transaksi sebenarnya.

## 4. Skenario dan Hasil Pengujian

### Pengujian 1 — Pembelian Barang

**Tujuan:** Memastikan transaksi pembelian menambah stok.

Perintah SQL:

```sql
INSERT INTO inventory_transactions (
    item_id,
    trx_type,
    qty
)
VALUES (
    'BRG001',
    'PURCHASE',
    5
);
```

Hasil yang diharapkan:

- Transaksi berhasil disimpan.
- Stok bertambah dari 10 menjadi 15 unit.

Pemeriksaan:

```sql
SELECT item_id, stock_qty
FROM inventory_items
WHERE item_id = 'BRG001';
```

| Keterangan | Jumlah |
|---|---:|
| Stok awal | 10 |
| Pembelian | +5 |
| Stok akhir yang diharapkan | 15 |

**Status:** Lulus apabila stok akhir menjadi 15 unit.

### Pengujian 2 — Penjualan Barang

**Tujuan:** Memastikan transaksi penjualan mengurangi stok.

Dengan stok awal 15 unit setelah Pengujian 1, jalankan:

```sql
INSERT INTO inventory_transactions (
    item_id,
    trx_type,
    qty
)
VALUES (
    'BRG001',
    'SALE',
    4
);
```

Hasil yang diharapkan:

- Transaksi berhasil disimpan.
- Stok berkurang dari 15 menjadi 11 unit.

| Keterangan | Jumlah |
|---|---:|
| Stok sebelum penjualan | 15 |
| Penjualan | -4 |
| Stok akhir yang diharapkan | 11 |

**Status:** Lulus apabila stok akhir menjadi 11 unit.

### Pengujian 3 — Penjualan Melebihi Stok

**Tujuan:** Memastikan sistem menolak transaksi penjualan yang melebihi persediaan.

Dengan stok 11 unit, jalankan:

```sql
INSERT INTO inventory_transactions (
    item_id,
    trx_type,
    qty
)
VALUES (
    'BRG001',
    'SALE',
    20
);
```

Hasil yang diharapkan:

- Database menampilkan pesan kesalahan `Stok tidak mencukupi`.
- Transaksi penjualan dibatalkan.
- Stok tetap 11 unit.

Pemeriksaan:

```sql
SELECT item_id, stock_qty
FROM inventory_items
WHERE item_id = 'BRG001';
```

**Status:** Lulus apabila transaksi ditolak dan stok tetap 11 unit.

### Pengujian 4 — Kuantitas Nol

**Tujuan:** Memastikan transaksi dengan kuantitas nol ditolak.

```sql
INSERT INTO inventory_transactions (
    item_id,
    trx_type,
    qty
)
VALUES (
    'BRG001',
    'PURCHASE',
    0
);
```

Hasil yang diharapkan:

- Database menampilkan pesan kesalahan `Kuantitas tidak boleh nol`.
- Transaksi tidak disimpan.
- Stok tidak berubah.

**Status:** Lulus apabila transaksi ditolak.

### Pengujian 5 — Kuantitas Negatif pada Pembelian

**Tujuan:** Memastikan transaksi pembelian tidak menggunakan kuantitas negatif.

```sql
INSERT INTO inventory_transactions (
    item_id,
    trx_type,
    qty
)
VALUES (
    'BRG001',
    'PURCHASE',
    -3
);
```

Hasil yang diharapkan:

- Database menampilkan pesan kesalahan `Kuantitas pembelian harus positif`.
- Transaksi dibatalkan.
- Stok tidak berubah.

**Status:** Lulus apabila transaksi ditolak.

### Pengujian 6 — Penyesuaian Stok

**Tujuan:** Memastikan transaksi `ADJUSTMENT` dapat menambah atau mengurangi stok sesuai kuantitas bertanda.

Contoh penambahan stok sebanyak 2 unit:

```sql
INSERT INTO inventory_transactions (
    item_id,
    trx_type,
    qty
)
VALUES (
    'BRG001',
    'ADJUSTMENT',
    2
);
```

Hasil yang diharapkan jika stok sebelumnya 11 unit:

| Keterangan | Jumlah |
|---|---:|
| Stok sebelum penyesuaian | 11 |
| Penyesuaian | +2 |
| Stok akhir yang diharapkan | 13 |

Untuk menguji penyesuaian yang menyebabkan stok negatif, gunakan kuantitas negatif yang lebih besar daripada stok saat itu. Misalnya, jika stok 13 unit:

```sql
INSERT INTO inventory_transactions (
    item_id,
    trx_type,
    qty
)
VALUES (
    'BRG001',
    'ADJUSTMENT',
    -20
);
```

Hasil yang diharapkan:

- Database menampilkan pesan kesalahan `Penyesuaian menyebabkan stok negatif`.
- Transaksi dibatalkan.
- Stok tetap 13 unit.

**Status:** Lulus apabila penyesuaian yang valid mengubah stok dengan benar dan penyesuaian yang menghasilkan stok negatif ditolak.

## 5. Pengujian Konkurensi Dua Kasir

### Skenario

Misalnya, stok sebuah barang hanya tersisa 1 unit. Pada waktu yang hampir bersamaan, Kasir A dan Kasir B masing-masing mencoba menjual 1 unit.

Jika sistem tidak mengunci baris persediaan, kedua transaksi dapat membaca stok awal yang sama. Hal ini berpotensi menyebabkan penjualan melebihi stok atau hasil persediaan yang tidak konsisten.

### Mekanisme Pencegahan

Fungsi trigger menggunakan:

```sql
SELECT stock_qty
INTO v_stock
FROM inventory_items
WHERE item_id = NEW.item_id
FOR UPDATE;
```

`FOR UPDATE` mengunci baris barang yang sedang diproses sampai transaksi database selesai. Transaksi lain yang mencoba mengunci baris yang sama harus menunggu.

### Hasil yang Diharapkan

1. Kasir A dan Kasir B mencoba menjual masing-masing 1 unit.
2. Salah satu transaksi memperoleh kunci terlebih dahulu.
3. Transaksi pertama berhasil dan stok berubah dari 1 menjadi 0.
4. Transaksi kedua melanjutkan setelah kunci dilepas, membaca stok terbaru, lalu ditolak karena stok tidak mencukupi.
5. Stok akhir tetap 0, bukan negatif.

**Status:** Lulus apabila hanya satu penjualan berhasil dan stok akhir tidak kurang dari nol.

Pengujian ini perlu dilakukan dengan dua sesi koneksi PostgreSQL secara bersamaan untuk membuktikan perilaku konkurensi secara langsung.

## 6. Ringkasan Pengujian

| No. | Skenario | Hasil yang Diharapkan |
|---:|---|---|
| 1 | Pembelian barang | Stok bertambah |
| 2 | Penjualan barang | Stok berkurang |
| 3 | Penjualan melebihi stok | Transaksi ditolak |
| 4 | Kuantitas nol | Transaksi ditolak |
| 5 | Kuantitas pembelian negatif | Transaksi ditolak |
| 6 | Penyesuaian stok valid | Stok disesuaikan |
| 7 | Penyesuaian menyebabkan stok negatif | Transaksi ditolak |
| 8 | Dua kasir menjual stok terakhir | Maksimal satu transaksi berhasil |

**Catatan hasil:** Tabel di atas berisi hasil yang diharapkan berdasarkan rancangan trigger, bukan hasil eksekusi aktual. Kolom status pengujian baru boleh dinyatakan *Lulus* setelah setiap skenario benar-benar dijalankan dan hasilnya sesuai.

## 7. Kesimpulan

Trigger persediaan berfungsi untuk menjaga konsistensi jumlah stok dengan memperbarui `stock_qty` secara otomatis ketika transaksi pembelian, penjualan, atau penyesuaian dimasukkan. Validasi kuantitas dan pemeriksaan ketersediaan stok mencegah transaksi yang tidak valid.

Penggunaan `SELECT ... FOR UPDATE` membantu mengatasi masalah konkurensi ketika beberapa kasir memproses barang yang sama secara bersamaan. Namun, seluruh skenario tetap perlu diuji pada database PostgreSQL untuk memastikan implementasi aktual sesuai dengan hasil yang diharapkan.
