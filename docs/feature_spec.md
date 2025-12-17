# Feature Spec — User-level Modeling Table

## Primary Key
- user_pseudo_id (GA4 user identifier)

## Core behavior features
- sessions: number of sessions per user
- purchases: number of purchase events per user
- revenue: total purchase revenue per user
- AOV (average order value): revenue / purchases (safe divide)

## Time-based features
- recency_days: days since last activity
- tenure_days: days between first and last activity (inclusive)

## Dimensions for segmentation / analysis
- device: device category (desktop/mobile/tablet)
- geo: country (or region if needed)
- traffic source: source / medium / campaign

## Notes
- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce
- We will build a user-level aggregated table from events_* tables.
