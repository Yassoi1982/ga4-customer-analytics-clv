WITH base AS (
  SELECT
    user_pseudo_id,
    event_name,
    device.category AS device_category,
    event_timestamp
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
),
user_device AS (
  SELECT
    user_pseudo_id,
    ARRAY_AGG(device_category ORDER BY event_timestamp DESC LIMIT 1)[OFFSET(0)] AS device_category
  FROM base
  GROUP BY user_pseudo_id
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
  d.device_category,
  COUNT(*) AS users,
  SUM(f.did_session) AS users_session,
  SUM(f.did_purchase) AS users_purchase,
  SAFE_DIVIDE(SUM(f.did_purchase), SUM(f.did_session)) AS conv_rate
FROM flags f
JOIN user_device d USING (user_pseudo_id)
GROUP BY d.device_category
ORDER BY users_purchase DESC;
