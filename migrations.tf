removed {
  from = aws_route53_record.ses_verification

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_ses_domain_identity_verification.main

  lifecycle {
    destroy = false
  }
}
