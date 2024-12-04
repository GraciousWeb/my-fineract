SELECT
    term.savings_account_id AS account_id,
    client.id AS customer_id,
    client.display_name AS customer_name,
    term.deposit_amount,
    term.maturity_amount,
    term.maturity_date
FROM
    m_deposit_account_term_and_preclosure term
        JOIN
    m_savings_account savings ON term.savings_account_id = savings.id
        JOIN
    m_client client ON savings.client_id = client.id
WHERE
    term.maturity_date = CURDATE();