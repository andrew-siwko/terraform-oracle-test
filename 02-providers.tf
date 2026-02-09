terraform {
  required_version = ">= 1.0.0"

  backend "oci" {
    bucket    = "terraform-state-bucket"
    namespace = "idndrno2dl3v"
    region    = "us-ashburn-1"
    key       = "terraform.tfstate"
    
    auth = "APIKey"
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 4.0.0"
    }
    # We will be working with linode and so will need the linode provider
    # in order to update DNS on linode, we'll need the linode provider.
    linode = {
      source = "linode/linode"
    }

  }
}

provider "oci" {
  # tenancy_ocid     = var.tenancy_ocid
  # user_ocid        = var.user_ocid
  # fingerprint      = var.fingerprint
  # private_key_path = var.private_key_path
  region           = var.region
}

provider "linode" {
  token = var.LINODE_API_KEY
}

