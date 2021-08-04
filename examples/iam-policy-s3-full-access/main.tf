# ------------------------------------------------------------------------------
# Provider Setup
# ------------------------------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}

# ------------------------------------------------------------------------------
# Example Usage: Create a Full S3 Access IAM Policy
# ------------------------------------------------------------------------------

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
