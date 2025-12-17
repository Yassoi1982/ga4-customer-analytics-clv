# Data Exploration Notes

## Key fields used
- user_pseudo_id: anonymous user identifier
- event_name: type of GA4 event
- event_params: nested parameters (revenue, value, session info)
- traffic_source: marketing attribution
- device.category: desktop, mobile, tablet
- geo.country: user location

## Caveats
- Dataset is obfuscated and sampled
- Limited historical time window
- Revenue values are event-based, not order-level
- Some users may have missing traffic source data
