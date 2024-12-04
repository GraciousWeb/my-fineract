SELECT
    onhold.savings_account_id AS account_id,
    client.id AS customer_id,
    client.display_name AS customer_name,
    onhold.amount AS liquidation_amount,
    onhold.transaction_date AS liquidation_date
FROM
    m_deposit_account_on_hold_transaction onhold
        JOIN
    m_savings_account savings ON onhold.savings_account_id = savings.id
        JOIN
    m_client client ON savings.client_id = client.id
WHERE
    onhold.transaction_type_enum = 'PREMATURE_LIQUIDATION'
  AND onhold.transaction_date = CURDATE();