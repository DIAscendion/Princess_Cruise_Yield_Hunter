____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Model data constraints and business rules for Input_Report_Requirement
## *Version*: 1
## *Updated on*: 
____________________________________________

## 1. Data Expectations

### 1.1 Data Completeness
1. All presence pings in op_guest_presence_log must have event timestamp, location, and zone_type populated.
2. Dining inventory snapshots must include capacity, occupied, and available seats for each venue and snapshot time.
3. All micro-offer events must include offer timestamp, state, and estimated revenue.
4. Gold-layer KPI records must exist for every venue and hour in the reporting period.

### 1.2 Data Accuracy
1. Occupied and available seats must sum to capacity in each inventory snapshot.
2. Offer state transitions must reflect actual guest actions (e.g., accepted only if presented).
3. Revenue attribution must only sum estimated_revenue_usd for redeemed offers.
4. Dwell_seconds in presence log must be a non-negative value.

### 1.3 Data Format
1. All timestamps must be in UTC and ISO 8601 format.
2. Numeric fields (e.g., occupancy_rate, revenue_usd) must use decimal notation.
3. Boolean flags (e.g., low_occupancy_flag) must be 0/1 or true/false.
4. Service periods must be represented as standard labels (breakfast/lunch/dinner).

### 1.4 Data Consistency
1. venue_id must be consistent across all tables and match dim_venue.
2. guest segmentation must align with dim_guest_segment definitions.
3. Offer lifecycle states must follow defined state machine (presented → accepted/redeemed/expired).
4. All aggregations must use consistent time grains (hour, 15-min, 30-min, as specified).

## 2. Constraints

### 2.1 Mandatory Fields
1. event_ts_utc, location_id, zone_type in op_guest_presence_log are mandatory for presence tracking.
2. snapshot_ts_utc, venue_id, capacity_seats in op_dining_inventory_snapshot are required for inventory reporting.
3. offer_ts_utc, state in op_micro_offer_events are required for offer funnel analysis.
4. hour_utc, venue_id in gold_yield_hunter_kpis are required for KPI reporting.

### 2.2 Uniqueness Requirements
1. Each (event_ts_utc, guest_id) combination in op_guest_presence_log must be unique.
2. Each (snapshot_ts_utc, venue_id) in op_dining_inventory_snapshot must be unique.
3. Each (offer_ts_utc, offer_id) in op_micro_offer_events must be unique.
4. Each (hour_utc, venue_id) in gold_yield_hunter_kpis must be unique.

### 2.3 Data Type Limitations
1. occupancy_rate, accept_rate, redeem_rate, revenue_usd must be decimals.
2. low_occupancy_flag must be boolean.
3. party_size, presented, accepted, redeemed, expired must be integers.
4. service_period must be a valid label (breakfast/lunch/dinner).

### 2.4 Dependencies
1. low_occupancy_flag depends on occupancy_rate calculation (<0.45).
2. accept_rate depends on counts of presented and accepted offers.
3. redeem_rate depends on counts of presented and redeemed offers.
4. seats_filled_via_offers depends on party_size and redeemed state.
5. missed_opportunity flag depends on both presented count and low_occupancy_flag.

### 2.5 Referential Integrity
1. venue_id in all fact tables must reference dim_venue.
2. guest_id in op_micro_offer_events must reference dim_guest_segment.
3. All time-based aggregations must align with defined reporting windows.
4. Baseline revenue comparisons must match venue_id and service_period.

## 3. Business Rules

### 3.1 Data Processing Rules
1. Inventory snapshots must be processed every 5-15 minutes as per source cadence.
2. Micro-offer events must be ingested in real-time for up-to-date funnel metrics.
3. Gold-layer KPIs must be aggregated hourly and batch loaded.
4. Guest presence logs must be processed in real-time (<5 sec latency).

### 3.2 Reporting Logic Rules
1. low_occupancy_flag is set to 1 if occupancy_rate < 0.45, else 0.
2. accept_rate is calculated as accepted / presented for each venue and time window.
3. redeem_rate is calculated as redeemed / presented for each venue and time window.
4. missed_opportunity is flagged if presented = 0 and low_occupancy_flag = 1.
5. incremental_revenue is calculated as test_revenue - control_revenue in A/B analysis.
6. profit_margin is (gross_revenue - discount_cost) / gross_revenue.

### 3.3 Transformation Guidelines
1. All timestamps must be converted to UTC before aggregation.
2. party_size must be grouped into standard segments (1, 2, 3-4, 5+).
3. discount_pct must be bucketed into defined tiers (10/15/20/25).
4. Service periods must be mapped to standard labels for reporting.
5. Data quality metrics (latency, refresh rate) must be tracked and surfaced in operational dashboards.
