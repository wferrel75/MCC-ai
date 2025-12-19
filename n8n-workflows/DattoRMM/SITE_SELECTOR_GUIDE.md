# Datto Site Selector - Quick Start Guide

## Workflow Overview

**Name:** Datto Site Selector
**ID:** `HePIj3g65MGfZxV5`
**Status:** Ready to activate
**Purpose:** Provides a web-based form to select a Datto RMM site and retrieve its UID

## What This Workflow Does

This workflow:
1. Provides a webhook URL that displays an HTML form
2. Fetches all sites from Datto RMM using the "S_Datto RMM - Get Sites" sub-workflow
3. Filters out:
   - Sites named "default"
   - Hidden sites
   - Managed sites
   - Deleted sites
   - Sites with "test" in the name
4. Sorts remaining sites alphabetically by name
5. Displays a dropdown form with all eligible sites
6. Shows the selected site's name and UID when submitted

## Quick Start (2 minutes)

### Step 1: Activate the Workflow

1. Open n8n → Workflows
2. Search for "Datto Site Selector"
3. Click the **Active** toggle (make it green)

### Step 2: Get the Webhook URL

1. Click on the "Webhook Trigger" node
2. Copy the **Production URL**

It will look like:
```
https://your-n8n-instance.com/webhook/datto-site-selector
```

### Step 3: Use the Site Selector

1. Open the webhook URL in your browser
2. Select a site from the dropdown
3. Click **Continue**
4. Copy the displayed Site UID

### Step 4: Use the Site UID (Optional)

Use the selected Site UID with the "Datto RMM Software Inventory Sync" workflow:

1. Set environment variable:
   ```
   DATTO_SITE_UID = <paste the UID here>
   ```

2. Or update the "Set Site UID" node in the inventory workflow to use the specific UID

## Workflow Architecture

```
Webhook GET Request
    ↓
Get Sites (sub-workflow: "S_Datto RMM - Get Sites")
    ↓
Filter Sites (remove default, hidden, managed, deleted, test)
    ↓
Sort by Name (alphabetical)
    ↓
Aggregate Sites (combine into single item)
    ↓
Generate HTML Form (create dropdown with site names)
    ↓
Respond with HTML (display form in browser)
```

## Filtering Logic

The workflow excludes sites where:
- `name = "default"`
- `settings.hidden = true`
- `settings.managed = true`
- `deleted = true`
- `name` contains "test" (case-insensitive)

All conditions must pass (AND logic) for a site to be included.

## Sample Output

When you submit the form, you'll see:

```
✅ Site Selected

Site Name: Acme Corporation
Site UID: ea514805-d152-4bd4-a3f1-8de6e4b603d4

Use this Site UID to run the software inventory sync workflow.
```

## Integration with Software Inventory Workflow

### Option 1: Environment Variable

1. Go to n8n → **Settings** → **Variables**
2. Add or update:
   ```
   DATTO_SITE_UID = ea514805-d152-4bd4-a3f1-8de6e4b603d4
   ```
3. Run "Datto RMM Software Inventory Sync" workflow

### Option 2: Manual Entry

1. Open "Datto RMM Software Inventory Sync" workflow
2. Find the "Set Site UID" node
3. Update the `siteUid` value with the selected UID
4. Execute workflow

### Option 3: Automation (Advanced)

Modify the Site Selector workflow to automatically trigger the software inventory workflow:

1. After "Generate HTML Form" node, add a branch
2. Add "Execute Workflow" node
3. Set workflow to "Datto RMM Software Inventory Sync"
4. Pass the selected Site UID as a parameter

## Customization

### Add More Filters

Edit the "Filter Sites" node to add additional conditions:

```javascript
// Example: Exclude sites with "demo" in the name
{
  "id": "not-demo",
  "leftValue": "={{ $json.name.toLowerCase() }}",
  "rightValue": "demo",
  "operator": {
    "type": "string",
    "operation": "notContains",
    "singleValue": true
  }
}
```

### Change Sort Order

Edit the "Sort by Name" node:
- Change `order` from `"ascending"` to `"descending"`

### Customize HTML Styling

Edit the "Generate HTML Form" Code node to modify:
- Colors
- Font sizes
- Layout
- Button text
- Instructions

## Troubleshooting

### Error: "No webhook URL available"

**Cause:** Workflow is not activated

**Solution:**
1. Activate the workflow (green toggle)
2. Refresh the workflow
3. Check the webhook trigger node for the URL

### No sites appear in dropdown

**Cause:** All sites filtered out, or authentication failed

**Solution:**
1. Verify "S_Datto RMM - Get Sites" workflow is active and working
2. Check filter conditions - may be too restrictive
3. Test the "Get Sites" sub-workflow manually

### Form doesn't display

**Cause:** Webhook configuration issue

**Solution:**
1. Check webhook path is set to "datto-site-selector"
2. Verify HTTP method is GET
3. Ensure "Response Mode" is set to "Using 'Respond to Webhook' Node"
4. Check that "Respond with HTML" node has Content-Type header set to "text/html"

## Security Considerations

### Access Control

The webhook URL is publicly accessible. To restrict access:

1. **Option 1: Authentication Header**
   - Add authentication check in "Generate HTML Form" node
   - Verify bearer token or API key

2. **Option 2: IP Whitelist**
   - Configure n8n to only accept requests from specific IPs
   - Use reverse proxy (nginx) for IP filtering

3. **Option 3: Internal Network Only**
   - Don't expose webhook URL externally
   - Access only via VPN or internal network

### Data Exposure

The site selector reveals:
- Site names
- Site UIDs

Consider if this information should be restricted to authenticated users only.

## Performance

### Response Time

Typical execution:
- 1-10 sites: ~2 seconds
- 11-50 sites: ~3 seconds
- 51-100 sites: ~5 seconds

Response time depends on:
- Number of sites in Datto RMM
- Network latency to Datto API
- n8n server resources

### Caching (Optional)

To improve performance, cache the site list:

1. Create a scheduled workflow that runs hourly
2. Fetches and filters sites
3. Stores results in n8n Data Table
4. Modify this workflow to read from the table instead of calling Datto API

Benefits:
- Faster response (~1 second)
- Reduces Datto API calls
- Site list refreshes automatically

## Next Steps

1. ✅ Activate the workflow
2. ✅ Test the webhook URL in browser
3. ✅ Select a site and copy the UID
4. ✅ Use the UID with the software inventory workflow
5. ✅ Bookmark the webhook URL for easy access
6. ✅ Consider adding authentication if needed

## Related Documentation

- **Software Inventory Workflow:** `QUICK_START.md`
- **Authentication Pattern:** `AUTHENTICATION_PATTERN.md`
- **Table Setup Pattern:** `TABLE_SETUP_PATTERN.md`

---

**Created:** 2025-12-18
**Workflow Version:** 1.0
**Author:** MCC MSP Operations Team
