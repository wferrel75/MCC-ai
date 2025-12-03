# Network Infrastructure Changes - Temporary Fix

## Summary
Implemented a temporary fix by taking the 2008 R2 domain controller and DNS server offline. Replaced it with a Windows 11 box running a Docker Desktop container with BIND to provide simple DNS relaying.

## Network Changes

### HP Switch Port Changes
- Disconnected the blue network cable from **port 23** on the HP Procurve switch (originally noted as port 24, corrected to port 23)
- Connected a white ethernet cable into port 23 on the HP switch (the server's original connection) for the temporary dns device
- Connected the Windows 11 replacement box to port 23

### Hardware Setup
- **Temporary DNS Server**: Ace Magician mini PC
  - Location: Sitting on the rack underneath the Great Plains Ubiquiti switch
  - Running: Docker Desktop container with BIND for DNS relaying

### Removed Equipment
- 
- Removed an older HP switch from the floor next to the servers (bottom of the middle shelf)
- Removed an older ethernet router device that was no longer in use
  - Note: Both these devices were powered on but had no active connections

## Current Issues
All devices that are unable to connect to anything are currently being locked out by SentinelOne, which is isolating the devices due to our attempted deployment of the Datto RMM agent.
