# SQL Proficiency Assessment

This repository contains solutions to a SQL proficiency assessment designed to evaluate technical SQL skills, data analysis capabilities, and problem-solving approaches in a business context. The assessment focused on querying and analyzing data from a relational database containing the following tables:

- `users_customuser`: Customer demographic and contact information
- `savings_savingsaccount`: Records of deposit transactions
- `plans_plan`: Records of customer-created plans (savings/investment)
- `withdrawals_withdrawal`: Records of withdrawal transactions

---

## Repository Structure


---

## SQL Solutions Overview

### 📌 Question 1: High-Value Customers with Multiple Products

**Scenario**: Identify customers who own both a savings and an investment plan (cross-selling opportunity).

**Approach**:
- Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan` tables.
- Filtered for users with at least one funded **savings plan** (`is_regular_savings = 1`) and one funded **investment plan** (`is_a_fund = 1`).
- Aggregated the number of each plan type and calculated the total confirmed deposits (in kobo).
- Sorted the results by total deposits in descending order for prioritization.

**Key Fields Returned**:
- `owner_id`, `name`, `savings_count`, `investment_count`, `total_deposits`

---

### 📌 Question 2: Transaction Frequency Analysis

**Scenario**: Segment customers by their average monthly transaction frequency.

**Approach**:
- Counted the number of deposit transactions for each user from `savings_savingsaccount`.
- Calculated average transactions per month by dividing total transactions by the number of distinct months with activity.
- Categorized users:
  - `High Frequency`: ≥10 transactions/month
  - `Medium Frequency`: 3-9 transactions/month
  - `Low Frequency`: ≤2 transactions/month
- Grouped results by frequency category and counted customers in each group.

**Key Fields Returned**:
- `frequency_category`, `customer_count`, `avg_transactions_per_month`

---

### 📌 Question 3: Account Inactivity Alert

**Scenario**: Flag accounts with no deposit activity in the last 365 days.

**Approach**:
- Checked the latest deposit transaction for each account in both savings and investment plans.
- Identified accounts where the most recent transaction occurred over a year ago.
- Calculated the number of inactivity days using the current date and the last transaction date.
- Filtered only **active** accounts and returned them with the required details.

**Key Fields Returned**:
- `plan_id`, `owner_id`, `type`, `last_transaction_date`, `inactivity_days`

---

### 📌 Question 4: Customer Lifetime Value (CLV) Estimation

**Scenario**: Estimate each customer's lifetime value using a simplified CLV model.

**Approach**:
- Calculated account tenure (in months) from signup date to the current date.
- Summed up total transaction value per customer from `savings_savingsaccount`.
- Assumed:
  - `profit_per_transaction = 0.001` (i.e., 0.1%)
  - `CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction`
- Returned results ordered by estimated CLV in descending order.

**Key Fields Returned**:
- `customer_id`, `name`, `tenure_months`, `total_transactions`, `estimated_clv`

---

## Challenges Encountered

- **Data in Kobo**: All monetary values were stored in kobo, requiring division by 100 to convert to Naira for human-readable outputs.
- **Plan Type Identification**: Plans were not directly labeled as "savings" or "investment". Logical conditions using `is_regular_savings` and `is_a_fund` were used for classification.
- **Handling Null Transactions**: Careful handling of accounts with no transactions to avoid null errors or inaccurate inactivity status.
- **Monthly Aggregation**: Standardizing monthly intervals while considering varying activity spans per user for accurate frequency categorization.

---

## Final Notes

- All queries were written for clarity, performance, and maintainability.
- Complex operations such as conditional aggregation and date interval calculations were thoroughly documented via comments in the SQL files.
- Solutions strictly follow the evaluation criteria: **accuracy**, **efficiency**, **completeness**, and **readability**.

Thank you for reviewing my solutions!

---
