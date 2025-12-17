WITH base AS (
  SELECT
    user_pseudo_id,
    event_name,
    traffic_source.source AS source,
    traffic_source.medium AS medium
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
),
user_dims AS (
  SELECT
    user_pseudo_id,
    ARRAY_AGG(CONCAT(IFNULL(source,'(none)'), '/', IFNULL(medium,'(none)')) ORDER BY event_name LIMIT 1)[OFFSET(0)] AS channel
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
  d.channel,
  COUNT(*) AS users,
  SUM(f.did_session) AS users_session,
  SUM(f.did_purchase) AS users_purchase,
  SAFE_DIVIDE(SUM(f.did_purchase), SUM(f.did_session)) AS conv_rate
FROM flags f
JOIN user_dims d USING (user_pseudo_id)
GROUP BY d.channel
ORDER BY users_purchase DESC
LIMIT 50;
