_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*:   Databricks Silver Layer Physical Data Model for Yield Management Application
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Databricks Silver Model Physical

This document defines the physical data model for the Silver layer of the Yield Management Application, based on the provided logical and Bronze models. The Silver layer stores cleansed, conformed data with added metadata for governance and lineage. All tables are implemented as Delta tables, following Databricks PySpark SQL standards.

---

## Silver Layer DDL Scripts

### 1. yield_dining_inventory_snapshot
```sql
CREATE TABLE IF NOT EXISTS silver.yield_dining_inventory_snapshot (
    inventory_snapshot_id   STRING,
    snapshot_ts_utc        TIMESTAMP,
    venue_id               STRING,
    venue_type             STRING,
    capacity_seats         INT,
    occupied_seats         INT,
    available_seats        INT,
    walkin_queue_size      INT,
    load_date              DATE,
    update_date            DATE,
    source_system          STRING
) USING DELTA
PARTITIONED BY (venue_id, load_date);
```

### 2. yield_guest_presence_log
```sql
CREATE TABLE IF NOT EXISTS silver.yield_guest_presence_log (
    guest_presence_id       STRING,
    event_ts_utc           TIMESTAMP,
    guest_id               STRING,
    location_id            STRING,
    zone_type              STRING,
    party_size             INT,
    dwell_seconds          INT,
    signal_confidence      FLOAT,
    load_date              DATE,
    update_date            DATE,
    source_system          STRING
) USING DELTA
PARTITIONED BY (guest_id, load_date);
```

### 3. yield_micro_offer_events
```sql
CREATE TABLE IF NOT EXISTS silver.yield_micro_offer_events (
    micro_offer_event_id    STRING,
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
    load_date              DATE,
    update_date            DATE,
    source_system          STRING
) USING DELTA
PARTITIONED BY (venue_id, load_date);
```

### 4. gold_yield_hunter_kpis
```sql
CREATE TABLE IF NOT EXISTS silver.gold_yield_hunter_kpis (
    kpi_id                  STRING,
    venue_id                STRING,
    hour                    TIMESTAMP,
    seats                   INT,
    occupied                FLOAT,
    available               FLOAT,
    occ_rate                FLOAT,
    low_occupancy_flag      INT,
    accepted                INT,
    expired                 INT,
    presented               INT,
    redeemed                INT,
    accept_rate             FLOAT,
    redeem_rate             FLOAT,
    revenue_usd             FLOAT,
    seats_filled_via_offers INT,
    load_date               DATE,
    update_date             DATE,
    source_system           STRING
) USING DELTA
PARTITIONED BY (venue_id, load_date);
```

### 5. Audit Table
```sql
CREATE TABLE IF NOT EXISTS silver.silver_audit (
    audit_id                STRING,
    pipeline_name           STRING,
    execution_start_time    TIMESTAMP,
    execution_end_time      TIMESTAMP,
    status                  STRING,
    error_message           STRING,
    load_date               DATE,
    update_date             DATE,
    source_system           STRING
) USING DELTA
PARTITIONED BY (load_date);
```

### 6. Error Data Table
```sql
CREATE TABLE IF NOT EXISTS silver.silver_error_data (
    error_id                STRING,
    table_name              STRING,
    record_id               STRING,
    error_type              STRING,
    error_description       STRING,
    error_ts                TIMESTAMP,
    load_date               DATE,
    update_date             DATE,
    source_system           STRING
) USING DELTA
PARTITIONED BY (table_name, load_date);
```

---

## Update DDL Script

If new columns are added or data types are changed, use the following template:

```sql
ALTER TABLE silver.<table_name> ADD COLUMNS (<new_column_name> <data_type>);
```

---

## Data Retention Policies

### Retention Periods for Silver Layer
- All Silver tables: 2 years rolling window (data older than 2 years is purged monthly).
- Audit and Error tables: 3 years retention for compliance.

### Archiving Strategies
- Data older than retention period is exported to cloud object storage (e.g., Azure Data Lake, AWS S3) in Parquet format before deletion.
- Partition pruning is used for efficient data management and query performance.

---

## Conceptual Data Model Diagram (Tabular Form)

| Source Table                      | Related Table(s)               | Relationship Key(s)           |
|-----------------------------------|--------------------------------|-------------------------------|
| yield_dining_inventory_snapshot   | yield_micro_offer_events       | venue_id                      |
| yield_guest_presence_log          | yield_micro_offer_events       | guest_id                      |
| yield_micro_offer_events          | gold_yield_hunter_kpis         | venue_id, hour                |
| gold_yield_hunter_kpis            |                                |                               |
| yield_micro_offer_events          | silver_error_data              | micro_offer_event_id          |
| yield_dining_inventory_snapshot   | silver_error_data              | inventory_snapshot_id         |
| yield_guest_presence_log          | silver_error_data              | guest_presence_id             |
| gold_yield_hunter_kpis            | silver_error_data              | kpi_id                        |
| silver_audit                      | silver_error_data              | audit_id                      |

---

## Assumptions & Design Decisions
- All tables are created in the `silver` schema and use descriptive names.
- Delta Lake format is used for all tables for ACID compliance and time travel.
- No primary keys, foreign keys, or constraints are enforced at the Silver layer (Databricks limitation).
- Metadata columns (`load_date`, `update_date`, `source_system`) are included for governance and lineage.
- Data types are mapped to Databricks PySpark SQL compatible types (STRING, INT, FLOAT, TIMESTAMP, DATE).
- The Audit table is used for tracking pipeline executions and status.
- The Error Data table is used for capturing data validation and transformation errors.
- Partitioning is applied on business keys and load_date for query performance and retention management.
- Data retention and archiving are managed via scheduled jobs and partition pruning.
- All Bronze columns are present in Silver tables, with additional id fields for each table.
- No PK/FK constraints are implemented due to Spark SQL limitations.

---

## API Cost

apiCost: 0.002000
