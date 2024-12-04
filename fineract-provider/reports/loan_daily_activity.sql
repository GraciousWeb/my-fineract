SELECT
    m_loan.account_no AS AccountNumber,
    m_client.display_name AS AccountName,
    m_loan.loan_status_id AS LoanStatus,
    m_loan_repayment_schedule.duedate AS RepaymentDate,
    m_loan_transaction.transaction_date AS TransactionDate,
    CASE
        WHEN m_loan_transaction.transaction_type_enum = 1 THEN 'Repayment'
        WHEN m_loan.loan_status_id = 2 AND m_loan_transaction.amount > 0 THEN 'Increment'
        WHEN m_loan.loan_status_id = 3 AND m_loan_transaction.amount = 0 THEN 'Extension'
        WHEN m_loan.loan_status_id = 4 AND m_loan_transaction.amount > 0 THEN 'Renewal'
        WHEN m_loan.loan_status_id = 5 THEN 'Clean Up'
        ELSE 'Other'
        END AS ActivityType,
    COALESCE(m_loan_transaction.amount, 0) AS TransactionAmount,
    acc_gl_account.gl_code AS GLCode,
    m_office.name AS AccountLocation,
    m_loan.loan_officer_id AS AccountOfficer
FROM
    m_loan
        JOIN m_client ON m_loan.client_id = m_client.id
        LEFT JOIN m_loan_repayment_schedule ON m_loan.id = m_loan_repayment_schedule.loan_id
        LEFT JOIN m_loan_transaction ON m_loan.id = m_loan_transaction.loan_id
        JOIN m_product_loan ON m_loan.product_id = m_product_loan.id
        JOIN acc_product_mapping ON m_product_loan.id = acc_product_mapping.product_id
        JOIN acc_gl_account ON acc_product_mapping.gl_account_id = acc_gl_account.id
        JOIN m_office ON m_client.office_id = m_office.id
WHERE
    m_loan_transaction.transaction_date = CURDATE() -- only today's activities, remember to ask Seyi how many days activities
   OR (m_loan_repayment_schedule.duedate = CURDATE()) -- Include due repayments for today
ORDER BY
    m_loan_transaction.transaction_date DESC;
