-- Purpose: Understand traffic source, device, geo patterns
-- Traffic fields vary; GA4 sample often uses: traffic_source, device, geo.

SELECT
  traffic_source.source AS source,
  traffic_source.medium AS medium,
  device.category AS device_category,
  geo.country AS country,
  COUNT(*) AS events,
  COUNT(DISTINCT user_pseudo_id) AS users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
GROUP BY 1,2,3,4
ORDER BY events DESC
LIMIT 200;
