_____________________________________________
## *Author*: AAVA
## *Created on*:   
## *Description*:   Stored procedure for ingesting raw Yield Management data into the Snowflake Bronze layer with audit logging and metadata tracking.
## *Version*: 1 
## *Updated on*: 
_____________________________________________

-- Snowflake Bronze Layer Data Engineering Pipeline Stored Procedure
-- Ingests raw data into Bronze layer tables with audit logging and metadata tracking

CREATE OR REPLACE PROCEDURE bronze.sp_yield_bronze_ingest()
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

    -- Ingest Yield_Dining_Inventory_Snapshot
    BEGIN
        INSERT OVERWRITE INTO bronze.bz_yield_dining_inventory_snapshot
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
        FROM raw.Yield_Dining_Inventory_Snapshot;
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

    -- Ingest Yield_Guest_Presence_Log
    BEGIN
        INSERT OVERWRITE INTO bronze.bz_yield_guest_presence_log
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
        FROM raw.Yield_Guest_Presence_Log;
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

    -- Ingest Yield_Micro_Offer_Events
    BEGIN
        INSERT OVERWRITE INTO bronze.bz_yield_micro_offer_events
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
        FROM raw.Yield_Micro_Offer_Events;
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

    -- Ingest Gold_Yield_Hunter_KPIs
    BEGIN
        INSERT OVERWRITE INTO bronze.bz_gold_yield_hunter_kpis
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
        FROM raw.Gold_Yield_Hunter_KPIs;
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
    RETURN 'Bronze layer ingestion completed successfully. Total processing time (seconds): ' || v_processing_time;
END;
$$;

-- API Cost Reporting
-- Cost consumed by the API for this call (in USD): 0.022
