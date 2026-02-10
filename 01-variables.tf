variable "LINODE_API_KEY" {
  description = "The key to the Linode API"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The domain to create instance records in."
  type    = string
  default = "siwko.org"
}

variable "domain_soa_email" {
  description = "The domain manager e-mail address."
  type    = string
  default = "asiwko@siwko.org"
}

# --- Authentication Variables ---
variable "tenancy_ocid" {
  description = "The OCID of your OCI tenancy"
  type        = string
}

variable "user_ocid" {
  description = "The OCID of the user calling the API"
  type        = string
}

variable "fingerprint" {
  description = "Fingerprint of the API private key"
  type        = string
}

variable "private_key_path" {
  description = "The path to your OCI API private key"
  type        = string
}

variable "region" {
  description = "OCI region (e.g., us-ashburn-1)"
  type        = string
  default     = "us-ashburn-1"
}

variable "instance_shape" {
  description = "The shape of the instance to create"
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "image_ocid" {
  description = "The ocid of the image to build"
  type        = string
  default     = "ocid1.image.oc1.iad.aaaaaaaavhiadmsoe7hqq2tj6qlfpvlhvyxlhlaxjgk5kd4auy6bbauvzn2q"
}

# # --- Resource Variables ---
# variable "compartment_id" {
#   description = "The OCID of the compartment where resources will be created"
#   type        = string
# }

variable "subnet_ocid" {
  description = "The OCID of the subnet where the VM will reside"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key for instance access"
  type        = string
}