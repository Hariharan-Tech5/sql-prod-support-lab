-- =========================================================================
-- INCIDENT 1: Customer charged twice for the same Order ID (Network Retry)
-- Goal: Identify duplicate rows using ROW_NUMBER() and mark extras for refund
-- =========================================================================

WITH DuplicateCheck AS (
    SELECT 
        txn_id,
        order_id,
        amount,
        created_at,
        ROW_NUMBER() OVER (PARTITION BY order_id, amount ORDER BY created_at ASC) AS row_num
    FROM payment_transactions
    WHERE status = 'SUCCESS'
)
SELECT * FROM DuplicateCheck WHERE row_num > 1;

-- Safe Production Fix using Transaction Control
BEGIN;

UPDATE payment_transactions
SET status = 'REFUND_QUEUED'
WHERE txn_id IN (
    SELECT txn_id FROM (
        SELECT txn_id,
               ROW_NUMBER() OVER (PARTITION BY order_id, amount ORDER BY created_at ASC) AS rn
        FROM payment_transactions
        WHERE status = 'SUCCESS'
    ) sub
    WHERE rn > 1
);

-- Always verify exact row count before committing!
SELECT * FROM payment_transactions WHERE status = 'REFUND_QUEUED';
COMMIT; -- Or ROLLBACK; if row count looks wrong


-- =========================================================================
-- INCIDENT 2: Nightly Batch Job missed transactions stuck in 'PENDING'
-- Goal: Find transactions stuck in PENDING for more than 30 minutes
-- =========================================================================

SELECT txn_id, order_id, customer_id, amount, created_at
FROM payment_transactions
WHERE status = 'PENDING'
  AND created_at < NOW() - INTERVAL '30 minutes';


-- =========================================================================
-- INCIDENT 3: Slow Reporting Query Causing Table Locks
-- Goal: Add composite index on frequently filtered columns (status + created_at)
-- =========================================================================

CREATE INDEX idx_txn_status_created ON payment_transactions (status, created_at);
