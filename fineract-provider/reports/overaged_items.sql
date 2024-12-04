# Over-Aged items in Suspense Account / Transit GLs
# When an item stays in a GL beyond the stated threshold(30 days in this case)
SELECT
    je.transaction_date AS Date,
    je.description AS Transaction_Description,
    gl.name AS GL_Account_Name,
    gl.gl_code AS GL_Account_Code,
    je.amount AS Amount,
    je.created_by AS Processor_ID,
    CASE
        WHEN je.type_enum = 1 THEN 'Debit'
        WHEN je.type_enum = 2 THEN 'Credit'
END AS Transaction_Type
FROM
    acc_gl_journal_entry je
        JOIN
    acc_gl_account gl ON je.account_id = gl.id
WHERE
    gl.classification_enum IN (1, 2)  -- I assumed that 1 is Suspense and 2 is Transit
  AND DATEDIFF(NOW(), je.transaction_date) > 30
ORDER BY
    je.transaction_date DESC;