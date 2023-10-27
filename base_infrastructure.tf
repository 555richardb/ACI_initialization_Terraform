#this tf file covers the fabric initial configuration (like in the QuickStart)
#including:
# - adding node
# - bgp AS and RR
# - OOB IP
# - NTP
# - DNS
# - Faric best practises

#adding nodes to fabric
resource "aci_fabric_node_member" "nodes" {
  for_each    = var.nodes
  name        = each.value.name
  serial      = each.value.serial
  annotation  = "orchestrator:terraform"
  description = ""
  ext_pool_id = "0"
  fabric_id   = "1"
  name_alias  = ""
  node_id     = each.value.nodeid
  node_type   = "unspecified"
  pod_id      = each.value.podid
  role        = each.value.role
}
#assigning oob IPs
resource "aci_rest" "oob_mgmt" {
  for_each   = var.oob_mgmt
  path       = "/api/node/mo/uni/tn-mgmt.json"
  class_name = "mgmtRsOoBStNode"
  payload    = <<EOF
{
    "mgmtRsOoBStNode": {
        "attributes": {
            "dn": "uni/tn-mgmt/mgmtp-default/oob-default/rsooBStNode-[topology/pod-${each.value.podid}/node-${each.value.nodeid}]",
            "addr": "${each.value.ip_addr}",
            "gw": "${each.value.ip_gw}",
            "tDn": "topology/pod-${each.value.podid}/node-${each.value.nodeid}",
            "v6Addr": "::",
            "v6Gw": "::"
        }
    }
}
	EOF
}
# set oob as the default connectivty method
resource "aci_rest" "default-oob" {
  path       = "/api/node/mo/uni/fabric/connectivityPrefs.json"
  class_name = "mgmtConnectivityPrefs"
  payload    = <<EOF
{
	"mgmtConnectivityPrefs": {
		"attributes": {
			"dn": "uni/fabric/connectivityPrefs",
			"interfacePref": "ooband"
		},
		"children": []
	}
}
	EOF
}
# set BGP AS
resource "aci_rest" "bgp_as" {
  path       = "/api/node/mo/uni/fabric/bgpInstP-default/as.json"
  class_name = "bgpAsP"
  payload    = <<EOF
{
    "bgpAsP": {
        "attributes": {
            "dn": "uni/fabric/bgpInstP-default/as",
            "asn": "${var.bgp_as}",
            "rn": "as"
        },
        "children": []
    }
}
	EOF
}
# assigning route reflectors to fabric
resource "aci_rest" "bgp_rr" {
  for_each   = var.bgp_rr
  path       = "/api/node/mo/uni/fabric/bgpInstP-default/rr/node-${each.value.nodeid}.json"
  class_name = "bgpRRNodePEp"
  payload    = <<EOF
{
    "bgpRRNodePEp": {
        "attributes": {
            "dn": "uni/fabric/bgpInstP-default/rr/node-${each.value.nodeid}",
            "id": "${each.value.nodeid}",
            "rn": "node-${each.value.nodeid}"
        },
        "children": []
    }
}
	EOF
}

#ntp server
resource "aci_rest" "ntp_srv" {
  for_each   = var.ntp_srv
  path       = "/api/node/mo/uni/fabric/time-default/ntpprov-${each.value.ip}.json"
  class_name = "datetimeNtpProv"
  payload    = <<EOF
{
    "datetimeNtpProv": {
        "attributes": {
            "dn": "uni/fabric/time-default/ntpprov-${each.value.ip}",
            "name": "${each.value.ip}",
            "preferred": "${each.value.preferred}",
            "rn": "ntpprov-${each.value.ip}"
        },
        "children": [
            {
                "datetimeRsNtpProvToEpg": {
                    "attributes": {
                        "tDn": "uni/tn-mgmt/mgmtp-default/oob-default"
                    }
                }
            }
        ]
    }
}
	EOF
}


#dns server
resource "aci_rest" "dns_srv" {
  for_each   = var.dns_srv
  path       = "/api/node/mo/uni/fabric/dnsp-default/prov-[${each.value.ip}].json"
  class_name = "dnsProv"
  payload    = <<EOF
{
    "dnsProv": {
        "attributes": {
            "dn": "uni/fabric/dnsp-default/prov-[${each.value.ip}]",
            "addr": "${each.value.ip}",
            "preferred": "${each.value.preferred}",
            "rn": "prov-[${each.value.ip}]"
        },
        "children": []
    }
}
	EOF
}
# search domain
resource "aci_rest" "set_search_domain" {
  path       = "/api/node/mo/uni/fabric/dnsp-default/dom-${var.search_domain}.json"
  class_name = "dnsDomain"
  payload    = <<EOF
{
    "dnsDomain": {
        "attributes": {
            "dn": "uni/fabric/dnsp-default/dom-${var.search_domain}",
            "name": "${var.search_domain}",
            "isDefault": "no",
            "rn": "dom-${var.search_domain}"
        },
        "children": []
    }
}
	EOF
}

resource "aci_coop_policy" "coop_pol" {
  annotation = "orchestrator:terraform"
  type       = "strict"
}
resource "aci_endpoint_ip_aging_profile" "ep_ip_aging" {
  annotation = "orchestrator:terraform"
  admin_st   = "enabled"
}
resource "aci_fabric_node_control" "fabric_node_ctrl" {
  name        = "default"
  annotation  = "orchestrator:terraform"
  control     = "Dom"
  feature_sel = "telemetry"
  #values are "analytics", "netflow" and "telemetry".

}
resource "aci_endpoint_controls" "ep_ctrl" {
  annotation            = "orchestrator:terraform"
  hold_intvl            = "1800"
  rogue_ep_detect_intvl = "60"
  rogue_ep_detect_mult  = "4"

}
resource "aci_port_tracking" "port_track" {
  annotation         = "orchestrator:terraform"
  admin_st           = "on"
  delay              = "120"
  include_apic_ports = "no"
  minlinks           = "0"

}

resource "aci_fabric_wide_settings" "fabric_set" {
  name                 = "default"
  annotation           = "orchestrator:terraform"
  disable_ep_dampening = "yes"
  #domain_validation = "yes"
  enable_mo_streaming          = "yes"
  enable_remote_leaf_direct    = "yes"
  enforce_subnet_check         = "yes"
  opflexp_authenticate_clients = "yes"
  opflexp_use_ssl              = "yes"
  restrict_infra_vlan_traffic  = "no"
  unicast_xr_ep_learn_disable  = "no"
  validate_overlapping_vlans   = "yes"
}

resource "aci_mcp_instance_policy" "mcp_pol" {
  admin_st         = "enabled"
  ctrl             = ["pdu-per-vlan"]
  init_delay_time  = "180"
  key              = "donotmisscable"
  loop_detect_mult = "3"
  loop_protect_act = "port-disable"
  tx_freq          = "2"
  tx_freq_msec     = "0"
}
resource "aci_endpoint_loop_protection" "loop_prot" {
  annotation        = "orchestrator:terraform"
  action            = ["port-disable"]
  admin_st          = "disabled"
  loop_detect_intvl = "60"
  loop_detect_mult  = "4"
}
resource "aci_qos_instance_policy" "qos_inst_pol" {
  annotation            = "orchestrator:terraform"
  etrap_age_timer       = "0"
  etrap_bw_thresh       = "0"
  etrap_byte_ct         = "0"
  etrap_st              = "no"
  fabric_flush_interval = "500"
  fabric_flush_st       = "yes"
  ctrl                  = "dot1p-preserve"
  uburst_spine_queues   = "10"
  uburst_tor_queues     = "10"
}

resource "aci_rest" "fabric_best_practices" {
  path       = "/api/node/mo/uni/fabric.json"
  class_name = "fabricInst"
  payload    = <<EOF
{
    "fabricInst": {
        "attributes": {
            "dn": "uni/fabric"
        },
        "children": [
			{
				"l3IfPol": {
					"attributes": {
						"dn": "uni/fabric/l3IfP-default",
						"bfdIsis": "enabled",
						},
					"children": []
				}
			}
		]
	}
}
	EOF
}

