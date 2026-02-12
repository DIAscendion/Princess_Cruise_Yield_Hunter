_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*:   Snowflake Bronze Layer Physical Data Model for Yield Management Application
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Snowflake Bronze Model Physical

This document defines the physical data model for the Bronze layer of the Yield Management Application, based on the provided logical model. The Bronze layer stores raw, untransformed data with added metadata for governance and lineage. All tables are implemented as Delta tables in the `bronze` schema, following Snowflake SQL standards.

---

## Bronze Layer DDL Scripts

### 1. Yield_Dining_Inventory_Snapshot
```sql
CREATE TABLE IF NOT EXISTS bronze.bz_yield_dining_inventory_snapshot (
    snapshot_ts_utc        TIMESTAMP,
    venue_id               STRING,
    venue_type             STRING,
    capacity_seats         INT,
    occupied_seats         INT,
    available_seats        INT,
    walkin_queue_size      INT,
    source_system          STRING,
    load_timestamp         TIMESTAMP,
    update_timestamp       TIMESTAMP,
    source_system_metadata STRING
) USING DELTA;
```

### 2. Yield_Guest_Presence_Log
```sql
CREATE TABLE IF NOT EXISTS bronze.bz_yield_guest_presence_log (
    event_ts_utc           TIMESTAMP,
    guest_id               STRING,
    location_id            STRING,
    zone_type              STRING,
    party_size             INT,
    dwell_seconds          INT,
    signal_confidence      FLOAT,
    source_system          STRING,
    load_timestamp         TIMESTAMP,
    update_timestamp       TIMESTAMP,
    source_system_metadata STRING
) USING DELTA;
```

### 3. Yield_Micro_Offer_Events
```sql
CREATE TABLE IF NOT EXISTS bronze.bz_yield_micro_offer_events (
    offer_ts_utc           TIMESTAMP,
    offer_id               STRING,
    guest_id               STRING,
    party_size             INT,
    target_zone            STRING,
    venue_id               STRING,
    discount_pct           INT,
    state                  STRING,
    redeemed_ts_utc        TIMESTAMP,
    estimated_revenue_usd  FLOAT,
    source_system          STRING,
    load_timestamp         TIMESTAMP,
    update_timestamp       TIMESTAMP,
    source_system_metadata STRING
) USING DELTA;
```

### 4. Gold_Yield_Hunter_KPIs
```sql
CREATE TABLE IF NOT EXISTS bronze.bz_gold_yield_hunter_kpis (
    venue_id               STRING,
    hour                   TIMESTAMP,
    seats                  INT,
    occupied               FLOAT,
    available              FLOAT,
    occ_rate               FLOAT,
    low_occupancy_flag     INT,
    accepted               INT,
    expired                INT,
    presented              INT,
    redeemed               INT,
    accept_rate            FLOAT,
    redeem_rate            FLOAT,
    revenue_usd            FLOAT,
    seats_filled_via_offers INT,
    load_timestamp         TIMESTAMP,
    update_timestamp       TIMESTAMP,
    source_system_metadata STRING
) USING DELTA;
```

### 5. Audit Table
```sql
CREATE TABLE IF NOT EXISTS bronze.bz_audit (
    record_id              STRING,
    source_table           STRING,
    load_timestamp         TIMESTAMP,
    processed_by           STRING,
    processing_time        FLOAT,
    status                 STRING
) USING DELTA;
```

---

## Conceptual Data Model Diagram (Tabular Form)

| Source Table                        | Related Table(s)                 | Relationship Key(s)           |
|-------------------------------------|----------------------------------|-------------------------------|
| Yield_Dining_Inventory_Snapshot     | Yield_Micro_Offer_Events         | venue_id                      |
| Yield_Guest_Presence_Log            | Yield_Micro_Offer_Events         | guest_id                      |
| Yield_Micro_Offer_Events            | Gold_Yield_Hunter_KPIs           | venue_id, hour                |
| Gold_Yield_Hunter_KPIs              |                                  |                               |

---

## Assumptions & Design Decisions

- All tables are created in the `bronze` schema and prefixed with `bz_`.
- Delta Lake format is used for all tables.
- No primary keys, foreign keys, or constraints are enforced at the Bronze layer.
- Metadata columns (`load_timestamp`, `update_timestamp`, `source_system_metadata`) are included for governance and lineage.
- Data types are mapped to Snowflake SQL compatible types (STRING, INT, FLOAT, TIMESTAMP).
- The Audit table is used for tracking data ingestion and processing status.
- The conceptual model is based on logical relationships inferred from shared keys (e.g., venue_id, guest_id).
- `source_system_metadata` is included as a generic metadata column for extensibility.

---

## API Cost

apiCost: 0.002000
