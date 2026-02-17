_____________________________________________
## *Author*: AAVA
## *Created on*: 
## *Description*: Conceptual data model for Yield Hunter Reporting Requirements
## *Version*: 1
## *Updated on*: 
_____________________________________________

## 1. Domain Overview
The Yield Hunter reporting solution covers cruise ship venue yield management, guest behavior analytics, micro-offer campaign performance, inventory perishability, and operational readiness. The system enables real-time and historical analysis for optimizing revenue, guest engagement, and operational efficiency across dining venues and entertainment zones.

## 2. List of Entity Names with Descriptions
1. **Venue**: Dining or entertainment location on the cruise ship where guest activity and revenue are tracked.
2. **Guest**: Individual cruise passenger whose presence, movement, and engagement are monitored.
3. **Offer**: Micro-offer or discount campaign presented to guests for conversion and redemption.
4. **Occupancy**: Real-time and historical seat utilization data for venues.
5. **Zone**: Specific area within the ship (casino, pool, theater, etc.) tracked for guest presence.
6. **Service Period**: Defined meal or activity time window (breakfast, lunch, dinner).
7. **Party**: Group of guests dining or participating together.
8. **Revenue**: Financial data attributed to venues, offers, and guest actions.
9. **Inventory**: Available seating or capacity in venues.
10. **A/B Test Group**: Segmentation for controlled experiment analysis.
11. **System Health**: Metadata on data source uptime, latency, and alert logs.

## 3. List of Attributes for Each Entity
### Venue
1. **Name**: Venue identifier for reporting and filtering.
2. **Type**: Classification (dining, entertainment, etc.).
3. **Seating Capacity**: Maximum available seats.
4. **Service Periods**: Meal/activity windows.
5. **Average Cost per Cover**: Typical revenue per guest.

### Guest
1. **Segment**: Loyalty tier or behavioral grouping.
2. **Spending Propensity**: Estimated spend level.
3. **Opt-Out Preferences**: Offer participation status.
4. **A/B Test Assignment**: Experimental group allocation.

### Offer
1. **Type**: Discount, promotion, etc.
2. **Discount Percentage Tier**: Level of discount offered.
3. **Time-to-Live (TTL)**: Offer validity window.
4. **Presentation Timestamp**: When offer was shown.
5. **Acceptance Timestamp**: When offer was accepted.
6. **Redemption Timestamp**: When offer was redeemed.

### Occupancy
1. **Current Occupancy Rate**: Percentage of seats filled.
2. **Available Seats**: Number of unoccupied seats.
3. **Peak/Off-Peak Indicator**: Utilization classification.
4. **Low Occupancy Alert Status**: Flag for underutilization.

### Zone
1. **Type**: Casino, pool, theater, etc.
2. **Location ID**: Unique zone identifier.
3. **Sensor ID**: Tracking device reference.

### Service Period
1. **Name**: Breakfast, lunch, dinner.
2. **Start Time**: Service window opening.
3. **End Time**: Service window closing.

### Party
1. **Size**: Number of guests in party.
2. **Segment**: Group classification (family, couple, solo).

### Revenue
1. **Total Revenue**: Gross earnings per venue/period.
2. **Average Revenue per Redemption**: Offer-driven earnings.
3. **Incremental Revenue**: Additional revenue from offers.
4. **Discount Cost**: Expense incurred from discounts.
5. **Profit Margin**: Net revenue ratio.

### Inventory
1. **Unused Capacity Hours**: Perishable seat-time metric.
2. **Table Turnover Rate**: Frequency of seat changes.
3. **RevPASH**: Revenue per available seat hour.

### A/B Test Group
1. **Test Variant Name**: Identifier for experiment group.
2. **Offer Strategy**: Approach used in test.
3. **Test Duration**: Time window for experiment.

### System Health
1. **RTLS Signal Quality**: Confidence score for guest tracking.
2. **Data Latency**: Time delay in data arrival.
3. **Inventory Refresh Rate**: Frequency of updates.
4. **Offer Delivery Success Rate**: Percentage of successful offer delivery.
5. **Alert Status**: System issue indicator.

## 4. KPI List
1. Current occupancy rate (% seats occupied)
2. Average available seats by time period
3. Low occupancy alerts (occupancy < 45%)
4. Peak vs. off-peak occupancy comparison
5. Total offers presented
6. Offers accepted (acceptance rate %)
7. Offers redeemed (redemption rate %)
8. Offers expired (expiration rate %)
9. Unique guests per zone
10. Average dwell time (minutes)
11. Total presence events (pings)
12. Average pings per guest
13. Total revenue from redeemed offers (USD)
14. Average revenue per redemption
15. Incremental seats filled via offers
16. Revenue by discount tier
17. Cost of discounts vs. revenue generated
18. Conversion rate by discount percentage
19. Conversion rate by party size
20. Average time to acceptance (minutes)
21. Offer effectiveness within TTL window
22. Minutes until next service period
23. Unused capacity hours
24. Table turnover rate
25. Revenue per available seat hour (RevPASH)
26. Control group revenue
27. Test group revenue
28. Incremental revenue (test - control)
29. Statistical significance (p-value)
30. Lift percentage
31. Redemption rate by discount tier
32. Gross revenue
33. Discount cost
34. Profit margin
35. Cost per acquisition
36. Offer sequence number
37. Acceptance rate by offer sequence
38. Previous offer response impact
39. Fatigue indicators
40. RTLS signal quality
41. Data latency
42. Inventory refresh rate
43. Offer delivery success rate
44. Total covers
45. Walk-in covers
46. Offer-driven covers
47. Revenue per cover
48. Yield index
49. Average occupancy rate by time window
50. Offers fired per time window
51. Conversion rate by time window
52. Revenue by time window
53. Composite opportunity score
54. Average party size
55. Acceptance rate by party size
56. Revenue by party size
57. Seating efficiency
58. Average walk-in queue size
59. Offers accepted during same time window
60. Queue displacement rate
61. Estimated service delay
62. Average signal confidence by zone
63. Ping frequency
64. Dead zone count
65. Tracking error rate
66. Baseline revenue
67. Revenue with offers enabled
68. Incremental covers
69. Return on investment (ROI %)

## 5. Conceptual Data Model Diagram
| Source Entity | Relationship Key Field      | Target Entity | Relationship Type |
|---------------|----------------------------|---------------|-------------------|
| Venue         | Name                       | Occupancy     | One-to-Many       |
| Venue         | Name                       | Offer         | One-to-Many       |
| Venue         | Name                       | Inventory     | One-to-One        |
| Venue         | Name                       | Revenue       | One-to-Many       |
| Venue         | Name                       | Zone          | One-to-Many       |
| Guest         | Segment                    | Offer         | One-to-Many       |
| Guest         | Segment                    | Party         | One-to-One        |
| Offer         | Type, Discount Tier        | Revenue       | One-to-One        |
| Zone          | Location ID                | Occupancy     | One-to-Many       |
| Service Period| Name                       | Venue         | One-to-Many       |
| A/B Test Group| Test Variant Name          | Offer         | One-to-Many       |
| System Health | Alert Status               | Venue         | One-to-Many       |

## 6. Common Data Elements in Report Requirements
1. Venue name
2. Discount tier/percentage
3. Party size
4. Service period
5. Date/time
6. Zone type
7. Guest segment
8. Offer type
9. Occupancy rate
10. Revenue
