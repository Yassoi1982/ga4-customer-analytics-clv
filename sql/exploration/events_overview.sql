-- Purpose: Confirm available event tables and overall counts by day
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Note: Filter by _TABLE_SUFFIX for date range selection.

SELECT
  _TABLE_SUFFIX AS event_date,
  COUNT(*) AS event_rows,
  COUNT(DISTINCT user_pseudo_id) AS users
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20200101' AND '20201231'
GROUP BY event_date
ORDER BY event_date;
