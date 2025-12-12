# Configuration Guide

## MCP Client Configuration

### Claude Desktop (macOS/Windows)

Add to your Claude Desktop configuration file:

**macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
**Windows:** `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "openapi": {
      "command": "node",
      "args": [
        "/absolute/path/to/openapi-mcp-server/dist/index.js"
      ],
      "env": {
        "OPENAPI_MAX_SPEC_SIZE": "10485760",
        "OPENAPI_CACHE_SPECS": "true"
      }
    }
  }
}
```

### Custom MCP Client

```typescript
import { Client } from '@modelcontextprotocol/sdk/client/index.js';
import { StdioClientTransport } from '@modelcontextprotocol/sdk/client/stdio.js';

const client = new Client({
  name: 'my-client',
  version: '1.0.0',
});

const transport = new StdioClientTransport({
  command: 'node',
  args: ['/path/to/openapi-mcp-server/dist/index.js'],
});

await client.connect(transport);

// Use the tools
const result = await client.callTool({
  name: 'load_openapi_spec',
  arguments: {
    source: 'https://api.example.com/openapi.json',
    specId: 'example-api',
  },
});
```

## Environment Variables

### OPENAPI_MAX_SPEC_SIZE

Maximum size in bytes for OpenAPI specifications.

- **Default:** No limit
- **Example:** `10485760` (10 MB)
- **Usage:** Prevents loading extremely large specs that could cause memory issues

```bash
export OPENAPI_MAX_SPEC_SIZE=10485760
```

### OPENAPI_CACHE_SPECS

Enable or disable in-memory caching of loaded specs.

- **Default:** `true`
- **Example:** `false` to disable caching
- **Usage:** Useful for development or when working with frequently changing specs

```bash
export OPENAPI_CACHE_SPECS=false
```

### OPENAPI_DEFAULT_FORMAT

Default format for output (when applicable).

- **Default:** `json`
- **Options:** `json`, `yaml`
- **Usage:** Determines output format for certain operations

```bash
export OPENAPI_DEFAULT_FORMAT=yaml
```

### OPENAPI_ENABLE_EXAMPLES

Enable automatic example generation.

- **Default:** `true`
- **Example:** `false` to disable
- **Usage:** Disabling can improve performance for large schemas

```bash
export OPENAPI_ENABLE_EXAMPLES=false
```

## Advanced Configuration

### Custom Server Implementation

Extend the base server for custom behavior:

```typescript
import { OpenAPIMCPServer } from './server.js';
import { LLMAPISpec } from './types.js';

class CustomOpenAPIMCPServer extends OpenAPIMCPServer {
  // Override to add custom preprocessing
  async loadSpec(source: string, specId?: string): Promise<LLMAPISpec> {
    console.log(`Loading spec from: ${source}`);
    const spec = await super.loadSpec(source, specId);

    // Add custom transformations
    spec.endpoints = spec.endpoints.filter(e => !e.deprecated);

    return spec;
  }

  // Add custom tool
  private async handleCustomTool(args: any) {
    // Your custom implementation
    return {
      content: [
        {
          type: 'text',
          text: 'Custom tool result',
        },
      ],
    };
  }
}

// Start custom server
const server = new CustomOpenAPIMCPServer();
await server.start();
```

### Adding Custom Code Generators

```typescript
import { CodeGenerator } from './generators.js';
import { LLMEndpoint } from './types.js';

class CustomCodeGenerator extends CodeGenerator {
  /**
   * Generate Go code
   */
  generateGo(endpoint: LLMEndpoint, baseUrl: string): string {
    const url = this.buildUrl(endpoint, baseUrl, true);
    const code: string[] = [
      'package main',
      '',
      'import (',
      '    "bytes"',
      '    "encoding/json"',
      '    "fmt"',
      '    "io"',
      '    "net/http"',
      ')',
      '',
      'func main() {',
    ];

    // Add request body
    if (endpoint.requestBody) {
      const body = this.generateExampleBody(endpoint.requestBody.schema);
      code.push(`    data := map[string]interface{}{`);
      for (const [key, value] of Object.entries(body)) {
        code.push(`        "${key}": ${JSON.stringify(value)},`);
      }
      code.push(`    }`);
      code.push('    jsonData, _ := json.Marshal(data)');
      code.push('');
    }

    // Create request
    const hasBody = !!endpoint.requestBody;
    code.push(
      `    req, err := http.NewRequest("${endpoint.method}", "${url}", ${
        hasBody ? 'bytes.NewBuffer(jsonData)' : 'nil'
      })`
    );
    code.push('    if err != nil {');
    code.push('        panic(err)');
    code.push('    }');
    code.push('');

    // Add headers
    const headers = this.getRequiredHeaders(endpoint);
    const authHeader = this.getAuthHeader(endpoint);
    if (authHeader) {
      headers[authHeader.key] = authHeader.value;
    }

    for (const [key, value] of Object.entries(headers)) {
      code.push(`    req.Header.Set("${key}", "${value}")`);
    }

    // Make request
    code.push('');
    code.push('    client := &http.Client{}');
    code.push('    resp, err := client.Do(req)');
    code.push('    if err != nil {');
    code.push('        panic(err)');
    code.push('    }');
    code.push('    defer resp.Body.Close()');
    code.push('');

    // Read response
    code.push('    body, _ := io.ReadAll(resp.Body)');
    code.push('    fmt.Println(string(body))');
    code.push('}');

    return code.join('\n');
  }
}
```

### Custom Authentication Handlers

```typescript
import { SecurityRequirement } from './types.js';

class AuthHandler {
  /**
   * Generate authentication setup for different schemes
   */
  generateAuthSetup(security: SecurityRequirement[]): string {
    const instructions: string[] = [];

    for (const sec of security) {
      switch (sec.type) {
        case 'apiKey':
          if (sec.in === 'header') {
            instructions.push(
              `Add header: ${sec.name} = YOUR_API_KEY`
            );
          } else if (sec.in === 'query') {
            instructions.push(
              `Add query parameter: ${sec.name}=YOUR_API_KEY`
            );
          }
          break;

        case 'http':
          if (sec.scheme === 'bearer') {
            instructions.push(
              'Add header: Authorization = Bearer YOUR_TOKEN'
            );
          } else if (sec.scheme === 'basic') {
            instructions.push(
              'Add header: Authorization = Basic BASE64(username:password)'
            );
          }
          break;

        case 'oauth2':
          instructions.push('OAuth2 Flow:');
          for (const flow of sec.flows || []) {
            if (flow.type === 'authorizationCode') {
              instructions.push(
                `1. Redirect user to: ${flow.authorizationUrl}`
              );
              instructions.push(
                `2. Exchange code for token at: ${flow.tokenUrl}`
              );
              instructions.push(
                `3. Use token in Authorization header: Bearer TOKEN`
              );
            } else if (flow.type === 'clientCredentials') {
              instructions.push(
                `1. POST to ${flow.tokenUrl} with client credentials`
              );
              instructions.push(
                `2. Use returned token in Authorization header`
              );
            }
          }
          break;

        case 'openIdConnect':
          instructions.push(
            'OpenID Connect authentication required - follow OIDC discovery flow'
          );
          break;
      }
    }

    return instructions.join('\n');
  }
}
```

## Performance Tuning

### Large API Specifications

For APIs with 500+ endpoints:

1. **Disable automatic example generation:**
   ```bash
   export OPENAPI_ENABLE_EXAMPLES=false
   ```

2. **Use targeted queries:**
   - Always filter by tag or method when searching
   - Don't use `includeEndpoints: true` in overview unless necessary

3. **Consider pagination:**
   - Implement your own pagination for endpoint lists if needed

### Memory Optimization

1. **Clear cache periodically:**
   ```typescript
   // In custom implementation
   clearSpecCache(specId: string) {
     this.loadedSpecs.delete(specId);
   }
   ```

2. **Set maximum cache size:**
   ```typescript
   private MAX_CACHED_SPECS = 10;

   cacheSpec(specId: string, spec: LLMAPISpec) {
     if (this.loadedSpecs.size >= this.MAX_CACHED_SPECS) {
       // Remove oldest spec
       const firstKey = this.loadedSpecs.keys().next().value;
       this.loadedSpecs.delete(firstKey);
     }
     this.loadedSpecs.set(specId, spec);
   }
   ```

## Integration Patterns

### Pattern 1: API Gateway

Use the MCP server as a gateway for multiple APIs:

```typescript
const apiRegistry = {
  'stripe': 'https://raw.githubusercontent.com/stripe/openapi/master/openapi/spec3.json',
  'github': 'https://raw.githubusercontent.com/github/rest-api-description/main/descriptions/api.github.com/api.github.com.json',
  'twilio': 'https://raw.githubusercontent.com/twilio/twilio-oai/main/spec/json/twilio_api_v2010.json',
};

// Load all APIs on startup
for (const [name, url] of Object.entries(apiRegistry)) {
  await client.callTool({
    name: 'load_openapi_spec',
    arguments: { source: url, specId: name },
  });
}
```

### Pattern 2: API Documentation Bot

Create a bot that answers API questions:

```typescript
async function answerAPIQuestion(question: string, apiName: string) {
  // Search for relevant endpoints
  const searchResult = await client.callTool({
    name: 'search_endpoints',
    arguments: {
      specId: apiName,
      query: question,
    },
  });

  // Get details for top result
  const endpoints = JSON.parse(searchResult.content[0].text).endpoints;
  if (endpoints.length > 0) {
    const details = await client.callTool({
      name: 'get_endpoint_details',
      arguments: {
        specId: apiName,
        endpointId: endpoints[0].id,
      },
    });

    // Generate code example
    const code = await client.callTool({
      name: 'generate_request_code',
      arguments: {
        specId: apiName,
        endpointId: endpoints[0].id,
        language: 'javascript',
      },
    });

    return {
      endpoint: endpoints[0],
      details: JSON.parse(details.content[0].text),
      code: JSON.parse(code.content[0].text),
    };
  }

  return null;
}
```

### Pattern 3: Automated Testing

Generate test cases from OpenAPI specs:

```typescript
async function generateTestSuite(apiName: string) {
  const overview = await client.callTool({
    name: 'get_api_overview',
    arguments: {
      specId: apiName,
      includeEndpoints: true,
    },
  });

  const spec = JSON.parse(overview.content[0].text);
  const tests: string[] = [];

  for (const endpoint of spec.endpoints) {
    const code = await client.callTool({
      name: 'generate_request_code',
      arguments: {
        specId: apiName,
        endpointId: endpoint.id,
        language: 'javascript',
      },
    });

    tests.push(`
      test('${endpoint.id}', async () => {
        ${JSON.parse(code.content[0].text).example}
        expect(response.status).toBeLessThan(400);
      });
    `);
  }

  return tests.join('\n\n');
}
```

## Troubleshooting

### Issue: Server Not Starting

**Symptoms:** No response from MCP server

**Solutions:**
1. Check Node.js version (requires Node 18+)
2. Verify file path in configuration
3. Check console for error messages
4. Test command manually: `node /path/to/dist/index.js`

### Issue: Spec Loading Fails

**Symptoms:** "Failed to parse OpenAPI spec" error

**Solutions:**
1. Validate spec at https://editor.swagger.io/
2. Check network connectivity for URL sources
3. Verify file permissions for file sources
4. Try loading a sample spec to test server

### Issue: Slow Performance

**Symptoms:** Long response times

**Solutions:**
1. Disable example generation
2. Use targeted searches instead of full lists
3. Clear cache and reload spec
4. Check spec size (>5 MB may be slow)

### Issue: Memory Usage

**Symptoms:** High memory consumption

**Solutions:**
1. Set `OPENAPI_MAX_SPEC_SIZE`
2. Implement cache size limits
3. Only load specs when needed
4. Restart server periodically

## Security Best Practices

1. **Validate Input Sources:**
   - Only load specs from trusted sources
   - Validate URLs before fetching
   - Sanitize file paths

2. **Protect Credentials:**
   - Never store API keys in generated code
   - Use environment variables for secrets
   - Implement credential management

3. **Rate Limiting:**
   - Implement rate limits for spec loading
   - Throttle code generation requests
   - Monitor for abuse

4. **Access Control:**
   - Restrict file system access
   - Validate MCP client identity
   - Log all operations

5. **Network Security:**
   - Use HTTPS for URL sources
   - Validate SSL certificates
   - Implement timeouts

## Logging and Monitoring

### Enable Debug Logging

```typescript
import { OpenAPIMCPServer } from './server.js';

class LoggingMCPServer extends OpenAPIMCPServer {
  private log(message: string, data?: any) {
    console.error(`[${new Date().toISOString()}] ${message}`, data);
  }

  async handleLoadSpec(args: any) {
    this.log('Loading spec', { source: args.source });
    const start = Date.now();

    try {
      const result = await super.handleLoadSpec(args);
      this.log('Spec loaded', { duration: Date.now() - start });
      return result;
    } catch (error) {
      this.log('Spec load failed', { error, duration: Date.now() - start });
      throw error;
    }
  }
}
```

### Monitor Performance

```typescript
class MetricsMCPServer extends OpenAPIMCPServer {
  private metrics = {
    specsLoaded: 0,
    codeGenerated: 0,
    errors: 0,
    avgLoadTime: 0,
  };

  getMetrics() {
    return this.metrics;
  }
}
```

## Testing

### Unit Tests

```bash
npm test
```

### Integration Tests

```typescript
// Test loading a spec
const result = await client.callTool({
  name: 'load_openapi_spec',
  arguments: {
    source: 'https://petstore3.swagger.io/api/v3/openapi.json',
    specId: 'test-petstore',
  },
});

assert(result.content[0].text.includes('success'));
```

### Load Testing

```bash
# Test with large spec
time node dist/index.js < test-large-spec.json
```
