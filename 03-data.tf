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

# Output the list of found free shapes
output "always_free_shapes" {
  value = data.oci_core_shapes.free_shapes.shapes[*]
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

output "oracle_linux_arm_image" {
  value = data.oci_core_images.oracle_linux_arm.images[*]
}
