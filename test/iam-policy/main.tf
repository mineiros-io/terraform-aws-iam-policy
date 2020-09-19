# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN AWS COGNITO USER POOL
# This example creates an AWS Cognito User Pool that can be used for authentication (identify verification).
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# PROVIDER CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

# ------------------------------------------------------------------------------
# CREATE THE USER POOL
# ------------------------------------------------------------------------------

module "test" {
  source = "../../"

  # name of the policy
  name_prefix = "S3FullAccess"

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
