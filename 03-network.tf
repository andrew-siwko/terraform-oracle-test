resource "oci_core_vcn" "asiwko_vcn" {
  compartment_id = var.tenancy_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "asiwko-vcn"
}

resource "oci_core_subnet" "asiwko_subnet" {
  compartment_id = var.tenancy_ocid
  vcn_id              = oci_core_vcn.asiwko_vcn.id
  display_name        = "asiwko-subnet"
  cidr_block          = "10.0.1.0/24"
  security_list_ids   = [oci_core_security_list.web_security_list.id]
  route_table_id      = oci_core_vcn.asiwko_vcn.default_route_table_id
  prohibit_public_ip_on_vnic = false
  depends_on = [oci_core_default_route_table.asiwko_rt]
}

resource "oci_core_internet_gateway" "asiwko_ig" {
  compartment_id = var.tenancy_ocid
  display_name   = "asiwko-internet-gateway"
  vcn_id         = oci_core_vcn.asiwko_vcn.id
  enabled        = true
}

resource "oci_core_default_route_table" "asiwko_rt" {
  manage_default_resource_id = oci_core_vcn.asiwko_vcn.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.asiwko_ig.id
    # this was present in the old (2020) route
    cidr-block        = "0.0.0.0/0"
  }
}