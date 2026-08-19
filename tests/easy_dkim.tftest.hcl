mock_provider "aws" {
  override_during = plan
}

override_resource {
  target = aws_ses_domain_dkim.main[0]

  values = {
    dkim_tokens = ["dkim-one", "dkim-two", "dkim-three"]
  }
}

run "creates_three_easy_dkim_records" {
  command = apply

  variables {
    domain_name     = "example.com"
    route53_zone_id = "Z0123456789ABCDEF"
  }

  assert {
    condition     = length(aws_route53_record.dkim) == 3
    error_message = "Easy DKIM must manage three CNAME records."
  }

  assert {
    condition = [for record in aws_route53_record.dkim : record.name] == [
      "dkim-one._domainkey.example.com",
      "dkim-two._domainkey.example.com",
      "dkim-three._domainkey.example.com",
    ]
    error_message = "DKIM CNAME names must use the SES v2 Easy DKIM tokens."
  }

  assert {
    condition = alltrue([
      for index, record in aws_route53_record.dkim : one(record.records) == [
        "dkim-one.dkim.amazonses.com",
        "dkim-two.dkim.amazonses.com",
        "dkim-three.dkim.amazonses.com",
      ][index]
    ])
    error_message = "DKIM CNAME targets must use the SES signing host."
  }
}

run "does_not_create_dkim_records_when_verification_is_disabled" {
  command = apply

  variables {
    domain_name         = "example.com"
    route53_zone_id     = "Z0123456789ABCDEF"
    enable_verification = false
  }

  assert {
    condition     = length(aws_route53_record.dkim) == 0
    error_message = "DKIM records must be absent when verification is disabled."
  }
}
