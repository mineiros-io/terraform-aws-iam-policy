[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Create a S3 Full Access IAM Policy

The code in [main.tf] creates an IAM Policy named 'S3FullAccess' which grants
full access to AWS Simple Storage Service (S3).

- [Example Code](#example-code)
- [Running the example](#running-the-example)
  - [Cloning the repository](#cloning-the-repository)
  - [Initializing Terraform](#initializing-terraform)
  - [Planning the example](#planning-the-example)
  - [Applying the example](#applying-the-example)
  - [Destroying the example](#destroying-the-example)
- [External documentation for the resources created in this example](#external-documentation-for-the-resources-created-in-this-example)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [License](#license)

## Example Code

This is an extract from the code in [main.tf]:

```hcl
module "policy-s3-full-access" {
  source  = "mineiros-io/iam-policy/aws"
  version = "~> 0.5.0"

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

```bash
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

## About Mineiros

Mineiros is a [DevOps as a Service][homepage] company based in Berlin, Germany. We offer commercial support
for all of our projects and encourage you to reach out if you have any questions or need help.
Feel free to send us an email at [hello@mineiros.io].

We can also help you with:

- Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
- Consulting & training on AWS, Terraform and DevOps

## Reporting Issues

We use GitHub [Issues]
to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please
see our [Contribution Guidelines].

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020 Mineiros GmbH

<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-iam-policy
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://mineiros.semaphoreci.com/badges/terraform-aws-iam-policy/branches/master.svg?style=shields
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.14%20|%200.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[build-status]: https://mineiros.semaphoreci.com/projects/terraform-aws-iam-policy
[releases-github]: https://github.com/mineiros-io/terraform-aws-iam-policy/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[main.tf]: https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/examples/iam-policy-s3-full-access/main.tf
[issues]: https://github.com/mineiros-io/terraform-aws-iam-policy/issues
[license]: https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-aws-iam-policy/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/CONTRIBUTING.md
