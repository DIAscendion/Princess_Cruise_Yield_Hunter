____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Model data constraints and business rules for Yield Hunter Reporting System
## *Version*: 1
## *Updated on*: 
____________________________________________

## 1. Data Expectations

### 1.1 Data Completeness
1. All operational source tables (op_guest_presence_log, op_dining_inventory_snapshot, op_micro_offer_events) must capture every relevant event in real-time or batch as specified.
2. Gold-layer KPIs must be refreshed hourly and include all venues in scope.
3. Dimensional tables (dim_venue, dim_guest_segment) must be populated for all active venues and guests.

### 1.2 Data Accuracy
1. Occupancy rates and offer conversion metrics must be calculated using correct denominators and filters (e.g., state='presented', state='redeemed').
2. Revenue attribution must sum only redeemed offers and exclude expired or unaccepted offers.
3. Guest presence logs must accurately reflect zone_type and dwell_seconds.

### 1.3 Data Format
1. Timestamps must be in UTC and support hourly, daily, and service period aggregation.
2. Numeric fields (occupancy_rate, revenue_usd, discount_pct) must conform to decimal formatting.
3. Boolean flags (low_occupancy_flag, opt_out_flag) must use 0/1 or true/false consistently.

### 1.4 Data Consistency
1. Venue_id, guest_id, and offer_id must be consistent across all tables and reports.
2. Service_period and zone_type must be standardized for aggregation and reporting.
3. State values in op_micro_offer_events must match defined lifecycle states (presented, accepted, redeemed, expired).

## 2. Constraints

### 2.1 Mandatory Fields
1. venue_id: Required for all venue-level reporting and aggregation.
2. guest_id: Required for guest segmentation and journey tracking.
3. state: Required for offer lifecycle analysis.
4. hour_utc/snapshot_ts_utc: Required for time-based aggregation.

### 2.2 Uniqueness Requirements
1. Each offer_id must be unique within op_micro_offer_events.
2. Each venue_id must be unique within dim_venue.
3. Each guest_id must be unique within dim_guest_segment.

### 2.3 Data Type Limitations
1. occupancy_rate, discount_pct, revenue_usd: Must be decimal values.
2. low_occupancy_flag, opt_out_flag: Must be boolean values.
3. party_size, seats_filled_via_offers: Must be integer values.

### 2.4 Dependencies
1. Gold-layer KPIs depend on timely refresh of operational source tables.
2. Revenue attribution depends on correct mapping of redeemed offers to venues and service periods.
3. Guest segmentation depends on accurate assignment in dim_guest_segment.

### 2.5 Referential Integrity
1. op_micro_offer_events.guest_id must reference dim_guest_segment.guest_id.
2. op_dining_inventory_snapshot.venue_id must reference dim_venue.venue_id.
3. gold_yield_hunter_kpis.venue_id must reference dim_venue.venue_id.

## 3. Business Rules

### 3.1 Data Processing Rules
1. Gold-layer KPIs must be aggregated hourly from operational sources.
2. Real-time dashboards must query operational sources directly for up-to-date metrics.
3. Baseline revenue attribution must use fact_baseline_revenue for comparison.

### 3.2 Reporting Logic Rules
1. Low occupancy flag is set when occupancy_rate < 0.45.
2. Missed opportunity is flagged when presented=0 and low_occupancy_flag=1.
3. Offer conversion rates are calculated as accepted/presented and redeemed/presented.

### 3.3 Transformation Guidelines
1. Service periods must be mapped to breakfast/lunch/dinner based on venue schedule.
2. Guest journey tracking uses window functions for event sequencing.
3. Profit margin is calculated as (gross_revenue - discount_cost) / gross_revenue.
