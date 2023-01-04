#Leaf Interface profile
resource "aci_leaf_interface_profile" "lip" {
  for_each = var.lip
  name     = each.value.name
}

#leaf switch profile

#leaf switch selctor

#cdp policy
resource "aci_cdp_interface_policy" "default" {
  for_each = var.policies_cdp
  name     = each.value.name
  admin_st = each.value.admin_st
}


#LACP policy
resource "aci_lacp_policy" "default" {
  for_each    = var.policies_lacp
  name        = each.value.name
  mode        = each.value.mode
}

# LLDP plicy
resource "aci_lldp_interface_policy" "default" {
  for_each    = var.policies_lldp
  name        = each.value.name
  admin_rx_st = each.value.admin_rx_st
  admin_tx_st = each.value.admin_tx_st
}

#MCP policy
resource "aci_miscabling_protocol_interface_policy" "default" {
  for_each    = var.policies_mcp
  name        = each.value.name
  admin_st    = each.value.admin_st
}

#stp
resource "aci_rest" "stp-policies" {
  for_each   = var.policies_stp
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
  for_each    = var.policies_link_level
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
# physical domain (needs amending)
resource "aci_physical_domain" "PhyDom" {
  depends_on                = [aci_vlan_pool.default]
  name                      = "EntProd_PhysDom"
  relation_infra_rs_vlan_ns = "uni/infra/vlanns-[EntProd_StaticVLPool]-static"
}
#policy groups
