_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*:   Recommended Data Quality Checks for Snowflake Silver Layer (Yield Management Application)
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Snowflake Silver DQ Recommender

This document provides a comprehensive set of data quality checks for the Silver layer tables in the Yield Management Application. The recommendations are based on the physical DDL, sample data, conceptual model, and business rules/constraints. Each check includes a rationale and a sample SQL query.

---

## Table: sv_yield_dining_inventory_snapshot

| Column              | Data Type  | Constraints/Notes                |
|---------------------|------------|----------------------------------|
| id                  | STRING     | Unique row identifier            |
| snapshot_ts_utc     | TIMESTAMP  | Not null, UTC                    |
| venue_id            | STRING     | Not null, must exist in dim_venue|
| venue_type          | STRING     | Not null, valid values           |
| capacity_seats      | INT        | >=0                              |
| occupied_seats      | INT        | >=0, <=capacity_seats            |
| available_seats     | INT        | >=0, <=capacity_seats            |
| walkin_queue_size   | INT        | >=0                              |
| load_date           | DATE       | Not null                         |
| update_date         | DATE       | Not null                         |
| source_system       | STRING     | Not null                         |

### Recommended Data Quality Checks:

1. [Null Check: Required Fields]
   - Description: Ensure snapshot_ts_utc, venue_id, venue_type, capacity_seats, occupied_seats, available_seats, walkin_queue_size, load_date, update_date, source_system are not null.
   - Rationale: Mandatory fields for reporting and aggregation.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_yield_dining_inventory_snapshot
     WHERE snapshot_ts_utc IS NULL OR venue_id IS NULL OR venue_type IS NULL OR capacity_seats IS NULL
       OR occupied_seats IS NULL OR available_seats IS NULL OR walkin_queue_size IS NULL
       OR load_date IS NULL OR update_date IS NULL OR source_system IS NULL;
     ```

2. [Range Check: capacity_seats, occupied_seats, available_seats, walkin_queue_size]
   - Description: Ensure all seat and queue counts are >= 0 and occupied_seats + available_seats <= capacity_seats.
   - Rationale: Negative or over-allocated seats are not possible.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_yield_dining_inventory_snapshot
     WHERE capacity_seats < 0 OR occupied_seats < 0 OR available_seats < 0 OR walkin_queue_size < 0
        OR (occupied_seats + available_seats) > capacity_seats;
     ```

3. [Referential Integrity: venue_id]
   - Description: venue_id must exist in dim_venue.
   - Rationale: Ensures valid venue references.
   - SQL Example:
     ```sql
     SELECT s.* FROM silver.sv_yield_dining_inventory_snapshot s
     LEFT JOIN dim_venue v ON s.venue_id = v.venue_id
     WHERE v.venue_id IS NULL;
     ```

4. [Format Check: snapshot_ts_utc]
   - Description: Ensure timestamp is in UTC.
   - Rationale: Consistency for time-based aggregation.
   - SQL Example:
     ```sql
     -- Assuming all timestamps are stored in UTC, else check timezone offset
     SELECT * FROM silver.sv_yield_dining_inventory_snapshot
     WHERE snapshot_ts_utc IS NULL;
     ```

5. [Allowed Values: venue_type]
   - Description: venue_type must be in ('specialty_dining', 'main_dining', 'buffet', 'bar_lounge', 'cafe', 'pool', 'spa', 'casino', 'promenade', 'deck', 'lobby').
   - Rationale: Prevents invalid venue types.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_yield_dining_inventory_snapshot
     WHERE venue_type NOT IN ('specialty_dining', 'main_dining', 'buffet', 'bar_lounge', 'cafe', 'pool', 'spa', 'casino', 'promenade', 'deck', 'lobby');
     ```

6. [Uniqueness: id]
   - Description: id must be unique per row.
   - Rationale: Prevents duplicate records.
   - SQL Example:
     ```sql
     SELECT id, COUNT(*) FROM silver.sv_yield_dining_inventory_snapshot
     GROUP BY id HAVING COUNT(*) > 1;
     ```

---

## Table: sv_yield_guest_presence_log

| Column            | Data Type  | Constraints/Notes                |
|-------------------|------------|----------------------------------|
| id                | STRING     | Unique row identifier            |
| event_ts_utc      | TIMESTAMP  | Not null, UTC                    |
| guest_id          | STRING     | Not null, must exist in dim_guest_segment |
| location_id       | STRING     | Not null                         |
| zone_type         | STRING     | Not null, valid values           |
| party_size        | INT        | >=1                              |
| dwell_seconds     | INT        | >=0                              |
| signal_confidence | FLOAT      | 0.0 <= value <= 1.0              |
| load_date         | DATE       | Not null                         |
| update_date       | DATE       | Not null                         |
| source_system     | STRING     | Not null                         |

### Recommended Data Quality Checks:

1. [Null Check: Required Fields]
   - Description: Ensure event_ts_utc, guest_id, location_id, zone_type, party_size, dwell_seconds, signal_confidence, load_date, update_date, source_system are not null.
   - Rationale: Mandatory for guest tracking and reporting.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_yield_guest_presence_log
     WHERE event_ts_utc IS NULL OR guest_id IS NULL OR location_id IS NULL OR zone_type IS NULL
       OR party_size IS NULL OR dwell_seconds IS NULL OR signal_confidence IS NULL
       OR load_date IS NULL OR update_date IS NULL OR source_system IS NULL;
     ```

2. [Range Check: party_size, dwell_seconds, signal_confidence]
   - Description: party_size >= 1, dwell_seconds >= 0, 0.0 <= signal_confidence <= 1.0.
   - Rationale: Ensures valid values for analytics.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_yield_guest_presence_log
     WHERE party_size < 1 OR dwell_seconds < 0 OR signal_confidence < 0 OR signal_confidence > 1;
     ```

3. [Referential Integrity: guest_id]
   - Description: guest_id must exist in dim_guest_segment.
   - Rationale: Ensures valid guest references.
   - SQL Example:
     ```sql
     SELECT s.* FROM silver.sv_yield_guest_presence_log s
     LEFT JOIN dim_guest_segment g ON s.guest_id = g.guest_id
     WHERE g.guest_id IS NULL;
     ```

4. [Allowed Values: zone_type]
   - Description: zone_type must be in ('pool', 'deck', 'promenade', 'spa', 'fitness', 'casino', 'lobby').
   - Rationale: Prevents invalid zone types.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_yield_guest_presence_log
     WHERE zone_type NOT IN ('pool', 'deck', 'promenade', 'spa', 'fitness', 'casino', 'lobby');
     ```

5. [Uniqueness: id]
   - Description: id must be unique per row.
   - Rationale: Prevents duplicate records.
   - SQL Example:
     ```sql
     SELECT id, COUNT(*) FROM silver.sv_yield_guest_presence_log
     GROUP BY id HAVING COUNT(*) > 1;
     ```

---

## Table: sv_yield_micro_offer_events

| Column                  | Data Type  | Constraints/Notes                |
|-------------------------|------------|----------------------------------|
| id                      | STRING     | Unique row identifier            |
| offer_ts_utc            | TIMESTAMP  | Not null, UTC                    |
| offer_id                | STRING     | Unique, not null                 |
| guest_id                | STRING     | Not null, must exist in dim_guest_segment |
| party_size              | INT        | >=1                              |
| target_zone             | STRING     | Not null                         |
| venue_id                | STRING     | Not null, must exist in dim_venue|
| discount_pct            | INT        | 0 <= value <= 100                |
| state                   | STRING     | Not null, allowed values         |
| redeemed_ts_utc         | TIMESTAMP  | Nullable, UTC                    |
| estimated_revenue_usd   | FLOAT      | >=0                              |
| load_date               | DATE       | Not null                         |
| update_date             | DATE       | Not null                         |
| source_system           | STRING     | Not null                         |

### Recommended Data Quality Checks:

1. [Null Check: Required Fields]
   - Description: Ensure offer_ts_utc, offer_id, guest_id, party_size, target_zone, venue_id, discount_pct, state, estimated_revenue_usd, load_date, update_date, source_system are not null.
   - Rationale: Required for offer lifecycle and analytics.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_yield_micro_offer_events
     WHERE offer_ts_utc IS NULL OR offer_id IS NULL OR guest_id IS NULL OR party_size IS NULL
       OR target_zone IS NULL OR venue_id IS NULL OR discount_pct IS NULL OR state IS NULL
       OR estimated_revenue_usd IS NULL OR load_date IS NULL OR update_date IS NULL OR source_system IS NULL;
     ```

2. [Uniqueness: offer_id]
   - Description: offer_id must be unique.
   - Rationale: Each offer event must be uniquely tracked.
   - SQL Example:
     ```sql
     SELECT offer_id, COUNT(*) FROM silver.sv_yield_micro_offer_events
     GROUP BY offer_id HAVING COUNT(*) > 1;
     ```

3. [Range Check: party_size, discount_pct, estimated_revenue_usd]
   - Description: party_size >= 1, 0 <= discount_pct <= 100, estimated_revenue_usd >= 0.
   - Rationale: Ensures valid values for analytics.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_yield_micro_offer_events
     WHERE party_size < 1 OR discount_pct < 0 OR discount_pct > 100 OR estimated_revenue_usd < 0;
     ```

4. [Allowed Values: state]
   - Description: state must be in ('presented', 'accepted', 'redeemed', 'expired').
   - Rationale: Ensures valid offer lifecycle states.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_yield_micro_offer_events
     WHERE state NOT IN ('presented', 'accepted', 'redeemed', 'expired');
     ```

5. [Referential Integrity: guest_id, venue_id]
   - Description: guest_id must exist in dim_guest_segment; venue_id must exist in dim_venue.
   - Rationale: Ensures valid references for reporting.
   - SQL Example:
     ```sql
     SELECT s.* FROM silver.sv_yield_micro_offer_events s
     LEFT JOIN dim_guest_segment g ON s.guest_id = g.guest_id
     WHERE g.guest_id IS NULL
     UNION ALL
     SELECT s.* FROM silver.sv_yield_micro_offer_events s
     LEFT JOIN dim_venue v ON s.venue_id = v.venue_id
     WHERE v.venue_id IS NULL;
     ```

6. [Format Check: offer_ts_utc, redeemed_ts_utc]
   - Description: Ensure timestamps are in UTC.
   - Rationale: Consistency for time-based reporting.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_yield_micro_offer_events
     WHERE offer_ts_utc IS NULL;
     -- If redeemed_ts_utc is not null, check format
     SELECT * FROM silver.sv_yield_micro_offer_events
     WHERE redeemed_ts_utc IS NOT NULL AND redeemed_ts_utc IS NULL;
     ```

---

## Table: sv_gold_yield_hunter_kpis

| Column                  | Data Type  | Constraints/Notes                |
|-------------------------|------------|----------------------------------|
| id                      | STRING     | Unique row identifier            |
| venue_id                | STRING     | Not null, must exist in dim_venue|
| hour                    | TIMESTAMP  | Not null, UTC                    |
| seats                   | INT        | >=0                              |
| occupied                | FLOAT      | >=0, <=seats                     |
| available               | FLOAT      | >=0, <=seats                     |
| occ_rate                | FLOAT      | 0.0 <= value <= 1.0              |
| low_occupancy_flag      | INT        | 0 or 1                           |
| accepted                | INT        | >=0                              |
| expired                 | INT        | >=0                              |
| presented               | INT        | >=0                              |
| redeemed                | INT        | >=0                              |
| accept_rate             | FLOAT      | 0.0 <= value <= 1.0              |
| redeem_rate             | FLOAT      | 0.0 <= value <= 1.0              |
| revenue_usd             | FLOAT      | >=0                              |
| seats_filled_via_offers | INT        | >=0                              |
| load_date               | DATE       | Not null                         |
| update_date             | DATE       | Not null                         |
| source_system           | STRING     | Not null                         |

### Recommended Data Quality Checks:

1. [Null Check: Required Fields]
   - Description: Ensure venue_id, hour, seats, occupied, available, occ_rate, low_occupancy_flag, accepted, expired, presented, redeemed, accept_rate, redeem_rate, revenue_usd, seats_filled_via_offers, load_date, update_date, source_system are not null.
   - Rationale: Required for KPI reporting.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_gold_yield_hunter_kpis
     WHERE venue_id IS NULL OR hour IS NULL OR seats IS NULL OR occupied IS NULL OR available IS NULL
       OR occ_rate IS NULL OR low_occupancy_flag IS NULL OR accepted IS NULL OR expired IS NULL
       OR presented IS NULL OR redeemed IS NULL OR accept_rate IS NULL OR redeem_rate IS NULL
       OR revenue_usd IS NULL OR seats_filled_via_offers IS NULL OR load_date IS NULL OR update_date IS NULL OR source_system IS NULL;
     ```

2. [Range Check: seats, occupied, available, occ_rate, accept_rate, redeem_rate, revenue_usd, seats_filled_via_offers]
   - Description: seats >= 0, occupied >= 0, available >= 0, occupied+available <= seats, occ_rate/accept_rate/redeem_rate between 0 and 1, revenue_usd >= 0, seats_filled_via_offers >= 0.
   - Rationale: Ensures valid KPI values.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_gold_yield_hunter_kpis
     WHERE seats < 0 OR occupied < 0 OR available < 0 OR (occupied + available) > seats
       OR occ_rate < 0 OR occ_rate > 1 OR accept_rate < 0 OR accept_rate > 1 OR redeem_rate < 0 OR redeem_rate > 1
       OR revenue_usd < 0 OR seats_filled_via_offers < 0;
     ```

3. [Allowed Values: low_occupancy_flag]
   - Description: low_occupancy_flag must be 0 or 1.
   - Rationale: Boolean flag for reporting.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_gold_yield_hunter_kpis
     WHERE low_occupancy_flag NOT IN (0, 1);
     ```

4. [Referential Integrity: venue_id]
   - Description: venue_id must exist in dim_venue.
   - Rationale: Ensures valid venue references.
   - SQL Example:
     ```sql
     SELECT s.* FROM silver.sv_gold_yield_hunter_kpis s
     LEFT JOIN dim_venue v ON s.venue_id = v.venue_id
     WHERE v.venue_id IS NULL;
     ```

5. [Uniqueness: id]
   - Description: id must be unique per row.
   - Rationale: Prevents duplicate records.
   - SQL Example:
     ```sql
     SELECT id, COUNT(*) FROM silver.sv_gold_yield_hunter_kpis
     GROUP BY id HAVING COUNT(*) > 1;
     ```

6. [Business Rule: Low Occupancy]
   - Description: low_occupancy_flag must be 1 if occ_rate < 0.45, else 0.
   - Rationale: Business rule for missed opportunity reporting.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_gold_yield_hunter_kpis
     WHERE (occ_rate < 0.45 AND low_occupancy_flag <> 1)
        OR (occ_rate >= 0.45 AND low_occupancy_flag <> 0);
     ```

7. [Business Rule: Offer Conversion Rates]
   - Description: accept_rate = accepted/presented, redeem_rate = redeemed/presented (if presented > 0).
   - Rationale: Ensures correct calculation of KPIs.
   - SQL Example:
     ```sql
     SELECT *,
       CASE WHEN presented > 0 THEN accepted/presented ELSE NULL END AS calc_accept_rate,
       CASE WHEN presented > 0 THEN redeemed/presented ELSE NULL END AS calc_redeem_rate
     FROM silver.sv_gold_yield_hunter_kpis
     WHERE (presented > 0 AND (accept_rate <> accepted/presented OR redeem_rate <> redeemed/presented));
     ```

---

## Table: sv_error_data

| Column         | Data Type  | Constraints/Notes                |
|---------------|------------|----------------------------------|
| error_id      | STRING     | Unique row identifier            |
| table_name    | STRING     | Not null                         |
| record_id     | STRING     | Not null                         |
| error_type    | STRING     | Not null                         |
| error_message | STRING     | Not null                         |
| error_timestamp| TIMESTAMP | Not null                         |
| pipeline_stage| STRING     | Not null                         |
| load_date     | DATE       | Not null                         |
| update_date   | DATE       | Not null                         |
| source_system | STRING     | Not null                         |

### Recommended Data Quality Checks:

1. [Null Check: Required Fields]
   - Description: Ensure all fields are not null.
   - Rationale: Error tracking requires all fields.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_error_data
     WHERE error_id IS NULL OR table_name IS NULL OR record_id IS NULL OR error_type IS NULL
       OR error_message IS NULL OR error_timestamp IS NULL OR pipeline_stage IS NULL
       OR load_date IS NULL OR update_date IS NULL OR source_system IS NULL;
     ```

2. [Uniqueness: error_id]
   - Description: error_id must be unique.
   - Rationale: Prevents duplicate error records.
   - SQL Example:
     ```sql
     SELECT error_id, COUNT(*) FROM silver.sv_error_data
     GROUP BY error_id HAVING COUNT(*) > 1;
     ```

---

## Table: sv_audit

| Column               | Data Type  | Constraints/Notes                |
|----------------------|------------|----------------------------------|
| audit_id             | STRING     | Unique row identifier            |
| pipeline_name        | STRING     | Not null                         |
| execution_start_time | TIMESTAMP  | Not null                         |
| execution_end_time   | TIMESTAMP  | Not null                         |
| status               | STRING     | Not null                         |
| error_message        | STRING     | Nullable                         |
| load_date            | DATE       | Not null                         |
| update_date          | DATE       | Not null                         |
| source_system        | STRING     | Not null                         |

### Recommended Data Quality Checks:

1. [Null Check: Required Fields]
   - Description: Ensure all fields except error_message are not null.
   - Rationale: Audit tracking requires all fields.
   - SQL Example:
     ```sql
     SELECT * FROM silver.sv_audit
     WHERE audit_id IS NULL OR pipeline_name IS NULL OR execution_start_time IS NULL OR execution_end_time IS NULL
       OR status IS NULL OR load_date IS NULL OR update_date IS NULL OR source_system IS NULL;
     ```

2. [Uniqueness: audit_id]
   - Description: audit_id must be unique.
   - Rationale: Prevents duplicate audit records.
   - SQL Example:
     ```sql
     SELECT audit_id, COUNT(*) FROM silver.sv_audit
     GROUP BY audit_id HAVING COUNT(*) > 1;
     ```

---

## Table-level Checks (All Silver Tables)

1. [Row Count Validation]
   - Description: Ensure row counts are within expected ranges (e.g., no sudden drops or spikes).
   - Rationale: Detects data loss or duplication.
   - SQL Example:
     ```sql
     SELECT 'sv_yield_dining_inventory_snapshot' AS table_name, COUNT(*) AS row_count FROM silver.sv_yield_dining_inventory_snapshot
     UNION ALL
     SELECT 'sv_yield_guest_presence_log', COUNT(*) FROM silver.sv_yield_guest_presence_log
     UNION ALL
     SELECT 'sv_yield_micro_offer_events', COUNT(*) FROM silver.sv_yield_micro_offer_events
     UNION ALL
     SELECT 'sv_gold_yield_hunter_kpis', COUNT(*) FROM silver.sv_gold_yield_hunter_kpis;
     ```

2. [Data Freshness]
   - Description: Check that the most recent load_date/update_date is within SLA (e.g., last 1 hour/day).
   - Rationale: Ensures timely data refresh.
   - SQL Example:
     ```sql
     SELECT table_name, MAX(load_date) AS max_load_date, MAX(update_date) AS max_update_date
     FROM (
       SELECT 'sv_yield_dining_inventory_snapshot' AS table_name, load_date, update_date FROM silver.sv_yield_dining_inventory_snapshot
       UNION ALL
       SELECT 'sv_yield_guest_presence_log', load_date, update_date FROM silver.sv_yield_guest_presence_log
       UNION ALL
       SELECT 'sv_yield_micro_offer_events', load_date, update_date FROM silver.sv_yield_micro_offer_events
       UNION ALL
       SELECT 'sv_gold_yield_hunter_kpis', load_date, update_date FROM silver.sv_gold_yield_hunter_kpis
     )
     GROUP BY table_name;
     ```

---

## API Cost

apiCost: 0.006000 USD
