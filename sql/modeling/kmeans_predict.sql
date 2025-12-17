-- Purpose: Assign k-means cluster to each user
-- Output: your_project.analytics.kmeans_user_clustered

CREATE OR REPLACE TABLE `your_project.analytics.kmeans_user_clustered` AS
SELECT
  f.user_pseudo_id,
  p.centroid_id AS cluster_id
FROM ML.PREDICT(
  MODEL `your_project.analytics.kmeans_user_segments`,
  (
    SELECT
      user_pseudo_id,
      sessions,
      purchases,
      revenue,
      recency_days,
      tenure_days
    FROM `your_project.analytics.user_features`
  )
) p
JOIN `your_project.analytics.user_features` f
ON p.user_pseudo_id = f.user_pseudo_id;
