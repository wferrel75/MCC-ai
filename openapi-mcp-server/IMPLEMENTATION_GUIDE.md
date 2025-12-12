# Implementation Guide

This guide explains the key implementation details and design patterns used in the OpenAPI MCP Server.

## Core Design Patterns

### 1. Parser Pattern

The parser uses a multi-stage pipeline:

```typescript
Input (JSON/YAML)
  → Validation (swagger-parser)
  → Dereferencing ($refs)
  → Transformation (OpenAPI → LLM format)
  → Output (LLMAPISpec)
```

**Why this approach?**
- Separation of concerns
- Each stage can be tested independently
- Easy to add new transformation steps
- Handles errors at appropriate level

### 2. Cache-Aside Pattern

```typescript
async getSpec(specId: string): LLMAPISpec {
  // Try cache first
  if (cache.has(specId)) {
    return cache.get(specId);
  }

  // Load and parse
  const spec = await loadAndParse(source);

  // Store in cache
  cache.set(specId, spec);

  return spec;
}
```

**Benefits:**
- Fast repeated access (O(1))
- Reduces parsing overhead
- Simple implementation

**Trade-offs:**
- Memory usage grows
- No automatic eviction
- Single-process only

### 3. Builder Pattern for Code Generation

```typescript
class CodeBuilder {
  private lines: string[] = [];

  addLine(line: string): this {
    this.lines.push(line);
    return this;
  }

  addBlock(block: string[]): this {
    this.lines.push(...block);
    return this;
  }

  build(): string {
    return this.lines.join('\n');
  }
}

// Usage
const code = new CodeBuilder()
  .addLine('import requests')
  .addLine('')
  .addBlock(generateHeaders())
  .addBlock(generateRequest())
  .build();
```

### 4. Strategy Pattern for Generators

Different code generation strategies for different languages:

```typescript
interface CodeGenerationStrategy {
  generate(endpoint: LLMEndpoint, baseUrl: string): string;
}

class JavaScriptStrategy implements CodeGenerationStrategy {
  generate(endpoint: LLMEndpoint, baseUrl: string): string {
    // JavaScript-specific generation
  }
}

class PythonStrategy implements CodeGenerationStrategy {
  generate(endpoint: LLMEndpoint, baseUrl: string): string {
    // Python-specific generation
  }
}
```

## Key Algorithms

### 1. Schema Flattening

Problem: OpenAPI schemas can be deeply nested with `$ref` pointers.

Solution: Recursive dereferencing and flattening

```typescript
function convertSchema(schema: OpenAPISchema, depth = 0): LLMSchema {
  // Prevent infinite recursion
  if (depth > 10) return { type: 'any' };

  // Handle $ref (after dereferencing)
  if (schema.$ref) {
    return convertSchema(resolveRef(schema.$ref), depth + 1);
  }

  // Handle object properties
  if (schema.type === 'object' && schema.properties) {
    const properties: Record<string, LLMSchema> = {};
    for (const [key, prop] of Object.entries(schema.properties)) {
      properties[key] = convertSchema(prop, depth + 1);
    }
    return {
      type: 'object',
      properties,
      required: schema.required,
    };
  }

  // Handle arrays
  if (schema.type === 'array' && schema.items) {
    return {
      type: 'array',
      items: convertSchema(schema.items, depth + 1),
    };
  }

  // Primitive types
  return {
    type: schema.type,
    format: schema.format,
    description: schema.description,
  };
}
```

### 2. Endpoint Search

Problem: Find endpoints matching user query efficiently.

Solution: Multi-field text search with filtering

```typescript
function searchEndpoints(
  endpoints: LLMEndpoint[],
  query?: string,
  method?: string,
  tag?: string
): LLMEndpoint[] {
  let results = endpoints;

  // Filter by method (O(n))
  if (method) {
    results = results.filter(e => e.method === method);
  }

  // Filter by tag (O(n))
  if (tag) {
    results = results.filter(e => e.tags?.includes(tag));
  }

  // Filter by query (O(n))
  if (query) {
    const lowerQuery = query.toLowerCase();
    results = results.filter(e =>
      e.path.toLowerCase().includes(lowerQuery) ||
      e.summary?.toLowerCase().includes(lowerQuery) ||
      e.description?.toLowerCase().includes(lowerQuery) ||
      e.tags?.some(t => t.toLowerCase().includes(lowerQuery))
    );
  }

  return results;
}
```

**Optimization opportunities:**
- Add inverted index for text search
- Pre-compute tag mappings
- Use trie for path prefix matching

### 3. Authentication Instruction Generation

Problem: Convert security schemes to human-readable instructions.

Solution: Pattern matching with templates

```typescript
function generateAuthInstruction(scheme: SecurityScheme): string {
  switch (scheme.type) {
    case 'apiKey':
      return `Include API key in ${scheme.in} parameter "${scheme.name}"`;

    case 'http':
      if (scheme.scheme === 'bearer') {
        return 'Include bearer token in Authorization header: "Bearer <token>"';
      }
      if (scheme.scheme === 'basic') {
        return 'Include basic auth in Authorization header: "Basic <base64>"';
      }
      return `Use HTTP ${scheme.scheme} authentication`;

    case 'oauth2':
      const flow = scheme.flows[0];
      if (flow.type === 'authorizationCode') {
        return [
          '1. Redirect user to authorization URL',
          '2. Exchange code for token',
          '3. Use token in Authorization header',
        ].join('\n');
      }
      return 'OAuth2 authentication required';

    default:
      return 'Authentication required';
  }
}
```

### 4. Example Value Generation

Problem: Generate realistic example values for any schema.

Solution: Type-based generation with smart defaults

```typescript
function generateExample(schema: LLMSchema, depth = 0): any {
  // Prevent deep recursion
  if (depth > 5) return null;

  // Use explicit example if available
  if (schema.example !== undefined) {
    return schema.example;
  }

  // Use enum value if available
  if (schema.enum && schema.enum.length > 0) {
    return schema.enum[0];
  }

  // Generate based on type
  switch (schema.type) {
    case 'string':
      if (schema.format === 'email') return 'user@example.com';
      if (schema.format === 'date-time') return new Date().toISOString();
      if (schema.format === 'uuid') return '123e4567-e89b-12d3-a456-426614174000';
      return 'string';

    case 'number':
    case 'integer':
      return schema.minimum ?? 0;

    case 'boolean':
      return true;

    case 'array':
      return schema.items ? [generateExample(schema.items, depth + 1)] : [];

    case 'object':
      const obj: any = {};
      if (schema.properties) {
        for (const [key, prop] of Object.entries(schema.properties)) {
          // Only include required fields or randomly include optional
          if (schema.required?.includes(key) || Math.random() > 0.5) {
            obj[key] = generateExample(prop, depth + 1);
          }
        }
      }
      return obj;

    default:
      return null;
  }
}
```

## Error Handling Strategy

### 1. Parse Errors

```typescript
try {
  const parsed = await SwaggerParser.validate(input);
} catch (error) {
  if (error.message.includes('$ref')) {
    throw new OpenAPIParseError(
      'Invalid reference in specification. Check that all $refs are valid.',
      error
    );
  }
  if (error.message.includes('schema')) {
    throw new OpenAPIParseError(
      'Schema validation failed. Ensure the spec follows OpenAPI 2.0 or 3.x format.',
      error
    );
  }
  throw new OpenAPIParseError('Failed to parse OpenAPI specification', error);
}
```

### 2. Network Errors

```typescript
async function loadFromUrl(url: string): Promise<string> {
  try {
    const response = await fetch(url, { timeout: 30000 });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    return await response.text();
  } catch (error) {
    if (error.name === 'AbortError') {
      throw new Error('Request timeout after 30 seconds');
    }
    if (error.code === 'ENOTFOUND') {
      throw new Error(`Could not resolve host: ${url}`);
    }
    throw error;
  }
}
```

### 3. User Input Errors

```typescript
function validateToolArguments(args: any, toolName: string): void {
  switch (toolName) {
    case 'load_openapi_spec':
      if (!args.source) {
        throw new McpError(
          ErrorCode.InvalidParams,
          'Missing required argument: source'
        );
      }
      break;

    case 'search_endpoints':
      if (!args.specId) {
        throw new McpError(
          ErrorCode.InvalidParams,
          'Missing required argument: specId'
        );
      }
      if (args.method && !VALID_METHODS.includes(args.method)) {
        throw new McpError(
          ErrorCode.InvalidParams,
          `Invalid method: ${args.method}`
        );
      }
      break;
  }
}
```

## Performance Optimizations

### 1. Lazy Loading

Only parse and process what's needed:

```typescript
class LazyAPISpec {
  private _endpoints?: LLMEndpoint[];
  private _schemas?: Record<string, LLMSchema>;

  get endpoints(): LLMEndpoint[] {
    if (!this._endpoints) {
      this._endpoints = this.parseEndpoints();
    }
    return this._endpoints;
  }

  get schemas(): Record<string, LLMSchema> {
    if (!this._schemas) {
      this._schemas = this.parseSchemas();
    }
    return this._schemas;
  }
}
```

### 2. Memoization

Cache expensive computations:

```typescript
const memoize = <T extends (...args: any[]) => any>(fn: T): T => {
  const cache = new Map<string, ReturnType<T>>();

  return ((...args: Parameters<T>) => {
    const key = JSON.stringify(args);
    if (cache.has(key)) {
      return cache.get(key)!;
    }
    const result = fn(...args);
    cache.set(key, result);
    return result;
  }) as T;
};

// Usage
const generateCode = memoize((endpoint: LLMEndpoint, lang: string) => {
  // Expensive code generation
});
```

### 3. Batch Processing

Process multiple items efficiently:

```typescript
function generateMultipleNodes(
  endpoints: LLMEndpoint[],
  baseUrl: string
): N8nWorkflowNode[] {
  return endpoints.map((endpoint, index) =>
    generateNode(endpoint, baseUrl, [250, 300 + index * 150])
  );
}
```

## Testing Patterns

### 1. Unit Tests

```typescript
describe('OpenAPIParser', () => {
  let parser: OpenAPIParser;

  beforeEach(() => {
    parser = new OpenAPIParser();
  });

  test('should parse valid OpenAPI 3.0 spec', async () => {
    const spec = await parser.parse(VALID_SPEC);
    expect(spec.endpoints).toHaveLength(10);
    expect(spec.title).toBe('Test API');
  });

  test('should throw error for invalid spec', async () => {
    await expect(parser.parse(INVALID_SPEC))
      .rejects
      .toThrow(OpenAPIParseError);
  });
});
```

### 2. Integration Tests

```typescript
describe('MCP Server Integration', () => {
  let server: OpenAPIMCPServer;
  let client: TestMCPClient;

  beforeAll(async () => {
    server = new OpenAPIMCPServer();
    await server.start();
    client = new TestMCPClient(server);
  });

  test('should load and search spec', async () => {
    // Load
    await client.callTool('load_openapi_spec', {
      source: TEST_SPEC,
      specId: 'test',
    });

    // Search
    const result = await client.callTool('search_endpoints', {
      specId: 'test',
      query: 'user',
    });

    expect(result).toContain('GET /users');
  });
});
```

### 3. Snapshot Tests

```typescript
test('should generate consistent JavaScript code', () => {
  const code = generator.generateJavaScript(SAMPLE_ENDPOINT, BASE_URL);
  expect(code).toMatchSnapshot();
});
```

## Best Practices

### 1. Type Safety

Always use TypeScript's strict mode:

```typescript
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true
  }
}
```

### 2. Error Messages

Provide actionable error messages:

```typescript
// Bad
throw new Error('Invalid input');

// Good
throw new OpenAPIParseError(
  'Failed to parse OpenAPI specification: invalid $ref at path "/components/schemas/User". ' +
  'Ensure all references point to existing schemas.'
);
```

### 3. Logging

Use structured logging:

```typescript
logger.info('Loading OpenAPI spec', {
  source: args.source,
  specId: args.specId,
  timestamp: Date.now(),
});

logger.error('Failed to load spec', {
  source: args.source,
  error: error.message,
  stack: error.stack,
});
```

### 4. Documentation

Document complex algorithms:

```typescript
/**
 * Converts an OpenAPI schema to LLM-friendly format.
 *
 * This function recursively processes the schema, dereferencing any $ref
 * pointers and flattening nested structures. It handles:
 * - Object types with properties
 * - Array types with items
 * - Composed schemas (allOf, oneOf, anyOf)
 * - Circular references (via depth limit)
 *
 * @param schema - The OpenAPI schema to convert
 * @param depth - Current recursion depth (used to prevent infinite loops)
 * @returns Simplified LLM-friendly schema
 *
 * @example
 * const llmSchema = convertSchema({
 *   type: 'object',
 *   properties: {
 *     name: { type: 'string' },
 *     age: { type: 'integer' }
 *   }
 * });
 */
function convertSchema(schema: OpenAPISchema, depth = 0): LLMSchema {
  // Implementation
}
```

## Common Pitfalls and Solutions

### Pitfall 1: Circular References

Problem: OpenAPI specs can have circular `$ref` pointers.

Solution: Track visited refs or use depth limit:

```typescript
function dereference(ref: string, visited = new Set<string>()): any {
  if (visited.has(ref)) {
    return { $ref: ref, circular: true };
  }
  visited.add(ref);
  // Continue dereferencing
}
```

### Pitfall 2: Large Specs

Problem: Large specs (1000+ endpoints) can cause memory issues.

Solution: Implement streaming or pagination:

```typescript
function* iterateEndpoints(spec: OpenAPIDocument): Generator<LLMEndpoint> {
  for (const [path, pathItem] of Object.entries(spec.paths)) {
    for (const method of METHODS) {
      const operation = pathItem[method];
      if (operation) {
        yield convertOperation(method, path, operation);
      }
    }
  }
}
```

### Pitfall 3: Authentication Complexity

Problem: OAuth2 and OpenID Connect are complex to explain.

Solution: Provide step-by-step instructions:

```typescript
function explainOAuth2(flow: OAuth2Flow): string[] {
  const steps = [
    'OAuth2 Authentication Steps:',
    '',
    '1. Obtain Client Credentials',
    '   - Client ID: Provided by API provider',
    '   - Client Secret: Keep this secure',
  ];

  if (flow.type === 'authorizationCode') {
    steps.push(
      '',
      '2. Authorization Request',
      `   - Redirect user to: ${flow.authorizationUrl}`,
      '   - Include: client_id, redirect_uri, scope, state',
      '',
      '3. Authorization Response',
      '   - User approves access',
      '   - Receive authorization code at redirect_uri',
      '',
      '4. Token Request',
      `   - POST to: ${flow.tokenUrl}`,
      '   - Include: code, client_id, client_secret, redirect_uri',
      '',
      '5. Use Access Token',
      '   - Add to Authorization header: Bearer <access_token>',
      '   - Refresh when expired using refresh_token'
    );
  }

  return steps;
}
```

This implementation guide provides the foundation for understanding and extending the OpenAPI MCP Server. Refer to specific files for detailed implementations.
