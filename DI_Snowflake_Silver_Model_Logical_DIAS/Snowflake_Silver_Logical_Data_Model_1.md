_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*: Silver Layer Logical Data Model for Yield Management Process
## *Version*: 1 
## *Updated on*: 
_____________________________________________

# 1. Silver Layer Logical Data Model

## 1.1 Table: Si_Yield_Dining_Inventory_Snapshot
*Description: Stores periodic snapshots of dining venue inventory, including seat availability and occupancy.*

| Column Name        | Description                                         | Data Type   |
|-------------------|-----------------------------------------------------|-------------|
| Snapshot_TS_UTC   | Timestamp of the inventory snapshot in UTC          | Timestamp   |
| Venue_Type        | Type/category of the dining venue                   | String      |
| Capacity_Seats    | Total seating capacity of the venue                 | Integer     |
| Occupied_Seats    | Number of seats currently occupied                  | Integer     |
| Available_Seats   | Number of seats currently available                 | Integer     |
| Walkin_Queue_Size | Number of guests waiting in walk-in queue           | Integer     |
| load_timestamp    | Timestamp when record was loaded to Silver          | Timestamp   |
| update_timestamp  | Timestamp when record was last updated in Silver    | Timestamp   |
| source_system     | Source system identifier                            | String      |

## 1.2 Table: Si_Yield_Guest_Presence_Log
*Description: Logs guest presence pings at specific zones and times for tracking movement and dwell times.*

| Column Name        | Description                                         | Data Type   |
|-------------------|-----------------------------------------------------|-------------|
| Event_TS_UTC      | Timestamp when guest presence was detected in UTC   | Timestamp   |
| Location_ID       | Identifier for the location where guest was detected| String      |
| Zone_Type         | Type of zone where guest was located                | String      |
| Party_Size        | Number of people in the guest's party               | Integer     |
| Dwell_Seconds     | Duration guest remained in the location (seconds)   | Integer     |
| Signal_Confidence | Confidence level of location detection signal (0-1) | Decimal     |
| load_timestamp    | Timestamp when record was loaded to Silver          | Timestamp   |
| update_timestamp  | Timestamp when record was last updated in Silver    | Timestamp   |
| source_system     | Source system identifier                            | String      |

## 1.3 Table: Si_Yield_Micro_Offer_Events
*Description: Records lifecycle events for micro-offers, including state transitions and estimated revenue.*

| Column Name           | Description                                         | Data Type   |
|----------------------|-----------------------------------------------------|-------------|
| Offer_TS_UTC         | Timestamp when offer was generated in UTC           | Timestamp   |
| Party_Size           | Size of the guest's dining party                    | Integer     |
| Target_Zone          | Location zone where guest was when offer was made   | String      |
| Venue_ID             | Dining venue for which the offer was made           | String      |
| Discount_Pct         | Percentage discount offered                         | Integer     |
| State                | Current state of the offer                          | String      |
| Redeemed_TS_UTC      | Timestamp when offer was redeemed (if applicable)   | Timestamp   |
| Estimated_Revenue_USD| Estimated revenue from this offer in USD            | Decimal     |
| load_timestamp       | Timestamp when record was loaded to Silver          | Timestamp   |
| update_timestamp     | Timestamp when record was last updated in Silver    | Timestamp   |
| source_system        | Source system identifier                            | String      |

## 1.4 Table: Si_Gold_Yield_Hunter_KPIs
*Description: Aggregated KPI table at venue-hour grain, containing occupancy, conversion, and revenue metrics.*

| Column Name            | Description                                         | Data Type   |
|-----------------------|-----------------------------------------------------|-------------|
| Hour                  | Hour timestamp for the aggregated metrics           | Timestamp   |
| Seats                 | Total seat capacity for the venue                   | Integer     |
| Occupied              | Average number of occupied seats during the hour    | Decimal     |
| Available             | Average number of available seats during the hour   | Decimal     |
| Occ_Rate              | Occupancy rate (occupied/seats) for the hour        | Decimal     |
| Low_Occupancy_Flag    | Flag indicating if occupancy was below threshold    | Integer     |
| Accepted              | Number of offers accepted during the hour           | Integer     |
| Expired               | Number of offers that expired during the hour       | Integer     |
| Presented             | Number of offers presented during the hour          | Integer     |
| Redeemed              | Number of offers redeemed during the hour           | Integer     |
| Accept_Rate           | Acceptance rate (accepted/presented) for the hour   | Decimal     |
| Redeem_Rate           | Redemption rate for the hour                        | Decimal     |
| Revenue_USD           | Total revenue generated during the hour in USD      | Decimal     |
| Seats_Filled_Via_Offers| Number of seats filled through offer redemptions   | Integer     |
| load_timestamp        | Timestamp when record was loaded to Silver          | Timestamp   |
| update_timestamp      | Timestamp when record was last updated in Silver    | Timestamp   |
| source_system         | Source system identifier                            | String      |

## 1.5 Table: Si_Error_Validation_Log
*Description: Stores error data from data quality checks and validation processes.*

| Column Name      | Description                                        | Data Type   |
|------------------|----------------------------------------------------|-------------|
| error_timestamp  | Timestamp when error was detected                   | Timestamp   |
| source_table     | Name of the table where error occurred              | String      |
| error_type       | Type/category of error (completeness, accuracy, etc)| String      |
| error_details    | Detailed description of the error                   | String      |
| record_reference | Reference to the affected record (non-ID)           | String      |
| severity         | Severity of the error (low/medium/high)             | String      |
| load_timestamp   | Timestamp when error record was loaded              | Timestamp   |

## 1.6 Table: Si_Audit_Process_Log
*Description: Stores process audit data from pipeline execution.*

| Column Name      | Description                                        | Data Type   |
|------------------|----------------------------------------------------|-------------|
| audit_timestamp  | Timestamp when audit event occurred                 | Timestamp   |
| source_table     | Name of the source table processed                  | String      |
| process_name     | Name of the process executed                        | String      |
| processed_by     | Identifier of the process/user loading the record   | String      |
| processing_time  | Time taken to process the record                    | Decimal     |
| status           | Status of the record processing (success/failure)   | String      |
| load_timestamp   | Timestamp when audit record was loaded              | Timestamp   |

# 2. Conceptual Data Model Diagram (Tabular Form)

| Source Table                        | Relationship Key Field | Target Table                      | Relationship Type |
|-------------------------------------|------------------------|-----------------------------------|-------------------|
| Si_Yield_Guest_Presence_Log         | Location_ID            | Si_Yield_Dining_Inventory_Snapshot| Many-to-One       |
| Si_Yield_Micro_Offer_Events         | Venue_ID               | Si_Yield_Dining_Inventory_Snapshot| Many-to-One       |
| Si_Gold_Yield_Hunter_KPIs           | Venue_ID               | Si_Yield_Dining_Inventory_Snapshot| Many-to-One       |
| Si_Gold_Yield_Hunter_KPIs           | Hour                   | Si_Yield_Dining_Inventory_Snapshot| Many-to-One       |
| Si_Gold_Yield_Hunter_KPIs           | Hour                   | Si_Yield_Micro_Offer_Events       | Many-to-One       |

# 3. Rationale for Key Design Decisions
1. All Silver tables mirror Bronze structure but exclude primary/foreign key fields and unique identifiers.
2. Table names use 'Si_' prefix for consistency and layer identification.
3. Data types standardized as per constraints and business rules.
4. Error and audit tables included for operational traceability and data quality management.
5. Relationships documented based on conceptual model and business context.
6. Column descriptions provided for clarity and data governance.

# 4. Assumptions
1. All timestamps are in UTC and ISO 8601 format.
2. Numeric fields use decimal notation.
3. Boolean flags are represented as integer (0/1).
4. Service periods use standard labels (breakfast/lunch/dinner).
5. No primary key, foreign key, or unique identifier fields included.

# 5. apiCost
apiCost: 0.015000

---

# OutputURL: https://github.com/DIAscendion/Princess_Cruise_Yield_Hunter/tree/main/DI_Snowflake_Silver_Model_Logical_DIAS
# pipelineID: 13834
