-- CTE to get count of savings plans per customer along with their name
WITH savings_plans AS (
  SELECT owner_id, COUNT(*) AS savings_count, MAX(name) AS name -- Using MAX to get a representative name per customer
  FROM plans_plan
  WHERE is_regular_savings = 1 -- Filter to only savings plans
  GROUP BY owner_id
),
-- CTE to get count of investment plans per customer
investment_plans AS (
  SELECT owner_id, COUNT(*) AS investment_count
  FROM plans_plan
  WHERE is_a_fund = 1 -- Filter to only investment plans
  GROUP BY owner_id
),
-- CTE to get total confirmed deposits per customer
deposits AS (
  SELECT owner_id, SUM(confirmed_amount) AS total_deposits
  FROM savings_savingsaccount
  GROUP BY owner_id
)
-- Final selection of customers with both savings and investment plans
SELECT
  s.owner_id,
  s.name,
  s.savings_count,
  i.investment_count,
  COALESCE(d.total_deposits, 0) AS total_deposits -- Total deposits (0 if none)
FROM savings_plans s
JOIN investment_plans i ON s.owner_id = i.owner_id
LEFT JOIN deposits d ON s.owner_id = d.owner_id
ORDER BY total_deposits DESC;
