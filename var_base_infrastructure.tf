# Login details
variable "APIC_username" {
  default = ""
}

variable "APIC_password" {
  default = ""
}

variable "APIC_url" {
  default = ""
}


variable "nodes" {
  default = {
    "Leaf101" = {
      name   = "Leaf1001"
      serial = "12346666"
      role   = "leaf"
      nodeid = "101"
      podid  = 1
    },
    "Leaf102" = {
      name   = "Leaf1002"
      serial = "12345"
      role   = "leaf"
      nodeid = "102"
      podid  = 1
    },
    "Leaf103" = {
      name   = "Leaf1003"
      serial = "12346"
      role   = "leaf"
      nodeid = "103"
      podid  = 1
    },
    "Leaf104" = {
      name   = "Leaf1004"
      serial = "12347"
      role   = "leaf"
      nodeid = "104"
      podid  = 1
    },
    "Spine201" = {
      name   = "Spine111"
      serial = "12349"
      role   = "spine"
      nodeid = "201"
      podid  = 1
    },
    "Spine202" = {
      name   = "Spine112"
      serial = "123492"
      role   = "spine"
      nodeid = "202"
      podid  = 1
    },

  }
}

variable "bgp_as" {
  default = "65101"
}

variable "bgp_rr" {
  default = {
    "Spine201" = {
      nodeid = "201"
    },
    "Spine202" = {
      nodeid = "202"
    }
  }
}

variable "oob_mgmt" {
  default = {
    "Leaf101" = {
      ip_addr = "20.0.1.1/24"
      ip_gw   = "20.0.1.254"
      nodeid  = "101"
      podid   = 1
    },
    "Leaf102" = {
      ip_addr = "20.0.1.2/24"
      ip_gw   = "20.0.1.254"
      nodeid  = "102"
      podid   = 1
    },
    "Leaf103" = {
      ip_addr = "20.0.1.3/24"
      ip_gw   = "20.0.1.254"
      nodeid  = "103"
      podid   = 1
    },
    "Leaf104" = {
      ip_addr = "20.0.1.4/24"
      ip_gw   = "20.0.1.254"
      nodeid  = "104"
      podid   = 1
    },
    "Spine201" = {
      ip_addr = "20.0.1.5/24"
      ip_gw   = "20.0.1.254"
      nodeid  = "201"
      podid   = 1
    },
    "Spine202" = {
      ip_addr = "20.0.1.6/24"
      ip_gw   = "20.0.1.254"
      nodeid  = "202"
      podid   = 1
    },
  }
}

variable "ntp_srv" {
  default = {
    "10.0.0.1" = {
      ip        = "10.0.0.1"
      preferred = "true"
    },
    "10.0.0.2" = {
      ip        = "10.0.0.2"
      preferred = "true"
    },
  }
}
variable "dns_srv" {
  default = {
    "10.0.0.1" = {
      ip        = "10.0.0.1"
      preferred = "no"
    },
    "10.0.0.2" = {
      ip        = "10.0.0.2"
      preferred = "yes"
    },
  }
}
variable "search_domain" {
  default = "example.com"
}
