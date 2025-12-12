# Example Usage Scenarios

## Scenario 1: Exploring a Public API

### Step 1: Load the API Specification

```typescript
// Tool: load_openapi_spec
{
  "source": "https://petstore3.swagger.io/api/v3/openapi.json",
  "specId": "petstore"
}
```

**Response:**
```json
{
  "success": true,
  "specId": "petstore",
  "summary": {
    "title": "Swagger Petstore - OpenAPI 3.0",
    "version": "1.0.11",
    "description": "This is a sample Pet Store Server...",
    "totalEndpoints": 19,
    "endpointsByMethod": {
      "GET": 8,
      "POST": 5,
      "PUT": 3,
      "DELETE": 3
    },
    "authTypes": ["apiKey", "oauth2"],
    "servers": ["https://petstore3.swagger.io/api/v3"]
  }
}
```

### Step 2: Get an Overview

```typescript
// Tool: get_api_overview
{
  "specId": "petstore",
  "includeEndpoints": false
}
```

**Response:**
```json
{
  "title": "Swagger Petstore - OpenAPI 3.0",
  "version": "1.0.11",
  "description": "This is a sample Pet Store Server...",
  "servers": [
    {
      "url": "https://petstore3.swagger.io/api/v3"
    }
  ],
  "authentication": [
    {
      "type": "apiKey",
      "name": "api_key",
      "in": "header",
      "instruction": "Provide API key in header parameter \"api_key\""
    }
  ],
  "summary": {
    "totalEndpoints": 19,
    "endpointsByMethod": { "GET": 8, "POST": 5, "PUT": 3, "DELETE": 3 },
    "authenticationTypes": ["apiKey", "oauth2"],
    "commonContentTypes": ["application/json", "application/xml"]
  },
  "tags": [
    { "name": "pet", "description": "Everything about your Pets", "endpointCount": 8 },
    { "name": "store", "description": "Access to Petstore orders", "endpointCount": 4 },
    { "name": "user", "description": "Operations about user", "endpointCount": 7 }
  ]
}
```

### Step 3: Search for Specific Endpoints

```typescript
// Tool: search_endpoints
{
  "specId": "petstore",
  "query": "pet",
  "method": "GET"
}
```

**Response:**
```json
{
  "total": 3,
  "endpoints": [
    {
      "id": "GET /pet/findByStatus",
      "method": "GET",
      "path": "/pet/findByStatus",
      "summary": "Finds Pets by status",
      "tags": ["pet"],
      "deprecated": false
    },
    {
      "id": "GET /pet/findByTags",
      "method": "GET",
      "path": "/pet/findByTags",
      "summary": "Finds Pets by tags",
      "tags": ["pet"],
      "deprecated": true
    },
    {
      "id": "GET /pet/{petId}",
      "method": "GET",
      "path": "/pet/{petId}",
      "summary": "Find pet by ID",
      "tags": ["pet"],
      "deprecated": false
    }
  ]
}
```

### Step 4: Get Detailed Endpoint Information

```typescript
// Tool: get_endpoint_details
{
  "specId": "petstore",
  "endpointId": "GET /pet/{petId}"
}
```

**Response:**
```json
{
  "id": "GET /pet/{petId}",
  "method": "GET",
  "path": "/pet/{petId}",
  "operationId": "getPetById",
  "summary": "Find pet by ID",
  "description": "Returns a single pet",
  "tags": ["pet"],
  "security": [
    {
      "type": "apiKey",
      "name": "api_key",
      "in": "header",
      "instruction": "Provide API key in header parameter \"api_key\""
    }
  ],
  "parameters": [
    {
      "name": "petId",
      "in": "path",
      "description": "ID of pet to return",
      "required": true,
      "schema": {
        "type": "integer",
        "format": "int64"
      }
    }
  ],
  "responses": [
    {
      "statusCode": "200",
      "description": "successful operation",
      "contentTypes": ["application/json", "application/xml"],
      "schema": {
        "type": "object",
        "properties": {
          "id": { "type": "integer", "format": "int64" },
          "name": { "type": "string", "example": "doggie" },
          "status": { "type": "string", "enum": ["available", "pending", "sold"] }
        }
      }
    },
    {
      "statusCode": "400",
      "description": "Invalid ID supplied",
      "contentTypes": []
    },
    {
      "statusCode": "404",
      "description": "Pet not found",
      "contentTypes": []
    }
  ]
}
```

### Step 5: Generate Request Code

```typescript
// Tool: generate_request_code
{
  "specId": "petstore",
  "endpointId": "GET /pet/{petId}",
  "language": "javascript",
  "includeSteps": true
}
```

**Response:**
```json
{
  "endpoint": {
    "id": "GET /pet/{petId}",
    "method": "GET",
    "path": "/pet/{petId}",
    "summary": "Find pet by ID"
  },
  "stepByStepInstructions": [
    "Send a GET request to endpoint: /pet/{petId}",
    "Authentication: Provide API key in header parameter \"api_key\"",
    "Replace path parameters: {petId} with your ID of pet to return",
    "Expected success response: 200 - successful operation"
  ],
  "example": "// Using fetch API\n\nconst response = await fetch('https://petstore3.swagger.io/api/v3/pet/{petId}', {\n  method: 'GET',\n  headers: {\n    'api_key': '{YOUR_API_KEY}',\n  },\n});\n\nif (!response.ok) {\n  throw new Error(`HTTP error! status: ${response.status}`);\n}\n\nconst data = await response.json();\nconsole.log(data);"
}
```

---

## Scenario 2: Creating an n8n Workflow

### Use Case: Sync Users Between Two Systems

#### Step 1: Load Both API Specs

```typescript
// Load Source API
{
  "source": "/path/to/source-api.json",
  "specId": "source-api"
}

// Load Destination API
{
  "source": "/path/to/dest-api.json",
  "specId": "dest-api"
}
```

#### Step 2: Find Relevant Endpoints

```typescript
// Find user list endpoint in source API
{
  "specId": "source-api",
  "query": "users",
  "method": "GET"
}

// Find user creation endpoint in destination API
{
  "specId": "dest-api",
  "query": "users",
  "method": "POST"
}
```

#### Step 3: Generate n8n Workflow

```typescript
// Tool: generate_n8n_workflow
{
  "specId": "source-api",
  "endpointIds": ["GET /users"],
  "workflowName": "Fetch Users from Source"
}
```

Then for the destination:

```typescript
{
  "specId": "dest-api",
  "endpointIds": ["POST /users"],
  "workflowName": "Create Users in Destination"
}
```

#### Step 4: Combine and Configure

Manually combine the workflows:
1. Import first workflow (fetch users)
2. Add transformation node
3. Import second workflow nodes (create users)
4. Connect them together
5. Configure credentials

---

## Scenario 3: Understanding Authentication

### Step 1: Get Authentication Overview

```typescript
// Tool: get_authentication_info
{
  "specId": "petstore"
}
```

**Response:**
```json
{
  "defaultSecurity": [
    {
      "type": "apiKey",
      "name": "api_key",
      "in": "header",
      "description": "API key for authentication",
      "instruction": "Provide API key in header parameter \"api_key\""
    }
  ],
  "authenticationTypes": ["apiKey", "oauth2"],
  "endpointSecurityVariations": [
    {
      "security": [
        {
          "type": "apiKey",
          "name": "api_key",
          "in": "header",
          "instruction": "Provide API key in header parameter \"api_key\""
        }
      ],
      "endpointCount": 15
    },
    {
      "security": [
        {
          "type": "oauth2",
          "flows": [
            {
              "type": "implicit",
              "authorizationUrl": "https://petstore3.swagger.io/oauth/authorize",
              "scopes": ["write:pets", "read:pets"]
            }
          ],
          "instruction": "OAuth2 authentication required. Scopes: write:pets, read:pets"
        }
      ],
      "endpointCount": 4
    }
  ]
}
```

### Step 2: Get Endpoint-Specific Auth

```typescript
// Tool: get_authentication_info
{
  "specId": "petstore",
  "endpointId": "POST /pet"
}
```

**Response:**
```json
{
  "endpoint": "POST /pet",
  "security": [
    {
      "type": "oauth2",
      "flows": [
        {
          "type": "implicit",
          "authorizationUrl": "https://petstore3.swagger.io/oauth/authorize",
          "scopes": ["write:pets", "read:pets"]
        }
      ],
      "instruction": "OAuth2 authentication required. Scopes: write:pets, read:pets"
    }
  ]
}
```

---

## Scenario 4: Working with Data Models

### Step 1: Explore Available Schemas

```typescript
// Tool: get_api_overview
{
  "specId": "petstore",
  "includeEndpoints": false
}
// Response includes schemas in the spec.schemas field
```

### Step 2: Get Schema Details

```typescript
// Tool: get_schema_details
{
  "specId": "petstore",
  "schemaName": "Pet",
  "includeExample": true
}
```

**Response:**
```json
{
  "name": "Pet",
  "schema": {
    "type": "object",
    "required": ["name", "photoUrls"],
    "properties": {
      "id": {
        "type": "integer",
        "format": "int64",
        "example": 10
      },
      "name": {
        "type": "string",
        "example": "doggie"
      },
      "category": {
        "type": "object",
        "properties": {
          "id": { "type": "integer", "format": "int64" },
          "name": { "type": "string" }
        }
      },
      "photoUrls": {
        "type": "array",
        "items": { "type": "string" }
      },
      "tags": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "id": { "type": "integer", "format": "int64" },
            "name": { "type": "string" }
          }
        }
      },
      "status": {
        "type": "string",
        "enum": ["available", "pending", "sold"],
        "description": "pet status in the store"
      }
    }
  },
  "example": {
    "id": 10,
    "name": "doggie",
    "category": {
      "id": 0,
      "name": "string"
    },
    "photoUrls": ["string"],
    "tags": [
      {
        "id": 0,
        "name": "string"
      }
    ],
    "status": "available"
  }
}
```

---

## Scenario 5: Implementing Pagination

### Step 1: Find List Endpoint

```typescript
// Tool: search_endpoints
{
  "specId": "github-api",
  "query": "repositories",
  "method": "GET"
}
```

### Step 2: Analyze Pagination

```typescript
// Tool: analyze_pagination
{
  "specId": "github-api",
  "endpointId": "GET /user/repos"
}
```

**Response:**
```json
{
  "detected": [
    {
      "endpoint": "GET /user/repos",
      "type": "page-based",
      "parameters": [
        {
          "name": "page",
          "in": "query",
          "description": "Page number of the results to fetch",
          "required": false,
          "schema": { "type": "integer", "default": 1 }
        },
        {
          "name": "per_page",
          "in": "query",
          "description": "Number of results per page",
          "required": false,
          "schema": { "type": "integer", "default": 30, "maximum": 100 }
        }
      ]
    }
  ],
  "recommendations": [
    "Implement page-based pagination by incrementing the page parameter until no more results are returned."
  ]
}
```

### Step 3: Generate Code with Pagination

```typescript
// Tool: generate_request_code
{
  "specId": "github-api",
  "endpointId": "GET /user/repos",
  "language": "javascript"
}
```

Then modify the generated code to add pagination:

```javascript
// Pagination example based on generated code
async function getAllRepositories() {
  const allRepos = [];
  let page = 1;
  let hasMore = true;

  while (hasMore) {
    const response = await fetch(
      `https://api.github.com/user/repos?page=${page}&per_page=100`,
      {
        method: 'GET',
        headers: {
          'Authorization': 'Bearer YOUR_TOKEN',
          'Accept': 'application/vnd.github.v3+json',
        },
      }
    );

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const repos = await response.json();

    if (repos.length === 0) {
      hasMore = false;
    } else {
      allRepos.push(...repos);
      page++;
    }
  }

  return allRepos;
}
```

---

## Scenario 6: Comparing API Versions

### Step 1: Load Different Versions

```typescript
// Load v1
{
  "source": "https://api.example.com/v1/openapi.json",
  "specId": "example-api-v1"
}

// Load v2
{
  "source": "https://api.example.com/v2/openapi.json",
  "specId": "example-api-v2"
}
```

### Step 2: Compare Endpoints

```typescript
// Get overview of v1
{
  "specId": "example-api-v1",
  "includeEndpoints": true
}

// Get overview of v2
{
  "specId": "example-api-v2",
  "includeEndpoints": true
}
```

### Step 3: Identify Changes

Compare the responses to find:
- New endpoints in v2
- Removed endpoints from v1
- Changed authentication
- Modified parameters

---

## Scenario 7: Building a Complete Integration

### Use Case: Integrate Stripe Payments

#### Step 1: Load Stripe API

```typescript
{
  "source": "https://raw.githubusercontent.com/stripe/openapi/master/openapi/spec3.json",
  "specId": "stripe"
}
```

#### Step 2: Find Payment Intent Endpoints

```typescript
{
  "specId": "stripe",
  "query": "payment_intents"
}
```

#### Step 3: Get Create Payment Intent Details

```typescript
{
  "specId": "stripe",
  "endpointId": "POST /v1/payment_intents"
}
```

#### Step 4: Generate Implementation Code

```typescript
{
  "specId": "stripe",
  "endpointId": "POST /v1/payment_intents",
  "language": "javascript",
  "includeSteps": true
}
```

#### Step 5: Generate n8n Workflow

```typescript
{
  "specId": "stripe",
  "endpointIds": [
    "POST /v1/payment_intents",
    "GET /v1/payment_intents/{intent}",
    "POST /v1/payment_intents/{intent}/confirm"
  ],
  "workflowName": "Stripe Payment Flow"
}
```

---

## Tips for Effective Usage

1. **Always start with `load_openapi_spec`** - This is required before any other operations

2. **Use `get_api_overview` first** - Get the big picture before diving into details

3. **Search before getting details** - Use `search_endpoints` to find what you need

4. **Check authentication early** - Use `get_authentication_info` to understand requirements

5. **Generate examples for complex endpoints** - Code generation helps with intricate APIs

6. **Analyze pagination for list endpoints** - Understand how to get all data

7. **Use schema details for request bodies** - Understand data structures before making requests

8. **Test with curl first** - Generated curl commands are easiest to test

9. **Save generated n8n workflows** - Export and version control your workflows

10. **Keep specIds consistent** - Use meaningful IDs for APIs you work with frequently
