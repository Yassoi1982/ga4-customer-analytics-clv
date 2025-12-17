-- Purpose: User-level revenue and engagement overview

SELECT
  user_pseudo_id,
  COUNTIF(event_name = 'session_start') AS sessions,
  SUM(
    (SELECT value.int_value
     FROM UNNEST(event_params)
     WHERE key = 'value')
  ) AS revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
GROUP BY user_pseudo_id
ORDER BY revenue DESC;

