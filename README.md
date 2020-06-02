[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="200"/>](https://mineiros.io/?ref=terraform-aws-iam-policy)

[![Build Status](https://mineiros.semaphoreci.com/badges/terraform-aws-iam-policy/branches/master.svg?style=shields)](https://mineiros.semaphoreci.com/projects/terraform-aws-iam-policy)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-policy.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-iam-policy/releases)
[![license](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-623CE4.svg)](https://github.com/hashicorp/terraform/releases)
[<img src="https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack">](https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg)

# terraform-aws-iam-policy

A [Terraform](https://www.terraform.io) 0.12 base module deploying and managing
[IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) on
[Amazon Web Services (AWS)](https://aws.amazon.com/).

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Module Configuration](#module-configuration)
  - [Top-level Arguments](#top-level-arguments)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource configuration](#extended-resource-configuration)
      - [Policy attachment](#policy-attachment)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

You can create a custom AWS IAM Policy that can be attached to other IAM resources as users, roles or groups.

- **Standard Module Features**: Create a custom IAM Policy.
- **Extended Module Features**: Create exclusive policy attachments to roles, groups and/or users.

## Getting Started

Basic usage for creating an IAM Policy granting full access to AWS Simple Storage Service (S3)

```hcl
module "role-s3-full-access" {
  source = "git@github.com:mineiros-io/terraform-aws-iam-policy.git?ref=v0.0.1"

  name = "S3FullAccess"

  policy_statements = [
    {
      sid = "FullS3Access"

      effect    = "Allow"
      actions   = ["s3:*"]
      resources = ["*"]
    }
  ]
}
```

## Module Argument Reference

See
[variables.tf](https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/variables.tf)
and
[examples/](https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/examples)
for details and use-cases.

### Module Configuration

- **`module_enabled`**: *(Optional `bool`)*

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_depends_on`**: *(Optional `list(any)`)*

  A list of dependencies. Any object can be assigned to this list to define a hidden
  external dependency.

### Top-level Arguments

#### Main Resource Configuration

- **`policy`**: **(Required `string`) The policy document.**

  This is a JSON formatted string representing an IAM Policy Document.
  *(only required if `policy_statements` is not set)*

- **`policy_statements`**: **(Required `list(statement)`)**

  List of IAM policy statements to attach to the role as an inline policy.
  *(only required if `policy` is not set)*

  ```hcl
  policy_statements = [
    {
      sid = "FullS3Access"

      effect = "Allow"

      actions     = ["s3:*"]
      not_actions = []

      resources     = ["*"]
      not_resources = []

      principals = [
        { type        = "AWS"
          identifiers = ["arn:aws:iam::123456789012:root"]
        }
      ]
      not_principals = []

      conditions = [
        { test     = "Bool"
          variable = "aws:MultiFactorAuthPresent"
          values   = [ "true" ]
        }
      ]
    }
  ]
  ```

- **`description`**: *(Optional `string`, Forces new resource)*

  Description of the IAM policy. Default is `""`.

- **`name`**: *(Optional `string`, Forces new resource)*

  The name of the policy. If omitted, Terraform will assign a random, unique name.

- **`name_prefix`**: *(Optional `string`, Forces new resource)* *(Conflicts with `name`.)*

  Creates a unique name beginning with the specified prefix.

- **`path`**: *(Optional `string`)*

  Path in which to create the policy. Default is `"/"`

#### Extended Resource configuration

##### Policy attachment

> **WARNING:** The used `aws_iam_policy_attachment` resource creates exclusive IAM policies attachments.
> Across the entire AWS account, all of the users/roles/groups to which a single policy
> is attached must be declared by a single `aws_iam_policy_attachment` resource.
> This means that even any users/roles/groups that have the attached policy via any other mechanism
> (including other Terraform resources) will have that attached policy revoked by this resource.
>
> Consider attaching this policy using the other Mineiros IAM modules
> [`mineiros-io/terraform-aws-iam-role`](https://github.com/mineiros-io/terraform-aws-iam-role),
> [`mineiros-io/terraform-aws-iam-group`](https://github.com/mineiros-io/terraform-aws-iam-group),
> [`mineiros-io/terraform-aws-iam-user`](https://github.com/mineiros-io/terraform-aws-iam-user).
>
> Or consider attaching this policy via the direct resources
> `aws_iam_role_policy_attachment`,
> `aws_iam_user_policy_attachment`, or
> `aws_iam_group_policy_attachment` instead.
> These modules and/or resources do not enforce exclusive attachment of an IAM policy.

- **`attachment_name`**: *(Optional `string`)*

  The name of the attachment. Defaults to the `name` of the policy.

- **`users`**: *(Optional `list(string)`)*

  The user(s) the policy should be applied to

- **`roles`**: *(Optional `list(string)`)*

  The role(s) the policy should be applied to

- **`groups`**: *(Optional `list(string)`)*

  The group(s) the policy should be applied to

## Module Attributes Reference

The following attributes are exported by the module:

- **`policy`**: The `aws_iam_policy` object.
- **`policy_attachment`**: The `aws_iam_policy_attachment` object.

## External Documentation

- AWS Documentation:
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
  - https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html

- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/iam_policy.html
  - https://www.terraform.io/docs/providers/aws/r/iam_policy_attachment.html

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)](https://semver.org/).

Using the given version number of `MAJOR.MINOR.PATCH`, we apply the following constructs:

1. Use the `MAJOR` version for incompatible changes.
1. Use the `MINOR` version when adding functionality in a backwards compatible manner.
1. Use the `PATCH` version when introducing backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- In the context of initial development, backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is
  increased. (Initial development)
- In the context of pre-release, backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is
  increased. (Pre-release)

## About Mineiros

Mineiros is a [DevOps as a Service](https://mineiros.io/?ref=terraform-aws-iam-policy) company based in Berlin,
Germany. We offer commercial support for all of our projects and encourage you to reach out if you have any questions or
need help. Feel free to send us an email at [hello@mineiros.io](mailto:hello@mineiros.io).

We can also help you with:

- Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
- Consulting & training on AWS, Terraform and DevOps

## Reporting Issues

We use GitHub [Issues](https://github.com/mineiros-io/terraform-aws-iam-policy/issues)
to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests](https://github.com/mineiros-io/terraform-aws-iam-policy/pulls). If you'd like more information, please
see our [Contribution Guidelines](https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/CONTRIBUTING.md).

## Makefile Targets

This repository comes with a handy
[Makefile](https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/Makefile).
Run `make help` to see details on each available target.

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/LICENSE) for full details.

Copyright &copy; 2020 Mineiros GmbH
