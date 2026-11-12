mock_provider "aws" {}

run "email_identity_with_notifications" {
  command = plan
  variables {
    domain_name                            = "sender@example.com"
    enable_domain_dkim                     = false
    enable_verification                    = false
    enable_notifications                   = true
    notifications_type                     = ["Bounce", "Complaint", "Delivery"]
    notifications_sns_topic_arn            = "arn:aws:sns:us-east-1:123456789012:feedback"
    notifications_include_original_headers = true
  }
  assert {
    condition = length(aws_ses_domain_dkim.main) == 0 && length(aws_route53_record.dkim) == 0 && alltrue([
      for notification in aws_ses_identity_notification_topic.this :
      notification.identity == aws_sesv2_email_identity.main.email_identity && notification.include_original_headers
    ]) && length(aws_ses_identity_notification_topic.this) == 3
    error_message = "Email identity must create all notifications without domain DKIM or DNS resources."
  }
}
