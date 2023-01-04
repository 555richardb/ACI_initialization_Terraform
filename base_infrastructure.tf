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
  annotation  = ""
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
				"coopPol": {
					"attributes": {
						"dn": "uni/fabric/pol-default",
						"rn": "pol-default",
						"type": "strict"
					},
					"children": []
				}
			},
			{
				"fabricNodeControl": {
					"attributes": {
						"dn": "uni/fabric/nodecontrol-default",
						"control": "1",
					},
					"children": []
				}
			},
            {
                "isisDomPol": {
                    "attributes": {
                        "dn": "uni/fabric/isisDomP-default",
                        "rn": "isisDomP-default",
                        "redistribMetric": "63"
					},
					"children": []
				}
			},
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

resource "aci_rest" "infra_best_practices" {
  path       = "/api/node/mo/uni/infra.json"
  class_name = "infraInfra"
  payload    = <<EOF
{
	"infraInfra": {
		"attributes": {
			"dn": "uni/infra",
		},
		"children": [
			{
				"infraSetPol": {
					"attributes": {
						"dn": "uni/infra/settings",
						"domainValidation": "true",
						"enforceSubnetCheck": "true",
						"unicastXrEpLearnDisable": "false"
					},
					"children": []
				}
			},
			{
				"epControlP": {
					"attributes": {
						"dn": "uni/infra/epCtrlP-default",
						"adminSt": "enabled",
						"rogueEpDetectIntvl": "30",
						"rogueEpDetectMult": "4",
						"rn": "epCtrlP-default"
					},
					"children": []
				}
			},
			{
				"epIpAgingP": {
					"attributes": {
						"dn": "uni/infra/ipAgingP-default",
						"rn": "ipAgingP-default",
						"adminSt": "enabled"
					},
					"children": []
				}
			},
			{
				"epLoopProtectP": {
					"attributes": {
						"dn": "uni/infra/epLoopProtectP-default",
						"adminSt": "disabled",
						"action": "",
						"rn": "epLoopProtectP-default"
					},
					"children": []
				}
			},
			{
				"infraPortTrackPol": {
					"attributes": {
						"dn": "uni/infra/trackEqptFabP-default",
						"adminSt": "on"
					},
					"children": []
				}
			},
			{
				"mcpInstPol": {
					"attributes": {
						"dn": "uni/infra/mcpInstP-default",
						"descr": "Policy Enabled as part of the Brahma Startup Wizard",
						"ctrl": "pdu-per-vlan",
						"adminSt": "enabled",
						"key": "mcpkeystring"
					},
					"children": []
				}
			},
			{
				"qosInstPol": {
					"attributes": {
						"dn": "uni/infra/qosinst-default",
						"ctrl": "dot1p-preserve"
					},
					"children": []
				}
			}
		]
	}
}
	EOF
}
