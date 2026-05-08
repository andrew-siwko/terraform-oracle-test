data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_instance" "siwko_vm" {
  availability_domain = local.selected_ad
  compartment_id      = var.tenancy_ocid
  display_name        = "asiwko-vm-01"
  # shape               = var.instance_shape
  shape               = local.free_shape_name

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.asiwko_subnet.id
    hostname_label   = "asiwko-vm-01"
  }

  source_details {
    source_type             = "image"
    # source_id               = var.image_ocid
    source_id               = local.latest_image_id
    boot_volume_size_in_gbs = 50
  }

  # added this for the flexible shape type.
  shape_config {
    ocpus         = 1
    memory_in_gbs = 1 
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data = base64encode(<<-EOT
      #!/bin/bash
      # Reclaim 448MB of RAM by disabling kdump
      sed -i 's/crashkernel=[^[:space:]"]*/crashkernel=no/g' /etc/default/grub
      grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
      # Reboot to apply the changes immediately
      shutdown -r +1 "Reclaiming memory for Nagios stability"
    EOT
    )
  }

}

