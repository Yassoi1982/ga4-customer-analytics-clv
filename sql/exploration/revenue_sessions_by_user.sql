-- Purpose: User-level revenue + sessions proxy
-- Revenue is derived from purchase event value params (may be sparse in sample).
-- Sessions proxy: count distinct ga_session_id.

WITH base AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    event_name,
    (SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'value') AS purchase_value
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
)
SELECT
  user_pseudo_id,
  COUNT(DISTINCT session_id) AS sessions,
  COUNTIF(event_name = 'purchase') AS purchases,
  SUM(IFNULL(purchase_value, 0)) AS revenue
FROM base
GROUP BY user_pseudo_id
ORDER BY revenue DESC;
