# Feature Spec (User-level Modeling Table)

## User key
- `user_pseudo_id`

## Core behavior features
- sessions (distinct ga_session_id)
- purchases (count of purchase events)
- revenue (sum of purchase value proxy)
- AOV = revenue / purchases (if purchases > 0)

## Time features
- recency_days: days since last event in selected window
- tenure_days: days between first and last event in selected window

## Attribution / dimensions
- device_category (most frequent)
- country (most frequent)
- source / medium (most frequent)
