_____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Data mapping for Bronze layer ingestion of Yield Management source tables into Snowflake, preserving original structure and metadata.
## *Version*: 1
## *Updated on*: 
_____________________________________________

# Data Mapping for Bronze Layer

This mapping defines the ingestion of raw source data from Yield Management tables into the Bronze layer of Snowflake, ensuring one-to-one mapping and preservation of original structure and metadata.

---

## Mapping Table

| Target Layer | Target Table                   | Target Field           | Source Layer | Source Table                  | Source Field           | Transformation Rule |
|--------------|-------------------------------|------------------------|--------------|-------------------------------|------------------------|---------------------|
| Bronze       | Yield_Dining_Inventory_Snapshot| Snapshot_TS_UTC        | Source       | Yield_Dining_Inventory_Snapshot| Snapshot_TS_UTC        | 1-1 Mapping         |
| Bronze       | Yield_Dining_Inventory_Snapshot| Venue_ID               | Source       | Yield_Dining_Inventory_Snapshot| Venue_ID               | 1-1 Mapping         |
| Bronze       | Yield_Dining_Inventory_Snapshot| Venue_Type             | Source       | Yield_Dining_Inventory_Snapshot| Venue_Type             | 1-1 Mapping         |
| Bronze       | Yield_Dining_Inventory_Snapshot| Capacity_Seats         | Source       | Yield_Dining_Inventory_Snapshot| Capacity_Seats         | 1-1 Mapping         |
| Bronze       | Yield_Dining_Inventory_Snapshot| Occupied_Seats         | Source       | Yield_Dining_Inventory_Snapshot| Occupied_Seats         | 1-1 Mapping         |
| Bronze       | Yield_Dining_Inventory_Snapshot| Available_Seats        | Source       | Yield_Dining_Inventory_Snapshot| Available_Seats        | 1-1 Mapping         |
| Bronze       | Yield_Dining_Inventory_Snapshot| Walkin_Queue_Size      | Source       | Yield_Dining_Inventory_Snapshot| Walkin_Queue_Size      | 1-1 Mapping         |
| Bronze       | Yield_Dining_Inventory_Snapshot| Source_System          | Source       | Yield_Dining_Inventory_Snapshot| Source_System          | 1-1 Mapping         |
| Bronze       | Yield_Guest_Presence_Log       | Event_TS_UTC           | Source       | Yield_Guest_Presence_Log       | Event_TS_UTC           | 1-1 Mapping         |
| Bronze       | Yield_Guest_Presence_Log       | Guest_ID               | Source       | Yield_Guest_Presence_Log       | Guest_ID               | 1-1 Mapping         |
| Bronze       | Yield_Guest_Presence_Log       | Location_ID            | Source       | Yield_Guest_Presence_Log       | Location_ID            | 1-1 Mapping         |
| Bronze       | Yield_Guest_Presence_Log       | Zone_Type              | Source       | Yield_Guest_Presence_Log       | Zone_Type              | 1-1 Mapping         |
| Bronze       | Yield_Guest_Presence_Log       | Party_Size             | Source       | Yield_Guest_Presence_Log       | Party_Size             | 1-1 Mapping         |
| Bronze       | Yield_Guest_Presence_Log       | Dwell_Seconds          | Source       | Yield_Guest_Presence_Log       | Dwell_Seconds          | 1-1 Mapping         |
| Bronze       | Yield_Guest_Presence_Log       | Signal_Confidence      | Source       | Yield_Guest_Presence_Log       | Signal_Confidence      | 1-1 Mapping         |
| Bronze       | Yield_Guest_Presence_Log       | Source_System          | Source       | Yield_Guest_Presence_Log       | Source_System          | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | Offer_TS_UTC           | Source       | Yield_Micro_Offer_Events       | Offer_TS_UTC           | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | Offer_ID               | Source       | Yield_Micro_Offer_Events       | Offer_ID               | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | Guest_ID               | Source       | Yield_Micro_Offer_Events       | Guest_ID               | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | Party_Size             | Source       | Yield_Micro_Offer_Events       | Party_Size             | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | Target_Zone            | Source       | Yield_Micro_Offer_Events       | Target_Zone            | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | Venue_ID               | Source       | Yield_Micro_Offer_Events       | Venue_ID               | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | Discount_Pct           | Source       | Yield_Micro_Offer_Events       | Discount_Pct           | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | State                  | Source       | Yield_Micro_Offer_Events       | State                  | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | Redeemed_TS_UTC        | Source       | Yield_Micro_Offer_Events       | Redeemed_TS_UTC        | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | Estimated_Revenue_USD  | Source       | Yield_Micro_Offer_Events       | Estimated_Revenue_USD  | 1-1 Mapping         |
| Bronze       | Yield_Micro_Offer_Events       | Source_System          | Source       | Yield_Micro_Offer_Events       | Source_System          | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Venue_ID               | Source       | Gold_Yield_Hunter_KPIs         | Venue_ID               | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Hour                   | Source       | Gold_Yield_Hunter_KPIs         | Hour                   | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Seats                  | Source       | Gold_Yield_Hunter_KPIs         | Seats                  | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Occupied               | Source       | Gold_Yield_Hunter_KPIs         | Occupied               | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Available              | Source       | Gold_Yield_Hunter_KPIs         | Available              | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Occ_Rate               | Source       | Gold_Yield_Hunter_KPIs         | Occ_Rate               | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Low_Occupancy_Flag     | Source       | Gold_Yield_Hunter_KPIs         | Low_Occupancy_Flag     | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Accepted               | Source       | Gold_Yield_Hunter_KPIs         | Accepted               | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Expired                | Source       | Gold_Yield_Hunter_KPIs         | Expired                | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Presented              | Source       | Gold_Yield_Hunter_KPIs         | Presented              | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Redeemed               | Source       | Gold_Yield_Hunter_KPIs         | Redeemed               | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Accept_Rate            | Source       | Gold_Yield_Hunter_KPIs         | Accept_Rate            | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Redeem_Rate            | Source       | Gold_Yield_Hunter_KPIs         | Redeem_Rate            | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Revenue_USD            | Source       | Gold_Yield_Hunter_KPIs         | Revenue_USD            | 1-1 Mapping         |
| Bronze       | Gold_Yield_Hunter_KPIs         | Seats_Filled_Via_Offers| Source       | Gold_Yield_Hunter_KPIs         | Seats_Filled_Via_Offers| 1-1 Mapping         |

---

## Data Type Assignments

All data types are preserved as per source system for compatibility with Snowflake Delta Lake and Stored Procedures:

- DATETIME → TIMESTAMP_NTZ
- VARCHAR(n) → VARCHAR(n)
- INT → INTEGER
- DECIMAL(p,s) → NUMBER(p,s)

---

## Assumptions & Notes
- All mappings are 1-1, no transformations or business rules applied.
- Raw data is retained in Bronze layer.
- Data types are mapped to Snowflake compatible types.
- No cleansing or validation is performed at this stage.
- Metadata and constraints are preserved for downstream processing.

---

## API Cost Reporting

apiCost: 0.02 // Cost consumed by the API for this call (in USD)

---

## Output URL
https://github.com/DIAscendion/Princess_Cruise_Yield_Hunter/blob/main/DI_Databricks_Bronze_Model_Data_Mapping_DIAS

## PipelineID
13790
