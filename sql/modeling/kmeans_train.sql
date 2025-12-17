-- Purpose: Train K-means model in BigQuery ML
-- Input:  your_project.analytics.user_features
-- Output: ML model your_project.analytics.kmeans_user_segments

CREATE OR REPLACE MODEL `your_project.analytics.kmeans_user_segments`
OPTIONS(
  model_type = 'kmeans',
  num_clusters = 5,
  standardize_features = TRUE
) AS
SELECT
  sessions,
  purchases,
  revenue,
  recency_days,
  tenure_days
FROM `your_project.analytics.user_features`
WHERE revenue IS NOT NULL;
