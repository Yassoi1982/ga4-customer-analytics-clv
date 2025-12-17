-- Profile clusters (mean metrics per cluster)

SELECT
  c.cluster_id,
  COUNT(*) AS users,
  AVG(uf.sessions) AS avg_sessions,
  AVG(uf.purchases) AS avg_purchases,
  AVG(uf.revenue_usd) AS avg_revenue_usd,
  AVG(uf.recency_days) AS avg_recency_days,
  AVG(uf.tenure_days) AS avg_tenure_days
FROM `your_project.analytics.kmeans_user_clusters` c
JOIN `your_project.analytics.user_features` uf
USING (user_pseudo_id)
GROUP BY cluster_id
ORDER BY users DESC;
