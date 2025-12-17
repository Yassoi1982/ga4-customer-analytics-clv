-- Purpose: Build a user-level feature table from GA4 event data
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Output:  your_project.analytics.user_features (change to your project)

-- í´§ REQUIRED: Update these before running
-- Replace `your_project.analytics.user_features` with your real destination table

CREATE OR REPLACE TABLE `your_project.analytics.user_features` AS
WITH base AS (
  SELECT
    user_pseudo_id,
    event_name,
    event_date,
    PARSE_DATE('%Y%m%d', event_date) AS event_dt,

    -- Device + Geo + Traffic Source fields
    device.category AS device_category,
    geo.country AS country,
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign,

    -- Revenue from ecommerce (only present for purchase events)
    ecommerce.purchase_revenue AS purchase_revenue
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20211231'
),

user_agg AS (
  SELECT
    user_pseudo_id,

    -- Activity window
    MIN(event_dt) AS first_event_dt,
    MAX(event_dt) AS last_event_dt,

    -- Counts
    COUNTIF(event_name = 'session_start') AS sessions,
    COUNTIF(event_name = 'purchase') AS purchases,

    -- Revenue
    SUM(CASE WHEN event_name = 'purchase' THEN purchase_revenue ELSE 0 END) AS revenue,

    -- Pick "most common" device/country/source/medium/campaign for user profile
    -- (simple approach using ARRAY_AGG ordered by count)
    (SELECT x FROM UNNEST(ARRAY_AGG(device_category IGNORE NULLS)) x LIMIT 1) AS device_category,
    (SELECT x FROM UNNEST(ARRAY_AGG(country IGNORE NULLS)) x LIMIT 1) AS country,
    (SELECT x FROM UNNEST(ARRAY_AGG(source IGNORE NULLS)) x LIMIT 1) AS source,
    (SELECT x FROM UNNEST(ARRAY_AGG(medium IGNORE NULLS)) x LIMIT 1) AS medium,
    (SELECT x FROM UNNEST(ARRAY_AGG(campaign IGNORE NULLS)) x LIMIT 1) AS campaign
  FROM base
  GROUP BY user_pseudo_id
)

SELECT
  user_pseudo_id,

  first_event_dt,
  last_event_dt,

  sessions,
  purchases,
  revenue,

  SAFE_DIVIDE(revenue, NULLIF(purchases, 0)) AS aov,

  -- Time features (using CURRENT_DATE; you can also use MAX(event_dt) as reference)
  DATE_DIFF(CURRENT_DATE(), last_event_dt, DAY) AS recency_days,
  DATE_DIFF(last_event_dt, first_event_dt, DAY) AS tenure_days,

  device_category,
  country,
  source,
  medium,
  campaign
FROM user_agg;
