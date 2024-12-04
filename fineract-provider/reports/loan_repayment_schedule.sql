
SELECT
    l.id AS Loan_ID,
    c.display_name AS Customer_Name,
    r.dueDate AS Due_Date,
    (COALESCE(r.principal_amount, 0) +
     COALESCE(r.interest_amount, 0) +
     COALESCE(r.fee_charges_amount, 0) +
     COALESCE(r.penalty_charges_amount, 0) -
     (COALESCE(r.credits_amount, 0) +
      COALESCE(r.credited_fee, 0) +
      COALESCE(r.credited_penalty, 0))) AS Total_Due_Amount,
    (COALESCE(r.credits_amount, 0) +
     COALESCE(r.credited_fee, 0) +
     COALESCE(r.credited_penalty, 0)) AS Amount_Paid,
    NULL AS Repayment_Status,
    o.name AS Account_Location,
    l.loan_officer_id AS Account_Officer,
    l.created_by AS Processor_ID
FROM
    m_loan_repayment_schedule r
        LEFT JOIN
    m_loan l ON r.loan_id = l.id
        LEFT JOIN
    m_client c ON l.client_id = c.id
        LEFT JOIN
    m_office o ON c.office_id = o.id
WHERE
    (:clientid IS NULL OR c.id = :clientid)
  AND r.dueDate BETWEEN :startdate AND :end_date
ORDER BY
    r.dueDate;


