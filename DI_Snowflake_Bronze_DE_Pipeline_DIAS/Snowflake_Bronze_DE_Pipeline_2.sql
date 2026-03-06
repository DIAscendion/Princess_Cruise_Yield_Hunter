_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*:   Updated stored procedure for ingesting raw Yield Management data into the Snowflake Bronze layer with enhanced audit logging, metadata tracking, and update (MERGE) logic for Mode 2.
## *Version*: 2 
## *Updated on*: 
_____________________________________________

-- Snowflake Bronze Layer Data Engineering Pipeline Stored Procedure (Mode 2)
-- Ingests raw data into Bronze layer tables with audit logging, metadata tracking, and update (MERGE) logic

CREATE OR REPLACE PROCEDURE bronze.sp_yield_bronze_ingest_update()
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
    v_start_time TIMESTAMP;
    v_end_time TIMESTAMP;
    v_processed_by STRING;
    v_status STRING;
    v_row_count INTEGER;
    v_error_msg STRING;
    v_record_id STRING;
    v_processing_time FLOAT;
BEGIN
    -- Capture start time
    v_start_time := CURRENT_TIMESTAMP();
    v_processed_by := CURRENT_USER();
    v_status := 'SUCCESS';
    v_error_msg := NULL;
    v_record_id := UUID_STRING();

    -- Ingest Yield_Dining_Inventory_Snapshot with MERGE for update mode
    BEGIN
        MERGE INTO bronze.bz_yield_dining_inventory_snapshot AS target
        USING (
            SELECT 
                Snapshot_TS_UTC,
                Venue_ID,
                Venue_Type,
                Capacity_Seats,
                Occupied_Seats,
                Available_Seats,
                Walkin_Queue_Size,
                Source_System,
                CURRENT_TIMESTAMP() AS load_timestamp,
                CURRENT_TIMESTAMP() AS update_timestamp,
                Source_System AS source_system_metadata
            FROM raw.Yield_Dining_Inventory_Snapshot
        ) AS src
        ON target.Snapshot_TS_UTC = src.Snapshot_TS_UTC AND target.Venue_ID = src.Venue_ID
        WHEN MATCHED THEN UPDATE SET
            Venue_Type = src.Venue_Type,
            Capacity_Seats = src.Capacity_Seats,
            Occupied_Seats = src.Occupied_Seats,
            Available_Seats = src.Available_Seats,
            Walkin_Queue_Size = src.Walkin_Queue_Size,
            update_timestamp = src.update_timestamp,
            source_system_metadata = src.source_system_metadata
        WHEN NOT MATCHED THEN INSERT (
            Snapshot_TS_UTC, Venue_ID, Venue_Type, Capacity_Seats, Occupied_Seats, Available_Seats, Walkin_Queue_Size, Source_System, load_timestamp, update_timestamp, source_system_metadata
        ) VALUES (
            src.Snapshot_TS_UTC, src.Venue_ID, src.Venue_Type, src.Capacity_Seats, src.Occupied_Seats, src.Available_Seats, src.Walkin_Queue_Size, src.Source_System, src.load_timestamp, src.update_timestamp, src.source_system_metadata
        );
        v_row_count := (SELECT COUNT(*) FROM bronze.bz_yield_dining_inventory_snapshot);
        -- Audit log
        INSERT INTO bronze.bz_audit (record_id, source_table, load_timestamp, processed_by, processing_time, status)
        VALUES (v_record_id, 'Yield_Dining_Inventory_Snapshot', CURRENT_TIMESTAMP(), v_processed_by, DATEDIFF('second', v_start_time, CURRENT_TIMESTAMP()), 'SUCCESS');
    EXCEPTION
        WHEN OTHERS THEN
            v_status := 'FAILED';
            v_error_msg := ERROR_MESSAGE();
            INSERT INTO bronze.bz_audit (record_id, source_table, load_timestamp, processed_by, processing_time, status)
            VALUES (v_record_id, 'Yield_Dining_Inventory_Snapshot', CURRENT_TIMESTAMP(), v_processed_by, DATEDIFF('second', v_start_time, CURRENT_TIMESTAMP()), v_status);
            RETURN 'Error in Yield_Dining_Inventory_Snapshot: ' || v_error_msg;
    END;

    -- Ingest Yield_Guest_Presence_Log with MERGE for update mode
    BEGIN
        MERGE INTO bronze.bz_yield_guest_presence_log AS target
        USING (
            SELECT 
                Event_TS_UTC,
                Guest_ID,
                Location_ID,
                Zone_Type,
                Party_Size,
                Dwell_Seconds,
                Signal_Confidence,
                Source_System,
                CURRENT_TIMESTAMP() AS load_timestamp,
                CURRENT_TIMESTAMP() AS update_timestamp,
                Source_System AS source_system_metadata
            FROM raw.Yield_Guest_Presence_Log
        ) AS src
        ON target.Event_TS_UTC = src.Event_TS_UTC AND target.Guest_ID = src.Guest_ID
        WHEN MATCHED THEN UPDATE SET
            Location_ID = src.Location_ID,
            Zone_Type = src.Zone_Type,
            Party_Size = src.Party_Size,
            Dwell_Seconds = src.Dwell_Seconds,
            Signal_Confidence = src.Signal_Confidence,
            update_timestamp = src.update_timestamp,
            source_system_metadata = src.source_system_metadata
        WHEN NOT MATCHED THEN INSERT (
            Event_TS_UTC, Guest_ID, Location_ID, Zone_Type, Party_Size, Dwell_Seconds, Signal_Confidence, Source_System, load_timestamp, update_timestamp, source_system_metadata
        ) VALUES (
            src.Event_TS_UTC, src.Guest_ID, src.Location_ID, src.Zone_Type, src.Party_Size, src.Dwell_Seconds, src.Signal_Confidence, src.Source_System, src.load_timestamp, src.update_timestamp, src.source_system_metadata
        );
        v_row_count := (SELECT COUNT(*) FROM bronze.bz_yield_guest_presence_log);
        INSERT INTO bronze.bz_audit (record_id, source_table, load_timestamp, processed_by, processing_time, status)
        VALUES (UUID_STRING(), 'Yield_Guest_Presence_Log', CURRENT_TIMESTAMP(), v_processed_by, DATEDIFF('second', v_start_time, CURRENT_TIMESTAMP()), 'SUCCESS');
    EXCEPTION
        WHEN OTHERS THEN
            v_status := 'FAILED';
            v_error_msg := ERROR_MESSAGE();
            INSERT INTO bronze.bz_audit (record_id, source_table, load_timestamp, processed_by, processing_time, status)
            VALUES (UUID_STRING(), 'Yield_Guest_Presence_Log', CURRENT_TIMESTAMP(), v_processed_by, DATEDIFF('second', v_start_time, CURRENT_TIMESTAMP()), v_status);
            RETURN 'Error in Yield_Guest_Presence_Log: ' || v_error_msg;
    END;

    -- Ingest Yield_Micro_Offer_Events with MERGE for update mode
    BEGIN
        MERGE INTO bronze.bz_yield_micro_offer_events AS target
        USING (
            SELECT 
                Offer_TS_UTC,
                Offer_ID,
                Guest_ID,
                Party_Size,
                Target_Zone,
                Venue_ID,
                Discount_Pct,
                State,
                Redeemed_TS_UTC,
                Estimated_Revenue_USD,
                Source_System,
                CURRENT_TIMESTAMP() AS load_timestamp,
                CURRENT_TIMESTAMP() AS update_timestamp,
                Source_System AS source_system_metadata
            FROM raw.Yield_Micro_Offer_Events
        ) AS src
        ON target.Offer_ID = src.Offer_ID
        WHEN MATCHED THEN UPDATE SET
            Offer_TS_UTC = src.Offer_TS_UTC,
            Guest_ID = src.Guest_ID,
            Party_Size = src.Party_Size,
            Target_Zone = src.Target_Zone,
            Venue_ID = src.Venue_ID,
            Discount_Pct = src.Discount_Pct,
            State = src.State,
            Redeemed_TS_UTC = src.Redeemed_TS_UTC,
            Estimated_Revenue_USD = src.Estimated_Revenue_USD,
            update_timestamp = src.update_timestamp,
            source_system_metadata = src.source_system_metadata
        WHEN NOT MATCHED THEN INSERT (
            Offer_TS_UTC, Offer_ID, Guest_ID, Party_Size, Target_Zone, Venue_ID, Discount_Pct, State, Redeemed_TS_UTC, Estimated_Revenue_USD, Source_System, load_timestamp, update_timestamp, source_system_metadata
        ) VALUES (
            src.Offer_TS_UTC, src.Offer_ID, src.Guest_ID, src.Party_Size, src.Target_Zone, src.Venue_ID, src.Discount_Pct, src.State, src.Redeemed_TS_UTC, src.Estimated_Revenue_USD, src.Source_System, src.load_timestamp, src.update_timestamp, src.source_system_metadata
        );
        v_row_count := (SELECT COUNT(*) FROM bronze.bz_yield_micro_offer_events);
        INSERT INTO bronze.bz_audit (record_id, source_table, load_timestamp, processed_by, processing_time, status)
        VALUES (UUID_STRING(), 'Yield_Micro_Offer_Events', CURRENT_TIMESTAMP(), v_processed_by, DATEDIFF('second', v_start_time, CURRENT_TIMESTAMP()), 'SUCCESS');
    EXCEPTION
        WHEN OTHERS THEN
            v_status := 'FAILED';
            v_error_msg := ERROR_MESSAGE();
            INSERT INTO bronze.bz_audit (record_id, source_table, load_timestamp, processed_by, processing_time, status)
            VALUES (UUID_STRING(), 'Yield_Micro_Offer_Events', CURRENT_TIMESTAMP(), v_processed_by, DATEDIFF('second', v_start_time, CURRENT_TIMESTAMP()), v_status);
            RETURN 'Error in Yield_Micro_Offer_Events: ' || v_error_msg;
    END;

    -- Ingest Gold_Yield_Hunter_KPIs with MERGE for update mode
    BEGIN
        MERGE INTO bronze.bz_gold_yield_hunter_kpis AS target
        USING (
            SELECT 
                Venue_ID,
                Hour,
                Seats,
                Occupied,
                Available,
                Occ_Rate,
                Low_Occupancy_Flag,
                Accepted,
                Expired,
                Presented,
                Redeemed,
                Accept_Rate,
                Redeem_Rate,
                Revenue_USD,
                Seats_Filled_Via_Offers,
                CURRENT_TIMESTAMP() AS load_timestamp,
                CURRENT_TIMESTAMP() AS update_timestamp,
                NULL AS source_system_metadata
            FROM raw.Gold_Yield_Hunter_KPIs
        ) AS src
        ON target.Venue_ID = src.Venue_ID AND target.Hour = src.Hour
        WHEN MATCHED THEN UPDATE SET
            Seats = src.Seats,
            Occupied = src.Occupied,
            Available = src.Available,
            Occ_Rate = src.Occ_Rate,
            Low_Occupancy_Flag = src.Low_Occupancy_Flag,
            Accepted = src.Accepted,
            Expired = src.Expired,
            Presented = src.Presented,
            Redeemed = src.Redeemed,
            Accept_Rate = src.Accept_Rate,
            Redeem_Rate = src.Redeem_Rate,
            Revenue_USD = src.Revenue_USD,
            Seats_Filled_Via_Offers = src.Seats_Filled_Via_Offers,
            update_timestamp = src.update_timestamp
        WHEN NOT MATCHED THEN INSERT (
            Venue_ID, Hour, Seats, Occupied, Available, Occ_Rate, Low_Occupancy_Flag, Accepted, Expired, Presented, Redeemed, Accept_Rate, Redeem_Rate, Revenue_USD, Seats_Filled_Via_Offers, load_timestamp, update_timestamp, source_system_metadata
        ) VALUES (
            src.Venue_ID, src.Hour, src.Seats, src.Occupied, src.Available, src.Occ_Rate, src.Low_Occupancy_Flag, src.Accepted, src.Expired, src.Presented, src.Redeemed, src.Accept_Rate, src.Redeem_Rate, src.Revenue_USD, src.Seats_Filled_Via_Offers, src.load_timestamp, src.update_timestamp, src.source_system_metadata
        );
        v_row_count := (SELECT COUNT(*) FROM bronze.bz_gold_yield_hunter_kpis);
        INSERT INTO bronze.bz_audit (record_id, source_table, load_timestamp, processed_by, processing_time, status)
        VALUES (UUID_STRING(), 'Gold_Yield_Hunter_KPIs', CURRENT_TIMESTAMP(), v_processed_by, DATEDIFF('second', v_start_time, CURRENT_TIMESTAMP()), 'SUCCESS');
    EXCEPTION
        WHEN OTHERS THEN
            v_status := 'FAILED';
            v_error_msg := ERROR_MESSAGE();
            INSERT INTO bronze.bz_audit (record_id, source_table, load_timestamp, processed_by, processing_time, status)
            VALUES (UUID_STRING(), 'Gold_Yield_Hunter_KPIs', CURRENT_TIMESTAMP(), v_processed_by, DATEDIFF('second', v_start_time, CURRENT_TIMESTAMP()), v_status);
            RETURN 'Error in Gold_Yield_Hunter_KPIs: ' || v_error_msg;
    END;

    v_end_time := CURRENT_TIMESTAMP();
    v_processing_time := DATEDIFF('second', v_start_time, v_end_time);
    RETURN 'Bronze layer ingestion (update mode) completed successfully. Total processing time (seconds): ' || v_processing_time;
END;
$$;

-- API Cost Reporting
-- Cost consumed by the API for this call (in USD): 0.022
