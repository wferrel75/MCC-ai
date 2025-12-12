/**
 * MCP Server for OpenAPI/Swagger Documentation Analysis
 */

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ListResourcesRequestSchema,
  ListToolsRequestSchema,
  ReadResourceRequestSchema,
  ErrorCode,
  McpError,
} from '@modelcontextprotocol/sdk/types.js';
import { OpenAPIParser } from './parser.js';
import { CodeGenerator, N8nGenerator } from './generators.js';
import {
  LLMAPISpec,
  LLMEndpoint,
  EndpointNotFoundError,
  OpenAPIParseError,
} from './types.js';
import * as fs from 'fs/promises';
import * as path from 'path';
import YAML from 'yaml';

/**
 * Main MCP Server class
 */
export class OpenAPIMCPServer {
  private server: Server;
  private parser: OpenAPIParser;
  private codeGenerator: CodeGenerator;
  private n8nGenerator: N8nGenerator;

  // In-memory cache of loaded API specs
  private loadedSpecs: Map<string, LLMAPISpec> = new Map();

  constructor() {
    this.server = new Server(
      {
        name: 'openapi-mcp-server',
        version: '1.0.0',
      },
      {
        capabilities: {
          resources: {},
          tools: {},
          prompts: {},
        },
      }
    );

    this.parser = new OpenAPIParser();
    this.codeGenerator = new CodeGenerator();
    this.n8nGenerator = new N8nGenerator();

    this.setupHandlers();
  }

  /**
   * Setup MCP protocol handlers
   */
  private setupHandlers(): void {
    // List available tools
    this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: [
        {
          name: 'load_openapi_spec',
          description:
            'Load and parse an OpenAPI/Swagger specification from a file path, URL, or JSON/YAML string. Returns a complete analysis of the API.',
          inputSchema: {
            type: 'object',
            properties: {
              source: {
                type: 'string',
                description:
                  'File path, URL, or inline JSON/YAML string containing the OpenAPI specification',
              },
              specId: {
                type: 'string',
                description:
                  'Unique identifier for this spec (optional, auto-generated if not provided)',
              },
            },
            required: ['source'],
          },
        },
        {
          name: 'get_api_overview',
          description:
            'Get a high-level overview of a loaded API including endpoints, authentication, and common patterns.',
          inputSchema: {
            type: 'object',
            properties: {
              specId: {
                type: 'string',
                description: 'The ID of the loaded API spec',
              },
              includeEndpoints: {
                type: 'boolean',
                description: 'Include list of all endpoints (default: false)',
                default: false,
              },
            },
            required: ['specId'],
          },
        },
        {
          name: 'search_endpoints',
          description:
            'Search for endpoints by path, method, tag, or description. Returns matching endpoints.',
          inputSchema: {
            type: 'object',
            properties: {
              specId: {
                type: 'string',
                description: 'The ID of the loaded API spec',
              },
              query: {
                type: 'string',
                description: 'Search query (searches path, summary, description, tags)',
              },
              method: {
                type: 'string',
                enum: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS', 'HEAD'],
                description: 'Filter by HTTP method',
              },
              tag: {
                type: 'string',
                description: 'Filter by tag',
              },
            },
            required: ['specId'],
          },
        },
        {
          name: 'get_endpoint_details',
          description:
            'Get complete details about a specific endpoint including parameters, request/response schemas, and examples.',
          inputSchema: {
            type: 'object',
            properties: {
              specId: {
                type: 'string',
                description: 'The ID of the loaded API spec',
              },
              endpointId: {
                type: 'string',
                description: 'The endpoint ID (e.g., "GET /users/{id}")',
              },
            },
            required: ['specId', 'endpointId'],
          },
        },
        {
          name: 'generate_request_code',
          description:
            'Generate code examples (JavaScript, Python, curl) for making a request to a specific endpoint.',
          inputSchema: {
            type: 'object',
            properties: {
              specId: {
                type: 'string',
                description: 'The ID of the loaded API spec',
              },
              endpointId: {
                type: 'string',
                description: 'The endpoint ID (e.g., "GET /users/{id}")',
              },
              language: {
                type: 'string',
                enum: ['javascript', 'python', 'curl', 'http', 'all'],
                default: 'all',
                description: 'Programming language for code generation',
              },
              includeSteps: {
                type: 'boolean',
                default: true,
                description: 'Include step-by-step instructions',
              },
            },
            required: ['specId', 'endpointId'],
          },
        },
        {
          name: 'generate_n8n_node',
          description:
            'Generate an n8n HTTP Request node configuration for a specific endpoint.',
          inputSchema: {
            type: 'object',
            properties: {
              specId: {
                type: 'string',
                description: 'The ID of the loaded API spec',
              },
              endpointId: {
                type: 'string',
                description: 'The endpoint ID (e.g., "GET /users/{id}")',
              },
            },
            required: ['specId', 'endpointId'],
          },
        },
        {
          name: 'generate_n8n_workflow',
          description:
            'Generate a complete n8n workflow that includes multiple endpoints from the API.',
          inputSchema: {
            type: 'object',
            properties: {
              specId: {
                type: 'string',
                description: 'The ID of the loaded API spec',
              },
              endpointIds: {
                type: 'array',
                items: { type: 'string' },
                description: 'Array of endpoint IDs to include in the workflow',
              },
              workflowName: {
                type: 'string',
                description: 'Name for the workflow',
              },
            },
            required: ['specId', 'endpointIds', 'workflowName'],
          },
        },
        {
          name: 'get_authentication_info',
          description:
            'Get detailed information about authentication requirements for the API or a specific endpoint.',
          inputSchema: {
            type: 'object',
            properties: {
              specId: {
                type: 'string',
                description: 'The ID of the loaded API spec',
              },
              endpointId: {
                type: 'string',
                description:
                  'Optional: specific endpoint ID to get auth info for',
              },
            },
            required: ['specId'],
          },
        },
        {
          name: 'get_schema_details',
          description:
            'Get detailed information about a specific data schema/model from the API.',
          inputSchema: {
            type: 'object',
            properties: {
              specId: {
                type: 'string',
                description: 'The ID of the loaded API spec',
              },
              schemaName: {
                type: 'string',
                description: 'Name of the schema (e.g., "User", "Product")',
              },
              includeExample: {
                type: 'boolean',
                default: true,
                description: 'Generate an example object',
              },
            },
            required: ['specId', 'schemaName'],
          },
        },
        {
          name: 'analyze_pagination',
          description:
            'Analyze how pagination works in the API and provide guidance for implementing pagination logic.',
          inputSchema: {
            type: 'object',
            properties: {
              specId: {
                type: 'string',
                description: 'The ID of the loaded API spec',
              },
              endpointId: {
                type: 'string',
                description:
                  'Optional: specific endpoint to analyze for pagination',
              },
            },
            required: ['specId'],
          },
        },
      ],
    }));

    // Handle tool calls
    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      try {
        switch (request.params.name) {
          case 'load_openapi_spec':
            return await this.handleLoadSpec(request.params.arguments);

          case 'get_api_overview':
            return await this.handleGetOverview(request.params.arguments);

          case 'search_endpoints':
            return await this.handleSearchEndpoints(request.params.arguments);

          case 'get_endpoint_details':
            return await this.handleGetEndpointDetails(request.params.arguments);

          case 'generate_request_code':
            return await this.handleGenerateCode(request.params.arguments);

          case 'generate_n8n_node':
            return await this.handleGenerateN8nNode(request.params.arguments);

          case 'generate_n8n_workflow':
            return await this.handleGenerateN8nWorkflow(request.params.arguments);

          case 'get_authentication_info':
            return await this.handleGetAuthInfo(request.params.arguments);

          case 'get_schema_details':
            return await this.handleGetSchemaDetails(request.params.arguments);

          case 'analyze_pagination':
            return await this.handleAnalyzePagination(request.params.arguments);

          default:
            throw new McpError(
              ErrorCode.MethodNotFound,
              `Unknown tool: ${request.params.name}`
            );
        }
      } catch (error) {
        if (error instanceof McpError) {
          throw error;
        }
        throw new McpError(
          ErrorCode.InternalError,
          `Tool execution failed: ${error instanceof Error ? error.message : String(error)}`
        );
      }
    });

    // List resources (loaded API specs)
    this.server.setRequestHandler(ListResourcesRequestSchema, async () => {
      const resources = Array.from(this.loadedSpecs.entries()).map(([id, spec]) => ({
        uri: `openapi://${id}`,
        name: spec.title,
        description: `${spec.summary.totalEndpoints} endpoints, v${spec.version}`,
        mimeType: 'application/json',
      }));

      return { resources };
    });

    // Read resource (get full API spec)
    this.server.setRequestHandler(ReadResourceRequestSchema, async (request) => {
      const uri = request.params.uri;
      const specId = uri.replace('openapi://', '');

      const spec = this.loadedSpecs.get(specId);
      if (!spec) {
        throw new McpError(ErrorCode.InvalidRequest, `Spec not found: ${specId}`);
      }

      return {
        contents: [
          {
            uri,
            mimeType: 'application/json',
            text: JSON.stringify(spec, null, 2),
          },
        ],
      };
    });
  }

  /**
   * Tool handlers
   */

  private async handleLoadSpec(args: any) {
    const source = args.source as string;
    const specId = args.specId || this.generateSpecId(source);

    let spec: LLMAPISpec;

    try {
      // Determine source type and load accordingly
      if (source.startsWith('http://') || source.startsWith('https://')) {
        // Load from URL
        const response = await fetch(source);
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        const content = await response.text();
        spec = await this.parser.parse(
          source.endsWith('.yaml') || source.endsWith('.yml')
            ? YAML.parse(content)
            : JSON.parse(content)
        );
      } else if (
        await fs
          .access(source)
          .then(() => true)
          .catch(() => false)
      ) {
        // Load from file
        const content = await fs.readFile(source, 'utf-8');
        spec = await this.parser.parse(
          source.endsWith('.yaml') || source.endsWith('.yml')
            ? YAML.parse(content)
            : JSON.parse(content)
        );
      } else {
        // Try to parse as inline JSON/YAML
        try {
          const parsed = source.trim().startsWith('{')
            ? JSON.parse(source)
            : YAML.parse(source);
          spec = await this.parser.parse(parsed);
        } catch {
          throw new Error(
            'Source must be a valid file path, URL, or JSON/YAML string'
          );
        }
      }

      // Cache the spec
      this.loadedSpecs.set(specId, spec);

      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify(
              {
                success: true,
                specId,
                summary: {
                  title: spec.title,
                  version: spec.version,
                  description: spec.description,
                  totalEndpoints: spec.summary.totalEndpoints,
                  endpointsByMethod: spec.summary.endpointsByMethod,
                  authTypes: spec.summary.authenticationTypes,
                  servers: spec.servers.map((s) => s.url),
                },
              },
              null,
              2
            ),
          },
        ],
      };
    } catch (error) {
      throw new McpError(
        ErrorCode.InternalError,
        `Failed to load OpenAPI spec: ${error instanceof Error ? error.message : String(error)}`
      );
    }
  }

  private async handleGetOverview(args: any) {
    const spec = this.getSpec(args.specId);
    const includeEndpoints = args.includeEndpoints || false;

    const overview: any = {
      title: spec.title,
      version: spec.version,
      description: spec.description,
      servers: spec.servers,
      authentication: spec.defaultSecurity,
      summary: spec.summary,
      tags: spec.tags.map((t) => ({
        name: t.name,
        description: t.description,
        endpointCount: t.endpoints.length,
      })),
    };

    if (includeEndpoints) {
      overview.endpoints = spec.endpoints.map((e) => ({
        id: e.id,
        method: e.method,
        path: e.path,
        summary: e.summary,
        tags: e.tags,
      }));
    }

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(overview, null, 2),
        },
      ],
    };
  }

  private async handleSearchEndpoints(args: any) {
    const spec = this.getSpec(args.specId);
    const query = args.query?.toLowerCase();
    const method = args.method?.toUpperCase();
    const tag = args.tag;

    let results = spec.endpoints;

    // Filter by method
    if (method) {
      results = results.filter((e) => e.method === method);
    }

    // Filter by tag
    if (tag) {
      results = results.filter((e) => e.tags?.includes(tag));
    }

    // Filter by query
    if (query) {
      results = results.filter(
        (e) =>
          e.path.toLowerCase().includes(query) ||
          e.summary?.toLowerCase().includes(query) ||
          e.description?.toLowerCase().includes(query) ||
          e.operationId?.toLowerCase().includes(query) ||
          e.tags?.some((t) => t.toLowerCase().includes(query))
      );
    }

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(
            {
              total: results.length,
              endpoints: results.map((e) => ({
                id: e.id,
                method: e.method,
                path: e.path,
                summary: e.summary,
                tags: e.tags,
                deprecated: e.deprecated,
              })),
            },
            null,
            2
          ),
        },
      ],
    };
  }

  private async handleGetEndpointDetails(args: any) {
    const spec = this.getSpec(args.specId);
    const endpoint = this.findEndpoint(spec, args.endpointId);

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(endpoint, null, 2),
        },
      ],
    };
  }

  private async handleGenerateCode(args: any) {
    const spec = this.getSpec(args.specId);
    const endpoint = this.findEndpoint(spec, args.endpointId);
    const language = args.language || 'all';
    const includeSteps = args.includeSteps !== false;

    const baseUrl = spec.servers[0]?.url || 'https://api.example.com';
    const guide = this.codeGenerator.generateExecutionGuide(endpoint, baseUrl);

    let result: any = {
      endpoint: {
        id: endpoint.id,
        method: endpoint.method,
        path: endpoint.path,
        summary: endpoint.summary,
      },
    };

    if (includeSteps) {
      result.stepByStepInstructions = guide.stepByStepInstructions;
    }

    if (language === 'all') {
      result.examples = guide.codeExamples;
    } else {
      result.example = guide.codeExamples[language as keyof typeof guide.codeExamples];
    }

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  }

  private async handleGenerateN8nNode(args: any) {
    const spec = this.getSpec(args.specId);
    const endpoint = this.findEndpoint(spec, args.endpointId);
    const baseUrl = spec.servers[0]?.url || 'https://api.example.com';

    const node = this.n8nGenerator.generateHttpRequestNode(endpoint, baseUrl);

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(
            {
              node,
              instructions:
                'Copy this node configuration and import it into your n8n workflow. You may need to configure credentials separately.',
            },
            null,
            2
          ),
        },
      ],
    };
  }

  private async handleGenerateN8nWorkflow(args: any) {
    const spec = this.getSpec(args.specId);
    const endpointIds = args.endpointIds as string[];
    const workflowName = args.workflowName as string;

    const endpoints = endpointIds.map((id) => this.findEndpoint(spec, id));
    const baseUrl = spec.servers[0]?.url || 'https://api.example.com';

    const workflow = this.n8nGenerator.generateWorkflow(
      workflowName,
      endpoints,
      baseUrl
    );

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(
            {
              workflow,
              instructions:
                'Import this workflow JSON into n8n. Configure credentials and test each node before activating.',
            },
            null,
            2
          ),
        },
      ],
    };
  }

  private async handleGetAuthInfo(args: any) {
    const spec = this.getSpec(args.specId);

    if (args.endpointId) {
      const endpoint = this.findEndpoint(spec, args.endpointId);
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify(
              {
                endpoint: endpoint.id,
                security: endpoint.security,
              },
              null,
              2
            ),
          },
        ],
      };
    } else {
      return {
        content: [
          {
            type: 'text',
            text: JSON.stringify(
              {
                defaultSecurity: spec.defaultSecurity,
                authenticationTypes: spec.summary.authenticationTypes,
                endpointSecurityVariations: this.analyzeAuthVariations(spec),
              },
              null,
              2
            ),
          },
        ],
      };
    }
  }

  private async handleGetSchemaDetails(args: any) {
    const spec = this.getSpec(args.specId);
    const schemaName = args.schemaName as string;
    const includeExample = args.includeExample !== false;

    const schema = spec.schemas[schemaName];
    if (!schema) {
      throw new McpError(
        ErrorCode.InvalidRequest,
        `Schema not found: ${schemaName}`
      );
    }

    const result: any = {
      name: schemaName,
      schema,
    };

    if (includeExample) {
      result.example = this.generateSchemaExample(schema);
    }

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(result, null, 2),
        },
      ],
    };
  }

  private async handleAnalyzePagination(args: any) {
    const spec = this.getSpec(args.specId);

    const paginationPatterns = this.detectPaginationPatterns(spec, args.endpointId);

    return {
      content: [
        {
          type: 'text',
          text: JSON.stringify(paginationPatterns, null, 2),
        },
      ],
    };
  }

  /**
   * Helper methods
   */

  private getSpec(specId: string): LLMAPISpec {
    const spec = this.loadedSpecs.get(specId);
    if (!spec) {
      throw new McpError(ErrorCode.InvalidRequest, `Spec not found: ${specId}`);
    }
    return spec;
  }

  private findEndpoint(spec: LLMAPISpec, endpointId: string): LLMEndpoint {
    const endpoint = spec.endpoints.find((e) => e.id === endpointId);
    if (!endpoint) {
      throw new McpError(
        ErrorCode.InvalidRequest,
        `Endpoint not found: ${endpointId}`
      );
    }
    return endpoint;
  }

  private generateSpecId(source: string): string {
    return `spec_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  private generateSchemaExample(schema: any): any {
    // Reuse code generator's example generation
    return this.codeGenerator['generateExampleBody'](schema);
  }

  private analyzeAuthVariations(spec: LLMAPISpec): any {
    const variations = new Map<string, number>();

    for (const endpoint of spec.endpoints) {
      const key = JSON.stringify(endpoint.security);
      variations.set(key, (variations.get(key) || 0) + 1);
    }

    return Array.from(variations.entries()).map(([security, count]) => ({
      security: JSON.parse(security),
      endpointCount: count,
    }));
  }

  private detectPaginationPatterns(spec: LLMAPISpec, endpointId?: string): any {
    const endpoints = endpointId
      ? [this.findEndpoint(spec, endpointId)]
      : spec.endpoints.filter((e) => e.method === 'GET');

    const patterns: any = {
      detected: [],
      recommendations: [],
    };

    for (const endpoint of endpoints) {
      const queryParams = endpoint.parameters.filter((p) => p.in === 'query');
      const paramNames = queryParams.map((p) => p.name.toLowerCase());

      // Detect common pagination patterns
      if (paramNames.includes('page') || paramNames.includes('page_number')) {
        patterns.detected.push({
          endpoint: endpoint.id,
          type: 'page-based',
          parameters: queryParams.filter((p) =>
            ['page', 'page_number', 'per_page', 'page_size', 'limit'].includes(
              p.name.toLowerCase()
            )
          ),
        });
      }

      if (paramNames.includes('offset') || paramNames.includes('skip')) {
        patterns.detected.push({
          endpoint: endpoint.id,
          type: 'offset-based',
          parameters: queryParams.filter((p) =>
            ['offset', 'skip', 'limit', 'take'].includes(p.name.toLowerCase())
          ),
        });
      }

      if (paramNames.includes('cursor') || paramNames.includes('next_token')) {
        patterns.detected.push({
          endpoint: endpoint.id,
          type: 'cursor-based',
          parameters: queryParams.filter((p) =>
            ['cursor', 'next_token', 'page_token'].includes(p.name.toLowerCase())
          ),
        });
      }
    }

    // Generate recommendations
    if (patterns.detected.length > 0) {
      const mainType = patterns.detected[0].type;
      if (mainType === 'page-based') {
        patterns.recommendations.push(
          'Implement page-based pagination by incrementing the page parameter until no more results are returned.'
        );
      } else if (mainType === 'offset-based') {
        patterns.recommendations.push(
          'Implement offset-based pagination by incrementing the offset by the limit value on each request.'
        );
      } else if (mainType === 'cursor-based') {
        patterns.recommendations.push(
          'Implement cursor-based pagination by using the cursor/token from the previous response in the next request.'
        );
      }
    } else {
      patterns.recommendations.push(
        'No standard pagination pattern detected. Check the response schema for links or metadata indicating pagination.'
      );
    }

    return patterns;
  }

  /**
   * Start the server
   */
  async start(): Promise<void> {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);

    console.error('OpenAPI MCP Server running on stdio');
  }
}
