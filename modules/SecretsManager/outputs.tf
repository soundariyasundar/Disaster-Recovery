output "secret_arn" {
  description = "ARN of the created Secrets Manager secret"
  value       = aws_secretsmanager_secret.secrets.arn
}

output "secret_name" {
  description = "Name of the created Secrets Manager secret"
  value       = aws_secretsmanager_secret.secrets.name
}
