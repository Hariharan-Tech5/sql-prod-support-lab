CREATE TABLE payment_transactions (
    txn_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL, -- 'SUCCESS', 'FAILED', 'PENDING'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserting normal, duplicate, and stuck transactions
INSERT INTO payment_transactions (txn_id, order_id, customer_id, amount, status, created_at) VALUES
('TXN-101', 'ORD-5001', 'CUST-01', 1500.00, 'SUCCESS', '2026-11-11 09:00:00'),
('TXN-102', 'ORD-5002', 'CUST-02', 2500.00, 'SUCCESS', '2026-11-11 09:05:00'),
('TXN-103', 'ORD-5002', 'CUST-02', 2500.00, 'SUCCESS', '2026-11-11 09:05:03'), -- Duplicate charge!
('TXN-104', 'ORD-5003', 'CUST-03', 4200.00, 'PENDING', '2026-11-11 08:15:00'), -- Stuck > 1 hour!
('TXN-105', 'ORD-5004', 'CUST-04', 900.00,  'FAILED',  '2026-11-11 09:20:00');
