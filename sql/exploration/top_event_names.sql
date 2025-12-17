-- Purpose: Top event names (volume)
SELECT
  event_name,
  COUNT(*) AS event_count
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
GROUP BY event_name
ORDER BY event_count DESC
LIMIT 50;
