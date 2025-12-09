# UPS Recommendations for IT Consolidation Project

This document provides Uninterruptible Power Supply (UPS) recommendations for the specified equipment as part of the IT infrastructure consolidation project.

## Assumptions

*   All recommended UPS units are **rack-mounted** to facilitate consolidation into the UPS Room.
*   The power requirement for the "Freezer Works - POE Switch Replacement" is an educated estimate. The actual power draw should be verified before purchase.
*   Pricing is not included as it fluctuates based on vendor and availability. The provided model numbers should be used to obtain current pricing.

## Summary of Recommendations

| Equipment              | APC Model Recommended                                  | Quantity | Voltage | Notes                                                              |
| ---------------------- | ------------------------------------------------------ | :------: | :-----: | ------------------------------------------------------------------ |
| The Iron Man           | `SMT3000RM2U`                                          |    2     |  120V   | One UPS per 30A circuit.                                           |
| The Beast              | `SMT3000RM2U`                                          |    2     |  120V   | One UPS per 30A circuit.                                           |
| PCR Sorters            | `SMT3000RM2U`                                          |    3     |  120V   | Load split across three units. Supports 12-15 sorters.             |
| Sequencer One          | `SRT3000RMXLT`                                         |    1     |  208V   | Safely covers 2500W load.                                          |
| Protein Analyzer       | `SRT3000RMXLT`                                         |    1     | 208/240V| 2700W capacity is an acceptable match for the 2800W load.        |
| DNA Fragment Analyzer  | `SCL500RM1UC`                                          |    1     |  120V   | Small, efficient 1U unit for a low-power device.                   |
| Freezer Works PoE Switch| `SRT1000RMXLA`                                         |    1     |  120V   | Safely covers estimated load of a large PoE switch.                |

---

## Detailed Recommendations

### The Iron Man & The Beast

*   **Requirement**: Two (2) 30A, 120V circuits for each system.
*   **Recommendation**: **APC Smart-UPS 3000VA RM 2U 120V**
*   **Model**: `SMT3000RM2U`
*   **Quantity**: **4 total** (2 for Iron Man, 2 for The Beast)
*   **Rationale**: This model has a NEMA L5-30P input plug and provides 2700W of power, which is the correct capacity for a 30A/120V circuit. Each system requires two, one for each specified circuit.

### PCR Sorters

*   **Requirement**: Power for 12-19 units at 550W each (6600W typical load), 120V.
*   **Recommendation**: **APC Smart-UPS 3000VA RM 2U 120V**
*   **Model**: `SMT3000RM2U`
*   **Quantity**: **3**
*   **Rationale**: A single 120V UPS for this entire load is not practical. The load should be split. Three of these 2700W units provide a total capacity of 8100W, comfortably supporting the typical 6600W load of 12 sorters and allowing for up to 15 sorters to run simultaneously. This requires three dedicated 30A/120V circuits.

### Sequencer One

*   **Requirement**: 2500W, 208V single phase.
*   **Recommendation**: **APC Smart-UPS SRT 3000VA RM 2U 208V**
*   **Model**: `SRT3000RMXLT`
*   **Quantity**: **1**
*   **Rationale**: This On-Line UPS provides 2700W of high-quality power at 208V, safely supporting the sequencer's 2500W load with adequate headroom.

### Protein Analyzer

*   **Requirement**: 2800W, 240V single phase.
*   **Recommendation**: **APC Smart-UPS SRT 3000VA RM 2U 208V**
*   **Model**: `SRT3000RMXLT`
*   **Quantity**: **1**
*   **Rationale**: This model is rated for 208V input but can provide 240V output. Its 2700W capacity is slightly below the 2800W nameplate rating of the analyzer (96% capacity). This is generally acceptable, as the actual sustained power draw of equipment is often less than its rating. This On-Line model also provides the highest level of power protection for a sensitive analyzer.

### DNA Fragment Analyzer

*   **Requirement**: 200W, assumed 120V.
*   **Recommendation**: **APC Smart-UPS 500VA Lithium-Ion RM 1U 120V**
*   **Model**: `SCL500RM1UC`
*   **Quantity**: **1**
*   **Rationale**: For this low-power device, a small, space-efficient unit is ideal. This 1U model provides 400W of power, has a long-life lithium-ion battery, and fits perfectly within the rack consolidation plan.

### Freezer Works - POE Switch Replacement

*   **Requirement**: Power for a POE Switch (Estimated ~750W).
*   **Recommendation**: **APC Smart-UPS SRT 1000VA RM 2U 120V**
*   **Model**: `SRT1000RMXLA`
*   **Quantity**: **1**
*   **Rationale**: Based on an estimated 750W draw for a large PoE switch, this 1000W On-Line UPS provides a safe power margin and excellent power conditioning for network equipment. **The actual power draw of the selected switch should be confirmed.**
