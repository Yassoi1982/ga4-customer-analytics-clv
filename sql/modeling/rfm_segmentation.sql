-- Purpose: RFM segmentation using user_features
-- Assumes: your_project.analytics.user_features exists

CREATE OR REPLACE TABLE `your_project.analytics.rfm_segments` AS
WITH rfm AS (
  SELECT
    user_pseudo_id,
    recency_days,
    purchases AS frequency,
    revenue_usd AS monetary
  FROM `your_project.analytics.user_features`
),
scored AS (
  SELECT
    *,
    NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,      -- lower recency_days = better
    NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
    NTILE(5) OVER (ORDER BY monetary DESC) AS m_score
  FROM rfm
),
labeled AS (
  SELECT
    user_pseudo_id,
    recency_days, frequency, monetary,
    r_score, f_score, m_score,
    CONCAT(CAST(r_score AS STRING), CAST(f_score AS STRING), CAST(m_score AS STRING)) AS rfm_code,
    CASE
      WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
      WHEN r_score >= 4 AND f_score >= 3 THEN 'Loyal'
      WHEN r_score >= 3 AND f_score <= 2 THEN 'Potential Loyalist'
      WHEN r_score <= 2 AND f_score >= 4 THEN 'At Risk'
      WHEN r_score = 1 AND f_score <= 2 THEN 'Hibernating'
      ELSE 'Others'
    END AS segment
  FROM scored
)
SELECT * FROM labeled;
