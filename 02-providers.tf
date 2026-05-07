terraform {
  required_version = ">= 1.0.0"

   backend "local" {
    path = "/container_shared/tfstate/oracle.tfstate"
  }

  # This project started with the state stored in the provider's oject storage.  
  # I moved it to local storage as providers charge for object storage and there was no benefit once the exercise was complete.
  # backend "oci" {
  #   bucket    = "terraform-state-bucket"
  #   namespace = "idndrno2dl3v"
  #   region    = "us-ashburn-1"
  #   # key       = "terraform.tfstate"
  # }

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
  region           = var.oci_region
}

provider "linode" {
  token = var.LINODE_API_KEY
}

