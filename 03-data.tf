resource "oci_core_compute_capacity_report" "test_compute_capacity_report" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.tenancy_ocid
  shape_availabilities {
    instance_shape = "VM.Standard.A1.Flex"
    # Optional: instance_shape_config for flex shapes
  }
}

output "capacity_report" {
  value = oci_core_compute_capacity_report.test_compute_capacity_report
}


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

data "oci_core_shapes" "free_shapes_0" {
  compartment_id      = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name

  # Filter for the specific Always Free shape names
  filter {
    name   = "name"
    values = ["VM.Standard.E2.1.Micro", "VM.Standard.A1.Flex"]
  }
}
data "oci_core_shapes" "free_shapes_1" {
  compartment_id      = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name

  # Filter for the specific Always Free shape names
  filter {
    name   = "name"
    values = ["VM.Standard.E2.1.Micro", "VM.Standard.A1.Flex"]
  }
}
data "oci_core_shapes" "free_shapes_2" {
  compartment_id      = var.tenancy_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name

  # Filter for the specific Always Free shape names
  filter {
    name   = "name"
    values = ["VM.Standard.E2.1.Micro", "VM.Standard.A1.Flex"]
  }
}


output "essential_shape_info_0" {
  value = [
    for shape in data.oci_core_shapes.free_shapes_0.shapes : {
      name = shape.name
      network_ports = shape.network_ports
      memory_in_gbs = shape.memory_in_gbs
      ocpus = shape.ocpus
      processor_description = shape.processor_description
    }
  ]
}

output "essential_shape_info_1" {
  value = [
    for shape in data.oci_core_shapes.free_shapes_1.shapes : {
      name = shape.name
      network_ports = shape.network_ports
      memory_in_gbs = shape.memory_in_gbs
      ocpus = shape.ocpus
      processor_description = shape.processor_description
    }
  ]
}

output "essential_shape_info_2" {
  value = [
    for shape in data.oci_core_shapes.free_shapes_2.shapes : {
      name = shape.name
      network_ports = shape.network_ports
      memory_in_gbs = shape.memory_in_gbs
      ocpus = shape.ocpus
      processor_description = shape.processor_description
    }
  ]
}

# Output the list of found free shapes
# output "always_free_shapes" {
#   value = data.oci_core_shapes.free_shapes.shapes[*]
# }

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
  
# Filter for the ARM architecture specifically
  filter {
    name   = "display_name"
    values = ["^.*-aarch64-.*$"]
    regex  = true
  }

  # Ensure we only get "Available" images
  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
}

# output "oracle_linux_arm_image" {
#   value = data.oci_core_images.oracle_linux_arm.images[*]
# }

output "essential_image_info" {
  value = [
    for img in data.oci_core_images.oracle_linux_arm.images : {
      name = img.display_name
      ocid = img.id
      date = img.time_created
    }
  ]
}

output "latest_arm_image_id" {
  value = data.oci_core_images.oracle_linux_arm.images[0].id
}

locals { latest_arm_image_id = data.oci_core_images.oracle_linux_arm.images[0].id }
locals { free_shape_name = data.oci_core_shapes.free_shapes.shapes[0].name }