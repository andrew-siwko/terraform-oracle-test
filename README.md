# Andrew's Multicloud Terraform Experiment
## Goal
The goal of this repo is to create a usable VM in the Oracle OCI cloud.<br/>
After this step completed I used Ansible to configure and install Tomcat and run a sample application.  [More on that later...](https://github.com/andrew-siwko/ansible-multi-cloud-tomcat-hello)<br/>
It all starts with the [Cloud Console](https://www.oracle.com/cloud/sign-in.html).

## Multicloud
I tried to build the same basic structures in each of the cloud environments.  Each one starts with providers (and a backend), lays out the network and security, creates the VM and then registers the public IP in my DNS.  There is some variability which has been interesting to study.  The Terraform state file is stored on each provider.
* Step 1 - [Amazon AWS](https://github.com/andrew-siwko/terraform-aws-test)
* Step 2 - [Microsoft Azure](https://github.com/andrew-siwko/terraform-azure-test)
* Step 3 - [Google GCP](https://github.com/andrew-siwko/terraform-gcp-test)
* Step 4 - [Linode](https://github.com/andrew-siwko/terraform-linode-test)
* Step 5 - [IBM Cloud](https://github.com/andrew-siwko/terraform-ibm-test)
* Step 6 - [Oracle OCI](https://github.com/andrew-siwko/terraform-oracle-test) (you are here)

## Build Environment
I stood up my own Jenkins server and built a freestyle job to support the Terraform infrastructure builds.
* terraform init
* _some bash to import the domain (see below)_
* terraform plan
* terraform apply -auto-approve
* terraform output (This is piped to mail so I get an e-mail with the outputs.)

Yes, I know plan and apply should be separate and intentional.  In this case I found defects in plan which halted the job before apply.  That was useful.  I also commented out apply until plan was pretty close to working.<br/>
The Jenkins job contains environment variables with authentication information for the cloud environment and [Linode](https://www.linode.com/) (my registrar).<br/>
I did have a second job to import the domain zone but switched to a conditional in a script.  The code checks to see whether my zone record has been imported.  If not, the zone creation will fail.
```bash
if ! terraform state list | grep -q "linode_domain.dns_zone"; then
  echo "Resource not in state. Importing..."
  terraform import linode_domain.dns_zone 3417841
else
  echo "Domain already managed. Skipping import."
fi
```

## Observations
* This was my sixth cloud provisioning project.  I was happy with the other 5 but asked Google Gemini whether there were other providers.  It suggested Oracle and Digital Ocean
* It took me one day to get my VMs provisioned.  One painful day.  I spent lots of time in the oci console which is super-helpful even if difficult to learn.  I really should learn jq also.  The biggest difficulty was trying to get a subnet to attach to the instance.  Without a dns_label on the subnet and vcn, Terraform would fail with vague work request errors.  Fortunately I had a network from 6 years ago that worked with the instance.  I was able to build the network without the instance then woth the diffs to closure.  That alone took 6 hours.
* When I figured out how to find an Oracle 9.7 image for my shap in my compartment I was delighted to see that the VM booted off the new image without a destroy / create cycle.
* I couldn't find a RHEL image but read that Oracle Linux is compatible.  Oracle Linux 9.7 
  * Start: 2026-02-09
  * Functional: 2026-02-09
  * Number of Jenkins builds to success: 68
  * Hurdles: 
    * Non-default networking - dns_label.
    * Locating a compatible shape and image
