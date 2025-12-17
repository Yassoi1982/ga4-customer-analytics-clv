-- Funnel conversion by RFM segment (requires rfm_users table)
WITH base AS (
  SELECT
    user_pseudo_id,
    event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
),
flags AS (
  SELECT
    user_pseudo_id,
    MAX(IF(event_name='session_start',1,0)) AS did_session,
    MAX(IF(event_name='purchase',1,0)) AS did_purchase
  FROM base
  GROUP BY user_pseudo_id
)
SELECT
  r.segment,
  COUNT(*) AS users,
  SUM(f.did_session) AS users_session,
  SUM(f.did_purchase) AS users_purchase,
  SAFE_DIVIDE(SUM(f.did_purchase), SUM(f.did_session)) AS conv_rate
FROM flags f
JOIN `YOUR_PROJECT_ID.analytics.rfm_users` r USING (user_pseudo_id)
GROUP BY r.segment
ORDER BY users_purchase DESC;
