-- Purpose: Profile clusters to describe behavior
-- Output: query result for docs/segment_definitions.md

SELECT
  cluster_id,
  COUNT(*) AS users,
  AVG(sessions) AS avg_sessions,
  AVG(purchases) AS avg_purchases,
  AVG(revenue) AS avg_revenue,
  AVG(recency_days) AS avg_recency_days,
  AVG(tenure_days) AS avg_tenure_days
FROM `your_project.analytics.kmeans_user_clustered` c
JOIN `your_project.analytics.user_features` f
USING (user_pseudo_id)
GROUP BY 1
ORDER BY users DESC;
