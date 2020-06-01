# ------------------------------------------------------------------------------
# Provider Setup
# ------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

variable "region" {
  type        = string
  description = "The AWS region to run in. Default is 'eu-west-1'"
  default     = "eu-west-1"
}

# ------------------------------------------------------------------------------
# Example Usage: Create a Full S3 Access IAM Policy
# ------------------------------------------------------------------------------

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
