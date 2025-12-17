-- Purpose: Understand key dimensions for segmentation & funnel analysis

SELECT
  traffic_source.source AS source,
  traffic_source.medium AS medium,
  device.category AS device_category,
  geo.country AS country,
  COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '00000000' AND '99999999'
GROUP BY source, medium, device_category, country
ORDER BY events DESC
LIMIT 200;
