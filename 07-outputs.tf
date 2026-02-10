output "instance_public_ip" {
  value = oci_core_instance.asiwko_vm.public_ip
}


data "oci_core_images" "ol8" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E2.1.Micro"
  state                    = "AVAILABLE"
  
  # Optional: Filter out GPU or specialized images
  # filter {
  #   name   = "display_name"
  #   values = ["^Oracle-Linux-8.[0-9]+-[0-9]{4}.[0-9]{2}.[0-9]{2}$"]
  #   regex  = true
  # }
}
output "latest_ol8_image_ocid" {
  value = data.oci_core_images.ol8.images.*
}

data "oci_core_images" "ol9" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.E2.1.Micro"
  state                    = "AVAILABLE"
  
  # Optional: Filter out GPU or specialized images
  # filter {
  #   name   = "display_name"
  #   values = ["^Oracle-Linux-9.[0-9]+-[0-9]{4}.[0-9]{2}.[0-9]{2}$"]
  #   regex  = true
  # }
}
output "latest_ol9_image_ocid" {
  value = data.oci_core_images.ol9.images.*
}