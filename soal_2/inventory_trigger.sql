CREATE OR REPLACE FUNCTION trg_update_stock_and_journal()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INT;
BEGIN
    IF NEW.qty = 0 THEN
        RAISE EXCEPTION 'Kuantitas tidak boleh nol';
    END IF;

    SELECT stock_qty
    INTO v_stock
    FROM inventory_items
    WHERE item_id = NEW.item_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Barang tidak ditemukan';
    END IF;

    IF NEW.trx_type = 'PURCHASE' THEN

        IF NEW.qty < 0 THEN
            RAISE EXCEPTION
                'Kuantitas pembelian harus positif';
        END IF;

        UPDATE inventory_items
        SET stock_qty = stock_qty + NEW.qty
        WHERE item_id = NEW.item_id;

    ELSIF NEW.trx_type = 'SALE' THEN

        IF NEW.qty < 0 THEN
            RAISE EXCEPTION
                'Kuantitas penjualan harus positif';
        END IF;

        IF v_stock < NEW.qty THEN
            RAISE EXCEPTION
                'Stok tidak mencukupi';
        END IF;

        UPDATE inventory_items
        SET stock_qty = stock_qty - NEW.qty
        WHERE item_id = NEW.item_id;

    ELSIF NEW.trx_type = 'ADJUSTMENT' THEN

        UPDATE inventory_items
        SET stock_qty = stock_qty + NEW.qty
        WHERE item_id = NEW.item_id
          AND stock_qty + NEW.qty >= 0;

        IF NOT FOUND THEN
            RAISE EXCEPTION
                'Penyesuaian menyebabkan stok negatif';
        END IF;

    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER inventory_stock_trigger
BEFORE INSERT ON inventory_transactions
FOR EACH ROW
EXECUTE FUNCTION trg_update_stock_and_journal();

INSERT INTO inventory_transactions
    (item_id, trx_type, qty)
VALUES
    ('BRG001', 'PURCHASE', 5);

    SELECT item_id, item_name, stock_qty
FROM inventory_items
WHERE item_id = 'BRG001';

INSERT INTO inventory_transactions
    (item_id, trx_type, qty)
VALUES
    ('BRG001', 'SALE', 3);

    INSERT INTO inventory_transactions
    (item_id, trx_type, qty)
VALUES
    ('BRG001', 'SALE', 100);