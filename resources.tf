resource "random_uuid" "resource" {}

resource "aws_accessanalyzer_analyzer" "resource" {
  # AWS requires analyzer_name to begin with a letter; a bare UUID can begin with a digit.
  analyzer_name = coalesce(var.name, "analyzer-${random_uuid.resource.id}")
  type          = var.type

  dynamic "configuration" {
    for_each = endswith(var.type, "UNUSED_ACCESS") ? [1] : []

    content {
      unused_access {
        unused_access_age = var.unused_access_age
      }
    }
  }

  tags = var.tags
}

output "id" {
  description = "The ID of the analyzer."
  value       = aws_accessanalyzer_analyzer.resource.id
}

output "arn" {
  description = "The ARN of the analyzer."
  value       = aws_accessanalyzer_analyzer.resource.arn
}

output "name" {
  description = "The name of the analyzer."
  value       = aws_accessanalyzer_analyzer.resource.analyzer_name
}
