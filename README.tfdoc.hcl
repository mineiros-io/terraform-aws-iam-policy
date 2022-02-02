header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-aws-iam-policy"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-aws-iam-policy/workflows/Tests/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-aws-iam-policy/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-policy.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-aws-iam-policy/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/terraform-1.x%20|%200.14%20|%200.13%20and%200.12.20+-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-aws-provider" {
    image = "https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-aws/releases"
    text  = "AWS Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-aws-iam-policy"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) base module for deploying and managing
    [IAM Policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) on
    [Amazon Web Services (AWS)](https://aws.amazon.com/).

    **_This module supports Terraform v1.x, v0.15, v0.14, v0.13, as well as v0.12.20 and above
    and is compatible with the terraform AWS provider v3 as well as v2.0 and above._**
  END

  section {
    title   = "Module Features"
    content = <<-END
      You can create a custom AWS IAM Policy that can be attached to other IAM resources such as users, roles or groups.

      - **Standard Module Features**: Create a custom IAM Policy.
      - **Extended Module Features**: Create exclusive policy attachments to roles, groups and/or users.
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
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
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_tags" {
        type        = map(string)
        default     = {}
        description = <<-END
          A map of tags that will be applied to all created resources that accept tags. Tags defined with `module_tags` can be overwritten by resource-specific tags.
        END
      }

      variable "module_depends_on" {
        type        = list(any)
        description = <<-END
          A list of dependencies. Any object can be assigned to this list to define a hidden external dependency.
        END
      }
    }

    section {
      title = "Top-level Arguments"

      section {
        title = "Main Resource Configuration"

        variable "policy" {
          required    = true
          type        = string
          description = <<-END
            This is a JSON formatted string representing an IAM Policy Document.
            _(only required if `policy_statements` is not set)_
          END
        }

        variable "policy_statements" {
          required       = true
          type           = list(statement)
          description    = <<-END
            A list of policy statements to build the policy document from.
            _(only required if `policy` is not set)_
          END
          readme_example = <<-END
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
          END
        }

        variable "description" {
          type        = string
          description = <<-END
            Description of the IAM policy. Forces new resource.
          END
        }

        variable "name" {
          type        = string
          description = <<-END
            The name of the policy. If omitted, Terraform will assign a random, unique name. Forces new resource.
          END
        }

        variable "name_prefix" {
          type        = string
          description = <<-END
            Creates a unique name beginning with the specified prefix. Forces new resource. Conflicts with `name`.
          END
        }

        variable "path" {
          type        = string
          default     = "/"
          description = <<-END
            Path in which to create the policy.
          END
        }
      }

      section {
        title = "Extended Resource configuration"

        section {
          title   = "Policy attachment"
          content = <<-END
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
          END

          variable "attachment_name" {
            type        = string
            description = <<-END
              The name of the attachment. Defaults to the `name` of the policy.
            END
          }

          variable "users" {
            type        = list(string)
            description = <<-END
              The user(s) the policy should be applied to.
            END
          }

          variable "roles" {
            type        = list(string)
            description = <<-END
              The role(s) the policy should be applied to.
            END
          }

          variable "groups" {
            type        = list(string)
            description = <<-END
              The group(s) the policy should be applied to.
            END
          }

          variable "tags" {
            type        = map(string)
            default     = {}
            description = <<-END
              A map of tags that will be applied to the created IAM policy.
            END
          }
        }
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported by the module:
    END

    output "policy" {
      type        = object(policy)
      description = <<-END
        The `aws_iam_policy` object.
      END
    }

    output "policy_attachment" {
      type        = object(policy_attachment)
      description = <<-END
        The `aws_iam_policy_attachment` object.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "AWS Documentation"
      content = <<-END
        - https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
        - https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      Mineiros is a [DevOps as a Service][homepage] company based in Berlin, Germany.
      We offer commercial support for all of our projects and encourage you to reach out
      if you have any questions or need help. Feel free to send us an email at [hello@mineiros.io] or join our [Community Slack channel][slack].

      We can also help you with:

      - Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
      - Consulting & training on AWS, Terraform and DevOps
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-aws-iam-policy"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-policy/workflows/Tests/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-policy.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/terraform-1.x%20|%200.14%20|%200.13%20and%200.12.20+-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "badge-tf-aws" {
    value = "https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-policy/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-policy/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-policy/tree/master/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-policy/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-policy/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-policy/blob/master/CONTRIBUTING.md"
  }
}
