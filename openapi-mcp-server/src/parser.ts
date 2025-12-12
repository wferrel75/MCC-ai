/**
 * OpenAPI Parser - Converts OpenAPI/Swagger specs to LLM-friendly format
 */

import SwaggerParser from '@apidevtools/swagger-parser';
import { OpenAPIV3, OpenAPIV2 } from 'openapi-types';
import {
  OpenAPIDocument,
  LLMAPISpec,
  LLMEndpoint,
  LLMParameter,
  LLMRequestBody,
  LLMResponse,
  LLMSchema,
  SecurityRequirement,
  APIServer,
  OpenAPIParseError,
} from './types.js';

export class OpenAPIParser {
  private document: OpenAPIV3.Document | null = null;
  private dereferenced: OpenAPIV3.Document | null = null;

  /**
   * Parse and validate an OpenAPI document from JSON/YAML string or object
   */
  async parse(input: string | object): Promise<LLMAPISpec> {
    try {
      // Parse and validate the document
      const parsed = await SwaggerParser.validate(input as any);
      this.document = parsed as OpenAPIV3.Document;

      // Dereference $refs for easier processing
      this.dereferenced = (await SwaggerParser.dereference(
        parsed as any
      )) as OpenAPIV3.Document;

      return this.convertToLLMFormat();
    } catch (error) {
      throw new OpenAPIParseError(
        `Failed to parse OpenAPI document: ${error instanceof Error ? error.message : String(error)}`,
        error instanceof Error ? error : undefined
      );
    }
  }

  /**
   * Convert OpenAPI document to LLM-friendly format
   */
  private convertToLLMFormat(): LLMAPISpec {
    if (!this.document || !this.dereferenced) {
      throw new OpenAPIParseError('No document loaded');
    }

    const doc = this.document;
    const deref = this.dereferenced;

    // Extract servers
    const servers = this.extractServers(doc);

    // Extract global security requirements
    const defaultSecurity = this.extractGlobalSecurity(doc);

    // Extract all endpoints
    const endpoints = this.extractEndpoints(deref, servers, defaultSecurity);

    // Extract reusable schemas
    const schemas = this.extractSchemas(doc);

    // Build tags index
    const tags = this.buildTagsIndex(doc, endpoints);

    // Generate summary statistics
    const summary = this.generateSummary(endpoints);

    return {
      title: doc.info.title,
      version: doc.info.version,
      description: doc.info.description,
      termsOfService: doc.info.termsOfService,
      contact: doc.info.contact,
      servers,
      defaultSecurity,
      endpoints,
      schemas,
      tags,
      summary,
    };
  }

  /**
   * Extract server configurations
   */
  private extractServers(doc: OpenAPIV3.Document): APIServer[] {
    if (!doc.servers || doc.servers.length === 0) {
      return [{ url: 'https://api.example.com', description: 'Default server' }];
    }

    return doc.servers.map((server) => ({
      url: server.url,
      description: server.description,
      variables: server.variables as any,
    }));
  }

  /**
   * Extract global security requirements
   */
  private extractGlobalSecurity(doc: OpenAPIV3.Document): SecurityRequirement[] {
    if (!doc.security || doc.security.length === 0) {
      return [];
    }

    const securitySchemes = doc.components?.securitySchemes || {};
    const requirements: SecurityRequirement[] = [];

    for (const securityReq of doc.security) {
      for (const [name, scopes] of Object.entries(securityReq)) {
        const scheme = securitySchemes[name] as OpenAPIV3.SecuritySchemeObject;
        if (scheme) {
          requirements.push(this.convertSecurityScheme(scheme, name, scopes));
        }
      }
    }

    return requirements;
  }

  /**
   * Convert security scheme to LLM format
   */
  private convertSecurityScheme(
    scheme: OpenAPIV3.SecuritySchemeObject,
    name: string,
    scopes: string[]
  ): SecurityRequirement {
    const base = {
      description: scheme.description,
    };

    switch (scheme.type) {
      case 'apiKey':
        return {
          ...base,
          type: 'apiKey',
          name: scheme.name,
          in: scheme.in as 'header' | 'query' | 'cookie',
          instruction: `Provide API key in ${scheme.in} parameter "${scheme.name}"`,
        };

      case 'http':
        return {
          ...base,
          type: 'http',
          scheme: scheme.scheme,
          instruction:
            scheme.scheme === 'bearer'
              ? 'Include bearer token in Authorization header: "Bearer <token>"'
              : scheme.scheme === 'basic'
              ? 'Include basic auth in Authorization header: "Basic <base64(username:password)>"'
              : `Use HTTP ${scheme.scheme} authentication`,
        };

      case 'oauth2':
        const flows = scheme.flows;
        const flowData = [];

        if (flows.implicit) {
          flowData.push({
            type: 'implicit' as const,
            authorizationUrl: flows.implicit.authorizationUrl,
            scopes: scopes,
          });
        }
        if (flows.password) {
          flowData.push({
            type: 'password' as const,
            tokenUrl: flows.password.tokenUrl,
            scopes: scopes,
          });
        }
        if (flows.clientCredentials) {
          flowData.push({
            type: 'clientCredentials' as const,
            tokenUrl: flows.clientCredentials.tokenUrl,
            scopes: scopes,
          });
        }
        if (flows.authorizationCode) {
          flowData.push({
            type: 'authorizationCode' as const,
            authorizationUrl: flows.authorizationCode.authorizationUrl,
            tokenUrl: flows.authorizationCode.tokenUrl,
            scopes: scopes,
          });
        }

        return {
          ...base,
          type: 'oauth2',
          flows: flowData,
          instruction: `OAuth2 authentication required. Scopes: ${scopes.join(', ')}`,
        };

      case 'openIdConnect':
        return {
          ...base,
          type: 'openIdConnect',
          instruction: 'OpenID Connect authentication required',
        };

      default:
        return {
          ...base,
          type: 'none',
          instruction: 'No authentication required',
        };
    }
  }

  /**
   * Extract all endpoints from the API
   */
  private extractEndpoints(
    doc: OpenAPIV3.Document,
    servers: APIServer[],
    defaultSecurity: SecurityRequirement[]
  ): LLMEndpoint[] {
    const endpoints: LLMEndpoint[] = [];

    if (!doc.paths) {
      return endpoints;
    }

    for (const [path, pathItem] of Object.entries(doc.paths)) {
      if (!pathItem) continue;

      const methods = ['get', 'post', 'put', 'patch', 'delete', 'options', 'head', 'trace'];

      for (const method of methods) {
        const operation = (pathItem as any)[method] as OpenAPIV3.OperationObject | undefined;
        if (!operation) continue;

        const endpoint = this.convertOperation(
          method.toUpperCase(),
          path,
          operation,
          pathItem,
          servers,
          defaultSecurity
        );

        endpoints.push(endpoint);
      }
    }

    return endpoints;
  }

  /**
   * Convert a single operation to LLM format
   */
  private convertOperation(
    method: string,
    path: string,
    operation: OpenAPIV3.OperationObject,
    pathItem: OpenAPIV3.PathItemObject,
    servers: APIServer[],
    defaultSecurity: SecurityRequirement[]
  ): LLMEndpoint {
    const id = `${method} ${path}`;

    // Merge path-level and operation-level parameters
    const allParams = [
      ...(pathItem.parameters || []),
      ...(operation.parameters || []),
    ] as OpenAPIV3.ParameterObject[];

    const parameters = allParams.map((p) => this.convertParameter(p));

    // Extract security requirements
    let security: SecurityRequirement[] = [];
    if (operation.security !== undefined) {
      // Operation-level security overrides global
      if (operation.security.length === 0) {
        security = [{ type: 'none', instruction: 'No authentication required' }];
      } else {
        // Convert operation security (would need access to securitySchemes)
        security = defaultSecurity; // Simplified
      }
    } else {
      security = defaultSecurity;
    }

    // Convert request body
    let requestBody: LLMRequestBody | undefined;
    if (operation.requestBody) {
      requestBody = this.convertRequestBody(
        operation.requestBody as OpenAPIV3.RequestBodyObject
      );
    }

    // Convert responses
    const responses = this.convertResponses(operation.responses);

    return {
      id,
      method,
      path,
      operationId: operation.operationId,
      summary: operation.summary,
      description: operation.description,
      tags: operation.tags,
      security,
      parameters,
      requestBody,
      responses,
      deprecated: operation.deprecated,
      servers: servers.map((s) => s.url),
    };
  }

  /**
   * Convert parameter to LLM format
   */
  private convertParameter(param: OpenAPIV3.ParameterObject): LLMParameter {
    return {
      name: param.name,
      in: param.in as 'path' | 'query' | 'header' | 'cookie',
      description: param.description,
      required: param.required || param.in === 'path',
      schema: this.convertSchema(param.schema as OpenAPIV3.SchemaObject),
      example: param.example,
      examples: param.examples as any,
    };
  }

  /**
   * Convert request body to LLM format
   */
  private convertRequestBody(body: OpenAPIV3.RequestBodyObject): LLMRequestBody {
    const contentTypes = Object.keys(body.content);
    const firstContent = body.content[contentTypes[0]];

    return {
      description: body.description,
      required: body.required || false,
      contentTypes,
      schema: this.convertSchema(firstContent.schema as OpenAPIV3.SchemaObject),
      examples: firstContent.examples as any,
    };
  }

  /**
   * Convert responses to LLM format
   */
  private convertResponses(
    responses: OpenAPIV3.ResponsesObject
  ): LLMResponse[] {
    const result: LLMResponse[] = [];

    for (const [statusCode, response] of Object.entries(responses)) {
      const responseObj = response as OpenAPIV3.ResponseObject;

      const contentTypes = responseObj.content ? Object.keys(responseObj.content) : [];
      const firstContent = contentTypes.length > 0 ? responseObj.content![contentTypes[0]] : null;

      result.push({
        statusCode,
        description: responseObj.description,
        contentTypes,
        schema: firstContent?.schema
          ? this.convertSchema(firstContent.schema as OpenAPIV3.SchemaObject)
          : undefined,
        examples: firstContent?.examples as any,
      });
    }

    return result;
  }

  /**
   * Convert JSON Schema to LLM format with simplified structure
   */
  private convertSchema(schema: OpenAPIV3.SchemaObject | undefined): LLMSchema {
    if (!schema) {
      return { type: 'any' };
    }

    const base: LLMSchema = {
      type: (schema.type as any) || 'any',
      format: schema.format,
      description: schema.description,
      enum: schema.enum,
      pattern: schema.pattern,
      minLength: schema.minLength,
      maxLength: schema.maxLength,
      minimum: schema.minimum,
      maximum: schema.maximum,
      example: schema.example,
      default: schema.default,
      nullable: schema.nullable,
      readOnly: schema.readOnly,
      writeOnly: schema.writeOnly,
    };

    // Handle object type
    if (schema.type === 'object' || schema.properties) {
      base.type = 'object';
      base.required = schema.required;
      base.properties = {};

      if (schema.properties) {
        for (const [propName, propSchema] of Object.entries(schema.properties)) {
          base.properties[propName] = this.convertSchema(
            propSchema as OpenAPIV3.SchemaObject
          );
        }
      }
    }

    // Handle array type
    if (schema.type === 'array' && schema.items) {
      base.items = this.convertSchema(schema.items as OpenAPIV3.SchemaObject);
    }

    // Handle composition (oneOf, anyOf, allOf)
    if (schema.oneOf) {
      base.oneOf = schema.oneOf.map((s) =>
        this.convertSchema(s as OpenAPIV3.SchemaObject)
      );
    }
    if (schema.anyOf) {
      base.anyOf = schema.anyOf.map((s) =>
        this.convertSchema(s as OpenAPIV3.SchemaObject)
      );
    }
    if (schema.allOf) {
      base.allOf = schema.allOf.map((s) =>
        this.convertSchema(s as OpenAPIV3.SchemaObject)
      );
    }

    return base;
  }

  /**
   * Extract reusable schemas from components
   */
  private extractSchemas(doc: OpenAPIV3.Document): Record<string, LLMSchema> {
    const schemas: Record<string, LLMSchema> = {};

    if (doc.components?.schemas) {
      for (const [name, schema] of Object.entries(doc.components.schemas)) {
        schemas[name] = this.convertSchema(schema as OpenAPIV3.SchemaObject);
      }
    }

    return schemas;
  }

  /**
   * Build tags index
   */
  private buildTagsIndex(
    doc: OpenAPIV3.Document,
    endpoints: LLMEndpoint[]
  ): Array<{ name: string; description?: string; endpoints: string[] }> {
    const tagMap = new Map<string, { description?: string; endpoints: string[] }>();

    // Initialize from doc.tags
    if (doc.tags) {
      for (const tag of doc.tags) {
        tagMap.set(tag.name, { description: tag.description, endpoints: [] });
      }
    }

    // Add endpoints to tags
    for (const endpoint of endpoints) {
      if (endpoint.tags) {
        for (const tagName of endpoint.tags) {
          if (!tagMap.has(tagName)) {
            tagMap.set(tagName, { endpoints: [] });
          }
          tagMap.get(tagName)!.endpoints.push(endpoint.id);
        }
      }
    }

    return Array.from(tagMap.entries()).map(([name, data]) => ({
      name,
      description: data.description,
      endpoints: data.endpoints,
    }));
  }

  /**
   * Generate summary statistics
   */
  private generateSummary(endpoints: LLMEndpoint[]) {
    const endpointsByMethod: Record<string, number> = {};
    const authTypes = new Set<string>();
    const contentTypes = new Set<string>();

    for (const endpoint of endpoints) {
      endpointsByMethod[endpoint.method] =
        (endpointsByMethod[endpoint.method] || 0) + 1;

      for (const sec of endpoint.security) {
        authTypes.add(sec.type);
      }

      if (endpoint.requestBody) {
        endpoint.requestBody.contentTypes.forEach((ct) => contentTypes.add(ct));
      }

      for (const response of endpoint.responses) {
        response.contentTypes.forEach((ct) => contentTypes.add(ct));
      }
    }

    return {
      totalEndpoints: endpoints.length,
      endpointsByMethod,
      authenticationTypes: Array.from(authTypes),
      commonContentTypes: Array.from(contentTypes),
    };
  }
}
