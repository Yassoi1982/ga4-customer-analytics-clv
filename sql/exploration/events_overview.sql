-- Purpose: Confirm tables, date range, and total events
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce

SELECT
  MIN(PARSE_DATE('%Y%m%d', _TABLE_SUFFIX)) AS min_event_date,
  MAX(PARSE_DATE('%Y%m%d', _TABLE_SUFFIX)) AS max_event_date,
  COUNT(*) AS total_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '00000000' AND '99999999';
