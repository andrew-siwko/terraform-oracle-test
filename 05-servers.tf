data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# resource "oci_core_instance" "asiwko_vm" {
#   availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
#   compartment_id = var.tenancy_ocid
#   display_name        = "asiwko-vm-01"

#   shape = var.instance_shape
  
#   create_vnic_details {
#     assign_public_ip = true
#     subnet_id        = oci_core_subnet.asiwko_subnet.id
#     display_name     = "primaryvnic"
#     hostname_label   = "asiwko-vm-01"
#   }

#   source_details {
#     source_type = "image"
#     source_id               = var.image_ocid
#     boot_volume_size_in_gbs = 50
#   }

#   metadata = {
#     ssh_authorized_keys = file(var.ssh_public_key_path)
#   }

#   preserve_boot_volume = false
#   depends_on = [
#     oci_core_internet_gateway.asiwko_ig,
#     oci_core_default_route_table.asiwko_rt
#   ]
# }


resource "oci_core_instance" "asiwko_vm" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
  compartment_id      = var.tenancy_ocid
  display_name        = "asiwko-vm-01"
  shape               = var.instance_shape

  create_vnic_details {
    assign_public_ip = true
    # subnet_id        = oci_core_subnet.asiwko_subnet.id
    subnet_id        = var.subnet_ocid
    hostname_label   = "asiwko-vm-01"
  }

  source_details {
    source_type             = "image"
    source_id               = var.image_ocid
    boot_volume_size_in_gbs = 50
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }
}