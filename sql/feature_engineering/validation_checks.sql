-- Purpose: Validate user_features table

-- 1) Row count
SELECT COUNT(*) AS user_rows
FROM `your_project.analytics.user_features`;

-- 2) Null checks
SELECT
  SUM(CASE WHEN user_pseudo_id IS NULL THEN 1 ELSE 0 END) AS null_user,
  SUM(CASE WHEN sessions IS NULL THEN 1 ELSE 0 END) AS null_sessions,
  SUM(CASE WHEN purchases IS NULL THEN 1 ELSE 0 END) AS null_purchases,
  SUM(CASE WHEN revenue_usd IS NULL THEN 1 ELSE 0 END) AS null_revenue
FROM `your_project.analytics.user_features`;

-- 3) Outliers (top users by revenue)
SELECT *
FROM `your_project.analytics.user_features`
ORDER BY revenue_usd DESC
LIMIT 50;

-- 4) Basic distributions (quantiles)
SELECT
  APPROX_QUANTILES(sessions, 10) AS sessions_deciles,
  APPROX_QUANTILES(purchases, 10) AS purchases_deciles,
  APPROX_QUANTILES(revenue_usd, 10) AS revenue_deciles,
  APPROX_QUANTILES(recency_days, 10) AS recency_deciles
FROM `your_project.analytics.user_features`;
