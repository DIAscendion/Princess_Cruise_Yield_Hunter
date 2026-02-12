_____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Snowflake Bronze Layer Logical Data Model for Yield Management Process
## *Version*: 1
## *Updated on*: 
_____________________________________________

# Snowflake Bronze Model Logical for Yield Management Process

## PII Classification

| Column Name      | Reason why it is classified as PII                |
|-----------------|---------------------------------------------------|
| Guest_ID        | Directly identifies an individual guest           |
|                 |                                                   |

*Note: Guest_ID is present in source but excluded from Bronze model as per instructions.*

---

## Bronze Layer Logical Model

### Table: Bz_Yield_Dining_Inventory_Snapshot
*Description: Stores periodic snapshots of dining venue inventory, including seat availability and occupancy.*

| Column Name        | Business Description                                 | Data Type   |
|-------------------|-----------------------------------------------------|-------------|
| Snapshot_TS_UTC   | Timestamp of the inventory snapshot in UTC           | Timestamp   |
| Venue_Type        | Type/category of the dining venue                    | String      |
| Capacity_Seats    | Total seating capacity of the venue                  | Integer     |
| Occupied_Seats    | Number of seats currently occupied                   | Integer     |
| Available_Seats   | Number of seats currently available                  | Integer     |
| Walkin_Queue_Size | Number of guests waiting in walk-in queue            | Integer     |
| load_timestamp    | Timestamp when record was loaded to Bronze           | Timestamp   |
| update_timestamp  | Timestamp when record was last updated in Bronze     | Timestamp   |
| source_system     | Source system identifier                             | String      |

---

### Table: Bz_Yield_Guest_Presence_Log
*Description: Logs guest presence pings at specific zones and times for tracking movement and dwell times.*

| Column Name        | Business Description                                 | Data Type   |
|-------------------|-----------------------------------------------------|-------------|
| Event_TS_UTC      | Timestamp when guest presence was detected in UTC    | Timestamp   |
| Location_ID       | Identifier for the location where guest was detected | String      |
| Zone_Type         | Type of zone where guest was located                 | String      |
| Party_Size        | Number of people in the guest's party                | Integer     |
| Dwell_Seconds     | Duration guest remained in the location (seconds)    | Integer     |
| Signal_Confidence | Confidence level of location detection signal (0-1)  | Decimal     |
| load_timestamp    | Timestamp when record was loaded to Bronze           | Timestamp   |
| update_timestamp  | Timestamp when record was last updated in Bronze     | Timestamp   |
| source_system     | Source system identifier                             | String      |

---

### Table: Bz_Yield_Micro_Offer_Events
*Description: Records lifecycle events for micro-offers, including state transitions and estimated revenue.*

| Column Name           | Business Description                                 | Data Type   |
|----------------------|-----------------------------------------------------|-------------|
| Offer_TS_UTC         | Timestamp when offer was generated in UTC            | Timestamp   |
| Party_Size           | Size of the guest's dining party                     | Integer     |
| Target_Zone          | Location zone where guest was when offer was made    | String      |
| Venue_ID             | Dining venue for which the offer was made            | String      |
| Discount_Pct         | Percentage discount offered                          | Integer     |
| State                | Current state of the offer                           | String      |
| Redeemed_TS_UTC      | Timestamp when offer was redeemed (if applicable)    | Timestamp   |
| Estimated_Revenue_USD| Estimated revenue from this offer in USD             | Decimal     |
| load_timestamp       | Timestamp when record was loaded to Bronze           | Timestamp   |
| update_timestamp     | Timestamp when record was last updated in Bronze     | Timestamp   |
| source_system        | Source system identifier                             | String      |

---

### Table: Bz_Gold_Yield_Hunter_KPIs
*Description: Aggregated KPI table at venue-hour grain, containing occupancy, conversion, and revenue metrics.*

| Column Name            | Business Description                                 | Data Type   |
|-----------------------|-----------------------------------------------------|-------------|
| Hour                  | Hour timestamp for the aggregated metrics            | Timestamp   |
| Seats                 | Total seat capacity for the venue                    | Integer     |
| Occupied              | Average number of occupied seats during the hour     | Decimal     |
| Available             | Average number of available seats during the hour    | Decimal     |
| Occ_Rate              | Occupancy rate (occupied/seats) for the hour         | Decimal     |
| Low_Occupancy_Flag    | Flag indicating if occupancy was below threshold     | Integer     |
| Accepted              | Number of offers accepted during the hour            | Integer     |
| Expired               | Number of offers that expired during the hour        | Integer     |
| Presented             | Number of offers presented during the hour           | Integer     |
| Redeemed              | Number of offers redeemed during the hour            | Integer     |
| Accept_Rate           | Acceptance rate (accepted/presented) for the hour    | Decimal     |
| Redeem_Rate           | Redemption rate for the hour                         | Decimal     |
| Revenue_USD           | Total revenue generated during the hour in USD       | Decimal     |
| Seats_Filled_Via_Offers| Number of seats filled through offer redemptions    | Integer     |
| load_timestamp        | Timestamp when record was loaded to Bronze           | Timestamp   |
| update_timestamp      | Timestamp when record was last updated in Bronze     | Timestamp   |
| source_system         | Source system identifier                             | String      |

---

## Audit Table Design

| Field Name      | Description                                        | Data Type   |
|-----------------|----------------------------------------------------|-------------|
| record_id       | Unique record identifier for audit log             | String      |
| source_table    | Name of the source table processed                 | String      |
| load_timestamp  | Timestamp when record was loaded                   | Timestamp   |
| processed_by    | Identifier of the process/user loading the record  | String      |
| processing_time | Time taken to process the record                   | Decimal     |
| status          | Status of the record processing (success/failure)  | String      |

---

## Conceptual Data Model Diagram (Tabular Form)

| Source Table                        | Relationship Key Field | Target Table                      | Relationship Type |
|-------------------------------------|------------------------|-----------------------------------|-------------------|
| Bz_Yield_Guest_Presence_Log         | Location_ID            | Bz_Yield_Dining_Inventory_Snapshot| Many-to-One       |
| Bz_Yield_Micro_Offer_Events         | Venue_ID               | Bz_Yield_Dining_Inventory_Snapshot| Many-to-One       |
| Bz_Gold_Yield_Hunter_KPIs           | Venue_ID               | Bz_Yield_Dining_Inventory_Snapshot| Many-to-One       |
| Bz_Gold_Yield_Hunter_KPIs           | Hour                   | Bz_Yield_Dining_Inventory_Snapshot| Many-to-One       |
| Bz_Gold_Yield_Hunter_KPIs           | Hour                   | Bz_Yield_Micro_Offer_Events       | Many-to-One       |

---

## Rationale and Assumptions
- All source tables are mirrored in the Bronze layer with the Bz_ prefix.
- Primary and foreign key fields (e.g., Guest_ID, Offer_ID) are excluded as per instructions.
- Metadata columns (load_timestamp, update_timestamp, source_system) are added to each table for lineage and auditability.
- PII fields are identified and excluded from the Bronze model.
- Data types are logical (String, Integer, Decimal, Timestamp).
- Relationships are documented based on conceptual model and business context.
- Audit table is designed for operational traceability.

---

## API Cost

apiCost: 0.015000
