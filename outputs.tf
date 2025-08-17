output "frontend_ecr_repository_url" {
  description = "Frontend ECR repository URL"
  value       = module.ecr_frontend.repository_url
}

output "backend_ecr_repository_url" {
  description = "Backend ECR repository URL"
  value       = module.ecr_backend.repository_url
}



