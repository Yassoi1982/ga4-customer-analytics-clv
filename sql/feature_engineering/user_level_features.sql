-- Purpose: Build user-level feature table for segmentation + CLV proxy
-- Output (example): your_project.analytics.user_features
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce

-- NOTE:
-- Replace `your_project.analytics.user_features` with your actual dataset/table.

CREATE OR REPLACE TABLE `your_project.analytics.user_features` AS
WITH base AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', _TABLE_SUFFIX) AS event_date,
    event_name,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    (SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'value') AS purchase_value,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    device.category AS device_category,
    geo.country AS country
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
),
agg AS (
  SELECT
    user_pseudo_id,
    COUNT(DISTINCT session_id) AS sessions,
    COUNTIF(event_name = 'purchase') AS purchases,
    SUM(IFNULL(purchase_value, 0)) AS revenue,
    SAFE_DIVIDE(SUM(IFNULL(purchase_value, 0)), NULLIF(COUNTIF(event_name='purchase'), 0)) AS aov,
    DATE_DIFF(MAX(event_date), MIN(event_date), DAY) AS tenure_days,
    DATE_DIFF(CURRENT_DATE(), MAX(event_date), DAY) AS recency_days
  FROM base
  GROUP BY user_pseudo_id
),
mode_dims AS (
  -- pick most frequent dimension values per user
  SELECT
    user_pseudo_id,
    ARRAY_AGG(device_category ORDER BY cnt DESC LIMIT 1)[OFFSET(0)] AS device_category,
    ARRAY_AGG(country ORDER BY cnt DESC LIMIT 1)[OFFSET(0)] AS country,
    ARRAY_AGG(source ORDER BY cnt DESC LIMIT 1)[OFFSET(0)] AS source,
    ARRAY_AGG(medium ORDER BY cnt DESC LIMIT 1)[OFFSET(0)] AS medium
  FROM (
    SELECT user_pseudo_id, device_category, country, source, medium, COUNT(*) AS cnt
    FROM base
    GROUP BY user_pseudo_id, device_category, country, source, medium
  )
  GROUP BY user_pseudo_id
)
SELECT
  a.*,
  m.device_category,
  m.country,
  m.source,
  m.medium
FROM agg a
LEFT JOIN mode_dims m USING (user_pseudo_id);
