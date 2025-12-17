-- Purpose: Top event names by count

SELECT
  event_name,
  COUNT(*) AS event_count
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '00000000' AND '99999999'
GROUP BY event_name
ORDER BY event_count DESC
LIMIT 50;
