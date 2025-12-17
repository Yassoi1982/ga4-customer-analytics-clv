-- Assign clusters to users

CREATE OR REPLACE TABLE `your_project.analytics.kmeans_user_clusters` AS
SELECT
  uf.user_pseudo_id,
  p.centroid_id AS cluster_id
FROM ML.PREDICT(MODEL `your_project.analytics.kmeans_user_segments`,
  (SELECT user_pseudo_id, sessions, purchases, revenue_usd, recency_days, tenure_days
   FROM `your_project.analytics.user_features`)) p
JOIN `your_project.analytics.user_features` uf
ON uf.user_pseudo_id = p.user_pseudo_id;
