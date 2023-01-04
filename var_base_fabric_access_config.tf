
variable "policies_cdp" {
  default = {
    "CDP_ENA" = {
      name     = "CDP_Disable"
      admin_st = "disabled"
    },
    "CDP_DIS" = {
      name     = "CDP_Enable"
      admin_st = "enabled"
    },
  }
}
variable "policies_lldp" {
  default = {
    "LLDP_ENA" = {
      name        = "LLDP_Enable"
      admin_rx_st = "enabled"
      admin_tx_st = "enabled"
    },
    "LLDP_DIS" = {
      name        = "LLDP_Disable"
      admin_rx_st = "disabled"
      admin_tx_st = "disabled"
    }
  }
}
variable "policies_mcp" {
  default = {
    "MCP_DIS" = {
      name        = "MCP_Disable"
      admin_st    = "disabled"
    },
    "MCP_ENA" = {
      name        = "MCP_Enable"
      admin_st    = "enabled"
    },
  }
}
variable "policies_link_level" {
  default = {
    "1G_AUTO" = {
      name        = "1Gig_Auto"
      description = "1G Auto"
      auto_neg    = "on"
      speed       = "1G"
    },
    "10G_AUTO" = {
      name        = "10Gig-Auto"
      description = "10G Auto"
      auto_neg    = "on"
      speed       = "10G"
    },
    "AUTO_AUTO" = {
      name        = "Inherit-Auto"
      description = "Inherit Auto"
      auto_neg    = "on"
      speed       = "inherit"
    },
  }
}
variable "policies_lacp" {
  default = {
    "ACTIVE" = {
      name        = "LACP_Active"
      mode        = "active"
    },
    "MACPIN" = {
      name        = "LACP_MacPinL"
      mode        = "mac-pin"
    },
    "STATIC" = {
      name        = "LACP_Off"
      mode        = "off"
    },
  }
}

variable "vlan_pool" {
  default = {
    "EntProd_StaticVLPool" = {
      name       = "EntProd_StaticVLPool"
      alloc_mode = "static"
      from       = "vlan-100"
      to         = "vlan-299"
      role       = "external"
    },
    "EntProd_DynVLPool" = {
      name       = "EntProd_DynVLPool"
      alloc_mode = "dynamic"
      from       = "vlan-300"
      to         = "vlan-499"
      role       = "external"
    },
    "EntProd_L3oVLPool" = {
      name       = "EntProd_L3oVLPool"
      alloc_mode = "static"
      from       = "vlan-90"
      to         = "vlan-99"
      role       = "external"
    }
  }
}
##need
variable "admin_maintgroup" {
  default = {
    "even_leaf_sw_pod1" = {
      name   = "Pod1-Leaf-Even_UPG"
      fwtype = "switch"
    },
    "odd_leaf_sw_pod1" = {
      name   = "Pod1-Leaf-Odd_UPG"
      fwtype = "switch"
    },
    "even_spine_sw_pod1" = {
      name   = "Pod1-Spine-Even_UPG"
      fwtype = "switch"
    },
    "odd_spine_sw_pod1" = {
      name   = "Pod1-Spine-Odd_UPG"
      fwtype = "switch"
    },
  }
}

variable "policies_stp" {
  default = {
    "BPDU_filter" = {
      name = "BPDU_Filter_Enable"
      ctrl = "bpdu-filter"
    },
    "BPDU_filter_guard" = {
      name = "BPDU_Filter_Guard_Enable"
      ctrl = "bpdu-filter,bpdu-guard"
    },
    "BPDU_guard" = {
      name = "BPDU_Guard_Enable"
      ctrl = "bpdu-guard"
    },
  }
}

variable "lip" {
  default = {
    "lip101" = {
      name = "Leaf101_IntProf"
    },
    "lip102" = {
      name = "Leaf102_IntProf"
    },
    "lip103" = {
      name = "Leaf103_IntProf"
    },
    "lip104" = {
      name = "Leaf104_IntProf"
    },
    "lip101-102" = {
      name = "Leaf101_102_IntProf"
    },
    "lip103-104" = {
      name = "Leaf103_104_IntProf"
    },

  }
}
