--  Report: Change/Maintenances on Investment Dynamics
--  It is assumed that the fixed deposit account is the investment account
SELECT
    deposit.savings_account_id AS account_id,
    deposit.deposit_amount,
    deposit.maturity_amount,
    deposit.maturity_date,
    deposit.expected_firstdepositon_date AS value_date,
    deposit.deposit_period,
    deposit.deposit_period_frequency_enum AS period_frequency,
    deposit.on_account_closure_enum AS closure_type,
    deposit.transfer_interest_to_linked_account,
    deposit.transfer_to_savings_account_id AS transfer_account_id,

    -- Reversal Details (from m_deposit_account_on_hold_transaction)
    hold_transaction.amount AS hold_amount,
    hold_transaction.is_reversed AS is_reversed,
    hold_transaction.transaction_date AS reversal_date,

    -- Mandate/Standing Instruction Details (from m_account_transfer_standing_instructions)
    standing_instructions.name AS mandate_name,
    standing_instructions.amount AS mandate_amount,
    standing_instructions.status AS mandate_status,
    standing_instructions.valid_from,
    standing_instructions.valid_till,

    -- Rate Information (from m_rate)
    rate.name AS rate_name,
    rate.percentage AS interest_rate_percentage,
    rate.active AS rate_active,
    rate.approve_user AS rate_approved_by,
    rate.lastmodified_date AS rate_last_modified_date

FROM
    m_deposit_account_term_and_preclosure deposit
        LEFT JOIN
    m_deposit_account_on_hold_transaction hold_transaction
    ON deposit.savings_account_id = hold_transaction.savings_account_id
        LEFT JOIN
    m_account_transfer_standing_instructions standing_instructions
    ON standing_instructions.account_transfer_details_id = deposit.savings_account_id
        LEFT JOIN
    m_rate rate
    ON rate.product_apply = deposit.savings_account_id  -- Assuming 'product_apply' links to account
WHERE
    deposit.savings_account_id = ?
ORDER BY
    rate.lastmodified_date DESC,
    hold_transaction.transaction_date DESC;