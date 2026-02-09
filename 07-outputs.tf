output "instance_public_ip" {
  value = oci_core_instance.rhel_vm.public_ip
}