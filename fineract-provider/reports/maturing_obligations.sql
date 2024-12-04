SELECT
    m_loan.account_no AS AccountNumber,
    m_client.display_name AS AccountName,
    m_loan.maturedon_date AS MaturityDate,
    m_loan.loan_status_id AS LoanStatus,
    m_loan.principal_amount AS LoanAmount,
    m_office.name AS AccountLocation,
    m_loan.loan_officer_id AS AccountOfficer
FROM
    m_loan
        JOIN m_client ON m_loan.client_id = m_client.id
        JOIN m_office ON m_client.office_id = m_office.id
WHERE
    m_loan.maturedon_date BETWEEN CURDATE() AND CURDATE() + INTERVAL 7 DAY  -- We can  Adjust range as needed
ORDER BY
    m_loan.maturedon_date ASC;
