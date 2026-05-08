variable "aws_region" {
  description = "AWS region for bootstrap resources"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project prefix used in resource names"
  type        = string
  default     = "rova"
}

variable "github_org" {
  description = "GitHub org or username that owns the repository"
  type        = string
  default     = "Nifesimi-p"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "rova-infra"
}