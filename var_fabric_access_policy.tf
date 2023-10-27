
#VPC explicit protection group (switchXid must match nodeid)
variable "vpc_exp_prot_grp" {
  default = {
    "grp1" = {
      name      = "L101-L102"
      switch1id = "101"
      switch2id = "102"
      grp_id    = "101"
    },
    "grp2" = {
      name      = "L103-L104"
      switch1id = "103"
      switch2id = "104"
      grp_id    = "103"
    },
  }

}
variable "cdp_pol" {
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
variable "lldp_pol" {
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
variable "mcp_pol" {
  default = {
    "MCP_DIS" = {
      name     = "MCP_Disable"
      admin_st = "disabled"
    },
    "MCP_ENA" = {
      name     = "MCP_Enable"
      admin_st = "enabled"
    },
  }
}
# link level policies
variable "link_level_pol" {
  default = {
    "1G_AUTO" = {
      name        = "1Gig_Auto"
      description = "1G Auto"
      auto_neg    = "on"
      speed       = "1G"
    },
    "10G_AUTO" = {
      name        = "10Gig_Auto"
      description = "10G Auto"
      auto_neg    = "on"
      speed       = "10G"
    },
    "25G_AUTO" = {
      name        = "25Gig_Auto"
      description = "25G Auto"
      auto_neg    = "on"
      speed       = "25G"
    },
    "AUTO_AUTO" = {
      name        = "Inherit_Auto"
      description = "Auto Auto"
      auto_neg    = "on"
      speed       = "inherit"
    },
  }
}
# storm control policy
variable "storm_ctrl" {
  default = {
    "1G" = {
      name    = "1G_SCrtl"
      bcast   = "0.1"
      bcastb  = "0.2"
      mcast   = "40"
      mcastb  = "50"
      uucast  = "0.2"
      uucastb = "0.4"
    },
    "10G" = {
      name    = "10G_SCrtl"
      bcast   = "0.05"
      bcastb  = "0.1"
      mcast   = "40"
      mcastb  = "50"
      uucast  = "0.05"
      uucastb = "0.1"
    }
  }
}


variable "lacp_pol" {
  default = {
    "ACTIVE" = {
      name = "LACP_Active"
      mode = "active"
    },
    "MACPIN" = {
      name = "LACP_MacPin"
      mode = "mac-pin"
    },
    "STATIC" = {
      name = "LACP_Stastic"
      mode = "off"
    },
  }
}
# vlan pools and associated physical/l3/wmm domains
variable "vlan_pool" {
  default = {
    "StaticVLPool" = {
      name       = "EntProd_StaticVLPool"
      alloc_mode = "static"
      from       = "vlan-100"
      to         = "vlan-299"
      role       = "external"
      domainname = "EntProd_PhysDom"
    },
    "DynVLPool" = {
      name       = "EntProd_DynVLPool"
      alloc_mode = "dynamic"
      from       = "vlan-300"
      to         = "vlan-499"
      role       = "external"
      domainname = "EntProd_WMMDom"
    },
    "L3oVLPool" = {
      name       = "EntProd_L3oVLPool"
      alloc_mode = "static"
      from       = "vlan-90"
      to         = "vlan-99"
      role       = "external"
      domainname = "EntProd_L3oDom"
    }
  }
}

#aaep
variable "aaep" {
  default = {
    "EntProd_AAEP" = {
      name = "EntProd_AAEP"
      desc = "EntProd AAEP desc"
    },
    "EntDev_AAEP" = {
      name = "EntDev_AAEP"
      desc = "EntDev AAEP desc"
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

variable "stp_pol" {
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

variable "leaf_int_sw_profile" {
  default = {
    "lsp101" = {
      lprof_name    = "Leaf101_LeafProf"
      lsel_name     = "Leaf101"
      from          = "101"
      to            = "101"
      leaf_int_prof = "Leaf101_LeafProf"
    },
    "lsp102" = {
      lprof_name    = "Leaf102_LeafProf"
      lsel_name     = "Leaf102"
      from          = "102"
      to            = "102"
      leaf_int_prof = "Leaf102_LeafProf"
    },
    "lsp103" = {
      lprof_name    = "Leaf103_LeafProf"
      lsel_name     = "Leaf103"
      from          = "103"
      to            = "103"
      leaf_int_prof = "Leaf103_LeafProf"
    },
    "lsp104" = {
      lprof_name    = "Leaf104_LeafProf"
      lsel_name     = "Leaf104"
      from          = "104"
      to            = "104"
      leaf_int_prof = "Leaf104_LeafProf"
    },
    "lsp101-102" = {
      lprof_name    = "Leaf101_102_LeafProf"
      lsel_name     = "Leaf101-102"
      from          = "101"
      to            = "102"
      leaf_int_prof = "Leaf101_102_LeafProf"
    },
    "lsp103-104" = {
      lprof_name    = "Leaf103_104_LeafProf"
      lsel_name     = "Leaf103-104"
      from          = "103"
      to            = "104"
      leaf_int_prof = "Leaf103_104_LeafProf"
    },

  }

}

