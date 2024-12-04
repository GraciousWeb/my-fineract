SELECT
    term.savings_account_id AS deal_slip_number,
    client.id AS customer_id,
    client.display_name AS customer_name,
    term.deposit_amount,
    term.maturity_amount,
    term.maturity_date,
    term.deposit_period
FROM
    m_deposit_account_term_and_preclosure term
        JOIN
    m_savings_account savings ON term.savings_account_id = savings.id
        JOIN
    m_client client ON savings.client_id = client.id
WHERE
    (client.id = :customerId OR client.display_name LIKE :customerName OR term.savings_account_id = :dealSlipNumber)
  AND term.maturity_date >= CURDATE(); -- Only retrieve active and future maturing accounts
