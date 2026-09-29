# terraform-aws-accessanalyzer-analyzer

Terraform module for an IAM Access Analyzer analyzer. The external access
types find resources shared outside the zone of trust; the unused access
types find permissions nobody exercises.

## Cost

An external access analyzer, `ACCOUNT` or `ORGANIZATION`, carries no
charge. The unused access types are billed per IAM role and user analysed
per month, so their cost follows the size of the identity estate rather
than the number of findings. That difference is the reason `type` defaults
to `ACCOUNT` rather than to the unused-access variant. See AWS's
[IAM Access Analyzer pricing](https://aws.amazon.com/iam/access-analyzer/pricing/)
page for current rates.

## Design

The analyzer is regional, and findings only cover the region it runs in.

### The name must begin with a letter

AWS rejects an analyzer name that starts with anything other than a letter,
and a bare UUID can begin with a digit. The generated fallback is therefore
prefixed rather than used raw. This is the one constraint in the module
that is not derivable from the code, and it carries the module's only
comment.

### Configuration applies to unused access only

The `configuration` block exists solely to carry `unused_access_age`, and
AWS rejects it on an external access analyzer. The module emits the block
only for the two unused-access types, so `unused_access_age` can be left
set while switching types without causing an error.

## Usage

```hcl
module "access_analyzer" {
  source = "kn47ytv9mv/accessanalyzer-analyzer/aws"

  name = "external-access"
}
```

Or directly from this repository:

```hcl
module "access_analyzer" {
  source = "github.com/kn47ytv9mv/terraform-aws-accessanalyzer-analyzer"

  name = "external-access"
}
```

Finding permissions that have gone unused for thirty days:

```hcl
module "unused_access" {
  source = "kn47ytv9mv/accessanalyzer-analyzer/aws"

  name              = "unused-access"
  type              = "ACCOUNT_UNUSED_ACCESS"
  unused_access_age = 30
}
```

## Requirements

| Name | Version |
|---|---|
| terraform | >= 1.3 |
| aws | ~> 6.61 |
| random | ~> 3.9 |

## Providers

| Name | Version |
|---|---|
| aws | ~> 6.61 |
| random | ~> 3.9 |

## Inputs

| Name | Description | Default | Required |
|---|---|---|---|
| name | Name of the analyzer. | `null` | no |
| type | What the analyzer looks for (e.g. `'ACCOUNT'`, `'ORGANIZATION'`, `'ACCOUNT_UNUSED_ACCESS'`, `'ORGANIZATION_UNUSED_ACCESS'`). | `"ACCOUNT"` | no |
| unused_access_age | How many days a permission must go unused before it is reported. | `null` | no |
| tags | A map of tags to assign to the analyzer. | `null` | no |

## Outputs

| Name | Description |
|---|---|
| id | The ID of the analyzer. |
| arn | The ARN of the analyzer. |
| name | The name of the analyzer. |

## License

MIT — see [LICENSE.md](LICENSE.md).
