# Cisco ACI fabric builder with Terraform
This Terraform script builds a Cisco ACI Fabricfrom from 0 to a ready to migrate state.
## Initial fabric configuration (base_infrastructure.tf)
 - Addinng Node members
 - OOB IP addressing
 - BGP route reflector config
 - NTP config
 - DNS config
 - system wide settings (ACI best practises)
## Fabric access policy configuration (fabric_access_policy.tf)
 - CDP policy
 - LLDP policy
 - MCP policy
 - LACP policy
 - STP policy
 - Link level policy
 - VPC protection groups
 - VLAN pools and range assignment
 - Physical Domain
 - Interface policy groups 
 - Leaf Interface profiles
 - ...
 ## Additional configuration
 - SYSlog, SNMP,backup, AAA, upgrade groups 
