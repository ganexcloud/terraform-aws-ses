variable "name" {
  description = "(Required) The name of the configuration set."
  type        = string
}

# delivery_options
variable "sending_pool_name" {
  type        = string
  description = "(Optional) The name of the dedicated IP pool to associate with the configuration set."
  default     = null
}

variable "tls_policy" {
  type        = string
  description = "(Optional) Specifies whether messages that use the configuration set are required to use Transport Layer Security (TLS). Valid values: REQUIRE, OPTIONAL."
  default     = null
}

# reputation_options
variable "reputation_metrics_enabled" {
  type        = string
  description = "(Optional) If true, tracking of reputation metrics is enabled for the configuration set. If false, tracking of reputation metrics is disabled for the configuration set."
  default     = null
}

# sending_options
variable "sending_enabled" {
  type        = string
  description = "(Optional) If true, email sending is enabled for the configuration set. If false, email sending is disabled for the configuration set."
  default     = null
}

variable "engagement_metrics" {
  description = "(Optional) VDM engagement metrics collection for the configuration set: ENABLED or DISABLED. Null leaves VDM options unspecified."
  type        = string
  default     = null

  validation {
    condition     = var.engagement_metrics == null ? true : contains(["ENABLED", "DISABLED"], var.engagement_metrics)
    error_message = "engagement_metrics must be ENABLED, DISABLED, or null."
  }
}

# suppression_options
variable "suppressed_reasons" {
  type        = list(string)
  description = "(Optional) A list that contains the reasons that email addresses are automatically added to the suppression list for your account. Valid values: BOUNCE, COMPLAINT."
  default     = []
}

# tracking_options
variable "custom_redirect_domain" {
  type        = string
  description = "(Required) The domain to use for tracking open and click events."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Additional Tags"
  default     = {}
}
