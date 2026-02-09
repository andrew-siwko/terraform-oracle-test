terraform {
  backend "s3" {
    bucket   = "terraform-state-bucket"      # Your bucket name
    key      = "network/terraform.tfstate"   # Path/name of the state file
    region   = "us-ashburn-1"                # Your OCI region
    
    # OCI Object Storage S3 Compatibility Endpoint
    # Format: <namespace>.compat.objectstorage.<region>.oraclecloud.com
    endpoint = "your_namespace.compat.objectstorage.us-ashburn-1.oraclecloud.com"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true # Required for OCI
  }
}
# 1. Define the OCI Provider
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# 2. Reference your Availability Domain
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

# 3. Create the RHEL 9 Instance
resource "oci_core_instance" "rhel_vm" {
  # The AD where the VM will live
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  display_name        = "RHEL9-Production-VM"
  
  # Shape selection (Flex shapes are standard for RHEL 9)
  shape = "VM.Standard.E4.Flex"
  shape_config {
    ocpus         = 1
    memory_in_gbs = 16
  }

  create_vnic_details {
    subnet_id        = var.subnet_ocid
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "rhel9-vm"
  }

  source_details {
    source_type = "image"
    # REPLACE THIS with the RHEL 9.x OCID from your region
    source_id   = "ocid1.image.oc1.iad.aaaaaaa..." 
    boot_volume_size_in_gbs = 50
  }

  metadata = {
    # Provide your SSH public key to access the instance
    ssh_authorized_keys = file(var.ssh_public_key_path)
    
    # Optional: user_data for cloud-init (e.g., register with Red Hat Subscription Manager)
    # user_data = base64encode(file("cloud-init.sh"))
  }

  preserve_boot_volume = false
}

# 4. Output the Public IP
output "instance_public_ip" {
  value = oci_core_instance.rhel_vm.public_ip
}