SELECT
    m_loan.account_no AS AccountNumber,
    m_client.display_name AS AccountName,
    m_loan.interest_calculated_from_date AS ApprovedInterestRate,
    m_loan.interest_charged_derived AS ModifiedInterestRate, -- there is no modified rate field yet,
    m_loan.loan_status_id AS LoanStatus,
    m_office.name AS AccountLocation,
    m_loan.loan_officer_id AS AccountOfficer,
    m_loan.interest_recalcualated_on AS LastModifiedDate
FROM
    m_loan
        JOIN m_client ON m_loan.client_id = m_client.id
        JOIN m_office ON m_client.office_id = m_office.id
WHERE
    m_loan.interest_recalcualated_on IS NOT NULL
ORDER BY
    m_loan.interest_recalcualated_on DESC;