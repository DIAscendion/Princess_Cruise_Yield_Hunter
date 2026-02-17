____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Model data constraints and business rules for Yield Hunter Analytical Reporting
## *Version*: 1
## *Updated on*: 
____________________________________________

## 1. Data Expectations

### 1.1 Data Completeness
1. Venue occupancy data must be captured for all service periods and venues.
2. Offer lifecycle data (presentation, acceptance, redemption) must be recorded for all micro-offers.
3. Guest presence and dwell data must be collected for all zones.
4. Revenue attribution must include all offer redemptions and baseline values.

### 1.2 Data Accuracy
1. Occupied seat counts must reflect actual guest presence.
2. Offer timestamps must be precise and correspond to real guest actions.
3. Revenue values must match financial records and discounts applied.
4. Guest density and dwell time must be calculated from accurate presence pings.

### 1.3 Data Format
1. Timestamps must follow a consistent date-time format across all reports.
2. Venue and zone names must be standardized.
3. Discount tiers must be represented as defined business categories.
4. Revenue values must be numeric and formatted as currency.

### 1.4 Data Consistency
1. Occupancy rates must be calculated uniformly across all venues and periods.
2. Offer conversion rates must use the same formula for all venues.
3. Guest presence and dwell metrics must be consistent across zones.
4. Revenue attribution must align with offer redemption records.

## 2. Constraints

### 2.1 Mandatory Fields
1. Venue Name: Required for all venue-based reports to identify location.
2. Service Period Name: Required for time-based occupancy and inventory reports.
3. Occupied Seats: Required for occupancy calculations.
4. Offer Presentation Timestamp: Required for tracking offer lifecycle.
5. Revenue: Required for financial and attribution reports.
6. Guest Presence Pings: Required for heatmap and targeting reports.

### 2.2 Uniqueness Requirements
1. Venue Name + Service Period Name: Must be unique for each occupancy record.
2. Offer Presentation Timestamp + Offer Redemption Timestamp: Must be unique for each offer lifecycle.
3. Zone Name + Timestamp: Must be unique for each guest presence record.

### 2.3 Data Type Limitations
1. Occupied Seats: Must be integer and non-negative.
2. Revenue: Must be numeric and non-negative.
3. Discount Tier: Must be categorical (business-defined levels).
4. Dwell Time: Must be numeric (minutes or hours).

### 2.4 Dependencies
1. Occupancy Rate depends on Occupied Seats and Seating Capacity.
2. Offer Redemption Rate depends on Offer Presentation and Acceptance.
3. Net Revenue depends on Gross Revenue and Discount Value.
4. Yield Index depends on Actual Revenue and Potential Revenue.

### 2.5 Referential Integrity
1. Venue Name in occupancy reports must reference valid venues in the master venue list.
2. Offer records must reference valid guests and venues.
3. Revenue records must reference valid offers and venues.
4. Guest presence records must reference valid zones.

## 3. Business Rules

### 3.1 Data Processing Rules
1. Occupancy Rate must be calculated as Occupied Seats divided by Seating Capacity times 100.
2. Conversion Rate must be calculated as Redeemed Offers divided by Presented Offers times 100.
3. Average Dwell Time must be calculated as Total Dwell Time divided by Unique Guests.
4. RevPASH must be calculated as Revenue divided by Seat Hours.

### 3.2 Reporting Logic Rules
1. Venue occupancy reports must allow drill-down by venue, service period, and day of week.
2. Micro-offer conversion reports must allow analysis by discount tier and venue.
3. Revenue attribution reports must compare performance across venues.
4. Inventory perishability reports must show trends by venue.

### 3.3 Transformation Guidelines
1. Guest identity must be anonymized in all reports.
2. Financial data must be restricted to authorized users.
3. System health metrics must be presented as trend analysis.
4. Data must be transformed to align with business-defined categories and formats.