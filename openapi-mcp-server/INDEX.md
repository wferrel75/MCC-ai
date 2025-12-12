# OpenAPI MCP Server - Documentation Index

Welcome! This index helps you navigate the comprehensive documentation for the OpenAPI MCP Server.

## Quick Navigation

### Getting Started (5-10 minutes)
1. [QUICKSTART.md](QUICKSTART.md) - Get running in 5 minutes
2. [README.md](README.md) - Overview and features
3. [examples/example-usage.md](examples/example-usage.md) - Common scenarios

### Installation
- [install.sh](install.sh) - Automated installation script
- [package.json](package.json) - Dependencies and scripts
- [QUICKSTART.md](QUICKSTART.md) - Manual installation steps

### Core Documentation
- [README.md](README.md) - Main documentation (~500 lines)
- [ARCHITECTURE.md](ARCHITECTURE.md) - System design (~800 lines)
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Complete project overview

### Configuration and Integration
- [CONFIGURATION.md](CONFIGURATION.md) - Advanced configuration (~500 lines)
- [N8N_INTEGRATION.md](N8N_INTEGRATION.md) - n8n workflow guide (~600 lines)

### Development
- [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) - Implementation patterns
- [ARCHITECTURE.md](ARCHITECTURE.md) - Technical architecture
- [src/types.ts](src/types.ts) - Type definitions

### Examples
- [examples/example-usage.md](examples/example-usage.md) - Detailed scenarios (~700 lines)
- [examples/sample-petstore-usage.sh](examples/sample-petstore-usage.sh) - Sample script

## By Use Case

### I want to...

#### Learn about the project
→ Start with [README.md](README.md) and [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)

#### Get it running quickly
→ Follow [QUICKSTART.md](QUICKSTART.md) or run [install.sh](install.sh)

#### Understand how it works
→ Read [ARCHITECTURE.md](ARCHITECTURE.md) and [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)

#### Create n8n workflows
→ See [N8N_INTEGRATION.md](N8N_INTEGRATION.md)

#### Configure advanced features
→ Check [CONFIGURATION.md](CONFIGURATION.md)

#### See examples
→ Browse [examples/example-usage.md](examples/example-usage.md)

#### Extend or customize
→ Read [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) and [ARCHITECTURE.md](ARCHITECTURE.md)

#### Troubleshoot issues
→ Check troubleshooting sections in [README.md](README.md) and [CONFIGURATION.md](CONFIGURATION.md)

## Documentation Structure

```
openapi-mcp-server/
├── INDEX.md (this file)                  ← Documentation index
├── README.md                             ← Start here
├── QUICKSTART.md                         ← 5-minute guide
├── PROJECT_SUMMARY.md                    ← Complete overview
├── ARCHITECTURE.md                       ← System design
├── CONFIGURATION.md                      ← Advanced config
├── N8N_INTEGRATION.md                    ← n8n workflows
├── IMPLEMENTATION_GUIDE.md               ← Dev patterns
├── install.sh                            ← Installation script
├── package.json                          ← Project config
├── tsconfig.json                         ← TypeScript config
├── .gitignore                            ← Git ignore rules
│
├── src/                                  ← Source code
│   ├── index.ts                          ← Entry point
│   ├── server.ts                         ← MCP server (680 lines)
│   ├── parser.ts                         ← OpenAPI parser (500 lines)
│   ├── generators.ts                     ← Code generators (450 lines)
│   └── types.ts                          ← Type definitions (300 lines)
│
├── examples/                             ← Usage examples
│   ├── example-usage.md                  ← Detailed scenarios (700 lines)
│   └── sample-petstore-usage.sh          ← Sample script
│
└── python-implementation/                ← Python version
    ├── README.md
    ├── requirements.txt
    └── src/
        └── types.py
```

## Documentation Statistics

| File | Lines | Purpose |
|------|-------|---------|
| README.md | ~500 | Overview, features, tools |
| QUICKSTART.md | ~300 | Quick start guide |
| ARCHITECTURE.md | ~800 | System design |
| CONFIGURATION.md | ~500 | Configuration guide |
| N8N_INTEGRATION.md | ~600 | n8n integration |
| IMPLEMENTATION_GUIDE.md | ~700 | Dev patterns |
| PROJECT_SUMMARY.md | ~400 | Project overview |
| examples/example-usage.md | ~700 | Usage scenarios |
| **Total Documentation** | **~4,500** | **Comprehensive** |

## Code Statistics

| File | Lines | Purpose |
|------|-------|---------|
| src/types.ts | ~300 | Type definitions |
| src/parser.ts | ~500 | OpenAPI parser |
| src/generators.ts | ~450 | Code generators |
| src/server.ts | ~680 | MCP server |
| src/index.ts | ~20 | Entry point |
| **Total Code** | **~1,950** | **Production-ready** |

## Learning Path

### Beginner Path
1. Read [QUICKSTART.md](QUICKSTART.md)
2. Run [install.sh](install.sh)
3. Try examples from [examples/example-usage.md](examples/example-usage.md)
4. Explore [README.md](README.md) for more features

### Intermediate Path
1. Complete Beginner Path
2. Read [N8N_INTEGRATION.md](N8N_INTEGRATION.md)
3. Study [CONFIGURATION.md](CONFIGURATION.md)
4. Build your first workflow integration

### Advanced Path
1. Complete Intermediate Path
2. Study [ARCHITECTURE.md](ARCHITECTURE.md)
3. Read [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md)
4. Review source code in `src/`
5. Extend with custom features

## Key Concepts

### What is MCP?
Model Context Protocol - A protocol for connecting LLMs with external tools and data sources.

### What is OpenAPI?
A specification for describing REST APIs. Also known as Swagger.

### What does this server do?
Bridges OpenAPI documentation with LLMs, making APIs easier to understand and use.

### Key Features
- Parse OpenAPI 2.0/3.x specifications
- Transform to LLM-friendly format
- Generate code in multiple languages
- Create n8n workflows
- Analyze API patterns

## Common Tasks

### Installation
```bash
./install.sh
# or
npm install && npm run build
```

### Configuration
Edit Claude Desktop config:
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`

### Usage Examples
```
"Load the Petstore API"
"Generate JavaScript code for GET /users"
"Create an n8n workflow"
"What authentication does this API use?"
```

### Extending
See [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) for:
- Custom code generators
- Custom tools
- Custom parsers

## Support

### Documentation
All `.md` files in this repository provide comprehensive documentation.

### Examples
See `examples/` directory for detailed usage scenarios.

### Troubleshooting
Check troubleshooting sections in:
- [README.md](README.md#troubleshooting)
- [CONFIGURATION.md](CONFIGURATION.md#troubleshooting)
- [QUICKSTART.md](QUICKSTART.md#troubleshooting)

### Issues
Report issues through appropriate channels (GitHub, etc.)

## Version Information

- **Current Version:** 1.0.0
- **Status:** Production-ready
- **Node.js Required:** 18+
- **TypeScript Version:** 5.3+
- **MCP SDK Version:** 1.0+

## License

MIT License - See LICENSE file for details

## Contributing

Contributions welcome! See:
- Code style in existing files
- Tests required for new features
- Documentation updates mandatory
- TypeScript strict mode enforced

## Credits

Built with:
- Model Context Protocol (MCP)
- OpenAPI/Swagger Parser
- TypeScript
- Node.js

---

## Quick Reference Card

### Most Important Files

| I need to... | Read this file |
|--------------|----------------|
| Get started quickly | [QUICKSTART.md](QUICKSTART.md) |
| Understand features | [README.md](README.md) |
| See examples | [examples/example-usage.md](examples/example-usage.md) |
| Create n8n workflows | [N8N_INTEGRATION.md](N8N_INTEGRATION.md) |
| Configure advanced features | [CONFIGURATION.md](CONFIGURATION.md) |
| Understand architecture | [ARCHITECTURE.md](ARCHITECTURE.md) |
| Learn implementation | [IMPLEMENTATION_GUIDE.md](IMPLEMENTATION_GUIDE.md) |
| Get project overview | [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) |

### Installation Commands

```bash
# Install
./install.sh

# Or manually
npm install
npm run build

# Run
node dist/index.js

# Test
npm test
```

### Configuration Location

**macOS:**
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

**Windows:**
```
%APPDATA%\Claude\claude_desktop_config.json
```

### Example Usage

```typescript
// Load API
"Load the Stripe API"

// Search
"Find endpoints for creating customers"

// Generate code
"Generate Python code for POST /customers"

// Create workflow
"Create an n8n workflow that syncs users"
```

---

Happy exploring! Start with [QUICKSTART.md](QUICKSTART.md) for the fastest path to success.
