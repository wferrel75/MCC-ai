#!/bin/bash

# Test script for OpenAPI MCP Server
# This script verifies the server starts correctly

echo "Testing OpenAPI MCP Server..."
echo "=============================="
echo ""

# Test 1: Check if server starts
echo "Test 1: Checking if server starts..."
OUTPUT=$(timeout 2 node dist/index.js 2>&1)
EXIT_CODE=$?
if [ $EXIT_CODE -eq 124 ] && echo "$OUTPUT" | grep -q "OpenAPI MCP Server running"; then
    echo "✅ Server starts successfully"
elif echo "$OUTPUT" | grep -q "OpenAPI MCP Server running"; then
    echo "✅ Server starts successfully"
else
    echo "❌ Server failed to start"
    echo "Error output: $OUTPUT"
    exit 1
fi

# Test 2: Check if all required files exist
echo ""
echo "Test 2: Checking built files..."
REQUIRED_FILES=(
    "dist/index.js"
    "dist/server.js"
    "dist/parser.js"
    "dist/generators.js"
    "dist/types.js"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file missing"
        exit 1
    fi
done

# Test 3: Check if package.json is valid
echo ""
echo "Test 3: Checking package.json..."
if node -e "require('./package.json')" 2>/dev/null; then
    echo "✅ package.json is valid"
else
    echo "❌ package.json is invalid"
    exit 1
fi

echo ""
echo "=============================="
echo "All tests passed! ✅"
echo ""
echo "Server is ready to use."
echo ""
echo "To configure in Claude Desktop, add to claude_desktop_config.json:"
echo ""
echo '{
  "mcpServers": {
    "openapi": {
      "command": "node",
      "args": ["'$(pwd)'/dist/index.js"]
    }
  }
}'
echo ""
