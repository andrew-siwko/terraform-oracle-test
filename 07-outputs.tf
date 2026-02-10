output "instance_public_ip" {
  value = oci_core_instance.asiwko_vm.public_ip
}


data "oci_core_images" "ol8" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E2.1.Micro"
  state                    = "AVAILABLE"
}
output "latest_ol8_image_ocid" {
  value = {
    for image in data.oci_core_images.ol8.images : image.id => {
      display_name = image.display_name
      state        = image.state
      id           = image.id
    }
  }
}

data "oci_core_images" "ol9" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.E2.1.Micro"
  state                    = "AVAILABLE"
  
}
output "latest_ol9_image_ocid" {
  value = {
    for image in data.oci_core_images.ol9.images : image.id => {
      display_name = image.display_name
      state        = image.state
      id           = image.id
    }
  }
}