# Python Implementation

This directory contains a Python implementation of the OpenAPI MCP Server. It provides the same functionality as the TypeScript version but in Python.

## Why Python?

- Easier to integrate with Python-based tools and scripts
- Rich ecosystem for API tooling (prance, openapi-spec-validator)
- Familiar to data scientists and ML engineers
- Simpler deployment in some environments

## Quick Start

```bash
cd python-implementation

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the server
python src/server.py
```

## Features

Same as TypeScript implementation:
- Parse OpenAPI 2.0/3.x specifications
- Transform to LLM-friendly format
- Generate code examples (JavaScript, Python, curl)
- Create n8n workflow configurations
- Analyze pagination patterns
- Handle authentication schemes

## Implementation Files

- `src/server.py` - MCP server implementation
- `src/parser.py` - OpenAPI parser
- `src/generators.py` - Code generators
- `src/types.py` - Type definitions (using dataclasses)
- `requirements.txt` - Python dependencies

## Dependencies

- `mcp` - MCP SDK for Python
- `prance` - OpenAPI spec parser
- `pydantic` - Data validation
- `PyYAML` - YAML support
- `requests` - HTTP client

## Usage

Same MCP protocol as TypeScript version. All tools work identically.

See main README.md for detailed usage instructions.
