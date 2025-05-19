WITH savings_plans AS (
  SELECT owner_id, COUNT(*) AS savings_count, MAX(name) AS name
  FROM plans_plan
  WHERE is_regular_savings = 1
  GROUP BY owner_id
),
investment_plans AS (
  SELECT owner_id, COUNT(*) AS investment_count
  FROM plans_plan
  WHERE is_a_fund = 1
  GROUP BY owner_id
),
deposits AS (
  SELECT owner_id, SUM(confirmed_amount) AS total_deposits
  FROM savings_savingsaccount
  GROUP BY owner_id
)
SELECT
  s.owner_id,
  s.name,
  s.savings_count,
  i.investment_count,
  COALESCE(d.total_deposits, 0) AS total_deposits
FROM savings_plans s
JOIN investment_plans i ON s.owner_id = i.owner_id
LEFT JOIN deposits d ON s.owner_id = d.owner_id
ORDER BY total_deposits DESC;
