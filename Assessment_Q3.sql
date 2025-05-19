SELECT
  p.id AS plan_id,
  p.owner_id,
  CASE
    WHEN p.is_regular_savings = 1 THEN 'Savings'
    ELSE 'Investment'
  END AS type,
  DATE_FORMAT(MAX(s.transaction_date), '%Y-%m-%d') AS last_transaction_date,
  DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount s
  ON s.plan_id = p.id
-- WHERE p.active = 1   <-- remove or comment out this line
GROUP BY p.id, p.owner_id, p.is_regular_savings
HAVING MAX(s.transaction_date) < DATE_SUB(CURDATE(), INTERVAL 365 DAY);
