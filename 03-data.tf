# I hate doing this manually, but the free shapes are named not tagged with attributes
data "oci_core_shapes" "free_shapes" {
  compartment_id      = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  # Filter for the specific Always Free shape names
  filter {
    name   = "name"
    values = ["VM.Standard.E2.1.Micro", "VM.Standard.A1.Flex"]
  }
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


data "oci_core_images" "oracle_linux_arm" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.A1.Flex"
  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
}

data "oci_core_images" "oracle_linux_x86" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.E2.1.Micro"
  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
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
  
locals { latest_arm_image_id = data.oci_core_images.oracle_linux_arm.images[0].id }
locals { latest_x86_image_id = data.oci_core_images.oracle_linux_x86.images[0].id }
locals { free_shape_name = data.oci_core_shapes.free_shapes.shapes[0].name }
locals { latest_image_id = length(regexall("A1", local.free_shape_name)) > 0 ? local.latest_arm_image_id : local.latest_x86_image_id }

# Create a report for every Availability Domain found in the region
resource "oci_core_compute_capacity_report" "ad_check_loop_a1" {
  for_each = { for ad in data.oci_identity_availability_domains.ads.availability_domains : ad.name => ad }

  availability_domain = each.value.name
  compartment_id      = var.tenancy_ocid

  shape_availabilities {
    instance_shape = "VM.Standard.A1.Flex"
    
    instance_shape_config {
      ocpus         = 1
      memory_in_gbs = 1
    }
  }
}

resource "oci_core_compute_capacity_report" "ad_check_loop_e2" {
  for_each = { for ad in data.oci_identity_availability_domains.ads.availability_domains : ad.name => ad }

  availability_domain = each.value.name
  compartment_id      = var.tenancy_ocid

  shape_availabilities {
    instance_shape = "VM.Standard.E2.1.Micro"
    
    instance_shape_config {
      ocpus         = 1
      memory_in_gbs = 1
    }
  }
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

locals {
  # 1. Identify all keys that are currently AVAILABLE
  available_keys = [
    for key, status in local.full_region_capacity_report_map : key 
    if status == "AVAILABLE"
  ]

  # 2. Filter that list to only include keys matching the shape we want (A1 or E2)
  # We check if the key ends with the suffix corresponding to our free_shape_name
  target_shape_suffix = length(regexall("A1", local.free_shape_name)) > 0 ? "-A1" : "-E2"
  
  valid_ad_keys = [
    for key in local.available_keys : key 
    if endswith(key, local.target_shape_suffix)
  ]

  # 3. Extract the AD name by removing the shape suffix from the first valid key
  # Example: "wXHG:US-ASHBURN-AD-2-E2" becomes "wXHG:US-ASHBURN-AD-2"
  selected_ad = length(local.valid_ad_keys) > 0 ? replace(local.valid_ad_keys[0], local.target_shape_suffix, "") : null
}

output "selected_availability_domain" {
  value = local.selected_ad
}