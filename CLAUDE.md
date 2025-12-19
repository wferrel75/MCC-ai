# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **Midwest Cloud Computing (MCC) MSP Operations & Automation Repository** - a central hub for customer management, automation workflows, integration tooling, and operational documentation. The repository follows a modular, purpose-driven structure with 25+ primary directories organized by function, customer, and tool type.

**Core Purpose:** MSP operations automation, customer lifecycle management, and multi-platform integration orchestration.

## Repository Structure

### Customer Management
- **`Customer_Profiles/`** - Individual customer profile documents (18+ customers)
  - Infrastructure details, contacts, tech stacks, service agreements
  - Subdirectories for detailed customer data (e.g., `Crowell/` with floor plans, server configs)
- **`customer_onboarding/`** - New customer onboarding templates and MSP transition checklists
  - 10-step onboarding process with Datto/Zoho/M365 integration
  - GPO deployment guides for service checks
- **`sme/`** - Subject Matter Expert to customer assignments

### Automation & Scripts
- **`powershell/`** - PowerShell automation organized into 13 subdirectories:
  - `AD-Computer-Connectivity/` - Active Directory connectivity testing
  - `Domain-Admin-Account/` - MSP admin account provisioning (Datto integrated)
  - `Server-Configuration/` - Server inventory scripts with JSON/Markdown export
  - `DattoRMM/` - BGInfo deployment and refresh automation
  - `DattoRMM-API/` - RMM API integration setup
  - `Netbird-Deployment/` - VPN client silent installation
  - `RustDesk-Deployment/` - Remote desktop automation
  - `Splunk-Installer/` - Splunk forwarder deployment
  - `BGInfo-Configuration/` - BGInfo config generators
  - `Integration-Guides/` - n8n, webhook, and Datto integration docs
- **`n8n-workflows/`** - n8n workflow configurations and API specs
  - `Connect_Secure/swagger.yaml` - 32K+ line OpenAPI 3.0 spec (226 endpoints)
  - Workflow templates for various integrations
- **`openapi-mcp-server/`** - Production-ready TypeScript MCP server (~2,000 lines)
  - Parses OpenAPI/Swagger 2.0 and 3.x specifications
  - Generates LLM-friendly API documentation
  - Creates code samples (JavaScript, Python, curl)
  - Builds n8n workflow configurations
  - See `PROJECT_SUMMARY.md` and `QUICKSTART.md` for details

### Employee & Operations Management
- **`employee_management/`** - Employee lifecycle automation
  - `offboarding_automation.py` (25K+ lines) - Python automation for access revocation
  - Zoho Desk/Projects integration templates
  - Handles ticket reassignment and customer transition planning
- **`team/`** - Team member YAML profiles

### Project-Specific Directories
- **`Helget_Gas_Server_Upgrades/`** - Customer-specific upgrade project
- **`berry_network_update/`** - Network redesign project
- **`barracuda_management/`** - Email security integration
- **`lowcost_mini_pcs/`** - Hardware evaluation and deployment
- **`MX_Record_Monitor/`** - Email infrastructure monitoring

### Utilities & Tools
- **`git-sync.sh`** - Automated git workflow (stage, commit, push with auto-generated messages)
- **`backup-cli-configs.sh`** / **`restore-cli-configs.sh`** - Claude/Gemini CLI config backup/restore
- **`meraki_wpa1_scanner.py`** - Meraki API script to scan wireless clients by security protocol

## Key Technologies & Integrations

### MSP Service Stack
- **Datto RMM** - Remote monitoring & management (REST API)
- **Zoho Desk** - Ticketing system (REST API)
- **Zoho Projects** - Project management (REST API)
- **Connect Secure (CyberCNS)** - Vulnerability & compliance (OpenAPI 3.0, 226 endpoints)
- **RocketCyber/Kaseya MDR** - 24/7 SOC and managed detection/response
- **Barracuda Email Security** - Email filtering tenant management
- **Keeper Security** - Credential management
- **Netbird** - Open-source VPN
- **RustDesk** - Remote desktop access
- **Splunk** - Security monitoring and log aggregation

### Cloud & Microsoft Stack
- **Microsoft 365 (M365)** - Email, Teams, Azure AD
- **Microsoft Graph API** - M365/Azure AD integration
- **Active Directory** - On-premises directory services
- **Azure** - Cloud infrastructure (referenced in transition docs)

### Automation Platforms
- **n8n** - Primary workflow automation platform (self-hosted)
  - Webhook-based event triggers
  - Multi-service integrations
  - Custom workflow templates
- **Model Context Protocol (MCP)** - AI/LLM integration layer
  - OpenAPI MCP Server for API analysis
  - n8n MCP Server for workflow management

### Network & Security
- **Cisco Meraki** - Network management (Dashboard API)
- **Barracuda CloudGen Firewall** - Network security

## Common Workflows

### Git Operations
```bash
# Daily sync with auto-generated commit message
./git-sync.sh

# Custom commit message
./git-sync.sh "Your custom message"

# Dry run (preview changes)
./git-sync.sh -d

# Available via slash command
/git-sync [commit message]
```

### Configuration Management
```bash
# Backup Claude & Gemini CLI configs
./backup-cli-configs.sh

# Restore configurations
./restore-cli-configs.sh
```

### Customer Onboarding (10 Steps)
1. Customer data entry in Zoho
2. Datto RMM tenant/site group setup
3. AV/EDR deployment
4. Email filtering configuration
5. Credentials in Keeper
6. Connect Secure tenant setup
7. M365 permissions configuration
8. Ticketing system setup
9. Documentation in customer profiles
10. RocketCyber deployment

### MSP Transition (18 Sections)
See `customer_onboarding/MSP_Transition_Checklist.md` for comprehensive 550+ line transition guide covering infrastructure, credentials, security, compliance, and knowledge transfer.

### PowerShell Development
- Scripts use PowerShell 5.1+ syntax
- Datto RMM integration patterns in `powershell/DattoRMM-API/`
- Component testing templates in `Domain-Admin-Account/Test-NewDomainAdminComponent.ps1`
- Deployment guides paired with each script (e.g., `DEPLOYMENT-GUIDE.md`, `REFRESH-GUIDE.md`)

### n8n Workflow Development
- OpenAPI spec in `n8n-workflows/Connect_Secure/swagger.yaml`
- Integration guides in `powershell/Integration-Guides/`
- Webhook setup: `n8n-webhook-setup-guide.md`
- DattoRMM integration: `DattoRMM-n8n-QuickStart.md`

**IMPORTANT: n8n Data Table Pattern**
- **Always create a CSV setup file** when workflows need data tables
- Naming: `{TableName}_table_setup.csv`
- Include 2-3 sample rows with all data types represented
- See `n8n-workflows/TABLE_SETUP_PATTERN.md` for complete guidelines
- Benefits: Faster setup, version controlled schema, clear documentation

### MCP Server Usage
```bash
# OpenAPI MCP Server
cd openapi-mcp-server
npm install
npm start

# Tools available:
# - load_openapi_spec
# - search_endpoints
# - get_endpoint_details
# - generate_request_code
# - generate_n8n_node
# - analyze_pagination
```

## Documentation Standards

### File Naming
- Customer profiles: `CustomerName_profile.md`
- Scripts: `Verb-Noun.ps1` (PowerShell), `verb_noun.sh` (Bash), `verb_noun.py` (Python)
- Guides: `TOPIC-GUIDE.md` or `README.md`

### Documentation Patterns
- **CLAUDE.md** - Directory-specific AI/LLM guidance (present in 6+ directories)
- **README.md** - Overview and usage documentation
- **QUICKSTART.md** - Getting started tutorials
- **ARCHITECTURE.md** - System design documentation
- **DEPLOYMENT-GUIDE.md** - Step-by-step deployment instructions
- **TROUBLESHOOTING.md** - Common issues and solutions

### Code Comments
- PowerShell: Inline `#` comments and `<# ... #>` block comments
- Python: Docstrings and inline `#` comments
- Bash: Inline `#` comments with usage headers
- TypeScript: JSDoc-style comments

## API Integration Patterns

### Authentication Methods
- **Bearer Token** - Datto RMM, Connect Secure
- **OAuth 2.0** - Microsoft Graph, Zoho APIs
- **API Key** - Meraki Dashboard, n8n webhooks
- **Base64 Credentials** - Custom auth schemes

### Common API Operations
```powershell
# Datto RMM API pattern
$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Content-Type" = "application/json"
}
Invoke-RestMethod -Uri $endpoint -Headers $headers -Method GET
```

```python
# Meraki API pattern
headers = {
    "X-Cisco-Meraki-API-Key": api_key,
    "Content-Type": "application/json"
}
response = requests.get(url, headers=headers)
```

### n8n Webhook Integration
- Base URL: `https://n8n.midcloudcomputing.com/webhook/`
- Authentication: Bearer token in headers
- Payload format: JSON
- See `powershell/Integration-Guides/n8n-webhook-setup-guide.md`

## Security Considerations

### Credential Management
- **DO NOT** commit API keys, tokens, or passwords
- Use environment variables or secure credential stores
- Keeper Security for centralized credential management
- `.gitignore` sensitive configuration files

### Access Control
- Domain admin accounts created via `powershell/Domain-Admin-Account/New-DomainAdminAccount.ps1`
- Security checklist: `New-DomainAdminAccount-SecurityChecklist.md`
- Employee offboarding includes access revocation automation

### Compliance & Security Tools
- Connect Secure for vulnerability scanning
- RocketCyber/Kaseya for EDR/MDR
- Splunk for security monitoring
- Barracuda for email security

## Common Development Tasks

### Adding a New Customer Profile
1. Copy `Customer_Profiles/Template_Customer-profile.md`
2. Fill in customer details (infrastructure, contacts, services)
3. Create subdirectory if needed (e.g., `CustomerName/`)
4. Update `sme/customer_smes.md` with SME assignment

### Creating a New PowerShell Script
1. Place in appropriate subdirectory under `powershell/`
2. Follow naming convention: `Verb-Noun.ps1`
3. Include comment-based help at top of script
4. Add README.md or integration guide
5. Include Datto RMM integration patterns if applicable

### Adding an n8n Workflow
1. Export workflow as JSON from n8n
2. Place in `n8n-workflows/` (create subdirectory if needed)
3. Document credentials required
4. Add quick start guide if complex

### Working with OpenAPI Specs
1. Place spec in appropriate directory (e.g., `n8n-workflows/ServiceName/`)
2. Use `openapi-mcp-server` to analyze and generate code
3. Generate n8n nodes for workflow integration
4. Document authentication requirements

## Project-Specific Notes

### openapi-mcp-server
- TypeScript project (Node.js 18+)
- Dependencies: `swagger-parser`, `zod`, `yaml`
- Build: `npm run build`
- Test: `npm test`
- Documentation: See `PROJECT_SUMMARY.md`, `QUICKSTART.md`, `ARCHITECTURE.md`

### employee_management
- Python 3 project
- Dependencies in `requirements.txt`
- Run: `python offboarding_automation.py`
- Zoho API integration for ticket and project queries

### Customer Projects
- **Helget_Gas_Server_Upgrades** - Server upgrade planning with MCC and customer profiles
- **berry_network_update** - Network redesign with Azure, Meraki options
- **barracuda_management** - Email security and firewall configuration

## Tips for Effective Development

### When Working with Customer Data
- Always reference existing customer profiles before creating new ones
- Follow established naming conventions
- Include infrastructure diagrams where applicable (DrawIO files)
- Document service agreements and SLAs

### When Writing Automation Scripts
- Test in development/lab environment first
- Include error handling and logging
- Document prerequisites and dependencies
- Provide examples in documentation
- Consider Datto RMM integration for deployment

### When Integrating APIs
- Check for existing OpenAPI specs first
- Use MCP server for API exploration
- Generate code samples for documentation
- Test authentication flows before deployment
- Document rate limits and error responses

### When Updating Documentation
- Keep CLAUDE.md files synchronized with directory changes
- Update README.md files when adding new scripts
- Include quick start guides for complex processes
- Add troubleshooting sections based on common issues

## Repository Maintenance

### Regular Tasks
- Run `./git-sync.sh` daily to commit and push changes
- Review and update customer profiles quarterly
- Audit API integrations for deprecated endpoints
- Update documentation when processes change
- Backup configurations with `./backup-cli-configs.sh`

### Key Files to Protect
- `.claude.json` - Claude Code global configuration
- `.claude/settings.local.json` - Project-specific settings
- `customer_onboarding/MCC_Profile.md` - Company reference
- API credentials and tokens (NEVER commit)

## Additional Resources

### Internal Documentation
- `powershell/README.md` - PowerShell directory overview (230+ lines)
- `GIT-SYNC-QUICK-REF.md` - Quick reference for git sync
- `CLI-CONFIG-TRANSFER-GUIDE.md` - CLI configuration backup/restore guide
- `customer_onboarding/MSP_Transition_Checklist.md` - Comprehensive transition guide

### External Links
- Datto RMM API: Check internal documentation
- Zoho API: https://www.zoho.com/desk/developer-guide/
- Connect Secure API: See `n8n-workflows/Connect_Secure/swagger.yaml`
- Microsoft Graph: https://learn.microsoft.com/en-us/graph/
- Meraki API: https://developer.cisco.com/meraki/

## Claude Code Configuration

### Slash Commands
- `/git-sync [message]` - Automated git commit and push workflow

### MCP Servers
- **n8n-mcp** - n8n workflow management (configured in some projects)
- **openapi-mcp** - OpenAPI specification analysis (standalone project)

### Permission Settings
- Project-specific settings in `.claude/settings.local.json`
- Global settings in `.claude.json`
- Tool permissions managed per directory
