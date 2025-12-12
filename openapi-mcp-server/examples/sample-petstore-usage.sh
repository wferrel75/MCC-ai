#!/bin/bash

# Example: Using the OpenAPI MCP Server to analyze Petstore API
# This script demonstrates common operations using the MCP CLI

echo "=== OpenAPI MCP Server Demo ==="
echo ""

# Note: This is a conceptual example. In practice, you'd use an MCP client
# to communicate with the server via stdio protocol.

echo "1. Loading Petstore API specification..."
cat << EOF | node ../dist/index.js
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "load_openapi_spec",
    "arguments": {
      "source": "https://petstore3.swagger.io/api/v3/openapi.json",
      "specId": "petstore"
    }
  }
}
EOF

echo ""
echo "2. Getting API overview..."
cat << EOF | node ../dist/index.js
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/call",
  "params": {
    "name": "get_api_overview",
    "arguments": {
      "specId": "petstore",
      "includeEndpoints": false
    }
  }
}
EOF

echo ""
echo "3. Searching for pet endpoints..."
cat << EOF | node ../dist/index.js
{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "tools/call",
  "params": {
    "name": "search_endpoints",
    "arguments": {
      "specId": "petstore",
      "query": "pet",
      "method": "GET"
    }
  }
}
EOF

echo ""
echo "4. Getting endpoint details..."
cat << EOF | node ../dist/index.js
{
  "jsonrpc": "2.0",
  "id": 4,
  "method": "tools/call",
  "params": {
    "name": "get_endpoint_details",
    "arguments": {
      "specId": "petstore",
      "endpointId": "GET /pet/{petId}"
    }
  }
}
EOF

echo ""
echo "5. Generating JavaScript code..."
cat << EOF | node ../dist/index.js
{
  "jsonrpc": "2.0",
  "id": 5,
  "method": "tools/call",
  "params": {
    "name": "generate_request_code",
    "arguments": {
      "specId": "petstore",
      "endpointId": "GET /pet/{petId}",
      "language": "javascript",
      "includeSteps": true
    }
  }
}
EOF

echo ""
echo "=== Demo Complete ==="
