#cdp policy
resource "aci_cdp_interface_policy" "default" {
  for_each = var.cdp_pol
  name     = each.value.name
  admin_st = each.value.admin_st
}

#LACP policy
resource "aci_lacp_policy" "default" {
  for_each    = var.lacp_pol
  name        = each.value.name
  mode        = each.value.mode
}

# LLDP plicy
resource "aci_lldp_interface_policy" "default" {
  for_each    = var.lldp_pol
  name        = each.value.name
  admin_rx_st = each.value.admin_rx_st
  admin_tx_st = each.value.admin_tx_st
}

#MCP policy
resource "aci_miscabling_protocol_interface_policy" "default" {
  for_each    = var.mcp_pol
  name        = each.value.name
  admin_st    = each.value.admin_st
}
# Storm control


#stp
resource "aci_rest" "stp_pol" {
  for_each   = var.stp_pol
  path       = "/api/node/mo/uni/infra/ifPol-${each.value.name}.json"
  class_name = "stpIfPol"
  payload    = <<EOF
{
	"stpIfPol": {
		"attributes": {
			"dn": "uni/infra/ifPol-${each.value.name}",
			"name": "${each.value.name}",
			"ctrl": "${each.value.ctrl}",
		},
	}
}
	EOF
}
# link level policy
resource "aci_fabric_if_pol" "default" {
  for_each    = var.link_level_pol
  name        = each.value.name
  auto_neg    = each.value.auto_neg
  speed       = each.value.speed
}
# vlan pools
resource "aci_vlan_pool" "default" {
  for_each   = var.vlan_pool
  name       = each.value.name
  alloc_mode = each.value.alloc_mode
}
#vlan pool range
resource "aci_ranges" "default" {
  for_each     = var.vlan_pool
  depends_on   = [aci_vlan_pool.default]
  vlan_pool_dn = "uni/infra/vlanns-[${each.value.name}]-${each.value.alloc_mode}"
  from         = each.value.from
  to           = each.value.to
  alloc_mode   = each.value.alloc_mode
  role         = each.value.role
}
# physical domain 
resource "aci_physical_domain" "PhyDom" {
  depends_on                = [aci_vlan_pool.default]
  name                      = "${var.vlan_pool["StaticVLPool"].domainname}"
  relation_infra_rs_vlan_ns = "uni/infra/vlanns-[${var.vlan_pool["StaticVLPool"].domainname}]-static"
}
# l3 domain
resource "aci_l3_domain_profile" "L3oDom" {
  depends_on                = [aci_vlan_pool.default]
  name                      = "${var.vlan_pool["L3oVLPool"].domainname}"
  relation_infra_rs_vlan_ns = "uni/infra/vlanns-[${var.vlan_pool["L3oVLPool"].domainname}]-static"
}

#AAEP
resource "aci_attachable_access_entity_profile" "aaep" {
  for_each     = var.aaep
  name        = each.value.name
  description = each.value.desc
}
# domian to aaep
resource "aci_aaep_to_domain" "aaep_to_domain_l3" {
  depends_on 				= [aci_l3_domain_profile.L3oDom]
  attachable_access_entity_profile_dn = aci_attachable_access_entity_profile.aaep["EntProd_AAEP"].id
  domain_dn                           = aci_l3_domain_profile.L3oDom.id
}
resource "aci_aaep_to_domain" "aaep_to_domain_phy" {
  depends_on 				= [aci_physical_domain.PhyDom]
  attachable_access_entity_profile_dn = aci_attachable_access_entity_profile.aaep["EntProd_AAEP"].id
  domain_dn                           = aci_physical_domain.PhyDom.id
}

#vpc protection
resource "aci_vpc_explicit_protection_group" "vpc_prot_grp" {
  for_each = var.vpc_exp_prot_grp
  name                             = "${each.value.name}"
  switch1                          = "${each.value.switch1id}"
  switch2                          = "${each.value.switch2id}"
  vpc_domain_policy                = "default"
  vpc_explicit_protection_group_id = "${each.value.grp_id}"
}
#Leaf Interface profile
resource "aci_leaf_interface_profile" "lip" {
  for_each = var.leaf_int_sw_profile
  name     = each.value.lip
}

#leaf switch profile
resource "aci_leaf_profile" "leaf_profile" {
  for_each = var.leaf_int_sw_profile
  name        = "${each.value.lprof_name}"
  leaf_selector {
    name                    = "${each.value.lsel_name}"
    switch_association_type = "range"
    node_block {
      name  = "blk-${each.value.lsel_name}"
      from_ = "${each.value.from}"
      to_   = "${each.value.to}"
      
    }
      }
      relation_infra_rs_acc_port_p = ["uni/infra/accportprof-${each.value.lip}"]
}