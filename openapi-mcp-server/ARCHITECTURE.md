# Architecture Documentation

## System Overview

The OpenAPI MCP Server is a Model Context Protocol server that bridges OpenAPI/Swagger documentation with LLM-based systems. It transforms complex API specifications into formats that are easier for Large Language Models to understand and work with.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        MCP Client                            │
│                  (Claude Desktop, Custom)                    │
└───────────────────────────┬─────────────────────────────────┘
                            │ MCP Protocol (stdio)
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                   OpenAPI MCP Server                         │
│  ┌──────────────────────────────────────────────────────┐  │
│  │              MCP Request Handler                      │  │
│  │  - Tool execution                                     │  │
│  │  - Resource management                                │  │
│  │  - Error handling                                     │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                        │
│  ┌──────────────────▼───────────────────────────────────┐  │
│  │              OpenAPI Parser                           │  │
│  │  - Spec validation                                    │  │
│  │  - $ref dereferencing                                 │  │
│  │  - LLM format transformation                          │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                        │
│  ┌──────────────────▼───────────────────────────────────┐  │
│  │              In-Memory Cache                          │  │
│  │  - Loaded API specs                                   │  │
│  │  - Fast retrieval                                     │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                        │
│  ┌──────────────────▼───────────────────────────────────┐  │
│  │              Code Generators                          │  │
│  │  - JavaScript/Python/curl                             │  │
│  │  - n8n workflows                                      │  │
│  │  - Step-by-step guides                                │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ HTTP/File System
                            │
┌───────────────────────────▼─────────────────────────────────┐
│                   External Sources                           │
│  - OpenAPI Spec URLs                                         │
│  - Local OpenAPI files                                       │
│  - Inline JSON/YAML                                          │
└─────────────────────────────────────────────────────────────┘
```

## Component Details

### 1. MCP Request Handler (server.ts)

**Responsibilities:**
- Implement MCP protocol (tools, resources, prompts)
- Route requests to appropriate handlers
- Manage server lifecycle
- Handle errors and validation

**Key Methods:**
- `setupHandlers()` - Register MCP protocol handlers
- `handleLoadSpec()` - Load and parse OpenAPI specs
- `handleSearchEndpoints()` - Search functionality
- `handleGenerateCode()` - Code generation orchestration

**Design Decisions:**
- Uses MCP SDK for protocol compliance
- Stdio transport for universal compatibility
- Async/await for clean error handling
- Map-based cache for O(1) lookups

### 2. OpenAPI Parser (parser.ts)

**Responsibilities:**
- Parse and validate OpenAPI 2.0/3.x specifications
- Dereference `$ref` pointers
- Transform to LLM-friendly format
- Extract and organize metadata

**Key Classes:**
- `OpenAPIParser` - Main parser class

**Key Methods:**
- `parse()` - Entry point for parsing
- `convertToLLMFormat()` - Transform to simplified format
- `extractEndpoints()` - Extract all API endpoints
- `convertSchema()` - Simplify JSON Schema
- `extractSecuritySchemes()` - Parse authentication

**Data Flow:**
```
OpenAPI Spec (JSON/YAML)
    ↓
swagger-parser (validate)
    ↓
swagger-parser (dereference $refs)
    ↓
Custom transformation
    ↓
LLMAPISpec (simplified format)
```

**Design Decisions:**
- Uses `swagger-parser` for validation and dereferencing
- Flattens nested structures for LLM consumption
- Generates human-readable instructions for auth
- Preserves essential metadata while simplifying

### 3. In-Memory Cache

**Structure:**
```typescript
Map<string, LLMAPISpec>
// Key: specId (user-provided or auto-generated)
// Value: Parsed and transformed API specification
```

**Operations:**
- **Set:** O(1) - Add new spec to cache
- **Get:** O(1) - Retrieve spec by ID
- **Delete:** O(1) - Remove spec from cache
- **List:** O(n) - Iterate all cached specs

**Design Decisions:**
- Map for fast lookups
- No TTL (time-to-live) by default
- No size limits by default
- Single-process (not distributed)

**Trade-offs:**
- **Pro:** Fast access, simple implementation
- **Con:** Memory usage grows with specs
- **Con:** Not persistent (lost on restart)
- **Con:** Not shared across processes

**Future Enhancements:**
- Add LRU eviction
- Implement persistence layer
- Add Redis for distributed cache

### 4. Code Generators (generators.ts)

**Responsibilities:**
- Generate executable code in various languages
- Create n8n workflow configurations
- Produce step-by-step instructions
- Handle authentication setup

**Key Classes:**
- `CodeGenerator` - Code generation for languages
- `N8nGenerator` - n8n-specific workflow generation

**Generation Process:**
```
LLMEndpoint + baseUrl
    ↓
Analyze parameters & body
    ↓
Build URL with params
    ↓
Generate auth headers
    ↓
Create language-specific code
    ↓
Format and return
```

**Design Decisions:**
- Template-based generation
- Uses example values when available
- Handles all parameter types (path, query, header, body)
- Generates idiomatic code for each language

### 5. Type System (types.ts)

**Core Types:**

```typescript
// Input: Standard OpenAPI
OpenAPIDocument = OpenAPIV3.Document | OpenAPIV2.Document

// Output: LLM-friendly format
LLMAPISpec {
  metadata,
  servers,
  security,
  endpoints: LLMEndpoint[],
  schemas,
  tags,
  summary
}

LLMEndpoint {
  id,
  method,
  path,
  parameters: LLMParameter[],
  requestBody,
  responses,
  security,
  ...
}

LLMSchema {
  type,
  properties,
  required,
  validation rules,
  examples,
  ...
}
```

**Design Principles:**
- Flat structures (avoid deep nesting)
- Self-contained (minimal references)
- Rich metadata (descriptions, examples)
- Type safety (TypeScript strict mode)

## Data Transformation Pipeline

### Input: OpenAPI Specification

```json
{
  "openapi": "3.0.0",
  "paths": {
    "/users/{id}": {
      "get": {
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "schema": { "$ref": "#/components/schemas/UserId" }
          }
        ],
        "responses": {
          "200": {
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/User" }
              }
            }
          }
        },
        "security": [{ "bearerAuth": [] }]
      }
    }
  },
  "components": {
    "schemas": {
      "UserId": { "type": "string", "format": "uuid" },
      "User": {
        "type": "object",
        "properties": {
          "id": { "$ref": "#/components/schemas/UserId" },
          "name": { "type": "string" }
        }
      }
    },
    "securitySchemes": {
      "bearerAuth": {
        "type": "http",
        "scheme": "bearer"
      }
    }
  }
}
```

### Output: LLM-Friendly Format

```json
{
  "endpoints": [
    {
      "id": "GET /users/{id}",
      "method": "GET",
      "path": "/users/{id}",
      "parameters": [
        {
          "name": "id",
          "in": "path",
          "required": true,
          "schema": {
            "type": "string",
            "format": "uuid",
            "description": "User ID"
          }
        }
      ],
      "responses": [
        {
          "statusCode": "200",
          "schema": {
            "type": "object",
            "properties": {
              "id": { "type": "string", "format": "uuid" },
              "name": { "type": "string" }
            }
          }
        }
      ],
      "security": [
        {
          "type": "http",
          "scheme": "bearer",
          "instruction": "Include bearer token in Authorization header: \"Bearer <token>\""
        }
      ]
    }
  ]
}
```

**Key Transformations:**
1. Dereference all `$ref` pointers
2. Flatten nested structures
3. Add human-readable instructions
4. Generate examples automatically
5. Organize by endpoint ID

## Protocol Implementation

### MCP Protocol Flow

```
Client                           Server
  │                                │
  ├─── ListTools Request ────────>│
  │<────── Tools List ─────────────┤
  │                                │
  ├─── CallTool: load_spec ──────>│
  │                                ├─ Validate input
  │                                ├─ Fetch/parse spec
  │                                ├─ Cache result
  │<────── Tool Response ──────────┤
  │                                │
  ├─── CallTool: search ─────────>│
  │                                ├─ Retrieve from cache
  │                                ├─ Filter endpoints
  │<────── Search Results ─────────┤
  │                                │
  ├─── CallTool: generate_code ──>│
  │                                ├─ Get endpoint details
  │                                ├─ Generate code
  │<────── Code + Instructions ────┤
  │                                │
```

### Error Handling

```typescript
try {
  // Operation
} catch (error) {
  if (error instanceof OpenAPIParseError) {
    throw new McpError(ErrorCode.InvalidRequest, error.message);
  }
  if (error instanceof EndpointNotFoundError) {
    throw new McpError(ErrorCode.InvalidRequest, error.message);
  }
  // Generic error
  throw new McpError(ErrorCode.InternalError, error.message);
}
```

**Error Categories:**
1. **Parse Errors** - Invalid OpenAPI spec
2. **Not Found Errors** - Missing spec/endpoint
3. **Network Errors** - URL fetch failures
4. **Validation Errors** - Invalid tool arguments
5. **Internal Errors** - Unexpected failures

## Performance Considerations

### Time Complexity

| Operation | Complexity | Notes |
|-----------|-----------|-------|
| Load spec | O(n) | n = size of spec |
| Dereference | O(n * r) | r = number of refs |
| Transform | O(n) | n = number of endpoints |
| Search | O(n) | n = number of endpoints |
| Get endpoint | O(1) | With ID |
| Get endpoint | O(n) | Without ID (search) |
| Generate code | O(1) | For single endpoint |

### Space Complexity

| Component | Space | Notes |
|-----------|-------|-------|
| Loaded spec | O(n) | n = spec size |
| Cache | O(s * n) | s = number of specs |
| Parser | O(n) | Temporary during parse |
| Generator | O(1) | No persistent state |

### Optimization Strategies

1. **Lazy Loading**
   - Only load specs when requested
   - Don't pre-process unused endpoints

2. **Caching**
   - Cache parsed specs in memory
   - Avoid re-parsing on every query

3. **Streaming** (Future)
   - Stream large responses
   - Paginate endpoint lists

4. **Parallel Processing** (Future)
   - Parse multiple specs concurrently
   - Generate code in parallel

## Security Architecture

### Input Validation

```typescript
// Validate spec source
if (isUrl(source)) {
  validateUrl(source); // Check protocol, domain
}

if (isFilePath(source)) {
  validatePath(source); // Check permissions, path traversal
}

// Validate spec content
await SwaggerParser.validate(spec); // Schema validation

// Validate tool arguments
validateToolArgs(args, schema); // Against JSON Schema
```

### Access Control

**Current:** None (local-only server)

**Future Considerations:**
- API key authentication for remote access
- Rate limiting per client
- Spec access permissions
- Audit logging

### Data Privacy

- No persistent storage of specs by default
- Credentials never logged or cached
- Generated code uses placeholders for secrets
- No external analytics or telemetry

### Threat Model

**Threats:**
1. **Malicious OpenAPI spec** - Could cause DoS via large spec
2. **Path traversal** - Loading files outside allowed directories
3. **SSRF** - Fetching internal URLs
4. **XSS in generated code** - Unsafe interpolation

**Mitigations:**
1. Size limits on specs
2. Path validation and sandboxing
3. URL whitelist (if needed)
4. Proper escaping in code generation

## Extensibility Points

### 1. Custom Parser

```typescript
class CustomParser extends OpenAPIParser {
  convertToLLMFormat(): LLMAPISpec {
    const spec = super.convertToLLMFormat();
    // Add custom transformations
    return spec;
  }
}
```

### 2. Custom Generator

```typescript
class RubyGenerator extends CodeGenerator {
  generateRuby(endpoint: LLMEndpoint): string {
    // Ruby-specific code generation
  }
}
```

### 3. Custom Tool

```typescript
class ExtendedMCPServer extends OpenAPIMCPServer {
  setupHandlers() {
    super.setupHandlers();

    // Add custom tool
    this.server.setRequestHandler(CallToolRequestSchema, async (req) => {
      if (req.params.name === 'my_custom_tool') {
        return await this.handleCustomTool(req.params.arguments);
      }
      // Delegate to parent
      return await super.handleToolCall(req);
    });
  }
}
```

### 4. Middleware

```typescript
class MiddlewareMCPServer extends OpenAPIMCPServer {
  async handleToolCall(request: any) {
    // Before
    await this.logRequest(request);

    // Execute
    const result = await super.handleToolCall(request);

    // After
    await this.logResponse(result);

    return result;
  }
}
```

## Testing Strategy

### Unit Tests

```typescript
// Test parser
describe('OpenAPIParser', () => {
  it('should parse valid OpenAPI 3.0 spec', async () => {
    const parser = new OpenAPIParser();
    const spec = await parser.parse(validSpec);
    expect(spec.endpoints).toHaveLength(10);
  });

  it('should handle $ref resolution', async () => {
    const parser = new OpenAPIParser();
    const spec = await parser.parse(specWithRefs);
    expect(spec.schemas['User']).toBeDefined();
  });
});

// Test generator
describe('CodeGenerator', () => {
  it('should generate valid JavaScript', () => {
    const gen = new CodeGenerator();
    const code = gen.generateJavaScript(endpoint, baseUrl);
    expect(code).toContain('fetch');
  });
});
```

### Integration Tests

```typescript
describe('MCP Server Integration', () => {
  it('should load spec and search endpoints', async () => {
    // Load spec
    const loadResult = await client.callTool({
      name: 'load_openapi_spec',
      arguments: { source: testSpec, specId: 'test' }
    });

    // Search
    const searchResult = await client.callTool({
      name: 'search_endpoints',
      arguments: { specId: 'test', query: 'user' }
    });

    expect(searchResult.content[0].text).toContain('GET /users');
  });
});
```

### Performance Tests

```typescript
describe('Performance', () => {
  it('should handle large specs', async () => {
    const start = Date.now();
    await parser.parse(largeSpec); // 1000+ endpoints
    const duration = Date.now() - start;
    expect(duration).toBeLessThan(5000); // < 5 seconds
  });

  it('should cache effectively', async () => {
    await server.loadSpec(spec, 'test');

    const start = Date.now();
    await server.getSpec('test');
    const duration = Date.now() - start;
    expect(duration).toBeLessThan(10); // < 10ms
  });
});
```

## Deployment

### Development

```bash
npm install
npm run dev  # Watch mode
```

### Production

```bash
npm install --production
npm run build
node dist/index.js
```

### Docker (Future)

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --production
COPY dist ./dist
CMD ["node", "dist/index.js"]
```

### Monitoring

```typescript
// Add metrics
class MonitoredServer extends OpenAPIMCPServer {
  private metrics = {
    requestCount: 0,
    errorCount: 0,
    avgResponseTime: 0,
  };

  async handleToolCall(req: any) {
    this.metrics.requestCount++;
    const start = Date.now();

    try {
      const result = await super.handleToolCall(req);
      this.updateMetrics(Date.now() - start);
      return result;
    } catch (error) {
      this.metrics.errorCount++;
      throw error;
    }
  }
}
```

## Future Enhancements

### Short Term
- [ ] GraphQL schema support
- [ ] AsyncAPI support
- [ ] More code generation targets (Go, Ruby, C#)
- [ ] Workflow validation

### Medium Term
- [ ] Persistent cache (Redis/SQLite)
- [ ] Spec diffing and comparison
- [ ] API testing generation
- [ ] Rate limiting analysis

### Long Term
- [ ] AI-powered API recommendations
- [ ] Automatic integration generation
- [ ] Multi-tenant support
- [ ] Cloud deployment options

## Contributing

See CONTRIBUTING.md for:
- Code style guidelines
- Pull request process
- Testing requirements
- Documentation standards
