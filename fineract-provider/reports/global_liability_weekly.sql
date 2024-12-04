SELECT
    SUM(term.deposit_amount) AS total_liability
FROM
    m_deposit_account_term_and_preclosure term
        JOIN
    m_savings_account savings ON term.savings_account_id = savings.id
        JOIN
    m_client client ON savings.client_id = client.id
WHERE
    savings.created_on_utc BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);