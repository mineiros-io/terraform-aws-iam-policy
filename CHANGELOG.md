# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.2]

### Added

- Added `module_tags` and `tags` variables.

## [0.5.1]

### Fixed

- Fix reference in policy when `module_enabled = false`

## [0.5.0]

### Added

- Add support for Terraform `v1`

## [0.4.0]

### Added

- Add support for Terraform `v0.15`

## 0.3.0 (unreleased)

### Added

- Add support for Terraform `v0.14`

## [0.2.0]

### Added

- Add support for Terraform `v0.13`
- Add support for Terraform AWS Provider `v3`
- Prepare support for Terraform `v0.14`

## [0.1.1]

### Fixed

- Fix type of `policy_statements` argument

## [0.1.0]

### Changed

- Add `module_enabled` tests
- Add `CHANGELOG.md`

## [0.0.2]

### Changed

- Align with latest repository structure and style

### Fixed

- Fix type of `module_depends_on`

## [0.0.1]

### Added

- Implement support for `aws_iam_policy` resource
- Implement support for `aws_iam_policy_attachment` resource
- Document the usage of the module in `README.md`
- Document the usage of examples
- Add unit tests for basic use cases

<!-- markdown-link-check-disable -->

[unreleased]: https://github.com/mineiros-io/terraform-aws-iam-policy/compare/v0.5.2...HEAD
[0.5.2]: https://github.com/mineiros-io/terraform-aws-iam-policy/compare/v0.5.1...v0.5.2

<!-- markdown-link-check-disabled -->

[0.5.1]: https://github.com/mineiros-io/terraform-aws-iam-policy/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/mineiros-io/terraform-aws-iam-policy/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/mineiros-io/terraform-aws-iam-policy/compare/v0.2.0...v0.4.0
[0.2.0]: https://github.com/mineiros-io/terraform-aws-iam-policy/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/mineiros-io/terraform-aws-iam-policy/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/mineiros-io/terraform-aws-iam-policy/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/mineiros-io/terraform-aws-iam-policy/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-aws-iam-policy/releases/tag/v0.0.1
