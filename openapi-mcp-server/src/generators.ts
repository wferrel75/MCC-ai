/**
 * Code and configuration generators for various platforms
 */

import {
  LLMEndpoint,
  LLMParameter,
  LLMSchema,
  EndpointExecutionGuide,
  N8nWorkflowConfig,
  N8nWorkflowNode,
} from './types.js';

export class CodeGenerator {
  /**
   * Generate a complete execution guide for an endpoint
   */
  generateExecutionGuide(
    endpoint: LLMEndpoint,
    baseUrl: string
  ): EndpointExecutionGuide {
    return {
      endpoint,
      curlExample: this.generateCurl(endpoint, baseUrl),
      httpRequestExample: this.generateHttpRequest(endpoint, baseUrl),
      codeExamples: {
        javascript: this.generateJavaScript(endpoint, baseUrl),
        python: this.generatePython(endpoint, baseUrl),
        curl: this.generateCurl(endpoint, baseUrl),
      },
      stepByStepInstructions: this.generateStepByStep(endpoint),
    };
  }

  /**
   * Generate curl command
   */
  generateCurl(endpoint: LLMEndpoint, baseUrl: string): string {
    const url = this.buildUrl(endpoint, baseUrl);
    const lines: string[] = [`curl -X ${endpoint.method} '${url}'`];

    // Add headers
    const headers = this.getRequiredHeaders(endpoint);
    for (const [key, value] of Object.entries(headers)) {
      lines.push(`  -H '${key}: ${value}'`);
    }

    // Add authentication
    const authHeader = this.getAuthHeader(endpoint);
    if (authHeader) {
      lines.push(`  -H '${authHeader.key}: ${authHeader.value}'`);
    }

    // Add request body
    if (endpoint.requestBody) {
      const body = this.generateExampleBody(endpoint.requestBody.schema);
      lines.push(`  -d '${JSON.stringify(body, null, 2)}'`);
    }

    return lines.join(' \\\n');
  }

  /**
   * Generate raw HTTP request
   */
  generateHttpRequest(endpoint: LLMEndpoint, baseUrl: string): string {
    const url = new URL(this.buildUrl(endpoint, baseUrl));
    const lines: string[] = [
      `${endpoint.method} ${url.pathname}${url.search} HTTP/1.1`,
      `Host: ${url.host}`,
    ];

    // Add headers
    const headers = this.getRequiredHeaders(endpoint);
    for (const [key, value] of Object.entries(headers)) {
      lines.push(`${key}: ${value}`);
    }

    // Add authentication
    const authHeader = this.getAuthHeader(endpoint);
    if (authHeader) {
      lines.push(`${authHeader.key}: ${authHeader.value}`);
    }

    lines.push(''); // Empty line before body

    // Add request body
    if (endpoint.requestBody) {
      const body = this.generateExampleBody(endpoint.requestBody.schema);
      lines.push(JSON.stringify(body, null, 2));
    }

    return lines.join('\n');
  }

  /**
   * Generate JavaScript/Node.js code
   */
  generateJavaScript(endpoint: LLMEndpoint, baseUrl: string): string {
    const url = this.buildUrl(endpoint, baseUrl, true);
    const hasBody = !!endpoint.requestBody;

    const code: string[] = [
      '// Using fetch API',
      hasBody
        ? `const requestBody = ${JSON.stringify(this.generateExampleBody(endpoint.requestBody!.schema), null, 2)};`
        : '',
      '',
      `const response = await fetch('${url}', {`,
      `  method: '${endpoint.method}',`,
    ];

    // Headers
    const headers = this.getRequiredHeaders(endpoint);
    const authHeader = this.getAuthHeader(endpoint);
    if (authHeader) {
      headers[authHeader.key] = authHeader.value;
    }

    if (Object.keys(headers).length > 0) {
      code.push('  headers: {');
      for (const [key, value] of Object.entries(headers)) {
        code.push(`    '${key}': '${value}',`);
      }
      code.push('  },');
    }

    // Body
    if (hasBody) {
      code.push('  body: JSON.stringify(requestBody),');
    }

    code.push('});');
    code.push('');
    code.push('if (!response.ok) {');
    code.push('  throw new Error(`HTTP error! status: ${response.status}`);');
    code.push('}');
    code.push('');
    code.push('const data = await response.json();');
    code.push('console.log(data);');

    return code.filter((line) => line !== undefined).join('\n');
  }

  /**
   * Generate Python code
   */
  generatePython(endpoint: LLMEndpoint, baseUrl: string): string {
    const url = this.buildUrl(endpoint, baseUrl, true);
    const hasBody = !!endpoint.requestBody;

    const code: string[] = ['import requests', 'import json', ''];

    // Headers
    const headers = this.getRequiredHeaders(endpoint);
    const authHeader = this.getAuthHeader(endpoint);
    if (authHeader) {
      headers[authHeader.key] = authHeader.value;
    }

    if (Object.keys(headers).length > 0) {
      code.push('headers = {');
      for (const [key, value] of Object.entries(headers)) {
        code.push(`    '${key}': '${value}',`);
      }
      code.push('}');
      code.push('');
    }

    // Request body
    if (hasBody) {
      const body = this.generateExampleBody(endpoint.requestBody!.schema);
      code.push(`data = ${JSON.stringify(body, null, 4)}`);
      code.push('');
    }

    // Make request
    const requestArgs = [`'${url}'`];
    if (Object.keys(headers).length > 0) {
      requestArgs.push('headers=headers');
    }
    if (hasBody) {
      requestArgs.push('json=data');
    }

    code.push(`response = requests.${endpoint.method.toLowerCase()}(${requestArgs.join(', ')})`);
    code.push('response.raise_for_status()');
    code.push('');
    code.push('result = response.json()');
    code.push('print(result)');

    return code.join('\n');
  }

  /**
   * Generate step-by-step instructions
   */
  generateStepByStep(endpoint: LLMEndpoint): string[] {
    const steps: string[] = [];

    steps.push(`Send a ${endpoint.method} request to endpoint: ${endpoint.path}`);

    // Authentication
    if (endpoint.security.length > 0 && endpoint.security[0].type !== 'none') {
      steps.push(`Authentication: ${endpoint.security[0].instruction || 'Required'}`);
    }

    // Path parameters
    const pathParams = endpoint.parameters.filter((p) => p.in === 'path');
    if (pathParams.length > 0) {
      steps.push(
        'Replace path parameters: ' +
          pathParams.map((p) => `{${p.name}} with your ${p.description || p.name}`).join(', ')
      );
    }

    // Query parameters
    const queryParams = endpoint.parameters.filter((p) => p.in === 'query');
    if (queryParams.length > 0) {
      const required = queryParams.filter((p) => p.required);
      const optional = queryParams.filter((p) => !p.required);

      if (required.length > 0) {
        steps.push(
          'Required query parameters: ' +
            required.map((p) => `${p.name} (${p.schema.type})`).join(', ')
        );
      }
      if (optional.length > 0) {
        steps.push(
          'Optional query parameters: ' +
            optional.map((p) => `${p.name} (${p.schema.type})`).join(', ')
        );
      }
    }

    // Request body
    if (endpoint.requestBody) {
      const contentType = endpoint.requestBody.contentTypes[0] || 'application/json';
      steps.push(`Set Content-Type header to: ${contentType}`);
      steps.push(
        `Include request body with required fields: ${
          endpoint.requestBody.schema.required?.join(', ') || 'see schema'
        }`
      );
    }

    // Expected responses
    const successResponse = endpoint.responses.find(
      (r) => r.statusCode.startsWith('2') || r.statusCode === 'default'
    );
    if (successResponse) {
      steps.push(`Expected success response: ${successResponse.statusCode} - ${successResponse.description}`);
    }

    return steps;
  }

  /**
   * Build URL with parameters
   */
  private buildUrl(endpoint: LLMEndpoint, baseUrl: string, useExamples: boolean = false): string {
    let path = endpoint.path;

    // Replace path parameters
    const pathParams = endpoint.parameters.filter((p) => p.in === 'path');
    for (const param of pathParams) {
      const value = useExamples
        ? param.example || `{${param.name}}`
        : `{${param.name}}`;
      path = path.replace(`{${param.name}}`, String(value));
    }

    // Add query parameters
    const queryParams = endpoint.parameters.filter((p) => p.in === 'query');
    if (queryParams.length > 0 && useExamples) {
      const query = queryParams
        .map((p) => `${p.name}=${p.example || 'value'}`)
        .join('&');
      path += `?${query}`;
    } else if (queryParams.length > 0) {
      const query = queryParams
        .map((p) => `${p.name}={${p.name}}`)
        .join('&');
      path += `?${query}`;
    }

    return baseUrl.replace(/\/$/, '') + path;
  }

  /**
   * Get required headers
   */
  private getRequiredHeaders(endpoint: LLMEndpoint): Record<string, string> {
    const headers: Record<string, string> = {};

    if (endpoint.requestBody) {
      headers['Content-Type'] = endpoint.requestBody.contentTypes[0] || 'application/json';
    }

    // Add header parameters
    const headerParams = endpoint.parameters.filter((p) => p.in === 'header');
    for (const param of headerParams) {
      headers[param.name] = param.example || `{${param.name}}`;
    }

    return headers;
  }

  /**
   * Get authentication header
   */
  private getAuthHeader(endpoint: LLMEndpoint): { key: string; value: string } | null {
    if (endpoint.security.length === 0 || endpoint.security[0].type === 'none') {
      return null;
    }

    const sec = endpoint.security[0];

    if (sec.type === 'apiKey' && sec.in === 'header') {
      return { key: sec.name!, value: '{YOUR_API_KEY}' };
    }

    if (sec.type === 'http' && sec.scheme === 'bearer') {
      return { key: 'Authorization', value: 'Bearer {YOUR_TOKEN}' };
    }

    if (sec.type === 'http' && sec.scheme === 'basic') {
      return { key: 'Authorization', value: 'Basic {BASE64_CREDENTIALS}' };
    }

    return null;
  }

  /**
   * Generate example body from schema
   */
  private generateExampleBody(schema: LLMSchema, depth: number = 0): any {
    if (depth > 5) return null; // Prevent infinite recursion

    if (schema.example !== undefined) {
      return schema.example;
    }

    switch (schema.type) {
      case 'string':
        return schema.enum ? schema.enum[0] : schema.format === 'email' ? 'user@example.com' : 'string';
      case 'number':
      case 'integer':
        return schema.enum ? schema.enum[0] : 0;
      case 'boolean':
        return true;
      case 'array':
        return schema.items ? [this.generateExampleBody(schema.items, depth + 1)] : [];
      case 'object':
        if (!schema.properties) return {};
        const obj: any = {};
        for (const [key, propSchema] of Object.entries(schema.properties)) {
          if (schema.required?.includes(key) || Math.random() > 0.5) {
            obj[key] = this.generateExampleBody(propSchema, depth + 1);
          }
        }
        return obj;
      default:
        return null;
    }
  }
}

/**
 * Generate n8n workflow configurations
 */
export class N8nGenerator {
  /**
   * Generate n8n HTTP Request node configuration for an endpoint
   */
  generateHttpRequestNode(
    endpoint: LLMEndpoint,
    baseUrl: string,
    position: [number, number] = [250, 300]
  ): N8nWorkflowNode {
    const url = this.buildUrl(endpoint, baseUrl);

    const parameters: any = {
      method: endpoint.method,
      url: url,
      options: {},
      sendBody: !!endpoint.requestBody,
    };

    // Add authentication
    if (endpoint.security.length > 0 && endpoint.security[0].type !== 'none') {
      const sec = endpoint.security[0];
      if (sec.type === 'http' && sec.scheme === 'bearer') {
        parameters.authentication = 'genericCredentialType';
        parameters.genericAuthType = 'httpHeaderAuth';
      } else if (sec.type === 'apiKey') {
        parameters.authentication = 'genericCredentialType';
        parameters.genericAuthType = 'httpHeaderAuth';
      }
    }

    // Add headers
    const headers = endpoint.parameters.filter((p) => p.in === 'header');
    if (headers.length > 0) {
      parameters.options.headers = {
        entries: headers.map((h) => ({
          name: h.name,
          value: `={{$json["${h.name}"]}}`,
        })),
      };
    }

    // Add query parameters
    const queryParams = endpoint.parameters.filter((p) => p.in === 'query');
    if (queryParams.length > 0) {
      parameters.options.queryParameters = {
        entries: queryParams.map((q) => ({
          name: q.name,
          value: `={{$json["${q.name}"]}}`,
        })),
      };
    }

    // Add request body
    if (endpoint.requestBody) {
      parameters.bodyParametersUi = {
        parameter: Object.keys(endpoint.requestBody.schema.properties || {}).map((key) => ({
          name: key,
          value: `={{$json["${key}"]}}`,
        })),
      };
    }

    return {
      id: this.generateNodeId(),
      name: endpoint.summary || `${endpoint.method} ${endpoint.path}`,
      type: 'n8n-nodes-base.httpRequest',
      typeVersion: 4.2,
      position,
      parameters,
    };
  }

  /**
   * Generate complete n8n workflow for an API integration
   */
  generateWorkflow(
    workflowName: string,
    endpoints: LLMEndpoint[],
    baseUrl: string
  ): N8nWorkflowConfig {
    const nodes: N8nWorkflowNode[] = [];
    const connections: any = {};

    // Add manual trigger node
    const triggerId = this.generateNodeId();
    nodes.push({
      id: triggerId,
      name: 'Manual Trigger',
      type: 'n8n-nodes-base.manualTrigger',
      typeVersion: 1,
      position: [250, 150],
      parameters: {},
    });

    // Add HTTP request nodes for each endpoint
    let yPosition = 300;
    let previousNodeId = triggerId;

    for (const endpoint of endpoints) {
      const node = this.generateHttpRequestNode(endpoint, baseUrl, [250, yPosition]);
      nodes.push(node);

      // Connect to previous node
      connections[previousNodeId] = {
        main: [[{ node: node.name, type: 'main', index: 0 }]],
      };

      previousNodeId = node.id;
      yPosition += 150;
    }

    return {
      name: workflowName,
      nodes,
      connections,
      settings: {
        executionOrder: 'v1',
      },
    };
  }

  /**
   * Build URL for n8n (with expression syntax)
   */
  private buildUrl(endpoint: LLMEndpoint, baseUrl: string): string {
    let path = endpoint.path;

    // Replace path parameters with n8n expressions
    const pathParams = endpoint.parameters.filter((p) => p.in === 'path');
    for (const param of pathParams) {
      path = path.replace(`{${param.name}}`, `={{$json["${param.name}"]}}`);
    }

    return baseUrl.replace(/\/$/, '') + path;
  }

  /**
   * Generate unique node ID
   */
  private generateNodeId(): string {
    return `node_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
}
