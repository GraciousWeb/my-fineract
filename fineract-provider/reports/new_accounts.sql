# new accounts
SELECT
    a.created_on_utc AS Account_Creation_Date,
    txn.transaction_date AS Tranx_Spool_Date,
    acc.field_officer_id AS Account_Officer,
    a.status_enum AS Documentation_Status,
    acc.account_type_enum AS Account_Type,
    a.status_enum AS Account_Status,
    o.name AS Account_Location,
    a.created_by AS Processor_ID
FROM
    m_client a
        JOIN m_office o ON a.office_id = o.id
        LEFT JOIN m_savings_account acc ON acc.client_id = a.id
        LEFT JOIN m_savings_account_transaction txn ON txn.savings_account_id = acc.id
WHERE
    a.created_on_utc >= CURDATE() - INTERVAL 7 DAY; -- the query pulls accounts that are a maximum of 7 days old, we can change that.
