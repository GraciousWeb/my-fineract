#  Customer Product Listing with Transaction History
SELECT
    c.id AS Client_ID,
    c.display_name AS Client_Name,
    txn.transaction_date AS Transaction_Date,
    txn.amount AS Transaction_Amount,
    CASE
        WHEN txn.transaction_type_enum = 1 THEN 'Active'
        WHEN txn.transaction_type_enum = 2 THEN 'Liquidated'
        ELSE 'Unknown'
        END AS Investment_Status,
    acc.account_type_enum AS Account_Type,
    txn.created_by AS Processor_ID,
    p.name AS Product_Name
FROM
    m_client c
        JOIN m_savings_account acc ON acc.client_id = c.id
        JOIN m_savings_account_transaction txn ON txn.savings_account_id = acc.id
        JOIN m_savings_product p ON acc.product_id = p.id
WHERE
    txn.transaction_type_enum IN (1, 2)
ORDER BY
    txn.transaction_date DESC;
