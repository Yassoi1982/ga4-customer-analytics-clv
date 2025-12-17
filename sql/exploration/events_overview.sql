-- Purpose: List GA4 event tables and row counts
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce

SELECT
  _TABLE_SUFFIX AS event_date,
  COUNT(*) AS total_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY event_date
ORDER BY event_date;
