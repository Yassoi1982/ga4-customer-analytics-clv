CREATE OR REPLACE TABLE `your_project.analytics.rfm_segments` AS
WITH base AS (
  SELECT
    user_pseudo_id,
    recency_days,
    purchases AS frequency,
    revenue   AS monetary
  FROM `your_project.analytics.user_features`
),

scored AS (
  SELECT
    *,
    -- Lower recency_days is better → score 5 is best
    NTILE(5) OVER (ORDER BY recency_days ASC) AS r_score,
    NTILE(5) OVER (ORDER BY frequency DESC)   AS f_score,
    NTILE(5) OVER (ORDER BY monetary DESC)    AS m_score
  FROM base
),

labeled AS (
  SELECT
    *,
    CONCAT(CAST(r_score AS STRING), CAST(f_score AS STRING), CAST(m_score AS STRING)) AS rfm_score,

    CASE
      WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
      WHEN r_score >= 4 AND f_score >= 3 THEN 'Loyal'
      WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
      WHEN r_score BETWEEN 2 AND 3 AND f_score >= 3 THEN 'Potential Loyalist'
      WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
      WHEN r_score = 1 AND f_score <= 2 THEN 'Hibernating'
      ELSE 'Needs Attention'
    END AS segment_label
  FROM scored
)

SELECT * FROM labeled;
EOF
