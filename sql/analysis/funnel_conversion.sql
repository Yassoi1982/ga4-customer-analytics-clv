-- Funnel conversion (user-based) for key steps
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
    MAX(IF(event_name = 'session_start', 1, 0)) AS did_session,
    MAX(IF(event_name = 'view_item', 1, 0)) AS did_view_item,
    MAX(IF(event_name = 'add_to_cart', 1, 0)) AS did_add_to_cart,
    MAX(IF(event_name = 'begin_checkout', 1, 0)) AS did_begin_checkout,
    MAX(IF(event_name = 'purchase', 1, 0)) AS did_purchase
  FROM base
  GROUP BY user_pseudo_id
)
SELECT
  COUNT(*) AS users,
  SUM(did_session) AS users_session,
  SUM(did_view_item) AS users_view_item,
  SUM(did_add_to_cart) AS users_add_to_cart,
  SUM(did_begin_checkout) AS users_begin_checkout,
  SUM(did_purchase) AS users_purchase,
  SAFE_DIVIDE(SUM(did_purchase), SUM(did_session)) AS session_to_purchase_rate
FROM flags;
