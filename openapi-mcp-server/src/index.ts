#!/usr/bin/env node
/**
 * OpenAPI MCP Server Entry Point
 */

import { OpenAPIMCPServer } from './server.js';

async function main() {
  const server = new OpenAPIMCPServer();
  await server.start();
}

main().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
