SELECT
    m_loan.account_no AS AccountNumber,
    m_client.display_name AS AccountName,
    m_loan.principal_amount AS LoanAmount,
    m_loan.loan_status_id AS LoanStatus,
    m_loan.submittedon_date AS SubmittedDate,
    m_office.name AS AccountLocation,
    m_loan.loan_officer_id AS AccountOfficer
FROM
    m_loan
        JOIN m_client ON m_loan.client_id = m_client.id
        JOIN m_office ON m_client.office_id = m_office.id
WHERE
    m_loan.submittedon_date >= CURDATE() - INTERVAL 1 DAY  -- One day , we can Change to 7 DAY for weekly
ORDER BY
    m_loan.submittedon_date DESC;
