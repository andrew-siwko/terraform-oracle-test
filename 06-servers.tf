data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_instance" "asiwko_vm" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
  compartment_id      = var.tenancy_ocid
  display_name        = "asiwko-vm-01"
  shape               = var.instance_shape
  # shape               = local.free_shape_name

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.asiwko_subnet.id
    hostname_label   = "asiwko-vm-01"
  }

  source_details {
    source_type             = "image"
    source_id               = var.image_ocid
    # source_id               = local.latest_arm_image_id
    boot_volume_size_in_gbs = 50
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }

  # lifecycle {
  #   replace_triggered_by = [
  #     oci_core_instance.asiwko_vm.source_details[0].source_id,
  #     oci_core_instance.asiwko_vm.shape
  #   ]  
  # }

}

output "source_details" {
  value = oci_core_instance.asiwko_vm.source_details
}

output "shape" {
  value = oci_core_instance.asiwko_vm.shape
}
