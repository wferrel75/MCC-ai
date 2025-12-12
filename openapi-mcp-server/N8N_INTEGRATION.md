# n8n Integration Guide

This guide explains how to use the OpenAPI MCP Server to generate n8n workflows and integrate APIs into your automation platform.

## Overview

The OpenAPI MCP Server can:
1. Generate n8n HTTP Request node configurations from OpenAPI endpoints
2. Create complete workflows with multiple API calls
3. Handle authentication setup automatically
4. Map parameters to n8n expressions
5. Provide ready-to-import JSON configurations

## Quick Start

### 1. Load Your API Specification

```typescript
{
  "name": "load_openapi_spec",
  "arguments": {
    "source": "https://api.example.com/openapi.json",
    "specId": "my-api"
  }
}
```

### 2. Search for Desired Endpoints

```typescript
{
  "name": "search_endpoints",
  "arguments": {
    "specId": "my-api",
    "query": "users"
  }
}
```

### 3. Generate n8n Node Configuration

```typescript
{
  "name": "generate_n8n_node",
  "arguments": {
    "specId": "my-api",
    "endpointId": "GET /users/{id}"
  }
}
```

### 4. Import into n8n

1. Copy the generated node configuration
2. Open your n8n workflow
3. Click "Add Node" → "HTTP Request"
4. Paste the configuration into the node
5. Configure credentials if needed

## Detailed Examples

### Example 1: Simple GET Request

#### API Endpoint
```
GET /users/{id}
Parameters:
  - id (path, required): User ID
Authentication: Bearer token
```

#### Generated n8n Node

```json
{
  "id": "node_1234567890_abc123def",
  "name": "Get User by ID",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "position": [250, 300],
  "parameters": {
    "method": "GET",
    "url": "https://api.example.com/users/={{$json[\"id\"]}}",
    "authentication": "genericCredentialType",
    "genericAuthType": "httpHeaderAuth",
    "options": {}
  }
}
```

#### How to Use
1. Add a trigger node (Manual Trigger, Webhook, etc.)
2. Add a Set node to provide the `id` value
3. Import this HTTP Request node
4. Configure Bearer token credentials
5. Test the workflow

### Example 2: POST Request with Body

#### API Endpoint
```
POST /users
Request Body:
  {
    "name": string,
    "email": string,
    "age": integer
  }
Authentication: API Key (header)
```

#### Generated n8n Node

```json
{
  "id": "node_1234567891_def456ghi",
  "name": "Create User",
  "type": "n8n-nodes-base.httpRequest",
  "typeVersion": 4.2,
  "position": [250, 300],
  "parameters": {
    "method": "POST",
    "url": "https://api.example.com/users",
    "authentication": "genericCredentialType",
    "genericAuthType": "httpHeaderAuth",
    "sendBody": true,
    "bodyParametersUi": {
      "parameter": [
        {
          "name": "name",
          "value": "={{$json[\"name\"]}}"
        },
        {
          "name": "email",
          "value": "={{$json[\"email\"]}}"
        },
        {
          "name": "age",
          "value": "={{$json[\"age\"]}}"
        }
      ]
    },
    "options": {
      "headers": {
        "entries": [
          {
            "name": "Content-Type",
            "value": "application/json"
          }
        ]
      }
    }
  }
}
```

#### How to Use
1. Add a trigger node
2. Add a Set node with fields: name, email, age
3. Import this HTTP Request node
4. Configure API Key credentials (create HTTP Header Auth credential with header name from API spec)
5. Test with sample data

### Example 3: Complete Workflow

#### Use Case: User Sync Workflow

Fetch users from Source API, transform data, create in Destination API

```typescript
// Generate workflow
{
  "name": "generate_n8n_workflow",
  "arguments": {
    "specId": "source-api",
    "endpointIds": ["GET /users"],
    "workflowName": "Fetch Source Users"
  }
}
```

#### Generated Workflow

```json
{
  "name": "User Sync Workflow",
  "nodes": [
    {
      "id": "trigger_node",
      "name": "Manual Trigger",
      "type": "n8n-nodes-base.manualTrigger",
      "typeVersion": 1,
      "position": [250, 150],
      "parameters": {}
    },
    {
      "id": "node_fetch_users",
      "name": "GET /users",
      "type": "n8n-nodes-base.httpRequest",
      "typeVersion": 4.2,
      "position": [250, 300],
      "parameters": {
        "method": "GET",
        "url": "https://source-api.example.com/users",
        "authentication": "genericCredentialType",
        "genericAuthType": "httpHeaderAuth",
        "options": {
          "queryParameters": {
            "entries": [
              {
                "name": "page",
                "value": "={{$json[\"page\"]}}"
              },
              {
                "name": "limit",
                "value": "={{$json[\"limit\"]}}"
              }
            ]
          }
        }
      }
    }
  ],
  "connections": {
    "trigger_node": {
      "main": [[{ "node": "GET /users", "type": "main", "index": 0 }]]
    }
  },
  "settings": {
    "executionOrder": "v1"
  }
}
```

#### Enhancements to Add Manually

1. **Add Split In Batches node** (for pagination)
2. **Add Function/Set node** (to transform data)
3. **Add HTTP Request node** (to create users in destination)
4. **Add Error Trigger** (for error handling)

Complete enhanced workflow:

```
[Manual Trigger]
    ↓
[Set (page=1, limit=100)]
    ↓
[GET /users (Source API)]
    ↓
[Split In Batches]
    ↓
[Function (Transform User Data)]
    ↓
[POST /users (Destination API)]
    ↓
[IF (Check if more pages)]
    ↓
[Loop back to Set node]
```

## Authentication Configuration

### Bearer Token

1. In n8n, go to Credentials → New Credential
2. Select "HTTP Header Auth"
3. Set:
   - Name: `Authorization`
   - Value: `Bearer YOUR_TOKEN_HERE`
4. Save as "API Bearer Token"

### API Key in Header

1. In n8n, go to Credentials → New Credential
2. Select "HTTP Header Auth"
3. Set:
   - Name: `X-API-Key` (or whatever your API uses)
   - Value: `YOUR_API_KEY_HERE`
4. Save as "API Key"

### Basic Authentication

1. In n8n, go to Credentials → New Credential
2. Select "HTTP Header Auth"
3. Set:
   - Name: `Authorization`
   - Value: `Basic BASE64(username:password)`
4. Or use built-in Basic Auth credential type

### OAuth2

1. In n8n, go to Credentials → New Credential
2. Select "OAuth2 API"
3. Configure:
   - Authorization URL
   - Access Token URL
   - Client ID
   - Client Secret
   - Scopes
4. Complete OAuth flow

## Advanced Patterns

### Pattern 1: Pagination Loop

```
[Manual Trigger]
    ↓
[Set: page=1, hasMore=true]
    ↓
[IF: hasMore === true]
    ├─ True → [HTTP Request: GET /items?page={{page}}]
    │           ↓
    │        [Function: Check if response has data]
    │           ↓
    │        [Set: page=page+1, hasMore=(data.length > 0)]
    │           ↓
    │        [Loop back to IF node]
    │
    └─ False → [Done]
```

**Generated Starting Point:**
```typescript
{
  "name": "generate_n8n_node",
  "arguments": {
    "specId": "my-api",
    "endpointId": "GET /items"
  }
}
```

**Manual Additions:**
- Split In Batches node (to handle pagination)
- Function node (to process each batch)
- IF node (to check for more pages)

### Pattern 2: Error Handling

```
[HTTP Request]
    ├─ Success → [Process Data]
    │
    └─ Error → [Error Trigger]
                  ↓
               [Log Error]
                  ↓
               [Send Alert (Email/Slack)]
```

**Configuration:**
1. In HTTP Request node settings:
   - Continue On Fail: `true`
2. Add Error Trigger node after HTTP Request
3. Connect both success and error paths

### Pattern 3: Batch Processing

```
[Trigger]
    ↓
[GET /items (All items)]
    ↓
[Split In Batches: 10 items at a time]
    ↓
[Item Lists Node]
    ↓
[HTTP Request: Process each item]
    ↓
[Wait: 1 second]
    ↓
[Loop back to Split In Batches]
```

**Use Case:** Process large datasets without overwhelming the API

### Pattern 4: Multi-Step API Call

```
[Trigger]
    ↓
[POST /auth/token (Get access token)]
    ↓
[Set: token={{$json["access_token"]}}]
    ↓
[GET /users (With token)]
    ↓
[Split In Batches]
    ↓
[For Each User]
    ├─ [GET /users/{id}/details]
    ├─ [GET /users/{id}/orders]
    └─ [Merge Data]
           ↓
        [POST /webhook/result]
```

**Generate nodes:**
```typescript
{
  "name": "generate_n8n_workflow",
  "arguments": {
    "specId": "my-api",
    "endpointIds": [
      "POST /auth/token",
      "GET /users",
      "GET /users/{id}/details",
      "GET /users/{id}/orders"
    ],
    "workflowName": "Multi-Step API Integration"
  }
}
```

## Mapping OpenAPI to n8n

### Parameter Mapping

| OpenAPI Location | n8n Configuration |
|------------------|-------------------|
| Path parameter | URL: `https://api.example.com/users/={{$json["userId"]}}` |
| Query parameter | Options → Query Parameters → Add Parameter |
| Header parameter | Options → Headers → Add Header |
| Request body | Body Parameters or JSON/RAW |
| Cookie parameter | Options → Headers → Add Header (Cookie) |

### Expression Examples

```javascript
// Access input data
={{$json["fieldName"]}}

// Access previous node
={{$node["NodeName"].json["fieldName"]}}

// Concatenate
={{$json["firstName"] + " " + $json["lastName"]}}

// Conditional
={{$json["status"] === "active" ? "yes" : "no"}}

// Array access
={{$json["items"][0]["name"]}}

// Current timestamp
={{$now}}

// Format date
={{$now.toISO()}}
```

### Content Type Handling

| Content-Type | n8n Configuration |
|--------------|-------------------|
| application/json | Body Parameters UI or JSON/RAW mode |
| application/x-www-form-urlencoded | Body Parameters UI (Form-urlencoded) |
| multipart/form-data | Body Parameters UI (Form-data) |
| text/plain | Body Parameters UI (Raw) with Content-Type header |
| application/xml | Body Parameters UI (Raw) with Content-Type header |

## Integration with n8n MCP Tools

If you're using the n8n MCP server alongside this OpenAPI MCP server:

### Combined Workflow

1. **Use OpenAPI MCP** to generate node configuration
2. **Use n8n MCP** to create the workflow
3. **Use n8n MCP** to validate the workflow
4. **Use n8n MCP** to deploy to your n8n instance

### Example Combined Usage

```typescript
// Step 1: Generate n8n node with OpenAPI MCP
const nodeConfig = await openapi_mcp.generate_n8n_node({
  specId: "my-api",
  endpointId: "GET /users/{id}"
});

// Step 2: Create workflow with n8n MCP
await n8n_mcp.n8n_create_workflow({
  name: "Get User Workflow",
  nodes: [
    {
      // Manual trigger
      id: "trigger",
      name: "Manual Trigger",
      type: "n8n-nodes-base.manualTrigger",
      typeVersion: 1,
      position: [250, 150],
      parameters: {}
    },
    nodeConfig.node // Generated HTTP Request node
  ],
  connections: {
    trigger: {
      main: [[{ node: nodeConfig.node.name, type: "main", index: 0 }]]
    }
  }
});

// Step 3: Validate
await n8n_mcp.n8n_validate_workflow({
  workflowId: "workflow-id"
});

// Step 4: Test
await n8n_mcp.n8n_test_workflow({
  workflowId: "workflow-id",
  data: { id: "123" }
});
```

## Best Practices

### 1. Credential Management

- **Never hardcode credentials** in workflows
- Use n8n's credential system
- Rotate credentials regularly
- Use different credentials for dev/prod

### 2. Error Handling

- Always enable "Continue On Fail" for HTTP nodes
- Add Error Trigger nodes
- Log errors for debugging
- Implement retry logic for transient failures

### 3. Performance

- Use pagination for large datasets
- Implement rate limiting (Wait node between requests)
- Batch requests when possible
- Cache frequently accessed data

### 4. Testing

- Test with sample data first
- Use n8n's execution view to debug
- Validate response schemas
- Monitor execution times

### 5. Maintenance

- Document your workflows
- Version control workflow JSON
- Monitor for API changes
- Update when API specs change

## Troubleshooting

### Issue: Generated node doesn't work

**Solutions:**
1. Check API endpoint is accessible
2. Verify authentication credentials
3. Validate request body format
4. Check for required parameters
5. Review API rate limits

### Issue: Parameters not mapping correctly

**Solutions:**
1. Verify input data structure
2. Check n8n expression syntax
3. Use Function node for complex transformations
4. Review OpenAPI spec for parameter requirements

### Issue: Authentication fails

**Solutions:**
1. Verify credential configuration
2. Check authentication type matches API spec
3. Ensure token/key is valid and not expired
4. Review API documentation for auth requirements

### Issue: Response parsing errors

**Solutions:**
1. Check response Content-Type
2. Verify response schema matches expectations
3. Use Function node to transform response
4. Handle edge cases (empty responses, errors)

## Additional Resources

- n8n Documentation: https://docs.n8n.io/
- n8n Expression Functions: https://docs.n8n.io/code-examples/expressions/
- n8n Community Forum: https://community.n8n.io/
- OpenAPI Specification: https://swagger.io/specification/

## Example Workflows

See the `examples/n8n-workflows/` directory for:
- Basic CRUD operations
- Pagination patterns
- Error handling examples
- Authentication setups
- Multi-API integrations
