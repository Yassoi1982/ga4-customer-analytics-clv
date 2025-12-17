-- Purpose: Analyze traffic sources, devices, and geography

SELECT
  traffic_source.source AS source,
  device.category AS device_category,
  geo.country AS country,
  COUNT(DISTINCT user_pseudo_id) AS users,
  COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY source, device_category, country
ORDER BY users DESC;
