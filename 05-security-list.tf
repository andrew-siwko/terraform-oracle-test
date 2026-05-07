resource "oci_core_security_list" "web_security_list" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.asiwko_vcn.id
  display_name   = "web-security-list"

  # Keep existing Egress rules (Allow all outbound)
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # Ingress: SSH
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
    description = "Allow SSH"
  }

  # Ingress: ICMP Echo Request (Ping)
  ingress_security_rules {
    protocol = "1" # ICMP
    source   = "0.0.0.0/0"
    icmp_options {
      type = 8
    }
    description = "Allow Ping"
  }

  ingress_security_rules {
    protocol = "1" # ICMP
    source   = "0.0.0.0/0"
    icmp_options {
      type = 3
      code = 4
    }
    description = "Allow Path MTU Discovery"
  }

  # Ingress: HTTP
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 80
      max = 80
    }
    description = "Allow HTTP"
  }

  # Ingress: HTTPS
  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
    description = "Allow HTTPS"
  }
}