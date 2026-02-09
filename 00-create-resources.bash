# install the oci client on linux
bash -c "$(curl -L https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh)"

oci setup config

# Where to get OCIDs: https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#Other
# How to upload the public key: https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#How2

export COMPARTMENT_OCID="ocid1.tenancy.oc1..aaaaaaaasby5y3q74jz6s3hfg6mad4wjszdcsm7jtjxskhnvodjbrycsdo7a"
# Test the oci cli installation
oci iam compartment list --all  
# replace with your compartment OCID
oci iam compartment list --compartment-id ${COMPARTMENT_OCID} --all

oci os bucket create --name terraform-state-bucket --compartment-id ${COMPARTMENT_OCID}

# this will list out the content of the tf state file in the s3 bucket.
aws s3 cp s3://terraform-state-bucket/terraform.tfstate -
# this will list out the content of the tf state file in the oci object storage bucket.
oci os object get --bucket-name terraform-state-bucket --name terraform.tfstate --file -
# replace with your bucket name and object name
# oci os object get --bucket-name <bucket_name> --name <object_name> --file -
# to get new keys: 
oci iam customer-secret-key create --display-name "TerraformS3" --user-id ${USER_OCID}

# find shaped 
oci compute shape list -c ${COMPARTMENT_OCID}

oci compute shape list -c ${COMPARTMENT_OCID} | jq '.data[] | select(."billing-type" == "ALWAYS_FREE")'
oci compute shape list -c ${COMPARTMENT_OCID} | jq '.data[] | select(."billing-type" == "LIMITED_FREE")'
oci compute shape list -c ${COMPARTMENT_OCID} | jq '.data[] | {shape: .shape, billing: ."billing-type"}'

# for aws cli 
export AWS_ACCESS_KEY_ID="{oracle access key}"
export AWS_SECRET_ACCESS_KEY="{oracle secret key}"

