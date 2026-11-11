# SQL Production Support & Data Recovery Lab

## Overview
Simulated FinTech payment database scenarios demonstrating safe production data remediation, duplicate record cleanup, and query performance optimization.

## Scenarios Covered
1. **Duplicate Payment Remediation:** Isolated double-charged orders caused by gateway retries using `CTE`s and `ROW_NUMBER()`. Executed safe updates wrapped inside `BEGIN...COMMIT/ROLLBACK` transaction blocks.
2. **Stuck Batch Detection:** Identified transactions stuck in `PENDING` state beyond the 30-minute SLA threshold for manual intervention.
3. **Query Performance Tuning:** Resolved slow reporting queries and table locking using composite indexing (`idx_txn_status_created`).
