-- Train K-means model (BigQuery ML)
-- Choose k=5 as a recruiter-friendly starting point

CREATE OR REPLACE MODEL `your_project.analytics.kmeans_user_segments`
OPTIONS(model_type='kmeans', num_clusters=5, standardize_features=true) AS
SELECT
  sessions,
  purchases,
  revenue_usd,
  recency_days,
  tenure_days
FROM `your_project.analytics.user_features`;
