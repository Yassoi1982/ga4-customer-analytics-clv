# Exploration Notes (GA4 Sample Ecommerce)

## Key fields used
- user_pseudo_id: user key
- event_name: behavior/action
- event_date: derived from _TABLE_SUFFIX
- ga_session_id: from event_params key = 'ga_session_id'
- ecommerce.purchase_revenue_in_usd: revenue (purchase events)
- traffic_source.source / traffic_source.medium
- device.category
- geo.country

## Caveats / limitations
- This is an obfuscated sample GA4 export (not production data).
- Date range is limited to what exists in events_* tables.
- Some users may have missing session id on certain events.
- Revenue should be interpreted from purchase events only.
