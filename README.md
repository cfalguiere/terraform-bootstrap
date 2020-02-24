# terraform-bootstrap-account

## Goals

This plan bootstraps the Terraform environment.

It creates the IAM and S3 resources required to run Terraform with a role and use a S3 backend to keep track of the remote state.

It is intended to be run with minimal pre-existing Terraform configuraation.

Resources Created :
- an automation role
- a S3 bucket for remote states
- a backend configuration file for future use
- a pass role policy for admin user

The role has the permissions listed below
- AdministratorAccess
- permissions to list the dedicated S3 bucket and put objects and get objects in it
- gives permissions to assume_role to the automation user when the request comes from a specific IP range


## Prerequisites

AWS advice against using the root account. We will use a user account to run the automation tools.

Connect to the AWS web console and
- create an AWS user with admin permissions (see details hereafter)
- create a repository in CodeCommit

On a local machine
- download terraform
- clone or copy the IAC code (this module)
- create the credentials file (see details hereafter)
- cd into the folder terraform-bootstrap-account

### (Details) create an AWS user with admin permissions

Steps of the user creation
- Give it a name
- Allow at least Programmatic access (required to gert the API key and secret)
- Console access might be useful for debugging tasks
- Enables a password that allows users to sign-in to the AWS Management Console
- Uncheck Require password reset
- In permissions Select AdministratorAccess
- Review and Validate

As a result AWS will generate a key and give you the apportunity to download it. This is the only moment you will have access to the secret attached to the key.
- Download the csv

Alternatively, create an Admin group with AdministratorAccess policy and add user to the group

Alternatively, if you use an existing user, use the associated Access Key or generate a new one in S3 / User / Tab Security credentials / Section Access Key

SECURITY WARNING : avoid leaking the content of this key file.
When copied locally, restrict access permissions to this file to your user.

### (Details) create the credentials file

Create a file named ~/.aws/credentials and adapt the following lines.

Use the csv file to get the API access key and secret.  and
Either run the aws configure command or fill in the template below.

```
[default]
aws_access_key_id = AAAAAAAAAAAAAAAAAAAA
aws_secret_access_key = AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
```

Use [default] if your local user's name is the same as the AWS user's name.
Replace default by the AWS user's name otherwise.

SECURITY WARNING : avoid leaking the content of this key file.
When copied locally, restrict access permissions to this file to your user.

## Configure the plan

Connection information :
- *profile* : the profile used to run the plan. A user with the same name must exists in your account.
- *profile_credentials* : the credentials file associated with the profile (the one you created above)
- *region* : a default region for AWS resources

Ressources to be used
- *vc_repo_name* : the name of the CodeCommit repository for iac code (the repo is not created and should exist)
- *main_policy* : the name of a policy allowing access to AWS services (usually AdministratorAccess)
- *local_cidr_block* : the CIDR block used as a conditional in the assume_role policy (usually your IP)
- *output_dir* = the location folder of the generated files

Resources to be created :
- *shared_s3_bucket.bucket_name* : the name of a S3 bucket used by terraform to store remote state (later, this plan must use a local state)
- *shared_s3_bucket.policy_name* : the policy allowing access to this bucket
- *shared_s3_bucket.ou_path* : a group name used in IAM ressources
- *admin_role.name* : the provisioning admin role to be created
- *admin_role.ou_path* : a group name used in IAM ressources
- *policies.vc_policy_name* = the policy allowing access to this repo
- *policies.pass_role_policy_name* : the name of a policy allowing a user to set PassRole to an ec2 instance

## Run the plan

Download plugins
```
$ terraform init
```

Validate the plan syntax (optional)
```
$ terraform validate
```

Build the plan and check whether it does what you want
```
$ terraform plan -out tfplan
```

Apply the plan
```
$ terraform apply -auto-approve tfplan
```

### Validation

WARNING : Please note that the .tfstate is generated locally. Keep track of the the terraform.state generated in the current directory. You may upload this file manually to the S3 bucket created for terraform.

In order to check whether the configuration is OK you may tun the tests below :
- check the role TF-AdminProvisioningFullAccess for existence
- check the user tf_admin is in the list of trusted entities
- check the role has 3 policies AdministratorAccess, tf_terraform_envs_s3_policy, tf_code_commit_infra_policy
- check the S3 bucket tf_terraform_envs for existence
- check the generated config file for existence
- check user has PassRole permission

### Ressources created

If the workloads has been executed correctly the following resources should have been created

```
$ terraform state list
data.aws_codecommit_repository.infra_vc
data.aws_iam_policy.base_policy
data.aws_iam_policy_document.pass_role_policy_document
data.aws_iam_policy_document.trust_policy_document
data.aws_iam_policy_document.vc_policy_document
data.aws_iam_policy_document.workspaces_s3_policy_document
data.aws_iam_user.admin_user
aws_iam_policy.pass_role_policy
aws_iam_policy.vc_policy
aws_iam_policy.workspaces_s3_policy
aws_iam_role.provisioning
aws_iam_role_policy_attachment.provisioning_full_access
aws_iam_role_policy_attachment.provisioning_vc_access
aws_iam_role_policy_attachment.provisioning_worspaces_s3_access
aws_iam_user_policy_attachment.pass_role_to_admin
aws_s3_bucket.workspaces
aws_s3_bucket_public_access_block.workspaces_block_all
local_file.backend_config
```


### Generated graph

Terraform can export the execution plan graph.

The file uses the dot format.
You can convert this format into an image (SVG or PNG) by using graphviz locally or online.

Locally : install the graphviz package and
```
terraform graph | dot -Tsvg > graph.svg
```

Online : you can find dot viewer here
- https://dreampuf.github.io/GraphvizOnline
- https://graphs.grevian.org/graph

```
$ terraform graph > current_graph.dot
```

The terraform graph as generated
![terraform graph](./outputs/graph.png)
A reworked version (removed some boilerplate)

![terraform graph](./doc/doc.png)



## Troubleshooting

### Bucket exists already

Bucket might be difficult to destroy when it's not empty. Terraform might be unable to destroy it and fail later because the bucket exists already.

Alternatelly, you may want to use your own bucket.

Use the workaround below to import this resource into the plan and avoid the plan failure on "Bucket exists already"

```
$ terraform import  aws_s3_bucket.workspaces YOUR-BUCKET-NAME
```

Then build the plan again and apply the plan.

### Some policy exists already

Same instructions apply to other resources like policies.

However if you changed names between runs, the plan might get messy with new and old names.
If you are in the initialisation process, it is usually easier to destroy the resources, remove the terraform.state file and start again from a clean configuration.

## Destroy

Warning : by destroying this plan you will erase the setups of all other plans

```
$ terraform destroy -auto-approve
```

However the bucket will not be destroyed because it's not empty.
