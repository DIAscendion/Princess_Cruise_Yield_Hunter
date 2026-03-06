_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*:   Snowflake Silver Layer Data Quality Data Mapping for Yield Management Application
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Overview
This document provides a comprehensive data mapping from the Bronze Layer to the Silver Layer for the Yield Management Application in Snowflake. It details attribute-level cleansing, validation, and business rules, ensuring data quality, consistency, and traceability. The mapping covers all Bronze tables, error data, and audit tables, and is compatible with Snowflake Stored Procedures.

---

# Data Mapping for the Silver Layer

## Table: Yield_Dining_Inventory_Snapshot

| Target Layer | Target Table                          | Target Field        | Source Layer | Source Table                        | Source Field        | Validation Rule                | Transformation Rule                                  |
|--------------|--------------------------------------|---------------------|--------------|-------------------------------------|---------------------|-------------------------------|------------------------------------------------------|
| Silver       | sv_yield_dining_inventory_snapshot    | id                  | Bronze       | bz_yield_dining_inventory_snapshot  | (generated)         | Unique, Not null              | Generate UUID or hash of venue_id+snapshot_ts_utc    |
| Silver       | sv_yield_dining_inventory_snapshot    | snapshot_ts_utc     | Bronze       | bz_yield_dining_inventory_snapshot  | snapshot_ts_utc     | Not null, Valid UTC timestamp | Convert to UTC if needed                             |
| Silver       | sv_yield_dining_inventory_snapshot    | venue_id            | Bronze       | bz_yield_dining_inventory_snapshot  | venue_id            | Not null, Consistent          | Standardize/case-normalize                           |
| Silver       | sv_yield_dining_inventory_snapshot    | venue_type          | Bronze       | bz_yield_dining_inventory_snapshot  | venue_type          | Not null                      | Standardize values                                   |
| Silver       | sv_yield_dining_inventory_snapshot    | capacity_seats      | Bronze       | bz_yield_dining_inventory_snapshot  | capacity_seats      | Not null, Integer >= 0        | Cast to INT, set to 0 if null                       |
| Silver       | sv_yield_dining_inventory_snapshot    | occupied_seats      | Bronze       | bz_yield_dining_inventory_snapshot  | occupied_seats      | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_yield_dining_inventory_snapshot    | available_seats     | Bronze       | bz_yield_dining_inventory_snapshot  | available_seats     | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_yield_dining_inventory_snapshot    | walkin_queue_size   | Bronze       | bz_yield_dining_inventory_snapshot  | walkin_queue_size   | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_yield_dining_inventory_snapshot    | load_date           | Bronze       | bz_yield_dining_inventory_snapshot  | load_timestamp      | Not null                      | Extract DATE from TIMESTAMP                         |
| Silver       | sv_yield_dining_inventory_snapshot    | update_date         | Bronze       | bz_yield_dining_inventory_snapshot  | update_timestamp    | Not null                      | Extract DATE from TIMESTAMP                         |
| Silver       | sv_yield_dining_inventory_snapshot    | source_system       | Bronze       | bz_yield_dining_inventory_snapshot  | source_system       | Not null                      | Standardize values                                   |

## Table: Yield_Guest_Presence_Log

| Target Layer | Target Table                       | Target Field      | Source Layer | Source Table                     | Source Field      | Validation Rule                | Transformation Rule                                  |
|--------------|-----------------------------------|-------------------|--------------|----------------------------------|-------------------|-------------------------------|------------------------------------------------------|
| Silver       | sv_yield_guest_presence_log        | id                | Bronze       | bz_yield_guest_presence_log      | (generated)       | Unique, Not null              | Generate UUID or hash of guest_id+event_ts_utc       |
| Silver       | sv_yield_guest_presence_log        | event_ts_utc      | Bronze       | bz_yield_guest_presence_log      | event_ts_utc      | Not null, Valid UTC timestamp | Convert to UTC if needed                             |
| Silver       | sv_yield_guest_presence_log        | guest_id          | Bronze       | bz_yield_guest_presence_log      | guest_id          | Not null, Consistent          | Standardize/case-normalize                           |
| Silver       | sv_yield_guest_presence_log        | location_id       | Bronze       | bz_yield_guest_presence_log      | location_id       | Not null                      | Standardize values                                   |
| Silver       | sv_yield_guest_presence_log        | zone_type         | Bronze       | bz_yield_guest_presence_log      | zone_type         | Not null                      | Standardize values                                   |
| Silver       | sv_yield_guest_presence_log        | party_size        | Bronze       | bz_yield_guest_presence_log      | party_size        | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_yield_guest_presence_log        | dwell_seconds     | Bronze       | bz_yield_guest_presence_log      | dwell_seconds     | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_yield_guest_presence_log        | signal_confidence | Bronze       | bz_yield_guest_presence_log      | signal_confidence | Float 0-1                     | Clamp to [0,1], set to null if out of range         |
| Silver       | sv_yield_guest_presence_log        | load_date         | Bronze       | bz_yield_guest_presence_log      | load_timestamp    | Not null                      | Extract DATE from TIMESTAMP                         |
| Silver       | sv_yield_guest_presence_log        | update_date       | Bronze       | bz_yield_guest_presence_log      | update_timestamp  | Not null                      | Extract DATE from TIMESTAMP                         |
| Silver       | sv_yield_guest_presence_log        | source_system     | Bronze       | bz_yield_guest_presence_log      | source_system     | Not null                      | Standardize values                                   |

## Table: Yield_Micro_Offer_Events

| Target Layer | Target Table                       | Target Field            | Source Layer | Source Table                     | Source Field            | Validation Rule                | Transformation Rule                                  |
|--------------|-----------------------------------|-------------------------|--------------|----------------------------------|-------------------------|-------------------------------|------------------------------------------------------|
| Silver       | sv_yield_micro_offer_events        | id                      | Bronze       | bz_yield_micro_offer_events      | (generated)             | Unique, Not null              | Generate UUID or hash of offer_id+offer_ts_utc       |
| Silver       | sv_yield_micro_offer_events        | offer_ts_utc            | Bronze       | bz_yield_micro_offer_events      | offer_ts_utc            | Not null, Valid UTC timestamp | Convert to UTC if needed                             |
| Silver       | sv_yield_micro_offer_events        | offer_id                | Bronze       | bz_yield_micro_offer_events      | offer_id                | Not null, Unique              | Standardize/case-normalize                           |
| Silver       | sv_yield_micro_offer_events        | guest_id                | Bronze       | bz_yield_micro_offer_events      | guest_id                | Not null, Consistent          | Standardize/case-normalize                           |
| Silver       | sv_yield_micro_offer_events        | party_size              | Bronze       | bz_yield_micro_offer_events      | party_size              | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_yield_micro_offer_events        | target_zone             | Bronze       | bz_yield_micro_offer_events      | target_zone             | Not null                      | Standardize values                                   |
| Silver       | sv_yield_micro_offer_events        | venue_id                | Bronze       | bz_yield_micro_offer_events      | venue_id                | Not null, Consistent          | Standardize/case-normalize                           |
| Silver       | sv_yield_micro_offer_events        | discount_pct            | Bronze       | bz_yield_micro_offer_events      | discount_pct            | Integer 0-100                 | Clamp to [0,100], set to null if out of range        |
| Silver       | sv_yield_micro_offer_events        | state                   | Bronze       | bz_yield_micro_offer_events      | state                   | Not null, Valid state         | Map to allowed values (presented, accepted, etc.)    |
| Silver       | sv_yield_micro_offer_events        | redeemed_ts_utc         | Bronze       | bz_yield_micro_offer_events      | redeemed_ts_utc         | Valid UTC timestamp           | Convert to UTC if needed                             |
| Silver       | sv_yield_micro_offer_events        | estimated_revenue_usd   | Bronze       | bz_yield_micro_offer_events      | estimated_revenue_usd   | Float >= 0                    | Cast to FLOAT, set to 0 if null                     |
| Silver       | sv_yield_micro_offer_events        | load_date               | Bronze       | bz_yield_micro_offer_events      | load_timestamp          | Not null                      | Extract DATE from TIMESTAMP                         |
| Silver       | sv_yield_micro_offer_events        | update_date             | Bronze       | bz_yield_micro_offer_events      | update_timestamp        | Not null                      | Extract DATE from TIMESTAMP                         |
| Silver       | sv_yield_micro_offer_events        | source_system           | Bronze       | bz_yield_micro_offer_events      | source_system           | Not null                      | Standardize values                                   |

## Table: Gold_Yield_Hunter_KPIs

| Target Layer | Target Table                       | Target Field            | Source Layer | Source Table                     | Source Field            | Validation Rule                | Transformation Rule                                  |
|--------------|-----------------------------------|-------------------------|--------------|----------------------------------|-------------------------|-------------------------------|------------------------------------------------------|
| Silver       | sv_gold_yield_hunter_kpis         | id                      | Bronze       | bz_gold_yield_hunter_kpis        | (generated)             | Unique, Not null              | Generate UUID or hash of venue_id+hour               |
| Silver       | sv_gold_yield_hunter_kpis         | venue_id                | Bronze       | bz_gold_yield_hunter_kpis        | venue_id                | Not null, Consistent          | Standardize/case-normalize                           |
| Silver       | sv_gold_yield_hunter_kpis         | hour                    | Bronze       | bz_gold_yield_hunter_kpis        | hour                    | Not null, Valid UTC timestamp | Convert to UTC if needed                             |
| Silver       | sv_gold_yield_hunter_kpis         | seats                   | Bronze       | bz_gold_yield_hunter_kpis        | seats                   | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_gold_yield_hunter_kpis         | occupied                | Bronze       | bz_gold_yield_hunter_kpis        | occupied                | Float >= 0                    | Cast to FLOAT, set to 0 if null                     |
| Silver       | sv_gold_yield_hunter_kpis         | available               | Bronze       | bz_gold_yield_hunter_kpis        | available               | Float >= 0                    | Cast to FLOAT, set to 0 if null                     |
| Silver       | sv_gold_yield_hunter_kpis         | occ_rate                | Bronze       | bz_gold_yield_hunter_kpis        | occ_rate                | Float 0-1                     | Clamp to [0,1], set to null if out of range         |
| Silver       | sv_gold_yield_hunter_kpis         | low_occupancy_flag      | Bronze       | bz_gold_yield_hunter_kpis        | low_occupancy_flag      | Boolean (0/1)                 | Cast to INT, set to 0 if null                       |
| Silver       | sv_gold_yield_hunter_kpis         | accepted                | Bronze       | bz_gold_yield_hunter_kpis        | accepted                | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_gold_yield_hunter_kpis         | expired                 | Bronze       | bz_gold_yield_hunter_kpis        | expired                 | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_gold_yield_hunter_kpis         | presented               | Bronze       | bz_gold_yield_hunter_kpis        | presented               | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_gold_yield_hunter_kpis         | redeemed                | Bronze       | bz_gold_yield_hunter_kpis        | redeemed                | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_gold_yield_hunter_kpis         | accept_rate             | Bronze       | bz_gold_yield_hunter_kpis        | accept_rate             | Float 0-1                     | Clamp to [0,1], set to null if out of range         |
| Silver       | sv_gold_yield_hunter_kpis         | redeem_rate             | Bronze       | bz_gold_yield_hunter_kpis        | redeem_rate             | Float 0-1                     | Clamp to [0,1], set to null if out of range         |
| Silver       | sv_gold_yield_hunter_kpis         | revenue_usd             | Bronze       | bz_gold_yield_hunter_kpis        | revenue_usd             | Float >= 0                    | Cast to FLOAT, set to 0 if null                     |
| Silver       | sv_gold_yield_hunter_kpis         | seats_filled_via_offers | Bronze       | bz_gold_yield_hunter_kpis        | seats_filled_via_offers | Integer >= 0                  | Cast to INT, set to 0 if null                       |
| Silver       | sv_gold_yield_hunter_kpis         | load_date               | Bronze       | bz_gold_yield_hunter_kpis        | load_timestamp          | Not null                      | Extract DATE from TIMESTAMP                         |
| Silver       | sv_gold_yield_hunter_kpis         | update_date             | Bronze       | bz_gold_yield_hunter_kpis        | update_timestamp        | Not null                      | Extract DATE from TIMESTAMP                         |
| Silver       | sv_gold_yield_hunter_kpis         | source_system           | Bronze       | bz_gold_yield_hunter_kpis        | source_system_metadata  | Not null                      | Standardize values                                   |

## Table: Error Data Table

| Target Layer | Target Table         | Target Field      | Source Layer | Source Table | Source Field      | Validation Rule                | Transformation Rule                                  |
|--------------|---------------------|-------------------|--------------|--------------|-------------------|-------------------------------|------------------------------------------------------|
| Silver       | sv_error_data       | error_id          | Bronze       | (N/A)        | (generated)       | Unique, Not null              | Generate UUID                                         |
| Silver       | sv_error_data       | table_name        | Bronze       | (N/A)        | (N/A)             | Not null                      | Populated by pipeline                                 |
| Silver       | sv_error_data       | record_id         | Bronze       | (N/A)        | (N/A)             | Not null                      | Populated by pipeline                                 |
| Silver       | sv_error_data       | error_type        | Bronze       | (N/A)        | (N/A)             | Not null                      | Populated by pipeline                                 |
| Silver       | sv_error_data       | error_message     | Bronze       | (N/A)        | (N/A)             | Not null                      | Populated by pipeline                                 |
| Silver       | sv_error_data       | error_timestamp   | Bronze       | (N/A)        | (N/A)             | Not null                      | Populated by pipeline                                 |
| Silver       | sv_error_data       | pipeline_stage    | Bronze       | (N/A)        | (N/A)             | Not null                      | Populated by pipeline                                 |
| Silver       | sv_error_data       | load_date         | Bronze       | (N/A)        | (N/A)             | Not null                      | Populated by pipeline                                 |
| Silver       | sv_error_data       | update_date       | Bronze       | (N/A)        | (N/A)             | Not null                      | Populated by pipeline                                 |
| Silver       | sv_error_data       | source_system     | Bronze       | (N/A)        | (N/A)             | Not null                      | Populated by pipeline                                 |

## Table: Audit Table

| Target Layer | Target Table         | Target Field           | Source Layer | Source Table | Source Field           | Validation Rule                | Transformation Rule                                  |
|--------------|---------------------|------------------------|--------------|--------------|------------------------|-------------------------------|------------------------------------------------------|
| Silver       | sv_audit            | audit_id               | Bronze       | bz_audit     | record_id              | Unique, Not null              | Generate UUID if not present                         |
| Silver       | sv_audit            | pipeline_name          | Bronze       | bz_audit     | source_table           | Not null                      | Standardize values                                   |
| Silver       | sv_audit            | execution_start_time   | Bronze       | bz_audit     | load_timestamp         | Not null, Valid timestamp     | Use load_timestamp                                   |
| Silver       | sv_audit            | execution_end_time     | Bronze       | bz_audit     | update_timestamp       | Not null, Valid timestamp     | Use update_timestamp                                 |
| Silver       | sv_audit            | status                 | Bronze       | bz_audit     | status                 | Not null                      | Standardize values                                   |
| Silver       | sv_audit            | error_message          | Bronze       | bz_audit     | (N/A)                  | Nullable                      | Populated by pipeline                                 |
| Silver       | sv_audit            | load_date              | Bronze       | bz_audit     | load_timestamp         | Not null                      | Extract DATE from TIMESTAMP                         |
| Silver       | sv_audit            | update_date            | Bronze       | bz_audit     | update_timestamp       | Not null                      | Extract DATE from TIMESTAMP                         |
| Silver       | sv_audit            | source_system          | Bronze       | bz_audit     | processed_by           | Not null                      | Standardize values                                   |

---

# Explanations for Complex Rules
- **ID Generation**: All Silver tables introduce a unique `id` field, generated as a UUID or hash of key fields to ensure uniqueness and traceability.
- **Timestamps**: All timestamps are validated for UTC compliance and converted if necessary. Date fields are extracted for partitioning and lineage.
- **State/Flag Standardization**: All state and flag fields are mapped to a controlled vocabulary (e.g., presented, accepted, redeemed, expired; 0/1 for booleans).
- **Data Type Enforcement**: All numeric fields are cast to their target types, with nulls defaulted to 0 where appropriate.
- **Error Handling**: Records failing validation are logged in `sv_error_data` with error details and pipeline stage.
- **Audit Logging**: All pipeline executions are logged in `sv_audit` for traceability and compliance.

# Recommendations for Error Handling and Logging
- All validation failures should be captured in `sv_error_data` with detailed error messages and context.
- Implement pipeline-level try/catch blocks to ensure failed records do not halt processing.
- Audit logs should capture pipeline execution metadata, including start/end times, status, and errors.
- Regularly review error and audit tables for recurring issues and pipeline improvements.

# API Cost
Bronze Model API Cost: 0.002000
Silver Model API Cost: 0.004000
**Total API Cost for this call: 0.006000 USD**

---

# Output URL
https://github.com/DIAscendion/Princess_Cruise_Yield_Hunter/tree/main/DI_Snowflake_Silver_DQ_Data_Mapping_DIAS

# Pipeline ID
13838
