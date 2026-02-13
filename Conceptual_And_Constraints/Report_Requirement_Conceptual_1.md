_____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Conceptual data model for Yield Hunter Reporting System
## *Version*: 1
## *Updated on*: 
_____________________________________________

## 1. Domain Overview
Yield Hunter is a cruise analytics platform focused on optimizing venue occupancy, guest engagement, offer conversion, and revenue attribution. The reporting system integrates operational data sources, gold-layer KPIs, and additional dimensional tables to support a wide range of business intelligence dashboards.

## 2. List of Entity Names with Descriptions
1. **op_guest_presence_log**: Guest location pings and presence tracking in ship zones.
2. **op_dining_inventory_snapshot**: Venue-level dining seat inventory and occupancy snapshots.
3. **op_micro_offer_events**: Offer lifecycle events and guest interactions.
4. **gold_yield_hunter_kpis**: Aggregated KPIs at venue-hour granularity.
5. **dim_venue**: Venue attributes and operational metadata.
6. **dim_guest_segment**: Guest segmentation and A/B test group assignment.
7. **fact_baseline_revenue**: Baseline revenue and covers for attribution analysis.
8. **log_system_health**: System-level data feed and operational metrics.

## 3. List of Attributes for Each Entity
### op_guest_presence_log
1. **event_ts_utc**: Timestamp of guest presence event
2. **guest_id**: Unique guest reference
3. **location_id**: Location/zone reference
4. **zone_type**: Type of ship zone
5. **dwell_seconds**: Duration of guest presence
6. **signal_confidence**: Quality of RTLS signal

### op_dining_inventory_snapshot
1. **snapshot_ts_utc**: Timestamp of inventory snapshot
2. **venue_id**: Venue reference
3. **capacity_seats**: Total seats available
4. **occupied_seats**: Seats currently occupied
5. **available_seats**: Seats available for booking
6. **walkin_queue_size**: Walk-in queue length

### op_micro_offer_events
1. **offer_ts_utc**: Timestamp of offer event
2. **offer_id**: Offer reference
3. **guest_id**: Guest reference
4. **state**: Offer lifecycle state (presented, accepted, redeemed, expired)
5. **estimated_revenue_usd**: Estimated revenue per offer
6. **discount_pct**: Discount percentage
7. **party_size**: Number of guests in party
8. **redeemed_ts_utc**: Timestamp of redemption
9. **offer_type**: Offer category/type
10. **target_zone**: Targeted ship zone

### gold_yield_hunter_kpis
1. **hour_utc**: Hourly aggregation timestamp
2. **venue_id**: Venue reference
3. **occ_rate**: Occupancy rate
4. **low_occupancy_flag**: Low occupancy indicator
5. **presented**: Offers presented count
6. **accepted**: Offers accepted count
7. **redeemed**: Offers redeemed count
8. **expired**: Offers expired count
9. **accept_rate**: Offer acceptance rate
10. **redeem_rate**: Offer redemption rate
11. **revenue_usd**: Revenue from redeemed offers
12. **seats_filled_via_offers**: Seats filled via offers

### dim_venue
1. **venue_name**: Venue name
2. **venue_type**: Venue category/type
3. **capacity_seats**: Maximum seating
4. **service_periods**: Service time windows
5. **cost_per_cover_avg**: Average cost per cover

### dim_guest_segment
1. **segment**: Guest segment (loyalty tier, spending propensity, cruise frequency)
2. **ab_test_group**: A/B test group assignment
3. **opt_out_flag**: Offer opt-out indicator

### fact_baseline_revenue
1. **date**: Calendar date
2. **venue_id**: Venue reference
3. **service_period**: Service period
4. **baseline_covers**: Baseline covers count
5. **baseline_revenue_usd**: Baseline revenue

### log_system_health
1. **timestamp**: Event timestamp
2. **source_system**: Data source name
3. **metric_name**: System metric name
4. **metric_value**: Metric value
5. **status**: System status

## 4. KPI List
1. **occupancy_rate**: Average occupied seats / capacity seats
2. **low_occupancy_flag**: Indicator for low occupancy (<0.45)
3. **presented_count**: Offers presented
4. **accepted_count**: Offers accepted
5. **redeemed_count**: Offers redeemed
6. **expired_count**: Offers expired
7. **accept_rate**: Acceptance ratio (accepted/presented)
8. **redeem_rate**: Redemption ratio (redeemed/presented)
9. **revenue_usd**: Revenue from redeemed offers
10. **seats_filled_via_offers**: Seats filled via offers
11. **avg_dwell_seconds**: Average guest dwell time
12. **unique_guests**: Unique guests present
13. **avg_available_seats**: Average available seats
14. **missed_opportunity**: Missed opportunity indicator
15. **incremental_revenue**: Revenue above baseline
16. **conversion_by_discount**: Offer conversion grouped by discount
17. **conversion_by_party_size**: Offer conversion grouped by party size
18. **time_to_acceptance**: Time between offer and acceptance
19. **queue_displacement_rate**: Queue reduction per offer accepted
20. **rtls_quality**: RTLS signal confidence
21. **inventory_refresh_rate**: Inventory update frequency
22. **yield_index**: Actual vs potential revenue index
23. **RevPASH**: Revenue per available seat hour
24. **profit_margin**: Offer profit margin
25. **cost_per_acquisition**: Offer cost per redemption

## 5. Conceptual Data Model Diagram
| Source Entity               | Relationship Key Field | Target Entity           | Relationship Type |
|----------------------------|------------------------|------------------------|-------------------|
| op_guest_presence_log      | guest_id               | op_micro_offer_events  | One-to-Many       |
| op_dining_inventory_snapshot| venue_id               | gold_yield_hunter_kpis | One-to-Many       |
| op_micro_offer_events      | venue_id               | gold_yield_hunter_kpis | One-to-Many       |
| op_micro_offer_events      | guest_id               | dim_guest_segment      | Many-to-One       |
| op_dining_inventory_snapshot| venue_id               | dim_venue              | Many-to-One       |
| gold_yield_hunter_kpis     | venue_id               | dim_venue              | Many-to-One       |
| gold_yield_hunter_kpis     | venue_id               | fact_baseline_revenue  | Many-to-One       |
| log_system_health          | source_system          | (none)                 | Standalone        |

## 6. Common Data Elements in Report Requirements
1. **venue_id**: Used across all reports for venue context
2. **guest_id**: Used for guest tracking and segmentation
3. **offer_id**: Used for offer lifecycle and conversion
4. **discount_pct**: Used for conversion and profit analysis
5. **party_size**: Used for segmentation and conversion
6. **service_period**: Used for inventory and revenue attribution
7. **snapshot_ts_utc / hour_utc**: Used for time-based aggregation
8. **state**: Used for offer lifecycle analysis
9. **zone_type/location_id**: Used for guest presence and RTLS quality
10. **revenue_usd**: Used for revenue attribution and profit analysis
