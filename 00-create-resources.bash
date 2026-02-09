# install the oci client on linux
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"

oci setup config

# Where to get OCIDs: https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#Other
# How to upload the public key: https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#How2

# Test the oci cli installation
oci iam compartment list --all  
# replace with your compartment OCID
oci iam compartment list --compartment-id ocid1.tenancy.oc1..aaaaaaaasby5y3q74jz6s3hfg6mad4wjszdcsm7jtjxskhnvodjbrycsdo7a --all
# this will list out the content of the tf state file in the s3 bucket.
aws s3 cp s3://asiwko-terraform-state-bucket/dev/asiwko/terraform.tfstate -
# this will list out the content of the tf state file in the oci object storage bucket.
oci os object get --bucket-name terraform-state-bucket --name network/terraform.tfstate --file -        
# replace with your bucket name and object name
# oci os object get --bucket-name <bucket_name> --name <object_name> --file -
