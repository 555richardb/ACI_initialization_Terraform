# Cisco ACI fabric builder with Terraform (work in progress)
This Terraform script builds a Cisco ACI Fabricfrom from 0 to a ready to migrate state. (no Tenant side configuration)
## Initial fabric configuration (base_infrastructure.tf) (done)
 - Addinng Node members
 - OOB IP addressing
 - BGP route reflector config
 - NTP config
 - DNS config
 - system wide settings (ACI best practises)
## Fabric access policy configuration (fabric_access_policy.tf) (done)
 - CDP policy
 - LLDP policy
 - MCP policy
 - LACP policy
 - STP policy
 - Storm Contol policy
 - Link level policy
 - VPC protection groups
 - VLAN pools and range assignment
 - Physical Domains
 - AAEP
 - Interface policy groups
 - Leaf Interface profiles
 - Switch profiles and selectors
 ## Additional configuration (WIP)
 - SYSlog, SNMP,backup, AAA, upgrade groups 

## Note
Some of the variables have dummy data as example
