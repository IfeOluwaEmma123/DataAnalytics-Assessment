-- Step 1: Aggregate total transactions and active transaction months per customer
WITH customer_activity AS (
    SELECT
        owner_id,  -- Customer ID
        COUNT(*) AS total_transactions,  -- Total number of transactions made
        TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) + 1 AS active_months  -- Number of months between first and last transaction
    FROM savings_savingsaccount
    WHERE transaction_date IS NOT NULL
    GROUP BY owner_id
),

-- Step 2: Compute average monthly transaction rate and assign frequency category
customer_frequency AS (
    SELECT
        owner_id,
        total_transactions,
        active_months,
        ROUND(total_transactions / active_months, 2) AS avg_txn_per_month,  -- Average transactions per month (rounded to 2 decimal places)
        CASE
            WHEN (total_transactions / active_months) >= 10 THEN 'High Frequency'
            WHEN (total_transactions / active_months) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category  -- Frequency classification
    FROM customer_activity
)

-- Step 3: Aggregate results by frequency category
SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,  -- Number of customers in each frequency group
    ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month  -- Group-wise average of avg monthly transactions
FROM customer_frequency
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');  -- Maintain consistent category order
