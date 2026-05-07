output "repository_url" {
  description = "Full ECR repository URL"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.this.arn
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.this.name
}

output "registry_id" {
  description = "Registry ID (AWS account ID)"
  value       = aws_ecr_repository.this.registry_id
}