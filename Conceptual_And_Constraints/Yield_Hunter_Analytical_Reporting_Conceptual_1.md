_____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Conceptual data model for Yield Hunter Analytical Reporting
## *Version*: 1
## *Updated on*: 
_____________________________________________

## 1. Domain Overview
Yield Hunter Analytical Reporting covers the domain of cruise venue revenue optimization, focusing on monitoring venue performance, optimizing micro-offer deployment, understanding guest behavior, maximizing seating utilization, and revenue. The system supports teams such as revenue management, marketing, operations, analytics, finance, and IT.

## 2. List of Entity Names with Descriptions
1. **Venue**: Represents a dining or entertainment location on the cruise ship where seating and revenue are tracked.
2. **Service Period**: Represents a specific time window during which a venue operates (e.g., breakfast, lunch, dinner).
3. **Seat**: Represents individual seating units within a venue.
4. **Offer**: Represents micro-offers or targeted promotions presented to guests.
5. **Guest**: Represents cruise guests whose presence and behavior are tracked.
6. **Zone**: Represents physical areas or zones within the cruise ship.
7. **Revenue**: Represents monetary values attributed to venues and offers.
8. **Inventory**: Represents available seating capacity and its perishability.
9. **System Health**: Represents operational readiness and data health metrics.

## 3. List of Attributes for Each Entity
### Venue
1. **Venue Name**: Name of the venue.
2. **Seating Capacity**: Total number of seats available.
3. **Occupied Seats**: Number of seats currently occupied.
4. **Available Seats**: Number of seats available for booking.

### Service Period
1. **Service Period Name**: Name of the time window (e.g., breakfast).
2. **Timestamp**: Date and time of the service period.

### Seat
1. **Seat Number**: Identifier for a seat (business label).
2. **Status**: Occupied or available.

### Offer
1. **Presentation Timestamp**: When the offer was shown.
2. **Acceptance Timestamp**: When the offer was accepted.
3. **Redemption Timestamp**: When the offer was redeemed.
4. **Discount Tier**: Level of discount applied.
5. **Party Size**: Number of guests in the party.

### Guest
1. **Presence Pings**: Data points indicating guest presence.
2. **Dwell Time**: Duration guest spends in a zone.

### Zone
1. **Zone Name**: Name of the area.
2. **Guest Density**: Number of guests present.

### Revenue
1. **Gross Revenue**: Total revenue before discounts.
2. **Discount Value**: Total value of discounts applied.
3. **Net Revenue**: Revenue after discounts.
4. **Revenue per Redemption**: Revenue generated per offer redemption.
5. **Baseline Revenue**: Revenue without offers.
6. **Offer Revenue**: Revenue generated from offers.

### Inventory
1. **Available Seats**: Seats not yet booked.
2. **Time Remaining**: Time left before seat perishes.
3. **Unused Capacity Hours**: Hours of unused seating.

### System Health
1. **Latency**: Time delay in data delivery.
2. **Delivery Success**: Successful data deliveries.
3. **System Uptime**: Percentage of time system is operational.

### Covers
1. **Covers**: Number of guests served.

## 4. KPI List
1. **Occupancy Rate**: Percentage of seats occupied.
2. **Available Seats**: Number of seats available for booking.
3. **Peak vs Off-Peak Utilization**: Comparison of occupancy during peak and off-peak periods.
4. **Low Occupancy Instances**: Occurrences of low seat utilization.
5. **Acceptance Rate**: Percentage of offers accepted.
6. **Redemption Rate**: Percentage of offers redeemed.
7. **Expiration Rate**: Percentage of offers expired.
8. **Unique Guests**: Count of distinct guests.
9. **Average Dwell Time**: Average time guests spend in a zone.
10. **Net Revenue**: Gross revenue minus discounts.
11. **Revenue per Redemption**: Revenue generated per offer redemption.
12. **Unused Capacity Hours**: Hours of unused seating.
13. **RevPASH**: Revenue per available seat hour.
14. **Yield Index**: Ratio of actual to potential revenue.
15. **Incremental Revenue**: Offer revenue minus baseline revenue.
16. **System Uptime**: Percentage of time system is operational.
17. **Delivery Success Rate**: Successful deliveries divided by total.

## 5. Conceptual Data Model Diagram
| Source Entity | Relationship Key Field | Target Entity | Relationship Type |
|---------------|------------------------|---------------|-------------------|
| Venue         | Venue Name             | Service Period| One-to-Many       |
| Venue         | Venue Name             | Seat          | One-to-Many       |
| Venue         | Venue Name             | Offer         | One-to-Many       |
| Offer         | Presentation Timestamp | Guest         | Many-to-One       |
| Guest         | Presence Pings         | Zone          | Many-to-One       |
| Offer         | Redemption Timestamp   | Revenue       | One-to-One        |
| Venue         | Venue Name             | Inventory     | One-to-One        |
| Venue         | Venue Name             | Covers        | One-to-Many       |
| System Health | Latency                | Delivery Success| One-to-One      |

## 6. Common Data Elements in Report Requirements
1. **Venue Name**
2. **Seating Capacity**
3. **Occupied Seats**
4. **Available Seats**
5. **Service Period**
6. **Timestamp**
7. **Offer (Presentation/Acceptance/Redemption Timestamp, Discount Tier, Party Size)**
8. **Revenue (Gross, Net, Discount Value, Revenue per Redemption, Baseline, Offer Revenue)**
9. **Guest (Presence Pings, Dwell Time)**
10. **Zone (Zone Name, Guest Density)**
11. **Inventory (Available Seats, Time Remaining, Unused Capacity Hours)**
12. **System Health (Latency, Delivery Success, System Uptime)**
13. **Covers**