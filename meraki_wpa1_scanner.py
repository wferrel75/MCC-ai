#!/usr/bin/env python3
"""
Meraki Wireless Security Scanner
Scans a Meraki network to identify clients by wireless security protocol (WPA1, WPA2, WPA3, or all).
"""

import requests
import json
import csv
import argparse
from datetime import datetime
from typing import List, Dict

class MerakiWirelessScanner:
    def __init__(self, api_key: str, network_id: str):
        self.api_key = api_key
        self.network_id = network_id
        self.base_url = "https://api.meraki.com/api/v1"
        self.headers = {
            'X-Cisco-Meraki-API-Key': api_key,
            'Content-Type': 'application/json'
        }

    def get_clients(self, timespan: int = 2592000) -> List[Dict]:
        """
        Retrieve all clients from the network.

        Args:
            timespan: Time in seconds to look back (default 30 days = 2592000)

        Returns:
            List of client dictionaries
        """
        url = f"{self.base_url}/networks/{self.network_id}/clients"
        params = {'timespan': timespan}

        try:
            print(f"Fetching clients from network {self.network_id}...")
            response = requests.get(url, headers=self.headers, params=params)
            response.raise_for_status()
            clients = response.json()
            print(f"Retrieved {len(clients)} total clients")
            return clients
        except requests.exceptions.RequestException as e:
            print(f"Error fetching clients: {e}")
            if hasattr(e, 'response') and e.response is not None:
                print(f"Response: {e.response.text}")
            return []

    def identify_clients(self, clients: List[Dict], filter_type: str = 'wpa1') -> List[Dict]:
        """
        Filter clients based on wireless security protocol.

        Args:
            clients: List of all clients
            filter_type: Type of filter ('wpa1', 'wpa2', 'wpa3', or 'all')

        Returns:
            List of filtered wireless clients
        """
        filtered_clients = []

        for client in clients:
            # Check if this is a wireless client
            if client.get('ssid') is None:
                continue

            # Check various fields that might contain security protocol info
            security = None

            # Primary location for security info
            if 'recentDeviceConnection' in client:
                recent_conn = client['recentDeviceConnection']
                # Check if it's a dictionary before calling .get()
                if isinstance(recent_conn, dict):
                    security = recent_conn.get('security', '')
                elif isinstance(recent_conn, str):
                    security = recent_conn

            # Alternative location
            if not security and 'security' in client:
                security = client.get('security', '')

            # Determine if client matches filter
            should_include = False

            if filter_type == 'all':
                # Include all wireless clients
                should_include = True
            elif security:
                security_upper = security.upper()

                if filter_type == 'wpa1':
                    # WPA1 patterns: "WPA-PSK", "WPA-TKIP", or just "WPA"
                    # But NOT "WPA2" or "WPA3"
                    should_include = (
                        ('WPA' in security_upper or 'TKIP' in security_upper) and
                        'WPA2' not in security_upper and
                        'WPA3' not in security_upper
                    )
                elif filter_type == 'wpa2':
                    # WPA2 patterns: "WPA2" but NOT "WPA3"
                    should_include = (
                        'WPA2' in security_upper and
                        'WPA3' not in security_upper
                    )
                elif filter_type == 'wpa3':
                    # WPA3 patterns
                    should_include = 'WPA3' in security_upper

            if should_include:
                filtered_clients.append({
                    'description': client.get('description', 'Unknown'),
                    'mac': client.get('mac', 'Unknown'),
                    'ip': client.get('ip', 'N/A'),
                    'ssid': client.get('ssid', 'N/A'),
                    'security': security if security else 'Unknown',
                    'manufacturer': client.get('manufacturer', 'Unknown'),
                    'os': client.get('os', 'Unknown'),
                    'lastSeen': client.get('lastSeen', 'Unknown'),
                    'status': client.get('status', 'Unknown')
                })

        return filtered_clients

    def print_results(self, clients: List[Dict], filter_type: str = 'wpa1'):
        """Print filtered clients in a readable format."""
        filter_display = {
            'wpa1': 'WPA1',
            'wpa2': 'WPA2',
            'wpa3': 'WPA3',
            'all': 'wireless'
        }

        filter_name = filter_display.get(filter_type, filter_type.upper())

        if not clients:
            if filter_type == 'all':
                print(f"\n✓ No wireless clients found!")
            else:
                print(f"\n✓ No {filter_name} clients found!")
            return

        print(f"\nFound {len(clients)} {filter_name} client(s):\n")
        print("-" * 100)

        for idx, client in enumerate(clients, 1):
            print(f"\nClient #{idx}:")
            print(f"  Description:  {client['description']}")
            print(f"  MAC Address:  {client['mac']}")
            print(f"  IP Address:   {client['ip']}")
            print(f"  SSID:         {client['ssid']}")
            print(f"  Security:     {client['security']}")
            print(f"  Manufacturer: {client['manufacturer']}")
            print(f"  OS:           {client['os']}")
            print(f"  Last Seen:    {client['lastSeen']}")
            print(f"  Status:       {client['status']}")

        print("\n" + "-" * 100)

    def export_to_csv(self, clients: List[Dict], filename: str = None, filter_type: str = 'wpa1'):
        """Export filtered clients to CSV file."""
        if not clients:
            print(f"No clients to export.")
            return

        if filename is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"{filter_type}_clients_{timestamp}.csv"

        try:
            with open(filename, 'w', newline='') as csvfile:
                fieldnames = ['description', 'mac', 'ip', 'ssid', 'security',
                            'manufacturer', 'os', 'lastSeen', 'status']
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

                writer.writeheader()
                for client in clients:
                    writer.writerow(client)

            print(f"\n✓ Results exported to: {filename}")
        except Exception as e:
            print(f"Error exporting to CSV: {e}")


def main():
    parser = argparse.ArgumentParser(
        description='Scan Meraki network for wireless clients by security protocol',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Find all WPA1 clients
  %(prog)s --api-key YOUR_KEY --network-id L_123456 --filter wpa1

  # Find all WPA2 clients
  %(prog)s --api-key YOUR_KEY --network-id L_123456 --filter wpa2

  # List all wireless devices
  %(prog)s --api-key YOUR_KEY --network-id L_123456 --filter all

  # Export WPA1 clients from last 7 days
  %(prog)s --api-key YOUR_KEY --network-id L_123456 --filter wpa1 --timespan 604800 --export wpa1_report.csv
        """
    )

    parser.add_argument('--api-key', required=True,
                       help='Meraki Dashboard API key')
    parser.add_argument('--network-id', required=True,
                       help='Meraki Network ID (e.g., L_123456789)')
    parser.add_argument('--filter', choices=['wpa1', 'wpa2', 'wpa3', 'all'], default='wpa1',
                       help='Filter by security protocol (default: wpa1)')
    parser.add_argument('--timespan', type=int, default=2592000,
                       help='Timespan in seconds to look back (default: 2592000 = 30 days)')
    parser.add_argument('--export', metavar='FILENAME',
                       help='Export results to CSV file')

    args = parser.parse_args()

    # Create scanner instance
    scanner = MerakiWirelessScanner(args.api_key, args.network_id)

    # Get all clients
    clients = scanner.get_clients(args.timespan)

    if not clients:
        print("No clients found or error occurred.")
        return

    # Filter clients based on security protocol
    filtered_clients = scanner.identify_clients(clients, args.filter)

    # Print results
    scanner.print_results(filtered_clients, args.filter)

    # Export if requested
    if args.export:
        scanner.export_to_csv(filtered_clients, args.export, args.filter)


if __name__ == "__main__":
    main()
