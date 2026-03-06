_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*:   Snowflake Silver Layer Physical Data Model for Yield Management Application
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Snowflake Silver Model Physical

This document defines the physical data model for the Silver layer of the Yield Management Application, based on the provided logical and bronze physical models. The Silver layer stores cleansed, conformed data, with additional error and audit tracking. All tables are implemented as Delta tables in the `silver` schema, following Snowflake SQL standards.

---

## Silver Layer DDL Scripts

### 1. Yield_Dining_Inventory_Snapshot
```sql
CREATE TABLE IF NOT EXISTS silver.sv_yield_dining_inventory_snapshot (
    id                      STRING,
    snapshot_ts_utc         TIMESTAMP,
    venue_id                STRING,
    venue_type              STRING,
    capacity_seats          INT,
    occupied_seats          INT,
    available_seats         INT,
    walkin_queue_size       INT,
    load_date               DATE,
    update_date             DATE,
    source_system           STRING
) USING DELTA;
```

### 2. Yield_Guest_Presence_Log
```sql
CREATE TABLE IF NOT EXISTS silver.sv_yield_guest_presence_log (
    id                      STRING,
    event_ts_utc            TIMESTAMP,
    guest_id                STRING,
    location_id             STRING,
    zone_type               STRING,
    party_size              INT,
    dwell_seconds           INT,
    signal_confidence       FLOAT,
    load_date               DATE,
    update_date             DATE,
    source_system           STRING
) USING DELTA;
```

### 3. Yield_Micro_Offer_Events
```sql
CREATE TABLE IF NOT EXISTS silver.sv_yield_micro_offer_events (
    id                      STRING,
    offer_ts_utc            TIMESTAMP,
    offer_id                STRING,
    guest_id                STRING,
    party_size              INT,
    target_zone             STRING,
    venue_id                STRING,
    discount_pct            INT,
    state                   STRING,
    redeemed_ts_utc         TIMESTAMP,
    estimated_revenue_usd   FLOAT,
    load_date               DATE,
    update_date             DATE,
    source_system           STRING
) USING DELTA;
```

### 4. Gold_Yield_Hunter_KPIs
```sql
CREATE TABLE IF NOT EXISTS silver.sv_gold_yield_hunter_kpis (
    id                          STRING,
    venue_id                    STRING,
    hour                        TIMESTAMP,
    seats                       INT,
    occupied                    FLOAT,
    available                   FLOAT,
    occ_rate                    FLOAT,
    low_occupancy_flag          INT,
    accepted                    INT,
    expired                     INT,
    presented                   INT,
    redeemed                    INT,
    accept_rate                 FLOAT,
    redeem_rate                 FLOAT,
    revenue_usd                 FLOAT,
    seats_filled_via_offers     INT,
    load_date                   DATE,
    update_date                 DATE,
    source_system               STRING
) USING DELTA;
```

---

## Error Data Table DDL Script

```sql
CREATE TABLE IF NOT EXISTS silver.sv_error_data (
    error_id                STRING,
    table_name              STRING,
    record_id               STRING,
    error_type              STRING,
    error_message           STRING,
    error_timestamp         TIMESTAMP,
    pipeline_stage          STRING,
    load_date               DATE,
    update_date             DATE,
    source_system           STRING
) USING DELTA;
```

---

## Audit Table DDL Script

```sql
CREATE TABLE IF NOT EXISTS silver.sv_audit (
    audit_id                STRING,
    pipeline_name           STRING,
    execution_start_time    TIMESTAMP,
    execution_end_time      TIMESTAMP,
    status                  STRING,
    error_message           STRING,
    load_date               DATE,
    update_date             DATE,
    source_system           STRING
) USING DELTA;
```

---

## Update DDL Script

If new columns are added or data types are changed, use the following template:

```sql
ALTER TABLE silver.<table_name> ADD COLUMN <column_name> <data_type>;
-- Example:
-- ALTER TABLE silver.sv_yield_dining_inventory_snapshot ADD COLUMN new_col STRING;
```

---

## Data Retention Policies

### Retention Periods for Silver Layer
- All Silver tables: 2 years rolling window (data older than 2 years is purged monthly).
- Error and audit tables: 3 years retention for compliance.

### Archiving Strategies
- Data older than retention period is exported to long-term cloud storage (e.g., S3/Blob) in Parquet format before deletion.
- Audit and error tables are snapshotted quarterly for compliance.

---

## Conceptual Data Model Diagram (Tabular Form)

| Source Table                        | Related Table(s)                 | Relationship Key(s)           |
|-------------------------------------|----------------------------------|-------------------------------|
| sv_yield_dining_inventory_snapshot  | sv_yield_micro_offer_events      | venue_id                      |
| sv_yield_guest_presence_log         | sv_yield_micro_offer_events      | guest_id                      |
| sv_yield_micro_offer_events         | sv_gold_yield_hunter_kpis        | venue_id, hour                |
| sv_gold_yield_hunter_kpis           |                                  |                               |
| sv_error_data                       | All Silver Tables                | record_id                     |
| sv_audit                            | All Silver Tables                | pipeline_name                 |

---

## Assumptions & Design Decisions
- All tables are created in the `silver` schema and prefixed with `sv_`.
- Delta Lake format is used for all tables.
- No primary keys, foreign keys, or constraints are enforced at the Silver layer.
- Metadata columns (`load_date`, `update_date`, `source_system`) are included for governance and lineage.
- Data types are mapped to Snowflake SQL compatible types (STRING, INT, FLOAT, TIMESTAMP, DATE).
- The Error Data table is used for tracking data validation and transformation errors.
- The Audit table is used for tracking pipeline execution and status.
- The conceptual model is based on logical relationships inferred from shared keys (e.g., venue_id, guest_id).
- All columns from the Bronze layer are present, with additional id fields and metadata columns.
- Data retention and archiving policies are defined for compliance and cost management.

---

## API Cost

apiCost: 0.004000
