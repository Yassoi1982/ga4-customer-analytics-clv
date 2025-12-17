# Feature Spec — User-Level Modeling Table

## User key
- user_pseudo_id

## Core metrics
- sessions: distinct ga_session_id per day
- purchases: count of purchase events
- revenue_usd: sum of ecommerce.purchase_revenue_in_usd for purchase events
- aov_usd: revenue_usd / purchases (if purchases > 0)

## Time-based features
- recency_days: days since last purchase (or last event if no purchase)
- tenure_days: days between first event and last event

## Dimensions (most frequent / latest)
- device_category
- country
- traffic_source (source/medium)
