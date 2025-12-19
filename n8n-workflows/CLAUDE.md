# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains n8n workflow automation configurations for Connect Secure (formerly CyberCNS) integrations. The primary purpose is to manage and develop n8n workflows that interact with the Connect Secure API.

## Architecture

### n8n MCP Integration
This repository uses the n8n Model Context Protocol (MCP) server for workflow management. The MCP tools are pre-configured in `.claude/settings.local.json` with auto-approved permissions for:
- Searching and retrieving n8n nodes
- Creating and updating workflows
- Fetching data from Connect Secure API (`pod107.myconnectsecure.com`)

### Connect Secure API

The Connect Secure API (`Connect_Secure/swagger.yaml`) is a comprehensive REST API with 226+ endpoints organized into functional modules. The API follows a path convention:
- `/w/` prefix: Write/Create operations
- `/r/` prefix: Read/Retrieve operations
- `/d/` prefix: Delete operations

**API Modules:**
- **Auth**: Authorization using Client-Auth-Token (base64 encoded `tenant+client_id:client_secret`)
- **Asset**: Asset management, discovery, and tracking
- **Company**: Company/tenant management, agents, credentials, discovery settings
- **Compliance**: Compliance assessments and tracking
- **Integration**: Third-party integrations (EDR, Firewall, Backup Software, Active Directory, etc.)
- **User**: User management and permissions
- **Report Queries**: Analytics and reporting endpoints
- **Vulnerabilities**: Vulnerability scanning and patch management

**Authentication Pattern:**
1. Authorize via `/w/authorize` with `Client-Auth-Token` header
2. Use returned `access_token` as Bearer token for subsequent requests
3. Include `X-USER-ID` header in authenticated requests

**Common Query Parameters:**
- `condition`: Filter query conditions
- `skip`: Pagination offset
- `limit`: Result limit
- `order_by`: Sort order

## n8n Data Table Pattern

**IMPORTANT:** When creating workflows that require n8n Data Tables, ALWAYS create a CSV setup file.

### Standard Practice

1. **Create CSV File:** `{TableName}_table_setup.csv`
2. **Include Sample Data:** 2-3 rows demonstrating all data types
3. **Document in Setup Guide:** Reference CSV import method
4. **Commit to Git:** Keep table schema version controlled

**See:** `TABLE_SETUP_PATTERN.md` for complete guidelines

### Data Table CSV Format

```csv
ColumnName1,ColumnName2,ColumnName3
example_value_1,example_value_2,example_value_3
example_value_4,example_value_5,example_value_6
```

**Data Types:**
- **String:** Plain text
- **Boolean:** `true` or `false` (lowercase)
- **DateTime:** ISO 8601 format (`2025-01-18T10:30:00.000Z`)
- **Number:** Decimal or integer

### Quick Example

```csv
DeviceID,DeviceName,IsOnline,LastSeen
device-001,Server-01,true,2025-01-18T10:00:00.000Z
device-002,Server-02,false,2025-01-17T22:30:00.000Z
```

## Workflow Development

### Creating n8n Workflows for Connect Secure

When building workflows that integrate with Connect Secure:

1. **Start with HTTP Request nodes** configured for the Connect Secure API endpoints
2. **Use the swagger.yaml** as reference for endpoint paths, parameters, and response schemas
3. **Implement authentication flow**:
   - First node: Authorize and store access token
   - Subsequent nodes: Use stored token for API calls
4. **Handle pagination** for endpoints that return large datasets (use `skip` and `limit`)
5. **Consider the module structure** when organizing multi-step workflows

### Working with n8n MCP Tools

Use the available MCP tools for workflow management:
- `mcp__n8n-mcp__search_nodes`: Find available n8n nodes by keyword
- `mcp__n8n-mcp__get_node`: Get detailed node configuration information
- `mcp__n8n-mcp__n8n_create_workflow`: Create new n8n workflows programmatically
- `mcp__n8n-mcp__n8n_update_full_workflow`: Update complete workflow structure
- `mcp__n8n-mcp__n8n_update_partial_workflow`: Make incremental workflow changes
- `mcp__n8n-mcp__n8n_get_workflow`: Retrieve existing workflow configurations

### API Reference Structure

The Connect Secure API swagger file contains:
- **32,566 lines** of OpenAPI 3.0 specification
- **Comprehensive schemas** for all request/response objects
- **Security definitions** for Bearer token authentication
- **Tag-based organization** for logical grouping of endpoints

Key functional areas covered:
- Active Directory integration
- Ad Audit and audit logging
- Agent management and deployment
- Application baseline and asset data
- Attack surface monitoring
- Backup software integration
- Compliance assessment
- Credentials management
- Discovery settings
- EDR integration
- Event sets and scheduling
- External scanning
- Firewall integration
- PII detection
- Patch management
- Reports and analytics
- Ticket templates
- Vulnerability management

## Existing Workflows

### ConnectSecure New Company
**Purpose:** Creates a new company/tenant in ConnectSecure
**ID:** `6dZa9lPkps3OtXyB`
**Status:** Inactive

**Flow:**
1. Loads credentials from environment variables (`CONNECTSECURE_TENANT`, `CONNECTSECURE_CLIENT_ID`, `CONNECTSECURE_CLIENT_SECRET`)
2. Encodes credentials to base64 format: `tenant+client_id:client_secret`
3. Authenticates with `/w/authorize` endpoint
4. Creates company using `/w/company/companies` endpoint with JSON body containing company data
5. Returns success/failure status

**Key Implementation Details:**
- Uses environment variables for secure credential storage
- HTTP Request node requires explicit `Content-Type: application/json` header
- Body must be sent as keypair parameters, not raw JSON string
- Includes `continueOnFail` to handle errors gracefully

### ConnectSecure Sync Companies
**Purpose:** Syncs all companies from ConnectSecure to n8n internal data table
**ID:** `LFPxadxdOeH9UGNY`
**Status:** Inactive

**Flow:**
1. Loads credentials from environment variables
2. Encodes credentials to base64
3. Authenticates with ConnectSecure API (`/w/authorize`)
4. Retrieves all companies from `/r/company/companies` (limit: 1000)
5. Transforms company data into table format
6. Upserts records to n8n Data Table "ConnectSecure_Companies"

**Key Implementation Details:**
- Uses environment variables for secure credential storage
- Data Table node uses **Upsert** operation with `CompanyID` as matching column
- Upsert automatically updates existing companies or inserts new ones
- Tracks sync time with `synced_at` timestamp on each sync
- Stores the following fields:
  - CompanyID (number, unique identifier)
  - name, description, domain, customer_name (strings)
  - address_country, address_state, address_city (strings)
  - is_deleted, is_assessment (boolean)
  - source (string)
  - tags (JSON string)
  - created_at, updated_at, synced_at (timestamps)

**Data Table Setup:**
- Table must be created manually in n8n UI (cannot be created via API)
- Table name: "ConnectSecure_Companies"
- Select the table in the "Upsert Company" node configuration

## File Structure

```
n8n-workflows/
├── .claude/
│   └── settings.local.json              # MCP permissions and tool configurations
└── Connect_Secure/
    └── swagger.yaml                      # Complete Connect Secure API specification (32K+ lines)
```

## Key Considerations

- **API Module Boundaries**: The Connect Secure API is divided into clear functional modules. Respect these boundaries when designing workflows.
- **Authentication State**: Always maintain authentication state across workflow steps. Store tokens appropriately.
- **Error Handling**: Connect Secure API returns standard HTTP status codes. Implement proper error handling for 401 (unauthorized), 404 (not found), etc.
- **Data Pagination**: Many endpoints support pagination. For large datasets, implement proper pagination logic using `skip` and `limit` parameters.
- **Tenant Context**: The API is multi-tenant. Ensure proper tenant identification in authorization and throughout workflow execution.
