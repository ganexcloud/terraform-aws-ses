mock_provider "aws" {}

variables {
  name            = "test-configuration-set"
  sending_enabled = true
}

run "omitted" {
  command = plan
  assert {
    condition     = length(aws_sesv2_configuration_set.this.vdm_options) == 0
    error_message = "Omitting engagement_metrics must leave VDM options unspecified."
  }
  assert {
    condition     = aws_sesv2_configuration_set.this.sending_options[0].sending_enabled && output.name == "test-configuration-set"
    error_message = "Sending and the name output must remain available."
  }
}

run "disabled" {
  command = plan
  variables { engagement_metrics = "DISABLED" }
  assert {
    condition     = aws_sesv2_configuration_set.this.vdm_options[0].dashboard_options[0].engagement_metrics == "DISABLED"
    error_message = "DISABLED must be passed to VDM dashboard options."
  }
}

run "enabled" {
  command = plan
  variables { engagement_metrics = "ENABLED" }
  assert {
    condition     = aws_sesv2_configuration_set.this.vdm_options[0].dashboard_options[0].engagement_metrics == "ENABLED"
    error_message = "ENABLED must be passed to VDM dashboard options."
  }
}

run "invalid" {
  command = plan
  variables { engagement_metrics = "invalid" }
  expect_failures = [var.engagement_metrics]
}
