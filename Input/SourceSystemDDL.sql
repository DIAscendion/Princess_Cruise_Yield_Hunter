
PMS – Guest & Reservation
CREATE TABLE guest_profile (
    guest_id            VARCHAR(50) PRIMARY KEY,
    loyalty_tier        VARCHAR(20),
    age_group           VARCHAR(20),
    home_country        VARCHAR(50),
    opt_in_offers       BOOLEAN,
    created_ts          TIMESTAMP
);

CREATE TABLE dining_reservation (
    reservation_id      VARCHAR(50) PRIMARY KEY,
    guest_id            VARCHAR(50),
    venue_id            VARCHAR(50),
    reservation_ts      TIMESTAMP,
    party_size          INT,
    service_period      VARCHAR(20),
    reservation_status  VARCHAR(20),
    created_ts          TIMESTAMP
);

Dining Inventory & Seating
CREATE TABLE venue_master (
    venue_id        VARCHAR(50) PRIMARY KEY,
    venue_name      VARCHAR(100),
    seating_capacity INT,
    venue_type      VARCHAR(50)
);

CREATE TABLE seating_inventory_snapshot (
    snapshot_id     VARCHAR(50) PRIMARY KEY,
    venue_id        VARCHAR(50),
    snapshot_ts     TIMESTAMP,
    occupied_seats  INT,
    available_seats INT
);


POS Transactions

CREATE TABLE pos_transaction (
    transaction_id      VARCHAR(50) PRIMARY KEY,
    guest_id            VARCHAR(50),
    venue_id            VARCHAR(50),
    transaction_ts      TIMESTAMP,
    bill_amount         DECIMAL(10,2),
    discount_amount     DECIMAL(10,2),
    net_amount          DECIMAL(10,2),
    covers              INT,
    offer_id            VARCHAR(50)
);


Offer Management
CREATE TABLE micro_offer (
    offer_id            VARCHAR(50) PRIMARY KEY,
    guest_id            VARCHAR(50),
    venue_id            VARCHAR(50),
    discount_pct        DECIMAL(5,2),
    offer_type          VARCHAR(50),
    fired_ts            TIMESTAMP,
    ttl_minutes         INT
);

CREATE TABLE offer_response (
    response_id         VARCHAR(50) PRIMARY KEY,
    offer_id            VARCHAR(50),
    response_status     VARCHAR(20), -- ACCEPTED / REJECTED / EXPIRED
    response_ts         TIMESTAMP
);

CREATE TABLE offer_redemption (
    redemption_id       VARCHAR(50) PRIMARY KEY,
    offer_id            VARCHAR(50),
    redeemed_ts         TIMESTAMP,
    revenue_amount      DECIMAL(10,2)
);


RTLS – Guest Presence

CREATE TABLE zone_master (
    zone_id     VARCHAR(50) PRIMARY KEY,
    zone_name   VARCHAR(100),
    zone_type   VARCHAR(50)
);

CREATE TABLE guest_presence_event (
    event_id        VARCHAR(50) PRIMARY KEY,
    guest_id        VARCHAR(50),
    zone_id         VARCHAR(50),
    event_ts        TIMESTAMP,
    signal_conf     DECIMAL(5,2)
);



Guest Journey
CREATE TABLE guest_journey (
    journey_id      VARCHAR(50) PRIMARY KEY,
    guest_id        VARCHAR(50),
    origin_zone     VARCHAR(50),
    destination_venue VARCHAR(50),
    journey_start_ts TIMESTAMP,
    journey_end_ts   TIMESTAMP
);


Queue / Walk-in

CREATE TABLE venue_queue_snapshot (
    queue_id        VARCHAR(50) PRIMARY KEY,
    venue_id        VARCHAR(50),
    snapshot_ts     TIMESTAMP,
    queue_size      INT,
    avg_wait_mins   INT
);


A/B Testing

CREATE TABLE ab_test_assignment (
    assignment_id   VARCHAR(50) PRIMARY KEY,
    guest_id        VARCHAR(50),
    test_name       VARCHAR(100),
    variant         VARCHAR(20), -- CONTROL / TEST
    assigned_ts     TIMESTAMP
);


Revenue Baseline

CREATE TABLE baseline_revenue (
    baseline_id     VARCHAR(50) PRIMARY KEY,
    venue_id        VARCHAR(50),
    service_period  VARCHAR(20),
    baseline_date   DATE,
    baseline_revenue DECIMAL(10,2),
    baseline_covers INT
);


System Health

CREATE TABLE rtls_signal_quality (
    signal_id       VARCHAR(50) PRIMARY KEY,
    zone_id         VARCHAR(50),
    snapshot_ts     TIMESTAMP,
    avg_confidence  DECIMAL(5,2)
);

CREATE TABLE offer_delivery_log (
    delivery_id     VARCHAR(50) PRIMARY KEY,
    offer_id        VARCHAR(50),
    delivery_status VARCHAR(20),
    delivery_ts     TIMESTAMP
);



