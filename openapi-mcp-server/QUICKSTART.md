# Quick Start Guide

Get up and running with the OpenAPI MCP Server in 5 minutes.

## Prerequisites

- Node.js 18 or higher
- npm or yarn
- A Claude Desktop account (or custom MCP client)

## Installation

### Step 1: Clone and Build

```bash
# Navigate to the project directory
cd openapi-mcp-server

# Install dependencies
npm install

# Build the project
npm run build
```

### Step 2: Configure Claude Desktop

Edit your Claude Desktop config file:

**macOS:**
```bash
nano ~/Library/Application\ Support/Claude/claude_desktop_config.json
```

**Windows:**
```powershell
notepad %APPDATA%\Claude\claude_desktop_config.json
```

Add this configuration:

```json
{
  "mcpServers": {
    "openapi": {
      "command": "node",
      "args": [
        "/absolute/path/to/openapi-mcp-server/dist/index.js"
      ]
    }
  }
}
```

**Important:** Replace `/absolute/path/to/` with the actual path on your system.

### Step 3: Restart Claude Desktop

Close and reopen Claude Desktop to load the MCP server.

## First API Analysis

Let's analyze the Petstore API:

### 1. Ask Claude to Load the API

```
Load the Petstore API from https://petstore3.swagger.io/api/v3/openapi.json
```

Claude will use the `load_openapi_spec` tool behind the scenes.

### 2. Get an Overview

```
Show me an overview of the Petstore API
```

You'll see:
- Number of endpoints
- Available HTTP methods
- Authentication types
- API tags/categories

### 3. Search for Endpoints

```
Find all endpoints related to pets
```

or

```
Show me all GET endpoints
```

### 4. Get Endpoint Details

```
Show me the details for GET /pet/{petId}
```

You'll see:
- Parameters required
- Request/response format
- Authentication needs
- Status codes

### 5. Generate Code

```
Generate JavaScript code to call GET /pet/{petId}
```

You'll receive:
- Working code example
- Authentication setup
- Step-by-step instructions

## Common Use Cases

### Use Case 1: Learn a New API

```
# Load the API
Load the GitHub API from https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json

# Get overview
What are the main categories of the GitHub API?

# Find specific functionality
How do I list repositories for a user?

# Get implementation details
Generate Python code to list all repositories for a user
```

### Use Case 2: Create an n8n Workflow

```
# Load your API
Load the API spec from /path/to/my-api-spec.json

# Find endpoints
Search for user creation and user listing endpoints

# Generate workflow
Generate an n8n workflow that fetches all users and processes them

# Get the configuration
Show me the n8n node configuration for POST /users
```

### Use Case 3: Understand Authentication

```
# Load API
Load the Stripe API

# Check auth
What authentication does the Stripe API require?

# Endpoint-specific
What authentication is needed for POST /v1/customers?

# Get setup instructions
How do I set up Bearer token authentication for this API?
```

### Use Case 4: Implement Pagination

```
# Load API
Load my API spec

# Analyze pagination
How does pagination work in GET /products?

# Get implementation
Generate code that fetches all products using pagination
```

## Testing the Server Directly

You can test the server without Claude Desktop:

```bash
# Create a test script
cat > test-server.js << 'EOF'
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';

const client = new Client({
  name: 'test-client',
  version: '1.0.0',
});

const transport = new StdioClientTransport({
  command: 'node',
  args: ['./dist/index.js'],
});

await client.connect(transport);

// Load a spec
const result = await client.callTool({
  name: 'load_openapi_spec',
  arguments: {
    source: 'https://petstore3.swagger.io/api/v3/openapi.json',
    specId: 'petstore',
  },
});

console.log(JSON.parse(result.content[0].text));

await client.close();
EOF

# Run it
node test-server.js
```

## Example Workflows

### Workflow 1: API Documentation Bot

Create a bot that answers questions about your API:

1. Load your company's API spec
2. Ask questions in natural language
3. Get code examples automatically
4. Share with your team

### Workflow 2: Integration Generator

Build integrations faster:

1. Load source API spec
2. Load destination API spec
3. Find matching endpoints (users, products, etc.)
4. Generate n8n workflow to sync data
5. Deploy and test

### Workflow 3: API Change Detector

Monitor API changes:

1. Load API spec v1
2. Load API spec v2
3. Compare endpoints
4. Identify breaking changes
5. Update integrations

## Tips for Success

### 1. Use Descriptive Spec IDs

```typescript
// Good
{ specId: "stripe-v2023" }
{ specId: "internal-users-api" }

// Less clear
{ specId: "api1" }
{ specId: "spec" }
```

### 2. Start with Overview

Always start with `get_api_overview` to understand the API structure before diving into specific endpoints.

### 3. Search Before Details

Use `search_endpoints` to find what you need, then use `get_endpoint_details` for specific endpoints.

### 4. Generate Examples

Let the server generate code examples - they include proper authentication, parameters, and error handling.

### 5. Save Frequently Used Specs

Keep a list of frequently used API specs and their URLs for quick loading:

```typescript
const myAPIs = {
  github: 'https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json',
  stripe: 'https://raw.githubusercontent.com/stripe/openapi/master/openapi/spec3.json',
  petstore: 'https://petstore3.swagger.io/api/v3/openapi.json',
};
```

## Troubleshooting

### Server Not Responding

1. Check the server is running: `ps aux | grep node`
2. Check Claude Desktop console for errors
3. Verify the path in config is absolute
4. Try running manually: `node dist/index.js`

### Spec Loading Fails

1. Validate the spec at https://editor.swagger.io/
2. Check URL is accessible
3. Try loading a sample spec (Petstore) to test server
4. Check file permissions if loading from file

### Generated Code Doesn't Work

1. Check authentication is configured correctly
2. Verify the endpoint exists in the API
3. Check parameter values are correct
4. Test with curl first to isolate the issue

## Next Steps

1. **Read the full documentation:**
   - README.md - Overview and features
   - ARCHITECTURE.md - System design
   - CONFIGURATION.md - Advanced configuration
   - N8N_INTEGRATION.md - n8n workflows

2. **Try the examples:**
   - See `examples/example-usage.md` for detailed scenarios
   - Run sample scripts in `examples/`

3. **Extend the server:**
   - Add custom code generators
   - Create new tools
   - Integrate with your systems

4. **Join the community:**
   - Report issues on GitHub
   - Share your use cases
   - Contribute improvements

## Common Commands Reference

| Task | Command in Claude |
|------|-------------------|
| Load API | "Load the API from [URL or path]" |
| Overview | "Show me an overview of [API name]" |
| Search | "Find endpoints for [functionality]" |
| Details | "Show details for [endpoint]" |
| Generate code | "Generate [language] code for [endpoint]" |
| n8n node | "Create n8n node for [endpoint]" |
| n8n workflow | "Create n8n workflow for [endpoints]" |
| Authentication | "What authentication does [API/endpoint] need?" |
| Schema | "Show me the [schema name] data model" |
| Pagination | "How does pagination work for [endpoint]?" |

## Support

- Documentation: See all `.md` files in this repository
- Issues: GitHub Issues (if available)
- Examples: See `examples/` directory
- Testing: Run `npm test` for unit tests

Happy API exploring!
