-- Purpose: Build user-level feature table for segmentation + CLV
-- Output example: your_project.analytics.user_features
-- Replace `your_project.analytics` with your own dataset.

CREATE OR REPLACE TABLE `your_project.analytics.user_features` AS
WITH base AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', _TABLE_SUFFIX) AS event_date,
    event_timestamp,
    event_name,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS ga_session_id,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    device.category AS device_category,
    geo.country AS country,
    ecommerce.purchase_revenue_in_usd AS purchase_revenue_usd
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '00000000' AND '99999999'
),
user_agg AS (
  SELECT
    user_pseudo_id,

    MIN(event_date) AS first_event_date,
    MAX(event_date) AS last_event_date,
    MAX(IF(event_name = 'purchase', event_date, NULL)) AS last_purchase_date,

    COUNT(DISTINCT CONCAT(CAST(ga_session_id AS STRING), '-', CAST(event_date AS STRING))) AS sessions,
    COUNTIF(event_name = 'purchase') AS purchases,
    SUM(IF(event_name = 'purchase', purchase_revenue_usd, 0)) AS revenue_usd,

    -- Most frequent dimension values (approx)
    (SELECT value FROM UNNEST(APPROX_TOP_COUNT(device_category, 1)) LIMIT 1) AS device_category,
    (SELECT value FROM UNNEST(APPROX_TOP_COUNT(country, 1)) LIMIT 1) AS country,
    (SELECT value FROM UNNEST(APPROX_TOP_COUNT(CONCAT(source,' / ',medium), 1)) LIMIT 1) AS source_medium
  FROM base
  GROUP BY user_pseudo_id
)
SELECT
  user_pseudo_id,
  sessions,
  purchases,
  revenue_usd,
  SAFE_DIVIDE(revenue_usd, NULLIF(purchases, 0)) AS aov_usd,

  DATE_DIFF(last_event_date, first_event_date, DAY) AS tenure_days,

  -- Recency: prefer last purchase, else last event
  DATE_DIFF(CURRENT_DATE(), COALESCE(last_purchase_date, last_event_date), DAY) AS recency_days,

  device_category,
  country,
  source_medium,

  first_event_date,
  last_event_date,
  last_purchase_date
FROM user_agg;
