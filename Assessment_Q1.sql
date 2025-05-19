SELECT
  s.owner_id,
  MAX(p.name) AS name,  -- get the name from plans_plan (assuming consistent)
  s.savings_count,
  i.investment_count,
  ROUND(COALESCE(t.total_deposits, 0), 2) AS total_deposits
FROM
  -- Count of savings plans per customer
  (SELECT owner_id, COUNT(*) AS savings_count
   FROM plans_plan
   WHERE is_regular_savings = 1
   GROUP BY owner_id) s
JOIN
  -- Count of investment plans per customer
  (SELECT owner_id, COUNT(*) AS investment_count
   FROM plans_plan
   WHERE is_a_fund = 1
   GROUP BY owner_id) i ON s.owner_id = i.owner_id
LEFT JOIN
  -- Sum of all deposit transactions per customer
  (SELECT owner_id, SUM(confirmed_amount) AS total_deposits
   FROM savings_savingsaccount
   GROUP BY owner_id) t ON s.owner_id = t.owner_id
JOIN
  plans_plan p ON s.owner_id = p.owner_id
GROUP BY
  s.owner_id, s.savings_count, i.investment_count, t.total_deposits
ORDER BY
  total_deposits DESC;
