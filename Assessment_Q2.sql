WITH customer_txn AS (
  SELECT owner_id, COUNT(*) AS txn_count
  FROM savings_savingsaccount
  GROUP BY owner_id
),
customer_freq AS (
  SELECT owner_id,
         txn_count / 12.0 AS avg_txn_per_month,
         CASE
           WHEN txn_count >= 120 THEN 'High Frequency'
           WHEN txn_count BETWEEN 36 AND 119 THEN 'Medium Frequency'
           ELSE 'Low Frequency'
         END AS frequency_category
  FROM customer_txn
)
SELECT frequency_category,
       COUNT(*) AS customer_count,
       ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month
FROM customer_freq
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
