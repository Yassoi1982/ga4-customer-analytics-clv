-- Purpose: Validate user_features table quality
-- Replace table name if needed.

-- 1) Row count
SELECT COUNT(*) AS user_rows
FROM `your_project.analytics.user_features`;

-- 2) Null checks (key + important metrics)
SELECT
  COUNTIF(user_pseudo_id IS NULL) AS null_user_key,
  COUNTIF(sessions IS NULL) AS null_sessions,
  COUNTIF(purchases IS NULL) AS null_purchases,
  COUNTIF(revenue IS NULL) AS null_revenue
FROM `your_project.analytics.user_features`;

-- 3) Basic distributions
SELECT
  APPROX_QUANTILES(sessions, 10) AS sessions_deciles,
  APPROX_QUANTILES(purchases, 10) AS purchases_deciles,
  APPROX_QUANTILES(revenue, 10) AS revenue_deciles
FROM `your_project.analytics.user_features`;

-- 4) Outliers (top 20 by revenue)
SELECT *
FROM `your_project.analytics.user_features`
ORDER BY revenue DESC
LIMIT 20;
