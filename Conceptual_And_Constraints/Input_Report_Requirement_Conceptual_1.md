_____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Conceptual data model for Input_Report_Requirement
## *Version*: 1
## *Updated on*: 
_____________________________________________

## 1. Domain Overview
The Yield Hunter reporting system covers cruise ship operations, guest presence tracking, dining inventory management, micro-offer orchestration, and revenue/KPI analytics. The domain spans real-time and batch data sources, operational tables, gold-layer KPIs, and multiple reporting use cases including occupancy, conversion, guest journey, inventory, and revenue attribution.

## 2. List of Entity Names with Descriptions
1. **op_guest_presence_log**: Logs guest presence pings at specific zones and times for tracking movement and dwell times.
2. **op_dining_inventory_snapshot**: Captures periodic snapshots of dining venue inventory, including seat availability and occupancy.
3. **op_micro_offer_events**: Records lifecycle events for micro-offers, including state transitions and estimated revenue.
4. **gold_yield_hunter_kpis**: Aggregated KPI table at venue-hour grain, containing occupancy, conversion, and revenue metrics.
5. **dim_venue**: Reference table for venue details, types, capacity, and service periods.
6. **dim_guest_segment**: Guest segmentation table for loyalty, spending, cruise frequency, and A/B test group.
7. **fact_baseline_revenue**: Baseline revenue and covers for comparison and incremental attribution.
8. **log_system_health**: System health and data quality metrics for operational readiness.

## 3. List of Attributes for Each Entity
### op_guest_presence_log
1. **event_ts_utc**: Timestamp of guest presence ping.
2. **guest_id**: Unique guest identifier (excluded from model per instructions).
3. **location_id**: Location where ping was recorded.
4. **zone_type**: Type of zone (e.g., dining, entertainment).
5. **dwell_seconds**: Duration guest spent in zone.

### op_dining_inventory_snapshot
1. **snapshot_ts_utc**: Timestamp of inventory snapshot.
2. **venue_id**: Venue identifier.
3. **capacity_seats**: Total seats in venue.
4. **occupied_seats**: Seats currently occupied.
5. **available_seats**: Seats available for booking.

### op_micro_offer_events
1. **offer_ts_utc**: Timestamp of offer event.
2. **offer_id**: Unique offer identifier (excluded from model per instructions).
3. **guest_id**: Guest identifier (excluded).
4. **state**: Offer lifecycle state (presented, accepted, redeemed, expired).
5. **estimated_revenue_usd**: Estimated revenue from offer.
6. **discount_pct**: Discount percentage applied.
7. **party_size**: Size of guest party.
8. **redeemed_ts_utc**: Timestamp of redemption event.
9. **target_zone**: Zone targeted by offer.
10. **offer_type**: Type of offer.

### gold_yield_hunter_kpis
1. **hour_utc**: Hourly timestamp for aggregation.
2. **venue_id**: Venue identifier.
3. **occ_rate**: Occupancy rate (decimal).
4. **low_occupancy_flag**: Boolean flag for low occupancy.
5. **presented**: Count of offers presented.
6. **accepted**: Count of offers accepted.
7. **redeemed**: Count of offers redeemed.
8. **expired**: Count of offers expired.
9. **accept_rate**: Acceptance rate.
10. **redeem_rate**: Redemption rate.
11. **revenue_usd**: Total revenue from redeemed offers.
12. **seats_filled_via_offers**: Seats filled via redeemed offers.

### dim_venue
1. **venue_name**: Name of venue.
2. **venue_type**: Type of venue.
3. **capacity_seats**: Venue seating capacity.
4. **service_periods**: Array of service periods (breakfast, lunch, dinner).
5. **cost_per_cover_avg**: Average cost per cover.

### dim_guest_segment
1. **segment**: Guest segment (loyalty tier, spending propensity, cruise frequency).
2. **ab_test_group**: A/B test group assignment.
3. **opt_out_flag**: Guest opt-out status.

### fact_baseline_revenue
1. **date**: Date of baseline measurement.
2. **venue_id**: Venue identifier.
3. **service_period**: Service period (breakfast/lunch/dinner).
4. **baseline_covers**: Baseline covers count.
5. **baseline_revenue_usd**: Baseline revenue in USD.

### log_system_health
1. **timestamp**: Timestamp of health metric.
2. **source_system**: Source system name.
3. **metric_name**: Name of health metric.
4. **metric_value**: Value of metric.
5. **status**: Status of system/component.

## 4. KPI List
1. **occupancy_rate**: Average occupied seats divided by capacity.
2. **avg_available_seats**: Average available seats per venue/time.
3. **low_occupancy_flag**: Indicates low occupancy (<0.45).
4. **presented_count**: Count of offers presented.
5. **accepted_count**: Count of offers accepted.
6. **redeemed_count**: Count of offers redeemed.
7. **expired_count**: Count of offers expired.
8. **accept_rate**: Acceptance rate (accepted/presented).
9. **redeem_rate**: Redemption rate (redeemed/presented).
10. **revenue_usd**: Total revenue from redeemed offers.
11. **seats_filled_via_offers**: Seats filled via redeemed offers.
12. **avg_dwell_seconds**: Average guest dwell time in zone.
13. **unique_guests**: Count of unique guests.
14. **avg_pings_per_guest**: Average pings per guest.
15. **total_revenue**: Sum of estimated revenue for redeemed offers.
16. **avg_revenue_per_redemption**: Average revenue per redemption.
17. **incremental_seats_filled**: Incremental seats filled via offers.
18. **conversion_by_discount**: Conversion rate by discount tier.
19. **conversion_by_party_size**: Conversion rate by party size.
20. **time_to_acceptance**: Time from offer to acceptance.
21. **missed_opportunity**: Missed opportunity flag when no offers presented during low occupancy.
22. **unused_capacity_hours**: Unused capacity hours.
23. **table_turnover_rate**: Table turnover rate.
24. **RevPASH**: Revenue per available seat hour.
25. **control_revenue**: Revenue for control group in A/B test.
26. **test_revenue**: Revenue for test group in A/B test.
27. **incremental_revenue**: Incremental revenue from test vs control.
28. **discount_cost**: Total discount cost.
29. **profit_margin**: Profit margin after discounts.
30. **cost_per_acquisition**: Cost per redeemed offer.
31. **offer_sequence**: Sequence number of offers per guest.
32. **previous_response**: Previous offer response per guest.
33. **rtls_quality**: RTLS signal confidence.
34. **data_latency**: Data latency metric.
35. **inventory_refresh_rate**: Inventory snapshot refresh rate.
36. **delivery_success_rate**: Offer delivery success rate.
37. **yield_index**: Yield index (actual/potential revenue).
38. **opportunity_score**: Composite score for time window opportunity.
39. **acceptance_by_size**: Acceptance rate by party size.
40. **efficiency**: Seats filled vs available seats.
41. **displacement_rate**: Queue displacement rate.
42. **avg_ping_frequency**: Average ping frequency per guest.
43. **dead_zone_count**: Count of zones with low signal confidence.
44. **tracking_error_rate**: Tracking error rate.
45. **ROI_percentage**: Return on investment for offers.

## 5. Conceptual Data Model Diagram
| Source Entity                | Relationship Key Field | Target Entity         | Relationship Type |
|-----------------------------|------------------------|----------------------|-------------------|
| op_guest_presence_log       | location_id            | dim_venue            | Many-to-One       |
| op_dining_inventory_snapshot| venue_id               | dim_venue            | Many-to-One       |
| op_micro_offer_events       | venue_id               | dim_venue            | Many-to-One       |
| op_micro_offer_events       | guest_id               | dim_guest_segment    | Many-to-One       |
| gold_yield_hunter_kpis      | venue_id               | dim_venue            | Many-to-One       |
| gold_yield_hunter_kpis      | hour_utc               | op_dining_inventory_snapshot | Many-to-One |
| gold_yield_hunter_kpis      | hour_utc               | op_micro_offer_events| Many-to-One       |
| fact_baseline_revenue       | venue_id               | dim_venue            | Many-to-One       |
| log_system_health           | source_system          | op_guest_presence_log| Many-to-One       |
| log_system_health           | source_system          | op_dining_inventory_snapshot| Many-to-One |
| log_system_health           | source_system          | op_micro_offer_events| Many-to-One       |

## 6. Common Data Elements in Report Requirements
1. **venue_id**: Used across all reports for venue context.
2. **hour_utc / snapshot_ts_utc / event_ts_utc / offer_ts_utc**: Time-based aggregation and analysis.
3. **occupied_seats / capacity_seats / available_seats**: Inventory and occupancy metrics.
4. **discount_pct**: Discount segmentation in offers and reporting.
5. **party_size**: Segmentation and conversion metrics.
6. **revenue_usd / estimated_revenue_usd**: Revenue attribution and KPIs.
7. **state**: Offer lifecycle state for funnel and conversion.
8. **zone_type / location_id**: Guest presence and heatmap analysis.
9. **service_period**: Service period segmentation.
10. **guest_segment**: Guest segmentation and A/B testing.
