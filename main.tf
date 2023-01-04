terraform {
  required_providers {
    aci = {
      source = "ciscodevnet/aci"
    }
  }
}

#login
provider "aci" {
  username = var.APIC_username
  password = var.APIC_password
  url      = var.APIC_url
  insecure = true
}
