SELECT
    m_loan.account_no AS AccountNumber,
    m_client.display_name AS AccountName,
    m_loan.loan_status_id AS LoanStatus,
    m_loan_repayment_schedule.duedate AS RepaymentDate,
    m_loan_repayment_schedule.principal_amount AS PrincipalDue,
    m_loan_repayment_schedule.interest_amount AS InterestDue,
    (m_loan_repayment_schedule.principal_amount + m_loan_repayment_schedule.interest_amount) AS TotalDue,
    COALESCE(m_loan_transaction.transaction_date, 'No Payments') AS LastPaymentDate,
    COALESCE(m_loan_transaction.amount, 0) AS LastPaymentAmount,
    acc_gl_account.gl_code AS GLCode,
    m_office.name AS AccountLocation,
    m_loan.loan_officer_id AS AccountOfficer,
    CASE
        WHEN m_loan_repayment_schedule.duedate < CURDATE() - INTERVAL 90 DAY
        AND (m_loan_transaction.transaction_date IS NULL OR m_loan_transaction.transaction_date < CURDATE() - INTERVAL 90 DAY)
        THEN 'Yes'
        ELSE 'No'
END AS IsNonPerforming,
    CASE
        WHEN m_loan_repayment_schedule.duedate < CURDATE() - INTERVAL 90 DAY
            AND (m_loan_transaction.transaction_date IS NULL OR m_loan_transaction.transaction_date < CURDATE() - INTERVAL 90 DAY)
            THEN TRUE
        ELSE FALSE
END AS is_npa
FROM
    m_loan
        JOIN m_client ON m_loan.client_id = m_client.id
        JOIN m_loan_repayment_schedule ON m_loan.id = m_loan_repayment_schedule.loan_id
        JOIN m_product_loan ON m_loan.product_id = m_product_loan.id
        JOIN acc_product_mapping ON m_product_loan.id = acc_product_mapping.product_id
        JOIN acc_gl_account ON acc_product_mapping.gl_account_id = acc_gl_account.id
        LEFT JOIN (
        SELECT loan_id, MAX(transaction_date) AS transaction_date, SUM(amount) AS amount
        FROM m_loan_transaction
        GROUP BY loan_id
    ) m_loan_transaction ON m_loan.id = m_loan_transaction.loan_id
        JOIN m_office ON m_client.office_id = m_office.id
WHERE
    m_loan_repayment_schedule.duedate < CURDATE() - INTERVAL 90 DAY
ORDER BY
    m_loan.account_no;
