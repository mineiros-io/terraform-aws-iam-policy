[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-aws-iam-policy)

[![Build Status](https://github.com/mineiros-io/terraform-aws-iam-policy/workflows/Tests/badge.svg)](https://github.com/mineiros-io/terraform-aws-iam-policy/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-policy.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-iam-policy/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-1.x%20|%200.14%20|%200.13%20and%200.12.20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-aws-iam-policy

A [Terraform](https://www.terraform.io) base module for deploying and managing
[IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) on
[Amazon Web Services (AWS)](https://aws.amazon.com/).

**_This module supports Terraform v1.x, v0.15, v0.14, v0.13, as well as v0.12.20 and above
and is compatible with the terraform AWS provider v3 as well as v2.0 and above._**


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Module Configuration](#module-configuration)
  - [Top-level Arguments](#top-level-arguments)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource configuration](#extended-resource-configuration)
      - [Policy attachment](#policy-attachment)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [AWS Documentation](#aws-documentation)
  - [Terraform AWS Provider Documentation](#terraform-aws-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

You can create a custom AWS IAM Policy that can be attached to other IAM resources such as users, roles or groups.

- **Standard Module Features**: Create a custom IAM Policy.
- **Extended Module Features**: Create exclusive policy attachments to roles, groups and/or users.

## Getting Started

Basic usage for creating an IAM Policy granting full access to AWS Simple Storage Service (S3)

```hcl
module "role-s3-full-access" {
  source  = "mineiros-io/iam-policy/aws"
  version = "~> 0.5.0"

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

See [variables.tf] and [examples/] for details and use-cases.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_tags`**](#var-module_tags): *(Optional `map(string)`)*<a name="var-module_tags"></a>

  A map of tags that will be applied to all created resources that accept tags. Tags defined with `module_tags` can be overwritten by resource-specific tags.

  Default is `{}`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(any)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be assigned to this list to define a hidden external dependency.

### Top-level Arguments

#### Main Resource Configuration

- [**`policy`**](#var-policy): *(**Required** `string`)*<a name="var-policy"></a>

  This is a JSON formatted string representing an IAM Policy Document.
  _(only required if `policy_statements` is not set)_

- [**`policy_statements`**](#var-policy_statements): *(**Required** `list(statement)`)*<a name="var-policy_statements"></a>

  A list of policy statements to build the policy document from.
  _(only required if `policy` is not set)_

  Example:

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
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::123456789012:root"]
        }
      ]
      not_principals = []

      conditions = [
        {
          test     = "Bool"
          variable = "aws:MultiFactorAuthPresent"
          values   = [ "true" ]
        }
      ]
    }
  ]
  ```

- [**`description`**](#var-description): *(Optional `string`)*<a name="var-description"></a>

  Description of the IAM policy. Forces new resource.

- [**`name`**](#var-name): *(Optional `string`)*<a name="var-name"></a>

  The name of the policy. If omitted, Terraform will assign a random, unique name. Forces new resource.

- [**`name_prefix`**](#var-name_prefix): *(Optional `string`)*<a name="var-name_prefix"></a>

  Creates a unique name beginning with the specified prefix. Forces new resource. Conflicts with `name`.

- [**`path`**](#var-path): *(Optional `string`)*<a name="var-path"></a>

  Path in which to create the policy.

  Default is `"/"`.

#### Extended Resource configuration

##### Policy attachment

> **WARNING:** The used `aws_iam_policy_attachment` resource creates exclusive IAM policies attachments.
> Across the entire AWS account, all of the users/roles/groups to which a single policy is attached must be declared by a single `aws_iam_policy_attachment` resource.
> This means that even any users/roles/groups that have the attached policy via any other mechanism (including other Terraform resources) will have that attached policy revoked by this resource.
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

- [**`attachment_name`**](#var-attachment_name): *(Optional `string`)*<a name="var-attachment_name"></a>

  The name of the attachment. Defaults to the `name` of the policy.

- [**`users`**](#var-users): *(Optional `list(string)`)*<a name="var-users"></a>

  The user(s) the policy should be applied to.

- [**`roles`**](#var-roles): *(Optional `list(string)`)*<a name="var-roles"></a>

  The role(s) the policy should be applied to.

- [**`groups`**](#var-groups): *(Optional `list(string)`)*<a name="var-groups"></a>

  The group(s) the policy should be applied to.

- [**`tags`**](#var-tags): *(Optional `map(string)`)*<a name="var-tags"></a>

  A map of tags that will be applied to the created IAM policy.

  Default is `{}`.

## Module Outputs

The following attributes are exported by the module:

- [**`policy`**](#output-policy): *(`object(policy)`)*<a name="output-policy"></a>

  The `aws_iam_policy` object.

- [**`policy_attachment`**](#output-policy_attachment): *(`object(policy_attachment)`)*<a name="output-policy_attachment"></a>

  The `aws_iam_policy_attachment` object.

## External Documentation

### AWS Documentation

- https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
- https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html

### Terraform AWS Provider Documentation

- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

Mineiros is a [DevOps as a Service][homepage] company based in Berlin, Germany.
We offer commercial support for all of our projects and encourage you to reach out
if you have any questions or need help. Feel free to send us an email at [hello@mineiros.io] or join our [Community Slack channel][slack].

We can also help you with:

- Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
- Consulting & training on AWS, Terraform and DevOps

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-iam-policy
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-aws-iam-policy/workflows/Tests/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-policy.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.14%20|%200.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-tf-aws]: https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[build-status]: https://github.com/mineiros-io/terraform-aws-iam-policy/actions
[releases-github]: https://github.com/mineiros-io/terraform-aws-iam-policy/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-iam-policy/tree/master/examples
[issues]: https://github.com/mineiros-io/terraform-aws-iam-policy/issues
[license]: https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-aws-iam-policy/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/CONTRIBUTING.md
