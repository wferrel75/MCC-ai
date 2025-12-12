# OpenAPI MCP Server

A Model Context Protocol (MCP) server that analyzes OpenAPI/Swagger documentation and transforms it into LLM-friendly formats. This server enables AI assistants to understand, interact with, and generate code for any API documented with OpenAPI/Swagger specifications.

## Features

### Core Capabilities

1. **Parse OpenAPI Specifications**
   - Support for OpenAPI 3.x and Swagger 2.0
   - Load from files, URLs, or inline JSON/YAML
   - Automatic validation and dereferencing of `$ref` pointers

2. **LLM-Optimized API Representation**
   - Simplified schema structure that's easier for LLMs to process
   - Clear authentication requirements with human-readable instructions
   - Organized by tags, methods, and functionality
   - Example values and step-by-step guidance

3. **Code Generation**
   - Generate request code in JavaScript, Python, and curl
   - Create n8n HTTP Request node configurations
   - Build complete n8n workflows
   - Include authentication setup and parameter handling

4. **API Analysis**
   - Search endpoints by path, method, tag, or description
   - Analyze pagination patterns (page-based, offset-based, cursor-based)
   - Understand authentication schemes and requirements
   - Explore data models and schemas

## Installation

```bash
# Clone the repository
git clone <repository-url>
cd openapi-mcp-server

# Install dependencies
npm install

# Build the project
npm run build
```

## Usage

### As an MCP Server

Configure your MCP client (e.g., Claude Desktop) to use this server:

```json
{
  "mcpServers": {
    "openapi": {
      "command": "node",
      "args": ["/absolute/path/to/openapi-mcp-server/dist/index.js"]
    }
  }
}
```

### Available Tools

#### 1. `load_openapi_spec`

Load and parse an OpenAPI specification.

```typescript
{
  "source": "https://petstore.swagger.io/v2/swagger.json",
  "specId": "petstore" // optional, auto-generated if not provided
}
```

**Returns:** Summary of the loaded API including endpoint count, authentication types, and servers.

#### 2. `get_api_overview`

Get a high-level overview of a loaded API.

```typescript
{
  "specId": "petstore",
  "includeEndpoints": true // optional, default: false
}
```

**Returns:** API metadata, servers, authentication, tags, and optionally all endpoints.

#### 3. `search_endpoints`

Search for specific endpoints.

```typescript
{
  "specId": "petstore",
  "query": "user", // optional: searches path, summary, description
  "method": "GET", // optional: filter by HTTP method
  "tag": "users" // optional: filter by tag
}
```

**Returns:** List of matching endpoints with their basic information.

#### 4. `get_endpoint_details`

Get complete details about a specific endpoint.

```typescript
{
  "specId": "petstore",
  "endpointId": "GET /users/{id}"
}
```

**Returns:** Full endpoint specification including parameters, request body, responses, and authentication.

#### 5. `generate_request_code`

Generate code examples for making API requests.

```typescript
{
  "specId": "petstore",
  "endpointId": "GET /users/{id}",
  "language": "javascript", // or "python", "curl", "http", "all"
  "includeSteps": true // optional, default: true
}
```

**Returns:** Code examples and step-by-step instructions.

#### 6. `generate_n8n_node`

Generate an n8n HTTP Request node configuration.

```typescript
{
  "specId": "petstore",
  "endpointId": "GET /users/{id}"
}
```

**Returns:** n8n node configuration ready to import.

#### 7. `generate_n8n_workflow`

Generate a complete n8n workflow.

```typescript
{
  "specId": "petstore",
  "endpointIds": ["GET /users", "POST /users", "GET /users/{id}"],
  "workflowName": "User Management"
}
```

**Returns:** Complete n8n workflow JSON.

#### 8. `get_authentication_info`

Get authentication requirements.

```typescript
{
  "specId": "petstore",
  "endpointId": "GET /users/{id}" // optional
}
```

**Returns:** Authentication schemes and instructions.

#### 9. `get_schema_details`

Get details about a data model/schema.

```typescript
{
  "specId": "petstore",
  "schemaName": "User",
  "includeExample": true // optional, default: true
}
```

**Returns:** Schema structure and example object.

#### 10. `analyze_pagination`

Analyze pagination patterns in the API.

```typescript
{
  "specId": "petstore",
  "endpointId": "GET /users" // optional
}
```

**Returns:** Detected pagination patterns and implementation recommendations.

## Architecture

### Component Overview

```
openapi-mcp-server/
├── src/
│   ├── index.ts         # Entry point
│   ├── server.ts        # MCP server implementation
│   ├── parser.ts        # OpenAPI parsing and conversion
│   ├── generators.ts    # Code generation utilities
│   └── types.ts         # TypeScript type definitions
├── package.json
└── tsconfig.json
```

### Data Flow

1. **Input:** OpenAPI/Swagger document (JSON/YAML)
2. **Parse:** Validate and dereference the specification
3. **Transform:** Convert to LLM-friendly format (`LLMAPISpec`)
4. **Cache:** Store in memory for fast access
5. **Query:** Search, filter, and retrieve specific information
6. **Generate:** Create code, configurations, and workflows

### Key Design Decisions

#### 1. Simplified Schema Representation

The parser converts complex OpenAPI schemas into a flatter, more readable structure:

```typescript
// Before (OpenAPI)
{
  "type": "object",
  "properties": {
    "user": {
      "$ref": "#/components/schemas/User"
    }
  }
}

// After (LLM-friendly)
{
  "type": "object",
  "properties": {
    "user": {
      "type": "object",
      "properties": { /* inline User schema */ },
      "resolvedType": "User"
    }
  }
}
```

#### 2. Human-Readable Authentication Instructions

Security schemes are converted to natural language instructions:

```typescript
{
  "type": "http",
  "scheme": "bearer",
  "instruction": "Include bearer token in Authorization header: \"Bearer <token>\""
}
```

#### 3. Example Generation

The server automatically generates example values for:
- Request bodies
- Query parameters
- Path parameters
- Response objects

This helps LLMs understand the expected data format.

#### 4. In-Memory Caching

Loaded API specifications are cached in memory for:
- Fast repeated access
- No need to re-parse on every query
- Resource efficiency

### Security Considerations

1. **Input Validation**
   - All OpenAPI specs are validated using `swagger-parser`
   - Malformed specs are rejected with clear error messages

2. **File System Access**
   - File loading uses Node.js `fs` module with proper error handling
   - No arbitrary command execution

3. **URL Fetching**
   - HTTP/HTTPS URLs are supported
   - Timeouts and error handling for network requests

4. **Memory Management**
   - Configurable max spec size (default: unlimited)
   - In-memory cache can be cleared if needed

## Integration Examples

### Example 1: Analyzing a New API

```
User: Load the Stripe API documentation
Assistant: [Uses load_openapi_spec with Stripe's OpenAPI URL]

User: What authentication do I need?
Assistant: [Uses get_authentication_info]

User: Show me how to create a customer
Assistant: [Uses search_endpoints, then generate_request_code]
```

### Example 2: Building an n8n Workflow

```
User: Create an n8n workflow that syncs users between API A and API B
Assistant:
  1. [Uses load_openapi_spec for both APIs]
  2. [Uses search_endpoints to find user listing and creation endpoints]
  3. [Uses generate_n8n_workflow to create the complete workflow]
```

### Example 3: Implementing Pagination

```
User: How do I get all products from this API?
Assistant:
  1. [Uses search_endpoints to find product listing endpoint]
  2. [Uses analyze_pagination to understand pagination]
  3. [Uses generate_request_code with loop logic]
```

## Best Practices

### For API Providers

1. **Provide Complete Examples**
   - Include example values in your OpenAPI spec
   - This improves the quality of generated code

2. **Use Clear Descriptions**
   - Describe what each endpoint does in plain language
   - LLMs use these descriptions for search and understanding

3. **Tag Your Endpoints**
   - Organize endpoints by functionality
   - Makes it easier to find related operations

4. **Document Authentication Clearly**
   - Include detailed security scheme descriptions
   - Specify which endpoints need which auth

### For LLM Tool Users

1. **Load Once, Query Many**
   - Load an API spec once and cache it
   - Then make multiple queries without re-parsing

2. **Start with Overview**
   - Use `get_api_overview` to understand the API structure
   - Then drill down to specific endpoints

3. **Use Search Effectively**
   - Search by tags for functional grouping
   - Search by query for text-based discovery

4. **Generate Code for Complex Endpoints**
   - Use code generation for endpoints with many parameters
   - Modify the generated code as needed

## Advanced Usage

### Custom Transformations

Extend the parser to add custom transformations:

```typescript
class CustomParser extends OpenAPIParser {
  convertToLLMFormat(): LLMAPISpec {
    const spec = super.convertToLLMFormat();
    // Add custom fields or transformations
    return spec;
  }
}
```

### Adding New Generators

Create custom code generators:

```typescript
class CustomGenerator {
  generateGoCode(endpoint: LLMEndpoint): string {
    // Generate Go code
  }
}
```

### Persistence

Add database persistence for loaded specs:

```typescript
class PersistentMCPServer extends OpenAPIMCPServer {
  async loadSpec(source: string) {
    // Check database first
    // Then call super.loadSpec if not found
  }
}
```

## Troubleshooting

### "Failed to parse OpenAPI spec"

**Cause:** Invalid OpenAPI document or network error

**Solution:**
1. Validate your OpenAPI spec using online validators
2. Check network connectivity for URL-based specs
3. Ensure the file path is correct and accessible

### "Endpoint not found"

**Cause:** Invalid endpoint ID format

**Solution:**
Use the exact endpoint ID format returned by `search_endpoints`:
```
"GET /users/{id}"  // Correct
"get /users/{id}"  // Wrong (case sensitive)
"/users/{id}"      // Wrong (missing method)
```

### "Spec not found"

**Cause:** Spec hasn't been loaded or wrong specId

**Solution:**
1. Load the spec using `load_openapi_spec` first
2. Use the specId returned from loading
3. List available specs using the MCP resources feature

## Performance Considerations

1. **Large API Specs**
   - First parse may take 1-5 seconds for very large specs (1000+ endpoints)
   - Subsequent queries are instant (in-memory cache)

2. **Memory Usage**
   - Each loaded spec: ~1-10 MB depending on size
   - Consider clearing cache for very large numbers of specs

3. **Code Generation**
   - Fast for single endpoints (<100ms)
   - Batch operations may take longer

## Roadmap

- [ ] Support for AsyncAPI specifications
- [ ] GraphQL schema analysis
- [ ] More code generation targets (Ruby, Go, C#)
- [ ] Integration with API testing tools
- [ ] AI-powered API usage recommendations
- [ ] Support for custom authentication flows
- [ ] Webhook configuration generation
- [ ] Rate limiting analysis and handling
- [ ] API versioning comparison

## Contributing

Contributions are welcome! Please:

1. Follow the existing code style
2. Add tests for new features
3. Update documentation
4. Submit pull requests with clear descriptions

## License

MIT License - see LICENSE file for details

## Support

For issues, questions, or contributions:
- GitHub Issues: [repository-url]/issues
- Documentation: [repository-url]/docs
- Examples: [repository-url]/examples
