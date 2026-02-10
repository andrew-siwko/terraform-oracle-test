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
}
