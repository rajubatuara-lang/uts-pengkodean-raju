-- ============================================================
-- Schema: Voucher Kas Keluar
-- Jalankan script ini di Supabase SQL Editor
-- ============================================================

-- Tabel header voucher
CREATE TABLE IF NOT EXISTS voucher_headers (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    voucher_no  VARCHAR(50)  NOT NULL UNIQUE,
    trans_date  DATE         NOT NULL,
    description TEXT         NOT NULL,
    total_amount NUMERIC(15,2) NOT NULL DEFAULT 0,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW()
);

-- Tabel baris jurnal (detail)
CREATE TABLE IF NOT EXISTS voucher_lines (
    id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    voucher_id  BIGINT       NOT NULL
                    REFERENCES voucher_headers(id)
                    ON DELETE CASCADE,
    account_id  VARCHAR(20)  NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    debit       NUMERIC(15,2) NOT NULL DEFAULT 0 CHECK (debit >= 0),
    credit      NUMERIC(15,2) NOT NULL DEFAULT 0 CHECK (credit >= 0),
    CHECK (debit > 0 OR credit > 0)
);

-- Aktifkan Row Level Security
ALTER TABLE voucher_headers ENABLE ROW LEVEL SECURITY;
ALTER TABLE voucher_lines   ENABLE ROW LEVEL SECURITY;

-- Policy: izinkan semua operasi dari anon key (untuk purwarupa)
CREATE POLICY "Allow all for anon" ON voucher_headers
    FOR ALL TO anon USING (true) WITH CHECK (true);

CREATE POLICY "Allow all for anon" ON voucher_lines
    FOR ALL TO anon USING (true) WITH CHECK (true);
