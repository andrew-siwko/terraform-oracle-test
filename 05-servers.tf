data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

resource "oci_core_instance" "asiwko_vm" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id = var.tenancy_ocid
  display_name        = "asiwko-vm-01"

  shape = "VM.Standard.E4.Flex"
  shape_config {
    ocpus         = 1
    memory_in_gbs = 4
  }

  
  create_vnic_details {
    subnet_id        = var.subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "asiwko-vm-01"
  }

  source_details {
    source_type = "image"
    # Fix: Use the Oracle Linux 9.7 OCID from your verified list
    source_id               = "ocid1.image.oc1.iad.aaaaaaaahvwnjutyewvsr2nkjcfq6i7l5anlm6bslnoom2vaerhwbzc2wx4a"
    boot_volume_size_in_gbs = 50
  }

  metadata = {
    # Provide your SSH public key to access the instance
    ssh_authorized_keys = file(var.ssh_public_key_path)

    # Optional: user_data for cloud-init (e.g., register with Red Hat Subscription Manager)
    # user_data = base64encode(file("cloud-init.sh"))
  }

  preserve_boot_volume = false
}

# some debugging
data "oci_core_shapes" "available_shapes" {
    compartment_id      = var.tenancy_ocid
    availability_domain = "wXHG:US-ASHBURN-AD-1" # Match your specific AD
}

output "shapes" {
    value = [for s in data.oci_core_shapes.available_shapes.shapes : s.name]
}
