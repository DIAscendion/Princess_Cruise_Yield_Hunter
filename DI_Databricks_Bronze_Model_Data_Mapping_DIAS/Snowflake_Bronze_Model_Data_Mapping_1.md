_____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Data mapping for Bronze layer in Medallion architecture for Princess Cruise Yield Hunter. Defines one-to-one mapping from raw source tables to Bronze layer tables, preserving original structure and metadata.
## *Version*: 1
## *Updated on*: 
_____________________________________________

# Data Mapping for Bronze Layer

This mapping defines the ingestion of raw source data into the Bronze layer of the Medallion architecture in Snowflake. All attributes are mapped one-to-one, preserving original structure and metadata. No transformations, cleansing, or business rules are applied at this stage.

---

## Mapping Table

### Yield_Dining_Inventory_Snapshot
| Target Layer | Target Table                  | Target Field        | Source Layer | Source Table                  | Source Field        | Transformation Rule |
|--------------|------------------------------|---------------------|--------------|------------------------------|---------------------|---------------------|
| Bronze       | Yield_Dining_Inventory_Snapshot | Snapshot_TS_UTC     | Source       | Yield_Dining_Inventory_Snapshot | Snapshot_TS_UTC     | 1-1 Mapping        |
| Bronze       | Yield_Dining_Inventory_Snapshot | Venue_ID            | Source       | Yield_Dining_Inventory_Snapshot | Venue_ID            | 1-1 Mapping        |
| Bronze       | Yield_Dining_Inventory_Snapshot | Venue_Type          | Source       | Yield_Dining_Inventory_Snapshot | Venue_Type          | 1-1 Mapping        |
| Bronze       | Yield_Dining_Inventory_Snapshot | Capacity_Seats      | Source       | Yield_Dining_Inventory_Snapshot | Capacity_Seats      | 1-1 Mapping        |
| Bronze       | Yield_Dining_Inventory_Snapshot | Occupied_Seats      | Source       | Yield_Dining_Inventory_Snapshot | Occupied_Seats      | 1-1 Mapping        |
| Bronze       | Yield_Dining_Inventory_Snapshot | Available_Seats     | Source       | Yield_Dining_Inventory_Snapshot | Available_Seats     | 1-1 Mapping        |
| Bronze       | Yield_Dining_Inventory_Snapshot | Walkin_Queue_Size   | Source       | Yield_Dining_Inventory_Snapshot | Walkin_Queue_Size   | 1-1 Mapping        |
| Bronze       | Yield_Dining_Inventory_Snapshot | Source_System       | Source       | Yield_Dining_Inventory_Snapshot | Source_System       | 1-1 Mapping        |

### Yield_Guest_Presence_Log
| Target Layer | Target Table                  | Target Field        | Source Layer | Source Table                  | Source Field        | Transformation Rule |
|--------------|------------------------------|---------------------|--------------|------------------------------|---------------------|---------------------|
| Bronze       | Yield_Guest_Presence_Log     | Event_TS_UTC        | Source       | Yield_Guest_Presence_Log     | Event_TS_UTC        | 1-1 Mapping        |
| Bronze       | Yield_Guest_Presence_Log     | Guest_ID            | Source       | Yield_Guest_Presence_Log     | Guest_ID            | 1-1 Mapping        |
| Bronze       | Yield_Guest_Presence_Log     | Location_ID         | Source       | Yield_Guest_Presence_Log     | Location_ID         | 1-1 Mapping        |
| Bronze       | Yield_Guest_Presence_Log     | Zone_Type           | Source       | Yield_Guest_Presence_Log     | Zone_Type           | 1-1 Mapping        |
| Bronze       | Yield_Guest_Presence_Log     | Party_Size          | Source       | Yield_Guest_Presence_Log     | Party_Size          | 1-1 Mapping        |
| Bronze       | Yield_Guest_Presence_Log     | Dwell_Seconds       | Source       | Yield_Guest_Presence_Log     | Dwell_Seconds       | 1-1 Mapping        |
| Bronze       | Yield_Guest_Presence_Log     | Signal_Confidence   | Source       | Yield_Guest_Presence_Log     | Signal_Confidence   | 1-1 Mapping        |
| Bronze       | Yield_Guest_Presence_Log     | Source_System       | Source       | Yield_Guest_Presence_Log     | Source_System       | 1-1 Mapping        |

### Yield_Micro_Offer_Events
| Target Layer | Target Table                  | Target Field        | Source Layer | Source Table                  | Source Field        | Transformation Rule |
|--------------|------------------------------|---------------------|--------------|------------------------------|---------------------|---------------------|
| Bronze       | Yield_Micro_Offer_Events     | Offer_TS_UTC        | Source       | Yield_Micro_Offer_Events     | Offer_TS_UTC        | 1-1 Mapping        |
| Bronze       | Yield_Micro_Offer_Events     | Offer_ID            | Source       | Yield_Micro_Offer_Events     | Offer_ID            | 1-1 Mapping        |
| Bronze       | Yield_Micro_Offer_Events     | Guest_ID            | Source       | Yield_Micro_Offer_Events     | Guest_ID            | 1-1 Mapping        |
| Bronze       | Yield_Micro_Offer_Events     | Party_Size          | Source       | Yield_Micro_Offer_Events     | Party_Size          | 1-1 Mapping        |
| Bronze       | Yield_Micro_Offer_Events     | Target_Zone         | Source       | Yield_Micro_Offer_Events     | Target_Zone         | 1-1 Mapping        |
| Bronze       | Yield_Micro_Offer_Events     | Venue_ID            | Source       | Yield_Micro_Offer_Events     | Venue_ID            | 1-1 Mapping        |
| Bronze       | Yield_Micro_Offer_Events     | Discount_Pct        | Source       | Yield_Micro_Offer_Events     | Discount_Pct        | 1-1 Mapping        |
| Bronze       | Yield_Micro_Offer_Events     | State               | Source       | Yield_Micro_Offer_Events     | State               | 1-1 Mapping        |
| Bronze       | Yield_Micro_Offer_Events     | Redeemed_TS_UTC     | Source       | Yield_Micro_Offer_Events     | Redeemed_TS_UTC     | 1-1 Mapping        |
| Bronze       | Yield_Micro_Offer_Events     | Estimated_Revenue_USD | Source     | Yield_Micro_Offer_Events     | Estimated_Revenue_USD | 1-1 Mapping      |
| Bronze       | Yield_Micro_Offer_Events     | Source_System       | Source       | Yield_Micro_Offer_Events     | Source_System       | 1-1 Mapping        |

### Gold_Yield_Hunter_KPIs
| Target Layer | Target Table                  | Target Field        | Source Layer | Source Table                  | Source Field        | Transformation Rule |
|--------------|------------------------------|---------------------|--------------|------------------------------|---------------------|---------------------|
| Bronze       | Gold_Yield_Hunter_KPIs       | Venue_ID            | Source       | Gold_Yield_Hunter_KPIs       | Venue_ID            | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Hour                | Source       | Gold_Yield_Hunter_KPIs       | Hour                | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Seats               | Source       | Gold_Yield_Hunter_KPIs       | Seats               | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Occupied            | Source       | Gold_Yield_Hunter_KPIs       | Occupied            | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Available           | Source       | Gold_Yield_Hunter_KPIs       | Available           | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Occ_Rate            | Source       | Gold_Yield_Hunter_KPIs       | Occ_Rate            | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Low_Occupancy_Flag  | Source       | Gold_Yield_Hunter_KPIs       | Low_Occupancy_Flag  | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Accepted            | Source       | Gold_Yield_Hunter_KPIs       | Accepted            | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Expired             | Source       | Gold_Yield_Hunter_KPIs       | Expired             | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Presented           | Source       | Gold_Yield_Hunter_KPIs       | Presented           | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Redeemed            | Source       | Gold_Yield_Hunter_KPIs       | Redeemed            | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Accept_Rate         | Source       | Gold_Yield_Hunter_KPIs       | Accept_Rate         | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Redeem_Rate         | Source       | Gold_Yield_Hunter_KPIs       | Redeem_Rate         | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Revenue_USD         | Source       | Gold_Yield_Hunter_KPIs       | Revenue_USD         | 1-1 Mapping        |
| Bronze       | Gold_Yield_Hunter_KPIs       | Seats_Filled_Via_Offers | Source   | Gold_Yield_Hunter_KPIs       | Seats_Filled_Via_Offers | 1-1 Mapping    |

---

## Assumptions & Notes
- All mappings are one-to-one, preserving original structure and data types.
- No transformations, cleansing, or business rules applied in Bronze layer.
- Data types are compatible with Snowflake Delta Lake and Stored proc.
- Metadata and constraints are retained for downstream processing.
- Additional tables/entities (dim_venue, dim_guest_segment, fact_baseline_revenue, log_system_health) are not included in Bronze layer mapping as per provided sample.

---

## API Cost Reporting
apiCost: 0.02 // Cost consumed by the API for this call (in USD)

---

# OutputURL
https://github.com/DIAscendion/Princess_Cruise_Yield_Hunter/tree/main/DI_Databricks_Bronze_Model_Data_Mapping_DIAS

# PipelineID
13790
