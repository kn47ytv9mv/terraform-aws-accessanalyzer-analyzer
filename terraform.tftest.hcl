mock_provider "aws" {}

run "an_unknown_analyzer_type_is_rejected" {
  command = plan

  variables {
    type = "REGION"
  }

  expect_failures = [var.type]
}

run "defaults_to_an_external_access_analyzer" {
  command = apply

  assert {
    condition     = aws_accessanalyzer_analyzer.resource.analyzer_name == "analyzer-${random_uuid.resource.id}"
    error_message = "With no name given, the analyzer should use the generated random_uuid behind a letter prefix, because AWS requires a leading letter."
  }

  assert {
    condition     = aws_accessanalyzer_analyzer.resource.type == "ACCOUNT"
    error_message = "The analyzer should default to account-scoped external access, which is the free tier."
  }

  assert {
    condition     = length(aws_accessanalyzer_analyzer.resource.configuration) == 0
    error_message = "No configuration block belongs on an external access analyzer."
  }
}

run "explicit_name_overrides_generated_uuid" {
  command = plan

  variables {
    name = "external-access"
  }

  assert {
    condition     = aws_accessanalyzer_analyzer.resource.analyzer_name == "external-access"
    error_message = "An explicit name should be used instead of the generated UUID."
  }
}

run "an_unused_access_analyzer_carries_a_configuration_block" {
  command = plan

  variables {
    type              = "ACCOUNT_UNUSED_ACCESS"
    unused_access_age = 30
  }

  assert {
    condition     = length(aws_accessanalyzer_analyzer.resource.configuration) == 1
    error_message = "An unused access analyzer needs a configuration block."
  }

  assert {
    condition     = aws_accessanalyzer_analyzer.resource.configuration[0].unused_access[0].unused_access_age == 30
    error_message = "unused_access_age should be passed through."
  }
}

run "organization_unused_access_also_configures" {
  command = plan

  variables {
    type = "ORGANIZATION_UNUSED_ACCESS"
  }

  assert {
    condition     = length(aws_accessanalyzer_analyzer.resource.configuration) == 1
    error_message = "Both unused access types should produce a configuration block."
  }
}
