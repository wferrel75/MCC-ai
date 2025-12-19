# Datto RMM Billing Policy Update Summary

**Effective Date:** December 1, 2025

This document summarizes the upcoming changes to the Datto RMM billing policy and highlights key impacts on our customers and operational costs.

## Key Changes

1.  **New Billing Model:** Datto is transitioning from a "high watermark" billing model to a **Committed Minimum Quantity (CMQ) and variable consumption model**.
2.  **Billing Calculation:** Your monthly bill will be based on the **higher of your CMQ or your actual license usage** for the billing period.
3.  **No More Overage Buffer:** The previous 10% overage buffer is being **eliminated**.

## Significant Impacts

### Cost Implications

*   **Potential for Higher Costs:** Without the 10% buffer, any license usage exceeding the CMQ will now incur additional charges. Previously, minor fluctuations might have been absorbed by the buffer. This makes precise license management critical to avoid unexpected costs.
*   **Strict License Counting:** We will be billed for every license used over our committed amount. This requires careful and proactive monitoring of deployed agents.

### Customer & Operational Impact

*   **Agent Audits are Crucial:** We must regularly audit and remove agents from any decommissioned, retired, or otherwise unused devices to prevent unnecessary charges.
*   **Policy Adjustments Needed:** For licenses like **Advanced Software Management** and **Ransomware Detection**, we need to ensure policies are scoped correctly to avoid deploying these features to devices that do not require them.
*   **Onboarding/Offboarding Processes:** Device lifecycle management becomes even more critical. We must ensure that our device offboarding process includes the removal of the Datto RMM agent to free up licenses.

## Affected and Unaffected Services

*   **Affected Licenses:**
    *   Datto RMM
    *   Advanced Software Management
    *   Ransomware Detection
*   **Unaffected Licenses:**
    *   Kaseya 365 Endpoint licenses

## Actionable Steps

To mitigate negative cost impacts, the following actions are recommended:

1.  **Conduct a Full Audit:** Perform a comprehensive audit of all deployed Datto RMM agents across all client sites.
2.  **Remove Unused Agents:** Identify and delete agents from devices that are no longer active or managed.
3.  **Review and Tune Policies:** Review and adjust Advanced Software Management and Ransomware Detection policies to target only the intended devices.
4.  **Update Internal Processes:** Reinforce device onboarding and offboarding procedures to include agent installation and removal as standard steps.
