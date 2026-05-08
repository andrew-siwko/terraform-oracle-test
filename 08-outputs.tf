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
output "essential_shape_info" {
  value = [
    for shape in data.oci_core_shapes.free_shapes.shapes : {
      name = shape.name
      network_ports = shape.network_ports
      memory_in_gbs = shape.memory_in_gbs
      ocpus = shape.ocpus
      processor_description = shape.processor_description
    }
  ]
}

output "essential_image_info_arm" {
  value = [
    for img in data.oci_core_images.oracle_linux_arm.images : {
      name = img.display_name
      ocid = img.id
      date = img.time_created
    }
  ]
}

output "essential_image_info_x86" {
  value = [
    for img in data.oci_core_images.oracle_linux_x86.images : {
      name = img.display_name
      ocid = img.id
      date = img.time_created
    }
  ]
}

output "latest_arm_image_id" {
  value = data.oci_core_images.oracle_linux_arm.images[0].id
}
output "latest_x86_image_id" {
  value = data.oci_core_images.oracle_linux_x86.images[0].id
}
output "full_region_capacity_report" {
  value = merge(
    {
      for ad, report in oci_core_compute_capacity_report.ad_check_loop_a1 :
      "${ad}-A1" => report.shape_availabilities[0].availability_status
    },
    {
      for ad, report in oci_core_compute_capacity_report.ad_check_loop_e2 :
      "${ad}-E2" => report.shape_availabilities[0].availability_status
    }
  )
}

output "available_keys" {
  value = local.available_keys
}
output "target_shape_suffix" {
  value = local.target_shape_suffix
}
output "selected_availability_domain_name" {
  value = local.selected_ad
}
