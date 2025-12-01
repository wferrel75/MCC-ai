#!/usr/bin/env python3
"""
Off-boarding Automation Script for MCC
Automates portions of the employee off-boarding process including:
- Access revocation checklist generation
- Ticket reassignment analysis
- Project task reporting
- Customer assignment identification
- Reassignment suggestions based on workload
"""

import argparse
import json
import os
import sys
from datetime import datetime
from typing import Dict, List, Optional
import requests


class OffboardingAutomation:
    """Main class for off-boarding automation tasks"""

    def __init__(self, config_file: str = "config.json"):
        """Initialize with configuration"""
        self.config = self._load_config(config_file)
        self.employee_data = {}

    def _load_config(self, config_file: str) -> Dict:
        """Load configuration from file"""
        if os.path.exists(config_file):
            with open(config_file, 'r') as f:
                return json.load(f)
        else:
            # Return default configuration template
            return {
                "zoho_desk": {
                    "api_url": "https://desk.zoho.com/api/v1",
                    "org_id": "",
                    "api_token": ""
                },
                "zoho_projects": {
                    "api_url": "https://projectsapi.zoho.com/api/v3",
                    "portal_id": "",
                    "api_token": ""
                },
                "microsoft_graph": {
                    "tenant_id": "",
                    "client_id": "",
                    "client_secret": ""
                },
                "datto_rmm": {
                    "api_url": "https://pinotage-api.centrastage.net",
                    "api_key": "",
                    "api_secret": ""
                }
            }

    def generate_access_checklist(self, employee_id: str, employee_name: str) -> str:
        """Generate comprehensive access revocation checklist"""

        checklist = f"""
# Access Revocation Checklist - {employee_name}
Employee ID: {employee_id}
Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

## Identity & Authentication
- [ ] Microsoft Entra ID - Disable account
- [ ] Microsoft Entra ID - Revoke app registrations
- [ ] Microsoft Entra ID - Remove from security groups
- [ ] Microsoft Entra ID - Revoke MFA methods
- [ ] Microsoft Entra ID - Remove from conditional access policies

## Microsoft 365
- [ ] Exchange Online - Set auto-reply
- [ ] Exchange Online - Configure forwarding (if approved)
- [ ] Exchange Online - Convert to shared mailbox
- [ ] SharePoint/OneDrive - Transfer file ownership
- [ ] SharePoint/OneDrive - Grant manager access
- [ ] Microsoft Teams - Transfer team ownership
- [ ] Microsoft Teams - Archive chat history

## Security Tools
- [ ] RocketCyber - Remove user account
- [ ] ConnectSecure - Remove user access
- [ ] ConnectSecure - Revoke API keys
- [ ] Keeper Security - Transfer vault ownership
- [ ] Keeper Security - Revoke account
- [ ] KnowBe4 - Remove from campaigns

## RMM & PSA
- [ ] Datto RMM - Revoke account
- [ ] Datto RMM - Transfer device ownership
- [ ] Zoho Desk - Reassign tickets
- [ ] Zoho Desk - Disable account
- [ ] Zoho Projects - Reassign tasks
- [ ] Zoho Projects - Transfer ownership

## Network & Infrastructure
- [ ] Cisco Meraki - Remove account
- [ ] Ubiquiti UniFi - Remove credentials
- [ ] Fortinet - Revoke VPN/admin access
- [ ] Azure Portal - Remove from subscriptions
- [ ] Azure Portal - Revoke RBAC roles
- [ ] AWS Console - Remove IAM user (if applicable)

## Backup & Documentation
- [ ] Acronis - Remove account
- [ ] OneNote - Transfer notebooks

## Client Access
- [ ] Customer VPNs - Audit and revoke
- [ ] Customer Admin Portals - Transfer
- [ ] Customer Cloud Tenants - Remove guest access

---
Completed by: ___________________
Date: ___________________
Verified by: ___________________
"""

        # Save to file
        filename = f"checklist_{employee_id}_{datetime.now().strftime('%Y%m%d')}.md"
        with open(filename, 'w') as f:
            f.write(checklist)

        print(f"✓ Access revocation checklist generated: {filename}")
        return filename

    def get_zoho_tickets(self, employee_email: str) -> List[Dict]:
        """Query Zoho Desk for tickets assigned to employee"""

        if not self.config['zoho_desk']['api_token']:
            print("⚠ Zoho Desk API not configured - using sample data")
            return self._get_sample_tickets(employee_email)

        try:
            headers = {
                'Authorization': f"Zoho-oauthtoken {self.config['zoho_desk']['api_token']}",
                'orgId': self.config['zoho_desk']['org_id']
            }

            # Query for open tickets assigned to employee
            params = {
                'assignee': employee_email,
                'status': 'Open',
                'limit': 100
            }

            response = requests.get(
                f"{self.config['zoho_desk']['api_url']}/tickets",
                headers=headers,
                params=params
            )

            if response.status_code == 200:
                return response.json().get('data', [])
            else:
                print(f"⚠ Zoho Desk API error: {response.status_code}")
                return self._get_sample_tickets(employee_email)

        except Exception as e:
            print(f"⚠ Error querying Zoho Desk: {e}")
            return self._get_sample_tickets(employee_email)

    def _get_sample_tickets(self, employee_email: str) -> List[Dict]:
        """Return sample ticket data for demonstration"""
        return [
            {
                'id': '12345',
                'subject': 'Network connectivity issues',
                'customer': 'Acme Corp',
                'priority': 'High',
                'status': 'Open',
                'created_date': '2025-11-20',
                'assignee': employee_email
            },
            {
                'id': '12346',
                'subject': 'Email migration assistance',
                'customer': 'Smith Industries',
                'priority': 'Medium',
                'status': 'In Progress',
                'created_date': '2025-11-22',
                'assignee': employee_email
            },
            {
                'id': '12347',
                'subject': 'Printer configuration',
                'customer': 'Johnson LLC',
                'priority': 'Low',
                'status': 'Open',
                'created_date': '2025-11-24',
                'assignee': employee_email
            }
        ]

    def get_zoho_projects(self, employee_email: str) -> List[Dict]:
        """Query Zoho Projects for tasks assigned to employee"""

        if not self.config['zoho_projects']['api_token']:
            print("⚠ Zoho Projects API not configured - using sample data")
            return self._get_sample_projects(employee_email)

        try:
            headers = {
                'Authorization': f"Zoho-oauthtoken {self.config['zoho_projects']['api_token']}"
            }

            portal_id = self.config['zoho_projects']['portal_id']

            # Query for active tasks
            response = requests.get(
                f"{self.config['zoho_projects']['api_url']}/portals/{portal_id}/tasks/",
                headers=headers,
                params={'assignee': employee_email, 'status': 'active'}
            )

            if response.status_code == 200:
                return response.json().get('tasks', [])
            else:
                print(f"⚠ Zoho Projects API error: {response.status_code}")
                return self._get_sample_projects(employee_email)

        except Exception as e:
            print(f"⚠ Error querying Zoho Projects: {e}")
            return self._get_sample_projects(employee_email)

    def _get_sample_projects(self, employee_email: str) -> List[Dict]:
        """Return sample project data for demonstration"""
        return [
            {
                'id': '9001',
                'name': 'Office 365 Migration - Acme Corp',
                'project': 'Acme Corp Migration',
                'status': 'In Progress',
                'priority': 'High',
                'due_date': '2025-12-15',
                'assignee': employee_email
            },
            {
                'id': '9002',
                'name': 'Network Security Assessment',
                'project': 'Smith Industries Security',
                'status': 'Planning',
                'priority': 'Medium',
                'due_date': '2025-12-30',
                'assignee': employee_email
            }
        ]

    def analyze_tickets(self, tickets: List[Dict]) -> Dict:
        """Analyze tickets and provide reassignment recommendations"""

        analysis = {
            'total': len(tickets),
            'by_priority': {'High': 0, 'Medium': 0, 'Low': 0},
            'by_customer': {},
            'critical_tickets': [],
            'recommendations': []
        }

        for ticket in tickets:
            priority = ticket.get('priority', 'Medium')
            customer = ticket.get('customer', 'Unknown')

            analysis['by_priority'][priority] = analysis['by_priority'].get(priority, 0) + 1
            analysis['by_customer'][customer] = analysis['by_customer'].get(customer, 0) + 1

            if priority == 'High':
                analysis['critical_tickets'].append(ticket)

        # Generate recommendations
        if analysis['by_priority']['High'] > 0:
            analysis['recommendations'].append(
                f"URGENT: {analysis['by_priority']['High']} high-priority tickets require immediate reassignment"
            )

        # Identify customers with multiple tickets
        for customer, count in analysis['by_customer'].items():
            if count >= 3:
                analysis['recommendations'].append(
                    f"Customer '{customer}' has {count} tickets - consider personal notification"
                )

        return analysis

    def get_customer_assignments(self, employee_email: str) -> List[Dict]:
        """Identify customers where employee is primary contact"""

        # This would integrate with your customer database/CRM
        # For now, return sample data
        print("⚠ Customer assignment tracking not yet integrated - using sample data")

        return [
            {
                'customer_name': 'Acme Corporation',
                'customer_id': 'CUST-001',
                'relationship_start': '2023-06-15',
                'tier': 'Premium',
                'active_tickets': 3,
                'active_projects': 1,
                'last_interaction': '2025-11-24',
                'technical_notes': 'Complex multi-site network, prefers email communication'
            },
            {
                'customer_name': 'Smith Industries',
                'customer_id': 'CUST-002',
                'relationship_start': '2024-01-10',
                'tier': 'Standard',
                'active_tickets': 1,
                'active_projects': 1,
                'last_interaction': '2025-11-23',
                'technical_notes': 'Manufacturing environment, prefers phone calls for urgent issues'
            },
            {
                'customer_name': 'Johnson LLC',
                'customer_id': 'CUST-003',
                'relationship_start': '2024-08-22',
                'tier': 'Standard',
                'active_tickets': 1,
                'active_projects': 0,
                'last_interaction': '2025-11-20',
                'technical_notes': 'Small office, basic IT needs'
            }
        ]

    def suggest_reassignment(self, workload_data: Dict) -> List[Dict]:
        """Suggest reassignment based on current team workload"""

        # This would integrate with actual team workload data
        # For now, provide template for manual input

        print("⚠ Team workload data not available - using sample suggestions")

        return [
            {
                'engineer': 'John Smith',
                'current_tickets': 12,
                'current_customers': 8,
                'specialties': ['Network', 'Security'],
                'recommendation': 'Good fit for Acme Corp (network expertise)'
            },
            {
                'engineer': 'Sarah Johnson',
                'current_tickets': 8,
                'current_customers': 6,
                'specialties': ['M365', 'Cloud'],
                'recommendation': 'Available capacity, cloud expertise'
            },
            {
                'engineer': 'Mike Wilson',
                'current_tickets': 15,
                'current_customers': 10,
                'specialties': ['General Support'],
                'recommendation': 'At capacity - avoid additional assignments'
            }
        ]

    def generate_customer_transition_doc(self, customer: Dict,
                                         departing_engineer: str,
                                         new_engineer: str) -> str:
        """Generate customer transition documentation"""

        doc = f"""
# Customer Transition Document

## Transition Details
- **Customer:** {customer.get('customer_name')}
- **Customer ID:** {customer.get('customer_id')}
- **Departing Engineer:** {departing_engineer}
- **New Primary Contact:** {new_engineer}
- **Transition Date:** {datetime.now().strftime('%Y-%m-%d')}
- **Relationship Duration:** Since {customer.get('relationship_start')}

## Customer Profile
- **Tier:** {customer.get('tier')}
- **Active Tickets:** {customer.get('active_tickets')}
- **Active Projects:** {customer.get('active_projects')}
- **Last Interaction:** {customer.get('last_interaction')}

## Technical Environment
{customer.get('technical_notes', 'No notes available')}

### Critical Systems
- [ ] Document primary systems and applications
- [ ] Document network topology
- [ ] Document backup/DR setup
- [ ] Document monitoring configuration

### Access Information
- [ ] VPN credentials (stored in Keeper)
- [ ] Admin portal URLs
- [ ] Emergency contact list
- [ ] Vendor relationships

## Communication Preferences
- [ ] Document preferred communication method
- [ ] Document escalation preferences
- [ ] Document meeting cadence
- [ ] Document reporting preferences

## Ongoing Initiatives
- [ ] Document active projects
- [ ] Document planned changes
- [ ] Document known issues
- [ ] Document upcoming renewals

## Relationship Context
### Customer Temperament
_To be filled in by departing engineer_

### Historical Issues & Resolutions
_To be filled in by departing engineer_

### Special Considerations
_To be filled in by departing engineer_

## Knowledge Transfer Checklist
- [ ] Technical environment review completed
- [ ] Access information verified
- [ ] Communication preferences documented
- [ ] Ongoing initiatives reviewed
- [ ] First shadowed interaction scheduled
- [ ] Customer introduction email sent

## Transition Timeline
1. **Week 1:** Knowledge transfer meeting
2. **Week 1:** Customer introduction email
3. **Week 2:** First shadowed interaction
4. **Week 3:** Independent management
5. **Week 4:** Transition review

---
*Prepared by: {departing_engineer}*
*Date: {datetime.now().strftime('%Y-%m-%d')}*
"""

        filename = f"customer_transition_{customer.get('customer_id')}_{datetime.now().strftime('%Y%m%d')}.md"
        with open(filename, 'w') as f:
            f.write(doc)

        print(f"✓ Customer transition document created: {filename}")
        return filename

    def generate_full_report(self, employee_id: str, employee_name: str,
                           employee_email: str, role: str = "helpdesk") -> str:
        """Generate comprehensive off-boarding report"""

        print(f"\n{'='*60}")
        print(f"GENERATING OFF-BOARDING REPORT")
        print(f"Employee: {employee_name} ({employee_id})")
        print(f"Role: {role}")
        print(f"{'='*60}\n")

        # Generate access checklist
        print("1. Generating access revocation checklist...")
        checklist_file = self.generate_access_checklist(employee_id, employee_name)

        # Get tickets
        print("\n2. Retrieving assigned tickets...")
        tickets = self.get_zoho_tickets(employee_email)
        ticket_analysis = self.analyze_tickets(tickets)

        print(f"   Found {ticket_analysis['total']} open tickets:")
        for priority, count in ticket_analysis['by_priority'].items():
            if count > 0:
                print(f"   - {priority} priority: {count}")

        # Get projects
        print("\n3. Retrieving project assignments...")
        projects = self.get_zoho_projects(employee_email)
        print(f"   Found {len(projects)} active project tasks")

        # Get customer assignments (for helpdesk role)
        customers = []
        if role == "helpdesk":
            print("\n4. Identifying customer primary contact assignments...")
            customers = self.get_customer_assignments(employee_email)
            print(f"   Found {len(customers)} customer assignments")
            for customer in customers:
                print(f"   - {customer['customer_name']} ({customer['tier']} tier)")

        # Generate recommendations
        print("\n5. Generating reassignment recommendations...")
        reassignment_suggestions = self.suggest_reassignment({})

        # Create comprehensive report
        report = f"""
# OFF-BOARDING REPORT: {employee_name}

Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
Employee ID: {employee_id}
Email: {employee_email}
Role: {role}

## Summary

- **Total Open Tickets:** {ticket_analysis['total']}
  - High Priority: {ticket_analysis['by_priority']['High']}
  - Medium Priority: {ticket_analysis['by_priority']['Medium']}
  - Low Priority: {ticket_analysis['by_priority']['Low']}

- **Active Project Tasks:** {len(projects)}

{"- **Customer Primary Contact Assignments:** " + str(len(customers)) if role == "helpdesk" else ""}

## IMMEDIATE ACTIONS REQUIRED

{chr(10).join(['- ' + rec for rec in ticket_analysis['recommendations']])}

## TICKET REASSIGNMENT

### Tickets by Customer
"""

        for customer, count in ticket_analysis['by_customer'].items():
            report += f"- **{customer}:** {count} ticket(s)\n"

        report += "\n### Critical Tickets Requiring Immediate Attention\n\n"

        for ticket in ticket_analysis['critical_tickets']:
            report += f"- #{ticket['id']}: {ticket['subject']} ({ticket['customer']})\n"

        if not ticket_analysis['critical_tickets']:
            report += "_None_\n"

        report += "\n### All Open Tickets\n\n"
        for ticket in tickets:
            report += f"- #{ticket['id']}: {ticket['subject']}\n"
            report += f"  - Customer: {ticket['customer']}\n"
            report += f"  - Priority: {ticket['priority']}\n"
            report += f"  - Status: {ticket['status']}\n"
            report += f"  - Created: {ticket['created_date']}\n\n"

        report += "## PROJECT ASSIGNMENTS\n\n"

        for project in projects:
            report += f"- **{project['name']}**\n"
            report += f"  - Project: {project['project']}\n"
            report += f"  - Priority: {project['priority']}\n"
            report += f"  - Due: {project['due_date']}\n"
            report += f"  - Status: {project['status']}\n\n"

        if role == "helpdesk" and customers:
            report += "## CUSTOMER PRIMARY CONTACT ASSIGNMENTS\n\n"

            for customer in customers:
                report += f"### {customer['customer_name']}\n"
                report += f"- **Customer ID:** {customer['customer_id']}\n"
                report += f"- **Tier:** {customer['tier']}\n"
                report += f"- **Relationship Start:** {customer['relationship_start']}\n"
                report += f"- **Active Tickets:** {customer['active_tickets']}\n"
                report += f"- **Active Projects:** {customer['active_projects']}\n"
                report += f"- **Last Interaction:** {customer['last_interaction']}\n"
                report += f"- **Notes:** {customer['technical_notes']}\n\n"

        report += "## REASSIGNMENT SUGGESTIONS\n\n"

        for suggestion in reassignment_suggestions:
            report += f"### {suggestion['engineer']}\n"
            report += f"- **Current Load:** {suggestion['current_tickets']} tickets, {suggestion['current_customers']} customers\n"
            report += f"- **Specialties:** {', '.join(suggestion['specialties'])}\n"
            report += f"- **Recommendation:** {suggestion['recommendation']}\n\n"

        report += f"""
## NEXT STEPS

1. **Immediate (within 24 hours):**
   - [ ] Review and approve reassignment plan
   - [ ] Execute access revocation checklist (see {checklist_file})
   - [ ] Reassign high-priority tickets
   - [ ] Notify affected customers

2. **Short-term (within 1 week):**
   - [ ] Complete all ticket reassignments
   - [ ] Complete all project task reassignments
   - [ ] Generate customer transition documents
   - [ ] Send customer introduction emails

3. **Medium-term (within 2-4 weeks):**
   - [ ] Complete knowledge transfer for all customers
   - [ ] Monitor transition success
   - [ ] Address any transition issues
   - [ ] Close off-boarding ticket

## FILES GENERATED

- Access Revocation Checklist: {checklist_file}
- Off-boarding Report: [this file]

---
*Generated by MCC Off-boarding Automation v1.0*
"""

        # Save report
        report_file = f"offboarding_report_{employee_id}_{datetime.now().strftime('%Y%m%d')}.md"
        with open(report_file, 'w') as f:
            f.write(report)

        print(f"\n{'='*60}")
        print(f"✓ REPORT COMPLETE")
        print(f"{'='*60}")
        print(f"\nFiles generated:")
        print(f"  - {report_file}")
        print(f"  - {checklist_file}")

        if role == "helpdesk" and customers:
            print(f"\nNext: Generate customer transition documents:")
            for customer in customers:
                print(f"  python offboarding_automation.py --customer-transition \"{customer['customer_name']}\" \"{employee_name}\" \"[new_engineer]\"")

        return report_file


def main():
    """Main entry point for CLI"""

    parser = argparse.ArgumentParser(
        description='MCC Employee Off-boarding Automation',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Generate full off-boarding report for helpdesk engineer
  python offboarding_automation.py --employee E12345 --name "John Doe" --email john.doe@midcloudcomputing.com --role helpdesk

  # Generate access revocation checklist only
  python offboarding_automation.py --generate-checklist E12345 --name "John Doe"

  # Generate customer transition document
  python offboarding_automation.py --customer-transition "Acme Corp" "John Doe" "Jane Smith"
        """
    )

    parser.add_argument('--employee', help='Employee ID')
    parser.add_argument('--name', help='Employee full name')
    parser.add_argument('--email', help='Employee email address')
    parser.add_argument('--role', default='helpdesk',
                       choices=['helpdesk', 'admin', 'manager'],
                       help='Employee role (default: helpdesk)')

    parser.add_argument('--generate-checklist', metavar='EMPLOYEE_ID',
                       help='Generate access revocation checklist only')

    parser.add_argument('--tickets', metavar='EMAIL',
                       help='Get ticket report for employee email')

    parser.add_argument('--projects', metavar='EMAIL',
                       help='Get project report for employee email')

    parser.add_argument('--customers', metavar='EMAIL',
                       help='Get customer assignment report')

    parser.add_argument('--customer-transition', nargs=3,
                       metavar=('CUSTOMER', 'DEPARTING', 'NEW'),
                       help='Generate customer transition document')

    parser.add_argument('--config', default='config.json',
                       help='Configuration file (default: config.json)')

    args = parser.parse_args()

    # Initialize automation
    automation = OffboardingAutomation(args.config)

    # Handle different command types
    if args.generate_checklist:
        name = args.name or input("Employee name: ")
        automation.generate_access_checklist(args.generate_checklist, name)

    elif args.tickets:
        tickets = automation.get_zoho_tickets(args.tickets)
        analysis = automation.analyze_tickets(tickets)
        print(json.dumps(analysis, indent=2))

    elif args.projects:
        projects = automation.get_zoho_projects(args.projects)
        print(json.dumps(projects, indent=2))

    elif args.customers:
        customers = automation.get_customer_assignments(args.customers)
        print(json.dumps(customers, indent=2))

    elif args.customer_transition:
        customer_name, departing, new = args.customer_transition
        customer_data = {'customer_name': customer_name, 'customer_id': 'MANUAL'}
        automation.generate_customer_transition_doc(customer_data, departing, new)

    elif args.employee and args.name and args.email:
        # Generate full report
        automation.generate_full_report(args.employee, args.name, args.email, args.role)

    else:
        parser.print_help()
        sys.exit(1)


if __name__ == '__main__':
    main()
