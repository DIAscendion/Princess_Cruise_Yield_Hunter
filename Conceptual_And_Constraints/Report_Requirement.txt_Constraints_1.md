____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Model data constraints and business rules for Yield Hunter Reporting Requirements
## *Version*: 1
## *Updated on*: 
____________________________________________

## 1. Data Expectations

### 1.1 Data Completeness
1. All venue occupancy data must be captured for every service period and venue.
2. Guest presence events (pings) must be recorded for all zones during operational hours.
3. Offer lifecycle events (presentation, acceptance, redemption, expiration) must be tracked for each micro-offer.
4. Revenue attribution data must be available for all redeemed offers.

### 1.2 Data Accuracy
1. Occupancy rates must reflect actual seat utilization as reported by inventory management systems.
2. Guest movement and zone dwell times must be accurately derived from RTLS/Medallion Readers.
3. Offer conversion metrics must be calculated based on real event timestamps.
4. Revenue figures must match financial system records for each venue and period.

### 1.3 Data Format
1. Date/time fields must use standardized timestamp formats (e.g., ISO 8601).
2. Discount tiers must be represented as percentages (10%, 15%, 20%, 25%).
3. Party size must be recorded as integer values.
4. Occupancy rates must be represented as percentages.

### 1.4 Data Consistency
1. Venue names, zone types, and service periods must be consistent across all reports and data sources.
2. Guest segments must be uniformly applied for all engagement and journey tracking reports.
3. Offer types and discount tiers must be consistent for conversion and revenue attribution analysis.
4. Revenue and occupancy metrics must be aligned for cross-report benchmarking.

## 2. Constraints

### 2.1 Mandatory Fields
1. Venue name: Required for all venue-based reports.
2. Service period: Required for occupancy and inventory analysis.
3. Offer type: Required for micro-offer performance and conversion tracking.
4. Discount tier: Required for offer and revenue optimization reports.
5. Guest segment: Required for engagement and journey analysis.
6. Occupancy rate: Required for alert and opportunity analysis.

### 2.2 Uniqueness Requirements
1. Venue name + service period combination must be unique for occupancy and inventory records.
2. Offer presentation timestamp + guest segment must be unique for micro-offer event tracking.
3. Zone type + location ID must be unique for guest presence analytics.

### 2.3 Data Type Limitations
1. Occupancy rate: Must be a percentage value.
2. Discount tier: Must be a percentage value.
3. Party size: Must be an integer.
4. Revenue: Must be a decimal value.

### 2.4 Dependencies
1. Offer redemption is dependent on prior offer acceptance.
2. Revenue attribution is dependent on successful offer redemption.
3. Low occupancy alerts are dependent on occupancy rate and available seats.
4. Guest journey tracking is dependent on presence events and zone mapping.

### 2.5 Referential Integrity
1. Venue name must reference a valid entry in the Venue Master Data table.
2. Guest segment must reference a valid entry in Guest Segmentation Data.
3. Offer type and discount tier must reference valid entries in Offer Orchestration Service.
4. Zone type and location ID must reference valid entries in RTLS/Medallion Readers.

## 3. Business Rules

### 3.1 Data Processing Rules
1. Real-time occupancy and guest presence data must be processed within 5 minutes of event occurrence.
2. Hourly batch reports must aggregate offer conversion and revenue metrics for each venue.
3. Daily batch reports must summarize guest engagement, journey tracking, and inventory perishability.

### 3.2 Reporting Logic Rules
1. Low occupancy alerts are triggered when occupancy rate falls below 45% for a venue.
2. Conversion funnel reports must track offers from presentation through acceptance and redemption.
3. Incremental revenue attribution must compare offer-enabled periods to baseline performance.
4. A/B test performance reports must compare control and test group metrics for statistical significance.

### 3.3 Transformation Guidelines
1. All guest data must be anonymized in shared reports; PII is restricted to authorized users only.
2. Offer effectiveness metrics must be calculated within the TTL window.
3. Party size segmentation must group guests as (1, 2, 3-4, 5+).
4. Composite opportunity scores must be calculated based on occupancy, conversion, and revenue metrics.
