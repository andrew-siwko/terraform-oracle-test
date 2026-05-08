terraform {
  # I started out with this in an S3 bucket but keeping the state file in a shared folder
  # was easier for my purposes. 
  backend "local" {
    path = "/container_shared/tfstate/oracle.tfstate"
  }
  required_providers {
    # The oracle provider will be used for the infrastructure provisioning.
    oci = {
      source  = "oracle/oci"
    }
    # The linode provider will be used for the DNS management.
    linode = {
      source = "linode/linode"
    }

  }
}

provider "oci" {
  region           = var.oci_region
}

provider "linode" {
  token = var.LINODE_API_KEY
}

