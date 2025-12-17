-- Purpose: Validate the user_features table after creation
-- Update the table name to your actual destination

-- í´§ Replace with your table:
-- `your_project.analytics.user_features`

-- 1) Row count
SELECT
  COUNT(*) AS user_rows
FROM `your_project.analytics.user_features`;

-- 2) Null checks (key + core fields)
SELECT
  SUM(CASE WHEN user_pseudo_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
  SUM(CASE WHEN sessions IS NULL THEN 1 ELSE 0 END) AS null_sessions,
  SUM(CASE WHEN purchases IS NULL THEN 1 ELSE 0 END) AS null_purchases,
  SUM(CASE WHEN revenue IS NULL THEN 1 ELSE 0 END) AS null_revenue
FROM `your_project.analytics.user_features`;

-- 3) Basic distributions
SELECT
  APPROX_QUANTILES(sessions, 10)  AS sessions_deciles,
  APPROX_QUANTILES(purchases, 10) AS purchases_deciles,
  APPROX_QUANTILES(revenue, 10)   AS revenue_deciles,
  APPROX_QUANTILES(aov, 10)       AS aov_deciles
FROM `your_project.analytics.user_features`;

-- 4) Outliers (top users by revenue)
SELECT
  user_pseudo_id,
  sessions,
  purchases,
  revenue,
  aov,
  recency_days,
  tenure_days,
  device_category,
  country,
  source,
  medium,
  campaign
FROM `your_project.analytics.user_features`
ORDER BY revenue DESC
LIMIT 50;

-- 5) Sanity checks: negative or impossible values
SELECT
  COUNTIF(sessions < 0)  AS negative_sessions,
  COUNTIF(purchases < 0) AS negative_purchases,
  COUNTIF(revenue < 0)   AS negative_revenue,
  COUNTIF(aov < 0)       AS negative_aov,
  COUNTIF(recency_days < 0) AS negative_recency,
  COUNTIF(tenure_days < 0)  AS negative_tenure
FROM `your_project.analytics.user_features`;
