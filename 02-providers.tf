terraform {
  required_version = ">= 1.0.0"

    # We will be working with linode and so will need the linode provider
    # in order to update DNS on linode, we'll need the linode provider.
    linode = {
      source = "linode/linode"
    }
  
  backend "s3" {
    bucket  = "terraform-state-bucket"
    key     = "terraform.tfstate"
    region  = "us-ashburn-1"
    encrypt = true

    endpoints = {
      s3 = "https://idndrno2dl3v.compat.objectstorage.us-ashburn-1.oraclecloud.com"
    }

    # OCI-specific compatibility flags
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    use_path_style              = true
    skip_s3_checksum            = true
    skip_metadata_api_check     = true
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.0.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}
