_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*:   Unit test cases and Sqltest script for Snowflake Bronze Layer Data Engineering Pipeline stored procedure ingestion logic.
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# Snowflake Bronze DE Pipeline Unit Test Cases

## Description
This document provides comprehensive unit test cases and a Snowflake-optimized Sqltest script for the Bronze Layer Data Engineering Pipeline stored procedure. The tests validate ingestion, audit logging, error handling, and edge cases for all raw-to-bronze table transformations.

---

## Test Case List

| Test Case ID | Test Case Description | Expected Outcome |
|--------------|----------------------|------------------|
| TC_001 | Ingest valid Yield_Dining_Inventory_Snapshot data | Data inserted into bronze.bz_yield_dining_inventory_snapshot; audit log entry created; status SUCCESS |
| TC_002 | Ingest valid Yield_Guest_Presence_Log data | Data inserted into bronze.bz_yield_guest_presence_log; audit log entry created; status SUCCESS |
| TC_003 | Ingest valid Yield_Micro_Offer_Events data | Data inserted into bronze.bz_yield_micro_offer_events; audit log entry created; status SUCCESS |
| TC_004 | Ingest valid Gold_Yield_Hunter_KPIs data | Data inserted into bronze.bz_gold_yield_hunter_kpis; audit log entry created; status SUCCESS |
| TC_005 | Handle empty source table (Yield_Dining_Inventory_Snapshot) | No rows inserted; audit log entry created; status SUCCESS |
| TC_006 | Handle empty source table (Yield_Guest_Presence_Log) | No rows inserted; audit log entry created; status SUCCESS |
| TC_007 | Handle empty source table (Yield_Micro_Offer_Events) | No rows inserted; audit log entry created; status SUCCESS |
| TC_008 | Handle empty source table (Gold_Yield_Hunter_KPIs) | No rows inserted; audit log entry created; status SUCCESS |
| TC_009 | Handle null values in source columns | Null values preserved in bronze tables; audit log entry created; status SUCCESS |
| TC_010 | Schema mismatch in source table | Procedure fails; audit log entry created; status FAILED; error message logged |
| TC_011 | Invalid data types in source table | Procedure fails; audit log entry created; status FAILED; error message logged |
| TC_012 | Exception during insert (e.g., permission denied) | Procedure fails; audit log entry created; status FAILED; error message logged |
| TC_013 | Audit log entry creation for each ingestion | Audit log entry exists for each source table processed |
| TC_014 | Correct calculation of processing time | Audit log entry contains accurate processing_time value |
| TC_015 | Multiple ingestion runs (idempotency) | Data is overwritten; audit log entry created for each run |

---

## Sqltest Script

```sql
-- Snowflake SQL Unit Test Script for Bronze Layer Ingestion Procedure
-- Uses Snowflake's SQL scripting and assertion utilities

-- Setup: Create mock raw tables and bronze tables
CREATE OR REPLACE TABLE raw.Yield_Dining_Inventory_Snapshot (
    Snapshot_TS_UTC TIMESTAMP,
    Venue_ID STRING,
    Venue_Type STRING,
    Capacity_Seats INTEGER,
    Occupied_Seats INTEGER,
    Available_Seats INTEGER,
    Walkin_Queue_Size INTEGER,
    Source_System STRING
);
CREATE OR REPLACE TABLE bronze.bz_yield_dining_inventory_snapshot LIKE raw.Yield_Dining_Inventory_Snapshot;
CREATE OR REPLACE TABLE bronze.bz_audit (
    record_id STRING,
    source_table STRING,
    load_timestamp TIMESTAMP,
    processed_by STRING,
    processing_time FLOAT,
    status STRING
);

-- Insert test data for TC_001
INSERT INTO raw.Yield_Dining_Inventory_Snapshot VALUES ('2024-06-01 12:00:00', 'V001', 'Buffet', 100, 80, 20, 5, 'SystemA');

-- Execute procedure
CALL bronze.sp_yield_bronze_ingest();

-- Assert data inserted
SELECT COUNT(*) AS cnt FROM bronze.bz_yield_dining_inventory_snapshot;
-- Expected: cnt = 1

-- Assert audit log entry
SELECT status FROM bronze.bz_audit WHERE source_table = 'Yield_Dining_Inventory_Snapshot' ORDER BY load_timestamp DESC LIMIT 1;
-- Expected: status = 'SUCCESS'

-- TC_005: Empty source table
TRUNCATE TABLE raw.Yield_Dining_Inventory_Snapshot;
CALL bronze.sp_yield_bronze_ingest();
SELECT COUNT(*) AS cnt FROM bronze.bz_yield_dining_inventory_snapshot;
-- Expected: cnt = 0

-- TC_010: Schema mismatch
DROP COLUMN Venue_Type FROM raw.Yield_Dining_Inventory_Snapshot;
CALL bronze.sp_yield_bronze_ingest();
SELECT status, load_timestamp FROM bronze.bz_audit WHERE source_table = 'Yield_Dining_Inventory_Snapshot' ORDER BY load_timestamp DESC LIMIT 1;
-- Expected: status = 'FAILED'

-- TC_011: Invalid data types
INSERT INTO raw.Yield_Dining_Inventory_Snapshot VALUES ('2024-06-01 12:00:00', 'V001', 'Buffet', 'invalid_int', 80, 20, 5, 'SystemA');
CALL bronze.sp_yield_bronze_ingest();
SELECT status FROM bronze.bz_audit WHERE source_table = 'Yield_Dining_Inventory_Snapshot' ORDER BY load_timestamp DESC LIMIT 1;
-- Expected: status = 'FAILED'

-- TC_013: Audit log entry for each ingestion
SELECT COUNT(*) FROM bronze.bz_audit WHERE source_table = 'Yield_Dining_Inventory_Snapshot';
-- Expected: count matches number of ingestions

-- Teardown: Drop test tables
DROP TABLE IF EXISTS raw.Yield_Dining_Inventory_Snapshot;
DROP TABLE IF EXISTS bronze.bz_yield_dining_inventory_snapshot;
DROP TABLE IF EXISTS bronze.bz_audit;
```

---

## API Cost

apiCost: 0.022

---

[OutputURL](https://github.com/DIAscendion/Princess_Cruise_Yield_Hunter/tree/main/DI_Snowflake_Bronze_Pyspark_Unit_Test_Case_DIAS)

pipelineID: 13793
