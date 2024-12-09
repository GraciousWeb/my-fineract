<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.3.xsd">

    <!-- Changeset to execute Loan Report SQL query -->
    <changeSet id="loan-report-1" author="fineract">
        <preConditions onFail="MARK_RAN">
            <!-- Check if the m_loan table exists before running the query -->
            <sqlCheck expectedResult="1">
SELECT COUNT(*) FROM m_loan
    </sqlCheck>
        </preConditions>

        <sql>
            <![CDATA[
-- Report: Loan details with interest recalculated
SELECT
    m_loan.account_no AS AccountNumber,
    m_client.display_name AS AccountName,
    m_loan.interest_calculated_from_date AS ApprovedInterestRate,
    m_loan.interest_charged_derived AS ModifiedInterestRate, -- there is no modified rate field yet
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
]]>
        </sql>
    </changeSet>

</databaseChangeLog>
