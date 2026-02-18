# I hate doing this manually, but the free shaped are named not tagged with attributes
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
