# Exploration Notes

## Key fields used
- User key: `user_pseudo_id`
- Date: `_TABLE_SUFFIX` from `events_*`
- Sessions proxy: `ga_session_id` from `event_params`
- Purchase proxy: `event_name = 'purchase'`
- Revenue proxy: `event_params.key = 'value'` (may be sparse in sample)
- Dimensions:
  - `traffic_source.source`, `traffic_source.medium`
  - `device.category`
  - `geo.country`

## Caveats
- This is an obfuscated GA4 sample dataset with a limited time window.
- Some revenue fields may be missing or not consistent; revenue in GA4 can also appear in ecommerce items/params depending on implementation.
- Session-level reconstruction is approximate using `ga_session_id`.
