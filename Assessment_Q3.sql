WITH all_inflows AS (
    -- Step 1: Combine inflow transactions from both savings and investment plans
    SELECT
        plan_id,
        owner_id,
        'Savings' AS type,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE transaction_date IS NOT NULL
    GROUP BY plan_id, owner_id

    UNION ALL

    SELECT
        id AS plan_id,
        owner_id,
        'Investment' AS type,
        MAX(created_on) AS last_transaction_date
    FROM plans_plan
    WHERE is_a_fund = 1  -- Only investment plans
    GROUP BY id, owner_id
),

inactivity_check AS (
    -- Step 2: Calculate days since last inflow
    SELECT
        plan_id,
        owner_id,
        type,
        last_transaction_date,
        DATEDIFF(CURRENT_DATE(), last_transaction_date) AS inactivity_days
    FROM all_inflows
)

-- Step 3: Filter accounts inactive for more than 365 days
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM inactivity_check
WHERE inactivity_days > 365
ORDER BY inactivity_days DESC;
