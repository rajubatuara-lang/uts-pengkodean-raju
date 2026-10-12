CREATE TABLE chart_of_accounts (
    account_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_code VARCHAR(20) NOT NULL UNIQUE,
    account_name VARCHAR(100) NOT NULL,
    normal_balance VARCHAR(10) NOT NULL
        CHECK (normal_balance IN ('DEBIT', 'CREDIT')),
    report_classification VARCHAR(30) NOT NULL
);

CREATE TABLE journal_headers (
    journal_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    transaction_date DATE NOT NULL,
    reference_no VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    posting_status VARCHAR(10) NOT NULL DEFAULT 'DRAFT'
        CHECK (posting_status IN ('DRAFT', 'POSTED'))
);

CREATE TABLE journal_lines (
    line_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    journal_id BIGINT NOT NULL
        REFERENCES journal_headers(journal_id)
        ON DELETE RESTRICT,

    account_id BIGINT NOT NULL
        REFERENCES chart_of_accounts(account_id)
        ON DELETE RESTRICT,

    debit NUMERIC(15, 2) NOT NULL DEFAULT 0
        CHECK (debit >= 0),

    credit NUMERIC(15, 2) NOT NULL DEFAULT 0
        CHECK (credit >= 0),

    CHECK (debit > 0 OR credit > 0)
);

INSERT INTO chart_of_accounts
    (account_code, account_name, normal_balance, report_classification)
VALUES
    ('1101', 'Kas', 'DEBIT', 'ASET'),
    ('6101', 'Beban Listrik', 'DEBIT', 'BEBAN');

    INSERT INTO journal_headers
    (transaction_date, reference_no, description)
VALUES
    ('2026-10-19', 'KK-001', 'Pembayaran listrik')
RETURNING journal_id;

INSERT INTO journal_lines
    (journal_id, account_id, debit, credit)
VALUES
    (1, 2, 1000000, 0),
    (1, 1, 0, 1000000);

    INSERT INTO journal_lines
    (journal_id, account_id, debit, credit)
VALUES
    (1, 1, 0, 0);

    SELECT
    journal_id,
    SUM(debit) AS total_debit,
    SUM(credit) AS total_credit
FROM journal_lines
GROUP BY journal_id;