variable "sns_topic_name" {
  description = "SNS topic name for alert notifications"
  type        = string
  default     = "project-alerts-topic"
}

variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}

variable "environment" {
  description = "Environment tag e.g. prod, dev"
  type        = string
}

variable "application_name" {
  description = "Application name tag"
  type        = string
}

variable "owner" {
  description = "Resource owner tag"
  type        = string
}