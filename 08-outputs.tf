output "oracle_instance_public_ip" {
  value = oci_core_instance.siwko_vm.public_ip
}


data "oci_core_images" "ol8" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  shape                    = "VM.Standard.E2.1.Micro"
  state                    = "AVAILABLE"
  # Ensure the newest image is at index 0
  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}

data "oci_core_images" "ol9" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.E2.1.Micro"
  state                    = "AVAILABLE"
  # Ensure the newest image is at index 0
  sort_by    = "TIMECREATED"
  sort_order = "DESC"
  
}
