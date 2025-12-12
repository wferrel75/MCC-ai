#!/bin/bash

# OpenAPI MCP Server Installation Script
# This script installs and configures the OpenAPI MCP Server

set -e  # Exit on error

echo "=================================="
echo "OpenAPI MCP Server Installation"
echo "=================================="
echo ""

# Check Node.js version
echo "Checking Node.js installation..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed"
    echo "Please install Node.js 18 or higher from https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version is too old (found: $(node -v), required: v18+)"
    echo "Please upgrade Node.js from https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js $(node -v) found"
echo ""

# Check npm
echo "Checking npm installation..."
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed"
    exit 1
fi
echo "✅ npm $(npm -v) found"
echo ""

# Install dependencies
echo "Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi
echo "✅ Dependencies installed"
echo ""

# Build project
echo "Building project..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Failed to build project"
    exit 1
fi
echo "✅ Project built successfully"
echo ""

# Get absolute path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SERVER_PATH="${SCRIPT_DIR}/dist/index.js"

echo "Installation complete!"
echo ""
echo "Server location: ${SERVER_PATH}"
echo ""
echo "=================================="
echo "Next Steps:"
echo "=================================="
echo ""
echo "1. Configure your MCP client (e.g., Claude Desktop)"
echo ""
echo "   For macOS, edit:"
echo "   ~/Library/Application Support/Claude/claude_desktop_config.json"
echo ""
echo "   For Windows, edit:"
echo "   %APPDATA%\\Claude\\claude_desktop_config.json"
echo ""
echo "2. Add this configuration:"
echo ""
echo '   {'
echo '     "mcpServers": {'
echo '       "openapi": {'
echo '         "command": "node",'
echo '         "args": ['
echo "           \"${SERVER_PATH}\""
echo '         ]'
echo '       }'
echo '     }'
echo '   }'
echo ""
echo "3. Restart Claude Desktop"
echo ""
echo "4. Try it out:"
echo '   "Load the Petstore API from https://petstore3.swagger.io/api/v3/openapi.json"'
echo ""
echo "For more information, see:"
echo "  - QUICKSTART.md"
echo "  - README.md"
echo "  - examples/example-usage.md"
echo ""
echo "Happy API exploring! 🚀"
