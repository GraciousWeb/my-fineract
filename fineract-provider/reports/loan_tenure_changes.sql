SELECT
    m_loan.account_no AS AccountNumber,
    m_client.display_name AS AccountName,
    DATEDIFF(m_loan.maturedon_date, m_loan.submittedon_date) AS LoanTenureDays,
    DATEDIFF(m_loan.submittedon_date, m_loan.last_modified_on_utc) AS ModifiedTenureDays,
    m_loan.loan_status_id AS LoanStatus,
    m_office.name AS AccountLocation,
    m_loan.loan_officer_id AS AccountOfficer,
    m_loan.last_modified_on_utc AS LastModifiedDate,
    CASE
        WHEN m_loan.last_modified_on_utc > m_loan.submittedon_date THEN 'Yes'
        ELSE 'No'
        END AS IsModified
FROM
    m_loan
        JOIN m_client ON m_loan.client_id = m_client.id
        JOIN m_office ON m_client.office_id = m_office.id
WHERE
    m_loan.last_modified_on_utc IS NOT NULL
ORDER BY
    m_loan.last_modified_on_utc DESC;