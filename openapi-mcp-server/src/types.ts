/**
 * Core types for OpenAPI MCP Server
 */

import { OpenAPIV3, OpenAPIV2 } from 'openapi-types';

export type OpenAPIDocument = OpenAPIV3.Document | OpenAPIV2.Document;

/**
 * Simplified API endpoint representation optimized for LLM consumption
 */
export interface LLMEndpoint {
  // Basic identification
  id: string; // Unique identifier: "GET /users/{id}"
  method: string;
  path: string;
  operationId?: string;
  summary?: string;
  description?: string;
  tags?: string[];

  // Authentication
  security: SecurityRequirement[];

  // Request structure
  parameters: LLMParameter[];
  requestBody?: LLMRequestBody;

  // Response structure
  responses: LLMResponse[];

  // Additional metadata
  deprecated?: boolean;
  servers?: string[]; // Specific server URLs if different from global
}

export interface SecurityRequirement {
  type: 'apiKey' | 'http' | 'oauth2' | 'openIdConnect' | 'none';
  scheme?: string; // For http: basic, bearer, etc.
  name?: string; // For apiKey: header/query/cookie name
  in?: 'header' | 'query' | 'cookie'; // For apiKey location
  flows?: {
    type: 'implicit' | 'password' | 'clientCredentials' | 'authorizationCode';
    authorizationUrl?: string;
    tokenUrl?: string;
    scopes?: string[];
  }[];
  description?: string;
  // Human-readable instruction for LLMs
  instruction?: string;
}

export interface LLMParameter {
  name: string;
  in: 'path' | 'query' | 'header' | 'cookie';
  description?: string;
  required: boolean;
  schema: LLMSchema;
  example?: any;
  examples?: Record<string, any>;
}

export interface LLMRequestBody {
  description?: string;
  required: boolean;
  contentTypes: string[]; // ['application/json', 'multipart/form-data']
  schema: LLMSchema;
  examples?: Record<string, any>;
}

export interface LLMResponse {
  statusCode: string; // '200', '404', 'default'
  description: string;
  contentTypes: string[];
  schema?: LLMSchema;
  examples?: Record<string, any>;
}

/**
 * Simplified schema representation that's easier for LLMs to process
 */
export interface LLMSchema {
  type: 'string' | 'number' | 'integer' | 'boolean' | 'array' | 'object' | 'null' | 'any';
  format?: string; // date-time, email, uuid, etc.
  description?: string;

  // Validation rules
  required?: string[]; // For object type
  properties?: Record<string, LLMSchema>; // For object type
  items?: LLMSchema; // For array type
  enum?: any[];
  pattern?: string;
  minLength?: number;
  maxLength?: number;
  minimum?: number;
  maximum?: number;

  // Composition
  oneOf?: LLMSchema[];
  anyOf?: LLMSchema[];
  allOf?: LLMSchema[];

  // References and examples
  $ref?: string; // Keep original ref for context
  resolvedType?: string; // Human-readable type name
  example?: any;
  default?: any;

  // Additional context for LLMs
  nullable?: boolean;
  readOnly?: boolean;
  writeOnly?: boolean;
}

/**
 * Complete API specification in LLM-friendly format
 */
export interface LLMAPISpec {
  // Metadata
  title: string;
  version: string;
  description?: string;
  termsOfService?: string;
  contact?: {
    name?: string;
    email?: string;
    url?: string;
  };

  // Base configuration
  servers: APIServer[];
  defaultSecurity: SecurityRequirement[];

  // API structure
  endpoints: LLMEndpoint[];
  schemas: Record<string, LLMSchema>; // Reusable data models

  // Categorization
  tags: {
    name: string;
    description?: string;
    endpoints: string[]; // Endpoint IDs
  }[];

  // Additional metadata for LLM context
  summary: {
    totalEndpoints: number;
    endpointsByMethod: Record<string, number>;
    authenticationTypes: string[];
    commonContentTypes: string[];
  };
}

export interface APIServer {
  url: string;
  description?: string;
  variables?: Record<string, {
    default: string;
    enum?: string[];
    description?: string;
  }>;
}

/**
 * Output format for specific use cases
 */
export interface EndpointExecutionGuide {
  endpoint: LLMEndpoint;
  curlExample: string;
  httpRequestExample: string;
  codeExamples: {
    javascript: string;
    python: string;
    curl: string;
  };
  stepByStepInstructions: string[];
}

export interface N8nWorkflowNode {
  id: string;
  name: string;
  type: string;
  typeVersion: number;
  position: [number, number];
  parameters: Record<string, any>;
  credentials?: Record<string, string>;
}

export interface N8nWorkflowConfig {
  name: string;
  nodes: N8nWorkflowNode[];
  connections: Record<string, any>;
  settings: {
    executionOrder: 'v1';
  };
}

/**
 * Configuration for the MCP server
 */
export interface MCPServerConfig {
  maxSpecSize: number; // Max bytes for OpenAPI spec
  cacheSpecs: boolean;
  enableExamples: boolean;
  defaultFormat: 'json' | 'yaml';
}

/**
 * Error types
 */
export class OpenAPIParseError extends Error {
  constructor(message: string, public readonly cause?: Error) {
    super(message);
    this.name = 'OpenAPIParseError';
  }
}

export class EndpointNotFoundError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'EndpointNotFoundError';
  }
}
