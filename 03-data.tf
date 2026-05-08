# search for free shapes by billing_type.
data "oci_core_shapes" "free_shapes" {
  compartment_id      = var.tenancy_ocid
  filter {
    name   = "billing_type"
    values = ["ALWAYS_FREE"]
  }
}

# find oracle linux on ARM
data "oci_core_images" "oracle_linux_arm" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.A1.Flex"
  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}

# find oracle linux on x86
data "oci_core_images" "oracle_linux_x86" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = "VM.Standard.E2.1.Micro"
  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
  sort_by    = "TIMECREATED"
  sort_order = "DESC"
}

# for each ad, find the ARM shape availability
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

# for each ad, find the x86 shape availability
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

locals {
  # identify the newest ARM image
  latest_arm_image_id = data.oci_core_images.oracle_linux_arm.images[0].id
  # identify the newest x86 image
  latest_x86_image_id = data.oci_core_images.oracle_linux_x86.images[0].id
  # pull out the name of the first free shape
  free_shape_name = data.oci_core_shapes.free_shapes.shapes[0].name
  # select the correct image for the shape.  A1 is ARM, E1 is x86.
  latest_image_id = length(regexall("A1", local.free_shape_name)) > 0 ? local.latest_arm_image_id : local.latest_x86_image_id

  # merge all the capacity reports for A1 and E1 into a single map
  full_region_capacity_report_map = merge(
    {
      for ad, report in oci_core_compute_capacity_report.ad_check_loop_a1 :
      "${ad}-A1" => report.shape_availabilities[0].availability_status
    },
    {
      for ad, report in oci_core_compute_capacity_report.ad_check_loop_e2 :
      "${ad}-E2" => report.shape_availabilities[0].availability_status
    }
  )

  # Keep only the available keys.  Maybe do this in the loop above some day
  available_keys = [
    for key, status in local.full_region_capacity_report_map : key 
    if status == "AVAILABLE"
  ]
  # break out ARM or x86
  target_shape_suffix = length(regexall("A1", local.free_shape_name)) > 0 ? "-A1" : "-E2"
  
  # keep the AD keys for the selected shape
  valid_ad_keys = [
    for key in local.available_keys : key 
    if endswith(key, local.target_shape_suffix)
  ]

  # get the first key and strip the suffix to get the ad name.
  selected_ad = length(local.valid_ad_keys) > 0 ? replace(local.valid_ad_keys[0], local.target_shape_suffix, "") : null

  # We don't use this yet, but A1 shapes get more memory.  We should pull this from the shape information to get
  # the maximum allocation.
  selected_memory = length(regexall("A1", local.free_shape_name)) > 0 ? "6" : "1"

}
