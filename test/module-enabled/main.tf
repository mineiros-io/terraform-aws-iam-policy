# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# UNIT TEST MODULE
# This module exists for the purpose of testing only and should not be
# considered as an example.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "aws" {
  region = var.aws_region
}

module "test" {
  source = "../.."

  module_enabled = false

  policy_statements = [
    {
      effect = "Deny"

      actions = [
        "logs:CreateLogGroups",
      ]

      resources = ["*"]
    },
  ]
}
