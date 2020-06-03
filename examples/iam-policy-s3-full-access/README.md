[<img src="https://raw.githubusercontent.com/mineiros-io/brand/master/mineiros-vertial-logo-smaller-font.svg" width="200"/>](https://mineiros.io/?ref=terraform-aws-iam-policy)

[![Maintained by Mineiros.io](https://img.shields.io/badge/maintained%20by-mineiros.io-f32752.svg)](https://mineiros.io/?ref=terraform-aws-iam-policy)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-brightgreen.svg)](https://github.com/hashicorp/terraform/releases)
[![License](https://img.shields.io/badge/License-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)

# Create a S3 Full Access IAM Policy
The code in [main.tf](https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/examples/iam-instance-profile/main.tf)
creates an IAM Policy named 'S3FullAccess' which grants
full access to AWS Simple Storage Service (S3).

## Example Code
This is an extract from the code in
[main.tf](https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/examples/iam-instance-profile/main.tf):
```hcl
module "policy-s3-full-access" {
  source = "git@github.com:mineiros-io/terraform-aws-iam-policy.git?ref=v0.0.1"

  # name of the policy
  name = "S3FullAccess"

  # construct the policy document granting access from the following statements
  policy_statements = [
    {
      sid = "S3FullAccess"

      effect    = "Allow"
      actions   = ["s3:*"]
      resources = ["*"]
    }
  ]
}
```

## Running the example
### Cloning the repository
```bash
git clone git@github.com:mineiros-io/terraform-aws-iam-policy.git
cd terraform-aws-iam-policy/examples/iam-policy-s3-full-access
```

### Initializing Terraform
Run `terraform init` to initialize the example. The output should look like:
```
Initializing modules...
Downloading git@github.com:mineiros-io/terraform-aws-iam-policy.git?ref=v0.0.1 for policy-s3-full-access...
- policy-s3-full-access in .terraform/modules/policy-s3-full-access

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.64.0...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Planning the example
Run `terraform plan` to preview the creation of the resources.
Attention: We are not creating a plan output file in this case. In a production environment, it would be recommended to create a plan file first that can be applied in an isolated apply run.

```hcl
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

module.policy-s3-full-access.data.aws_iam_policy_document.policy[0]: Refreshing state...

------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.policy-s3-full-access.aws_iam_policy.policy[0] will be created
  + resource "aws_iam_policy" "policy" {
      + arn    = (known after apply)
      + id     = (known after apply)
      + name   = "S3FullAccess"
      + path   = "/"
      + policy = jsonencode(
            {
              + Statement = [
                  + {
                      + Action   = "s3:*"
                      + Effect   = "Allow"
                      + Resource = "*"
                      + Sid      = "S3FullAccess"
                    },
                ]
              + Version   = "2012-10-17"
            }
        )
    }

Plan: 1 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

### Applying the example
Run `terraform apply -auto-approve` to create the resources.
Attention: this will not ask for confirmation and also not use the previously
run plan as no plan output file was used.

### Destroying the example
Run `terraform destroy -refresh=false -auto-approve` to destroy all
previously created resources again.

## External documentation for the resources created in this example
- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/iam_policy.html

- AWS Documentation:
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
