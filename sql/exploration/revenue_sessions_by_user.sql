-- Purpose: User-level revenue and sessions overview
-- Notes:
-- - Sessions use ga_session_id from event_params
-- - Revenue uses ecommerce.purchase_revenue_in_usd (purchase events)

WITH base AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', _TABLE_SUFFIX) AS event_date,
    event_name,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS ga_session_id,
    ecommerce.purchase_revenue_in_usd AS purchase_revenue_usd
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '00000000' AND '99999999'
)
SELECT
  user_pseudo_id,
  COUNT(DISTINCT CONCAT(CAST(ga_session_id AS STRING), '-', CAST(event_date AS STRING))) AS sessions,
  COUNTIF(event_name = 'purchase') AS purchases,
  SUM(IF(event_name = 'purchase', purchase_revenue_usd, 0)) AS revenue_usd
FROM base
GROUP BY user_pseudo_id
ORDER BY revenue_usd DESC
LIMIT 1000;
